/*

 A program is just a toplevel function with no 
 parameters. To run the program, select the 
 function name and go to: 
 
   Run > Run As > Ceylon Application
   
*/

void hello() {
    print("Hello, World!");
}

/*

 hello() and print() are examples of toplevel 
 functions - we don't need an instance of an 
 object to invoke them.
 
 To see the definition of print(), hold down
 the command or ctrl key and click on its 
 name.
 
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

void helloName() => print(greeting("Ceylon"));

void helloWorld() => print(greeting());

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

void calculateSums() {
    
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

void values() {
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

void inferredTypes() {
    value time = process.milliseconds;
    value nl = process.newline; 
    function sqr(Float float) => float*float;
}

/*
 
 EXERCISE
 
 Position the caret over a value or function
 keyword and select:
 
   Edit > Quick Fix / Assist
 
 And then select the Specify type quick assist
 from the popup menu. 
 
*/


/*
 
 Unicode character escapes are really useful.
 For example pi can be written \{#03C0}. 
 
 Ooops, the Eclipse console is braindead!
 Go to:
 
   Project > Properties > Resource
 
 and set your text file encoding to UTF-8 
 before running this program.
 
*/

void helloPi() => print(greeting("\{#03C0}"));

/*

 What if we want to actually print "\{#03C0}"?
 We can use a backslash escape, or a verbatim
 string.

*/

void printTheUnicodeEscapeForPi() {
    
    //the escape \\ is a literal backslash
    print("\\{#03C0}");
    
    //triple-double-quotes delimit a verbatim 
    //string with no escape characters
    print("""\{#03C0}""");
    
}

/*

 String literals may span multiple lines. We
 especially use multi-line string literals to 
 specify API documentation in markdown format. 
 Hover over this function to see its 
 documentation.
 
*/

"This program prints: 
 
 - the _name of the virtual machine,_
 - the _version of the virtual machine,_ and
 - the _version of the Ceylon language._
 
 It uses the [[process]] and [[language]] 
 objects defined in `ceylon.language`, the 
 Ceylon language module."
void printInfo() =>
        print("virtual machine: ``process.vm``
               version: ``process.vmVersion``
               language: ``language.version`` (``language.versionName``)");
              //hint: try using the normalized 
              //      attribute of String

/*

 Annotations specify metadata about a program
 element.

*/

by ("Gavin")
throws (`Exception`)
deprecated ("Well, this is not a very useful 
             program. Try [[hello]] instead.")
see (`hello`)
void failNoisily() {
    throw Exception("aaaaarrrrrggggghhhhhhh");
}

/*

 EXERCISE
  
 Write a program that prints out all the prime 
 numbers between 1 and 100. Remember to 
 properly document your work!
  
*/

//TODO: print out the prime numbers!
