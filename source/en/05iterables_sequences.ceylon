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
