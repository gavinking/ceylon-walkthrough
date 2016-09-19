/*

 A program is just a toplevel function with no 
 parameters. To run the program, select the 
 function name and go to: 
 
   Run > Run As > Ceylon Java Application
   
*/

shared void hello() {
    print("Hello, World!");
}

/*
  
  EXERCISE
  
  You probably want to know what print() does!
  You can either:
  
  - hover over the name of the function to see
    its documentation, or
  - hold down the ctrl or command key while
    clicking the name of the function to 
    navigate to its declaration.
  
*/

/*

 hello() and print() are examples of toplevel 
 functions - we don't need an instance of an 
 object to invoke them.
 
 A toplevel function may accept arguments and
 return a value, in which case we must specify 
 the types of the parameters, and the type of 
 value it returns.
 
 A parameter may have a default value.

*/

String greeting(String name = "World") {
    //interpolated expressions are enclosed
    //in double-backticks within a string
    return "Hello, ``name``!";
}

/*

 When a function just returns an expression,
 we can abbreviate it using a fat arrow. 
 
*/

shared void helloName() => print(greeting("Ceylon"));

shared void helloWorld() => print(greeting());

/*
 
 A parameter may be variadic, meaning it 
 accepts multiple values.
 
*/

Integer sum(Integer* numbers) {
    variable value sum = 0; //assignable values must be annotated variable
    for (x in numbers) {
        sum+=x;
    }
    return sum;
}

shared void calculateSums() {
    
    //the sum of no numbers
    print(sum());
    
    //the sum of two numbers
    print(sum(2, 2));
    
    //the sum of all the numbers from 0 to 10 
    //inclusive, using the range operator ..
    //and the spread operator *
    print(sum(*(0..10)));
    
    //just to whet your appetite, the sum of 
    //all the square numbers from 0 to 100!
    //the ^ operator performs exponentiation
    print(sum(for (n in 0..10) n^2));
    
}

/*
  
  Variables are called "values" in Ceylon,
  because they're not actually variable
  by default!
  
*/

shared void greet() {
    String greeting = "hei verden";
    //TODO: use the IDE to fill in the rest!
}

/*
  
  EXERCISE
  
  Fill in the rest of this function. No, we 
  don't want you to write a trivial call to
  print() by hand. We want you to let the 
  IDE do it for you:
  
  - Type part of the name of the function
    you want to call.
  
  - ctrl-space activates autocompletion.
  
  - Selecting a function puts you into linked
    mode where you can quickly fill in the 
    arguments. Use tab to navigate between
    them.
  
  - esc or a typed character outside the 
    linked mode fields exits linked mode.
  
*/

/*
 
 A value may be a constant (within a certain
 scope), a variable, or a getter.

*/

//a toplevel constant
Integer zero = 0;

//a variable with its initial value
variable Integer int = zero;

//a getter defined using a fat arrow
Integer intSquared => int^2;

//a getter defined using a block
Integer intFactorial {
    variable value fac = 1;
    for (i in 1..int) {
        fac*=i;
    }
    return fac;
}

shared void values() {
    int = 3;
    print("i = ``int``");
    print("i^2 = ``intSquared``");
    print("i! = ``intFactorial``");
    int = 4;
    print("i = ``int``");
    print("i^2 = ``intSquared``");
    print("i! = ``intFactorial``");
}

/*

 A local declaration may have its type 
 inferred by the compiler. Hover over the 
 keyword value or function to see the inferred 
 type of the declaration.
 
 The type of a function parameter cannot be
 inferred.

*/

shared void inferredTypes() {
    value time = system.milliseconds;
    value nl = operatingSystem.newline;
    function sqr(Float float) => float*float;
}

/*
 
 EXERCISE
 
 Position the caret over a value or function
 keyword and select:
 
   Source > Quick Fix/Assist
 
 And then select the 'Declare explicit type' 
 quick assist from the popup menu.
 
 Or: select the whole function, and select:
 
   Source > Reveal Inferred Types
 
*/


/*
 
 Unicode character escapes are really useful.
 For example, pi can be written \{#03C0}. 
 
 Ooops, the Eclipse console is braindead!
 Go to:
 
   Project > Properties > Resource
 
 and set your text file encoding to UTF-8 
 before running this program.
 
*/

shared void helloPi() => print(greeting("\{#03C0}"));

/*

  Or, much more verbose, but also much more 
  understandable, we can use the Unicode
  character name.

*/

shared void helloPi2() 
        => print(greeting("\{GREEK SMALL LETTER PI}"));


/*

 What if we want to actually literally print 
 the string "\{#03C0}"? We can use a backslash 
 escape, or a verbatim string.

*/

shared void printTheUnicodeEscapesForPi() {
    
    //the escape \\ is a literal backslash
    print("\\{#03C0}");
    
    //triple-double-quotes delimit a verbatim 
    //string with no escape characters
    print("""\{GREEK SMALL LETTER PI}""");
    
}

/*

 String literals may span multiple lines. We
 especially use multi-line string literals to 
 specify API documentation in markdown format. 
 Hover over the name of this function to see 
 its documentation.
 
*/

"This program prints: 
 
 - the _name of the virtual machine,_
 - the _version of the virtual machine,_ and
 - the _version of the Ceylon language._
 
 It uses the [[operatingSystem]] and [[language]] 
 objects defined in `ceylon.language`, the 
 Ceylon language module."
shared void printInfo() =>
        print("operating system: ``operatingSystem.name``
               version: ``operatingSystem.version``
               language: ``language.version`` (``language.versionName``)");
              //hint: try using the normalized 
              //      attribute of String

/*

 Annotations specify metadata about a program
 element. Hover over the name of this function.

*/

by ("Gavin")
throws (`class Exception`)
deprecated ("Well, this is not a very useful 
             program. Try [[hello]] instead.")
see (`function hello`)
shared void failNoisily() {
    throw Exception("aaaaarrrrrggggghhhhhhh");
}

/*

 EXERCISE
  
 Write a program that prints out all the prime 
 numbers between 1 and 100. Remember to 
 properly document your work!
  
*/

//TODO: print out the prime numbers!
