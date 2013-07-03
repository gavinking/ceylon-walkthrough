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
