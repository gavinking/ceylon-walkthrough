/*
 
 As in most modern languages, a function is a
 value. The type of a function is represented
 using the interfaces Callable and Tuple, but
 we usually hide these interfaces using 
 syntactic sugar.
 
 The type of a function is written X(P,Q,R)
 where X is the return type, and P, Q, R are
 the parameter types. Furthermore:
 
 - P* means a variadic parameter of type P, and  
 - P= means a parameter of type P with a default 
   value. 
 
 A value whose type is a function type is 
 sometimes called a "function reference".
 
*/

//the return type of a void function is Anything
Anything(Anything) printFun = print;

//for a parameterized function, type arguments
//must be specified, since a value cannot have
//free parameters
Float(Float, Float) plusFun = plus<Float>;

//sum() has a variadic parameter
Integer(Integer*) sumFun = sum;

//classes are functions too!
Range<Integer>(Integer, Integer) rangeFun 
        = Range<Integer>;

//even methods are functions
String({String*}) joinWithCommasFun = ", ".join;

//some crazy examples (don't sweat them)
{Integer*}({Integer?*}) coalesceFun = coalesce<Integer?>;
String[]({String*}*) joinFun = concatenate<String>;
{String*}(Boolean(Character)=, Boolean=, Boolean=) splitFun 
        = "Hello, world! Goodbye :-(".split;

/*
 
 Given a value with a function type, we can do
 almost everything we can do with the actual
 function.
 
 (Note: the one thing we can't do is pass named 
 arguments.)
 
*/

void demoFunctionRefs() {
    printFun("Hello!");
    print(sumFun(3, 7, 0));
    print(plusFun(3.0, 7.0));
    print(rangeFun(0, 20));
}

/*
 
 Function types exhibit the correct variance
 with respect to their return and parameter
 types. This is just a consequence of the
 variance of the type parameters of the types
 Callable and Tuple.
 
 That is, a function with more general 
 parameter types and a more specific return 
 type is assignable to a function type. Sounds
 complicated, but it all works out pretty much 
 intuitively.
 
*/

//a function that accepts Anything is also a
//function that accepts a String
Anything(String) printStringFun = printFun;

//a function that returns a Range is also a
//function that returns an Iterable
{Integer+}(Integer, Integer) iterableFun = rangeFun;

//a function with a variadic parameter is also
//a function with two parameters!
Integer(Integer, Integer) sumBothFun = sumFun;

/*

 Usually we pass function refs to other 
 functions.

*/

//TODO: change the declaration of op to use a function type
Float apply(Float op(Float x, Float y), Float z)
        => op(z/2,z/2);

void testApply() {
    assert (apply(plus<Float>, 1.0)==1.0);
    assert (apply(times<Float>, 3.0)==2.25);
}

/*
 
 EXERCISE
 
 The parameter op() of apply() is declared in
 "function style", with the parameters listed
 after the parameter name, and the return type
 first. Change the declaration to use "value 
 style", with a function type before the 
 parameter name.
 
*/

/*
 
 It's even possible to write an "anonymous"
 function, inline, within an expression.
 
*/

//TODO: change to a regular function definition
Float(Float, Float) timesFun 
        = (Float x, Float y) => x*y;

//TODO: change to a regular function definition
Anything(String) printTwiceFun 
        = void (String s) { 
            print(s); 
            print(s);
        };

/*
 
 EXERCISE
 
 What I have just written is very bad style!
 The purpose of anonymous functions is to
 pass them as arguments to other functions.
 Fix the code above by rewriting it using
 regular C-style function declaration syntax.
 
*/

/*
  
  Usually we pass anonymous functions as
  arguments to other functions.
  
*/

void demoAnonFunction() {
    
    {String*} result = combine(
            (String s, Integer i) 
                => s.repeat(i), 
            "oh hello world goodbye".split(), 
            1..10);
    
    print(" ".join(result));
    
}

/*

  A "curried" function is a function with
  multiple parameter lists.
  
  Curried functions are especially useful
  for representing methods without supplying
  a receiving object. (Coming in M6!)

*/

String repeat(Integer times)(String s) 
        => (" "+s).repeat(times)[1...];

void demoCurriedFunction() {
    String(String) thrice = repeat(3);
    print(thrice("hello"));
    print(thrice("bye"));
}

/*
  
  There's one place we very commonly 
  encounter functions in curried form:
  "static" method references.
  
*/

String({String*})(String) staticJoinFun = String.join;

void testStaticMethodRef() {
    value joinWithCommas = staticJoinFun(", ");
    value string = joinWithCommas({"hello", "world"});
    print(string);
}

/*
  
  Static attribute references are especially useful,
  especially in combination with the map() method.
  
*/

void testStaticAttributeRef() {
    value words = {"hi", "hello", "hola", "jambo"};
    value lengths = words.map(String.size);
    print(lengths);
}

/*

 Because function types are defined in terms
 of the perfectly ordinary interfaces Callable
 and Tuple, it's possible to write functions
 that abstract over many function types at
 once. (This is not typically possible in 
 other languages.)
 
 The most useful such functions are compose(),
 curry(), shuffle(), and uncurry(). These are 
 perfectly ordinary functions, written entirely 
 in Ceylon!

*/

void demoGenericFunctions() {
    
    //TODO: change this "one-liner" to three lines
    value fun = uncurry(compose(curry(plus<Float>), 
            (String s) => parseFloat(s) else 0.0));
    
    assert(fun("3.0", 1.0)==4.0);
    
}

/*

 EXERCISE
 
 The code above is too "compact" to be easily
 understood. Use Source > Extract Value to
 pull out the subexpressions and see the type
 of each.

*/

/*

 We've now started to see some pretty 
 complicated types. To make it easier to deal
 with types like these, we can give them names.
 
*/

alias Predicate<T> => Boolean(T);
alias StringPredicate => Predicate<String>;

Boolean both<T>(Predicate<T> p, T x, T y) 
        => p(x) && p(y);

void testPredicates() {
    
    StringPredicate length5 
            = (String s) => s.size==5;
    
    assert(both(length5, "hello", "world"));
    assert(!both(length5, "goodbye", "world"));
    
}

