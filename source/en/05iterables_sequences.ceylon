/*

 We've already met the type Iterable. We 
 usually write:
 
 - {T*} to mean an iterable of zero or more 
   instances of T
 - {T+} to mean an iterable of one or more 
   instances of T
 
 In fact, these type abbreviations just mean
 Iterable<T,Null> and Iterable<T,Nothing>,
 respectively.
 
 Of course, {T+} is a subtype of {T*}.
 
 We can construct an iterable using braces.

*/

{String*} noStrings = {};
{String+} twoStrings = {"hello", "world"};
{String+} manyStrings = { for (n in 0..100) n.string };

/*
 
 Iterable defines a large suite of methods for
 working with streams of values. For example,
 Iterable has the famous methods map(), 
 filter(), and fold().
 
 Here we're letting Ceylon infer the type of
 the anonymous function parameters.
 
*/

shared void demoMapFilterFold() {
    print((1..100)
            .filter((i) => i%3==0)
            .map((i) => i^2)
            //TODO: replace fold() with String.join()
            .fold("")((partial, ii) 
                    => partial + ", " + ii.string));
}

/*
 
 EXERCISE
 
 Clean up the code above using String.join().
 
*/

/*

 The code above is quite noisy. It's much more
 usual to use comprehensions to express this
 kind of thing.

*/

shared void demoComprehension() {
    value squares = { 
        for (i in 1..100) 
            if (i%3==0) 
                (i^2).string 
    };
    print(", ".join(squares));
}

/*

 A comprehension may have multiple for and if
 clauses.

*/

{Character*} ss = { 
    for (arg in process.arguments)
        for (c in arg)
            if (c.uppercase)
                c.uppercased
};

/*

 So we often have a choice of two different
 ways to express something:
 
 - using anonymous functions, or
 - using a comprehension.

*/

Boolean allNumbers1 = manyStrings.every((String s) 
        => parseInteger(s) exists);

Boolean allNumbers2 = every { 
    for (s in manyStrings) 
            parseInteger(s) exists 
};

/*
 
 A sequence is an immutable list of values
 of finite length. Sequence types are written
 [T*] or [T+]. For reasons of tradition, we 
 are also allowed to write [T*] as T[].
 
 In fact, these are just abbreviations for
 Sequential<T> and Sequence<T>.
 
 We can construct a sequence using brackets.
 
*/

[String*] noStringsSeq = [];
[String+] twoStringsSeq = ["hello", "world"];
[String+] manyStringsSeq = [ for (n in 0..100) n.string ];

/*
 
 The empty sequence [] is of type Empty, which
 we write [].
 
*/

[] emptySeq = [];

/*

 We can access the elements of a sequence (or
 of any other kind of List) using the index 
 operator.

*/

shared void testSequenceIndexing() {
    
    //the single-index indexing operator
    //results in a possibly-null type!
    //(there is no IndexOutOfBoundsException)
    assert(exists world = twoStringsSeq[1],
            world=="world");
    
    //the closed and open ranged indexing 
    //operators result in a sequence
    assert(manyStringsSeq[1..2]==["1", "2"]);
    assert(manyStringsSeq[99...]==["99", "100"]);
    
}

/*
 We can narrow a possibly-empty sequence (a
 [T*]) to nonempty sequence (a [T+]) using the
 nonempty operator.
*/

shared void demoNonempty() {
    if (nonempty args = process.arguments) {
        //hover over args and first to see 
        //their types!
        value first = args.first;
        print(first);
    }
}

/*
 
 We can iterate the indexes and elements of
 a sequence (or any other kind of List).
 
*/

shared void demoForWithIndexes() {
    for (i->s in twoStringsSeq.indexed) {
        print("``i`` -> ``s``");
    }
}

/*

 Tuples are a special kind of sequence: a 
 typed linked list. Tuple types are specified
 by listing element types in brackets, and a
 tuple is created by listing its elements
 in brackets.

*/

[Float, Integer, String, String] tuple 
        = [0.0, 22, "hello", "world"];

/*

 Elements may be retrieved from a tuple 
 without losing any typing information.

*/

shared void demoTupleIndexing() {
    Null nil1 = tuple[-1];
    Float float = tuple[0];
    Integer int = tuple[1];
    String string1 = tuple[2];
    String string2 = tuple[3];
    Null nil2 = tuple[4];
}

/*
 
 Really, all this is just syntax sugar for
 the Tuple class. We always use the sugar
 in this case; we never want to write the 
 following:
 
 */

shared void desugaredTuple() {
    Tuple<Float|String,Float,Tuple<String,String,Empty>> pair 
            = Tuple(1.0,Tuple("hello",[]));
    Float float = pair.first;
    String string = pair.rest.first;
    Null nil = pair.rest.rest.first;
}

/*

 EXERCISE
 
 Go check out the declaration of Tuple to 
 understand how this works!

*/

/*
 
 We can use the spread operator to pass a tuple
 containing arguments to a function. Remember that
 a function type consists of a return type and a
 tuple type encoding the parameter types? Well, 
 the spread argument tuple must be assignable to 
 that tuple type.
 
*/

shared void demoSpreadTuple() {
    value args = [(Character c) => !c.letter, true];
    for (word in "Hello, World! Goodbye.".split(*args)) {
        print(word);
    }
}

/*
 
 We can use tuples to define functions with multiple 
 return values.
 
 */

//a function that produces a tuple
[String, String?, String] parseName(String name) {
    value it = name.split().iterator();
    "first name is required"
    assert (is String first = it.next());
    "last name is required"
    assert (is String second = it.next());
    if (is String third = it.next()) {
        return [first, second, third];
    }
    else {
        return [first, null, second];
    }
}

/*
 
 The spread operator and the unflatten() function 
 help us compose such functions.
 
 */

//a function with multiple parameters
String welcome(String first, String? middle, String last) => 
        "Welcome, ``first`` ``last``!";

shared void demoFunctionComposition() {
    //the * operator "spreads" the tuple result
    //of parseName() over the parameters of
    //welcome()
    print(welcome(*parseName("John Doe")));
    
    //but what if we want to compose parseName()
    //and welcome() without providing arguments
    //up front? Well, we can use compose() and
    //unflatten()
    value greet = compose(print, 
    compose(unflatten(welcome), parseName)); 
    greet("Jane Doe");
    
    //so we could actually re-express the first
    //example in terms of unflatten()
    print(unflatten(welcome)(parseName("Jean Doe"))); 
}