
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
{String+} manyStrings = { for (i in 0..100) i.string };

/*
 
 Iterable defines a large suite of methods for
 working with streams of values. For example,
 Iterable has the famous methods map(), 
 filter(), and fold().
 
*/

void demoMapFilterFold() {
    print((1..100)
            .filter((Integer i) => i%3==0)
            .map((Integer i) => i^2)
            //TODO: replace fold() with String.join()
            .fold("", (String partial, Integer ii) => 
                    partial + ", " + ii.string));
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

void demoComprehension() {
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

Boolean allNumbers1 = manyStrings.every((String s) => 
        parseInteger(s) exists);

Boolean allNumbers2 = every { for (s in manyStrings) 
        parseInteger(s) exists };

/*
 
 A sequence is an immutable sequence of values
 of finite length. Sequence types are written
 [T*] or [T+]. For reasons of tradition, we 
 are also allowed to write [T*] as T[].
 
 In fact, these are just abbreviations for
 Sequential<T> and Sequence<T>.
 
 We can construct a sequence using brackets.
 
*/

[String*] noStringsSeq = [];
[String+] twoStringsSeq = ["hello", "world"];
[String+] manyStringsSeq = [ for (i in 0..100) i.string ];

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

void testSequenceIndexing() {
    
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

void demoNonempty() {
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

void demoForWithIndexes() {
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

[Float, Integer, String, String] tuple = 
        [0.0, 22, "hello", "world"];

/*

 Elements may be retreived from a tuple 
 without losing any typing information.

*/

void testTupleIndexing() {
    Null nil1 = tuple[-1];
    Float float = tuple[0];
    Integer int = tuple[1];
    String string1 = tuple[2];
    String string2 = tuple[3];
    Null nil2 = tuple[4];
}

/*

 EXERCISE
 
 Go check out the declaration of Tuple to 
 understand how this works!

*/