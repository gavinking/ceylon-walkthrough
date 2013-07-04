/*

 A union type represents a choice between 
 types. A union type is written A|B for any
 types A and B.

*/

void printDouble(String|Integer|Float val) {
    String|Integer|Float double;
    switch (val)
    case (is String) { double = val+val; }
    case (is Integer) { double = 2*val; }
    case (is Float) { double = 2.0*val; }
    print("double ``val`` is ``double``");
}

void testDouble() {
    printDouble("hello");
    printDouble(111);
    printDouble(0.111);
}

/*
 
 We deal with missing or "null" values using
 union types. The class Null has a single 
 instance named null, which represents a 
 missing value. Therefore, a possibly-null
 string is represented by the type Null|String.
 
 We can write the type "Null|String" using the 
 special syntactic abbreviation "String?". 
 This is just syntax sugar for the union type!
 
 Run the following program with and without a
 command line argument. (You can set a command
 line argument using:
 
   Run > Run Configurations... 
 
*/

void helloArguments() {
    String? name = process.arguments[0];
    if (is String name) { //TODO: use exists
        print("hello " + name);
    }
    else {
        print("hello world");
    }
}

/*

 EXERCISE
 
 We usually use the "exists" operator instead
 of "is String" in code like this. Change the
 program above to use exists. More syntactic
 sugar!
 
 Next, to make the code a little more compact,
 change the code to use this form of the if 
 statement:
 
   if (is String name = process.arguments[0])
 
 (But using "exists", not "is String".)
 
*/

/*
 
 The then and else operators produce and 
 consume null values.
 
*/

void thenAndElse() {
    Integer n = 5;
    
    print(n>0 then n);
    print(n<=0 then n);
    
    print(n>=0 then "positive" else "strictly negative");
    
    print("123456789"[n] else "out of bounds");    
    print("12345"[n] else "out of bounds");
}

/*

 EXERCISE
 
 Change the helloArguments() program above to
 use an operator instead of if/else.

*/

/*

 An intersection represents the combination of
 two types. An intersection type is written 
 A&B for any types A and B.
 
 Intersection types often arise as a result of
 type narrowing.

*/

T? third<T>({T*} iterable) {
    if (is Correspondence<Integer, T> iterable) {
        //hover over iterable to see its
        //narrowed type within this block!
        return iterable[2];
    }
    else {
        value iterator = iterable.iterator();
        iterator.next();
        iterator.next();
        if (is T third = iterator.next()) {
            return third;
        }
        else {
            return null;
        }
    }
}

void testThird() {
    assert (exists thrd = third("hello"), 
            thrd =='l');
}

/*

 Cute observation: the type of thrd above is
 <Null|Character>&Object, which expands to
 Null&Object|Character&Object, which simplifies
 to Nothing|Character, which further simplifies 
 to Character. The typechecker does all this
 reasoning automatically.
 
 Union and intersection types are especially
 useful when it comes to type inference.
 
*/

void demoTypeInference() {
    //hover over joined to see its type!
    value joined = join("hello", 1..69);
    Object[] objects = joined;
    print(objects);
}

/*

 Union and intersection types also help is
 correctly type the union and intersection
 operations on Sets.
 
 Set union and intersection are defined in
 terms of the methods intersection() and
 union() of the interface Set. The | and & 
 operators are syntactic sugar for these
 methods.
 
 Check out the definition of these methods in
 Set to see how they are in turn defined in
 terms of union/intersection types.

*/

void demoSets() {
    Set<Character> chars = LazySet("hello");
    Set<Integer> ints = LazySet(0..10);
    //hover over intsAndChars to see its type!
    value intsAndChars = chars|ints;
    print(intsAndChars);
    //hover over empty to see its type!
    value empty = chars&ints;
    print(empty);
}

/*

 EXERCISE
 
 The special type Nothing is the "bottom" type,
 a type with no instances.
 
 Explain why the type of the intersection
 chars&ints above is Set<Nothing>, given that
 the type Character and the type Integer are
 disjoint types (have no instances in common).

*/

/*

 There's a special trick we can do with union
 types that help us give functions like max()
 and min() the correct type.
 
 The problem is that when we have "zero or 
 more things", max() can return null. But when 
 we have "one or more" things, it can. And 
 when we have exactly zero things, max() 
 always returns null. How can we capture this
 within the type system?
 
*/

void demoMax() {
    
    Null maxOfZero = max({});
    
    {Integer+} oneOrMore = {1, 2};
    Integer maxOfOneOrMore = max(oneOrMore);
    
    {Integer*} zeroOrMore = {1, 2};
    Integer? maxOfZeroOrMore = max(zeroOrMore);
    
}

/*

 EXERCISE

 Check out the definitions of max() and
 Iterable and figure out how this works!

*/
