/*

 Every value is an instance of a class. The
 simplest classes just package together some
 related state into attributes.
 
 Classes have members:
 
 - parameters,
 - methods (member functions),
 - attributes (member values), and
 - member classes.

 Any member annotated shared forms part of the 
 API of the class and may be accessed from 
 outside the class.
 
 For simple classes, we usually need to refine
 members string, equals(), and hash that are
 inherited from the default supertype Basic.
 
 A member annotated actual refines a member of
 a supertype of the class.
 
*/

class Time(shared Integer hour, 
           shared Integer minute) {
    
    shared Integer secondsSinceMidnight =>
            minute%60*60 + hour%24*60*60;
    
    shared actual Integer hash => 
            secondsSinceMidnight;
    
    shared actual Boolean equals(Object that) {
        //the "is Time" construct tests and
        //narrows the type of a value
        if (is Time that) {
            //that is of type Time here
            return secondsSinceMidnight == 
                   that.secondsSinceMidnight;
        }
        else {
            return false;
        }
    }
    
    //if writing "shared actual Type" gets too
    //boring, you can use this shortcut syntax! 
    string => "``hour``:``minute``";
    
}

void tryOutTime() {
    Time time1 = Time(13,30);
    print(time1);
    Time time2 = Time(37,30);
    print(time2);
    Time time3 = Time(13,29);
    print(time2);
    print(time1==time2);
    print(time1==time3);
    print(time1.secondsSinceMidnight);
}

/*

 For testing classes, assertions are very 
 useful. Run this function to see an assertion
 failure occur.

*/

//TODO: get the assertions passing
void testTime() {
    Time time1 = Time(13,30);
    assert (time1.string=="13:30");
    Time time2 = Time(37,30);
    assert (time2.string=="37:30");
    Time time3 = Time(13,29);
    assert (time3.string=="13:29");
    assert (time1==time2);
    assert (time1!=time3);
    assert (time2==time3);
    assert (time1.secondsSinceMidnight==48600);
}

/*
  
  EXERCISE
  
  Fix the Time class so that all the assertions 
  pass.
  
*/

/*

 Some classes have mutable state. If an attribute
 is mutable, it must be annotated variable.

*/

class Counter(count=0) {
    shared variable Integer count;
    shared void inc() => count++;
    string => count.string;
}

void testCounter() {
    value counter = Counter();
    assert (counter.count==0);
    counter.inc();
    counter.inc();
    assert (counter.count==2);
    counter.count = 0;
    assert (counter.count==0);
}

/*
 
 EXERCISE
 
 Add a reset() method to Counter. 
 
 If you're clever, you can get the IDE to 
 write almost all the code for you. First
 uncomment the test code below, and notice
 the error span. Hover over the error span, 
 or use:
 
   Edit > Quick Fix / Assist
 
 while your caret is inside the error span to 
 let the IDE propose a partial fix.
 
*/

//TODO: uncomment this test and get it to pass
//void testReset() {
//    value counter = Counter();
//    assert (counter.count==0);
//    counter.inc();
//    counter.inc();
//    assert (counter.count==2);
//    counter.reset();
//    assert (counter.count==0);
//}

/*
 
 A subclass may extend our class, and refine
 its members. A class member mat be refined iff
 it is annotated default.
  
*/

class SecondTime(Integer hour, 
                 Integer minute, 
                 second) 
        extends Time(hour, minute) {
    
    //We can declare the type and annotations
    //of a parameter in the body of the class
    //to clean up the parameter list.
    shared Integer second;
    
    /*
    
     Ooops! The following code contains an error!
     
     First uncomment the code, and then fix the
     error by adding a 'default' annotation to 
     Time.secondsSinceMidnight, above.
     
    */
    
    //TODO: uncomment and fix the error!
    //secondsSinceMidnight => 
    //        super.secondsSinceMidnight+second%60;
    
}

/*
 
 EXERCISE
 
 Fix the implementation of Time and SecondTime 
 so that the following tests pass.
 
*/

//TODO: get the assertions passing
void testSecondTime() {
    Time time = Time(13,30);
    assert (time.string=="13:30");
    SecondTime stime1 = SecondTime(13,30,00);
    SecondTime stime2 = SecondTime(13,30,25);
    assert (time==stime1);
    assert (time!=stime2);
    assert (stime1.string=="13:30:00");
    assert (stime2.string=="13:30:25");
}

/*
 
 An anonymous class declaration defines an 
 instance.
 
 */

object midnight extends SecondTime(0,0,0) {
    //TODO: uncomment and fix the error
    //string => "midnight";
}

/*
 
 The above anonymous class is a singleton, because
 it occurs as a toplevel declaration. But not
 every anonymous class is a singleton.
 
 (Don't worry about the "satisfies" keyword for
 now. We'll come back to that when we discuss
 interfaces.) 
 
 */

//this anonymous class is a singleton
object naturals 
        satisfies Iterable<Integer> {
    
    shared actual Iterator<Integer> iterator() {
        //a new instance of this anonymous class 
        //is created each time iterator() is 
        //called
        object iterator 
                satisfies Iterator<Integer> {
            variable value int = 1;
            next() => int++;
        }
        return iterator;
    }
    
}

/*
 
 An abstract class is a class which can't be
 instantiated. It may declare formal members,
 which must be implemented by concrete 
 subclasses of the abstract class.
 
 An enumerated type is an abstract class or
 interface which enumerates (restricts) its 
 subtypes.
 
*/

abstract class LinkedList<out T>() 
        of Cons<T> | empty {
    shared formal Integer length;
}

//this case of the enumerated type is a class
class Cons<out T>(shared T first,
                  shared LinkedList<T> rest) 
        extends LinkedList<T>() {
    length=>rest.length+1;
}

//this case of the enumerated type is a 
//singleton object
object empty 
        extends LinkedList<Nothing>() {
    length=>0;
}

String formatLinkedList(LinkedList<Object> list) {
    //We use a switch statement to handle
    //the cases of the enumerated type. The
    //compiler validates that the switch
    //exhausts all cases
    switch (list)
    case (empty) {
        return "";
    }
    case (is Cons<Object>) {
        value rest = list.rest;
        value firstString = list.first.string;
        switch (rest)
        case (empty) {
            return firstString;
        }
        else {
            return firstString + ", " + 
                    formatLinkedList(rest);
        }
    }
}

void testLinkedList() {
    value list = Cons("Smalltalk", Cons("Java", Cons("Ceylon", empty)));
    assert (list.length==3);
    print(formatLinkedList(list));
}

/*

 EXERCISE
 
 Write a Java-style enum in Ceylon. The classic
 example is the Suit enum, with cases hearts,
 diamonds, clubs, spades.

*/

//TODO: write a Suit class here