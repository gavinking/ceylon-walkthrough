
/*

 Ya conocimos el tipo Iterable. Normalmente
 escribimos:

 - {T*} para indicar un iterable de cero o
   más instancias de T
 - {T+} para indicar un iterable de una o
   más instancias de T 

 De hecho, estas abreviaciones simplemente
 significan Iterable<T,Null> e Iterable<T,Nothing>
 respectivamente.

 Y por supuesto, {T+} es un subtipo de {T*}.

 Se puede construir un Iterable usando llaves.
 
*/

{String*} noStrings = {};
{String+} twoStrings = {"hello", "world"};
{String+} manyStrings = { for (i in 0..100) i.string };

/*

 Iterable define bastantes métodos para trabajar
 con flujos de valores. Por ejemplo, los famosos
 métodos map(), filter() y fold().
 
*/

void demoMapFilterFold() {
    print((1..100)
            .filter((Integer i) => i%3==0)
            .map((Integer i) => i^2)
            //TODO: reemplazar fold() con String.join()
            .fold("", (String partial, Integer ii) => 
                    partial + ", " + ii.string));
}

/*

 EJERCICIO 

 Limpiar el código anterior usando String.join(). 
 
*/

/*

 El código anterior es bastante ruidoso. Es
 mucho más común usar comprensiones para
 expresar este tipo de cosas.

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

 Una comprensión puede tener varias cláusulas
 de for y de if.

*/

{Character*} ss = { 
    for (arg in process.arguments)
        for (c in arg)
            if (c.uppercase)
                c.uppercased
};

/*

 Por lo tanto, en muchos casos tenemos dos
 maneras distintas de expresar algo:

 - usando funciones anónimas, o
 - usando una comprensión.

*/

Boolean allNumbers1 = manyStrings.every((String s) => 
        parseInteger(s) exists);

Boolean allNumbers2 = every { for (s in manyStrings) 
        parseInteger(s) exists };

/*

 Una secuencia es una lista inmutable de valores
 con una longitud finita. Los tipos secuencia se
 escriben [T*] o [T+]. Y para no romper con la
 tradición, [T*] también se puede escribir como T[].

 De hecho, lo anterior son simples abreviaciones para
 Sequential<T> y Sequence<T>. 

 Podemos construir una secuencia usando corchetes. 
 
*/

[String*] noStringsSeq = [];
[String+] twoStringsSeq = ["hello", "world"];
[String+] manyStringsSeq = [ for (i in 0..100) i.string ];

/*

 La secuencia vacía [] es de tipo Empty, que se
 escribe []. 
 
*/

[] emptySeq = [];

/*

 Podemos acceder a los elementos de una secuencia
 (o cualquier otro subtipo de List) usando
 el operador de índice.

*/

void testSequenceIndexing() {

    //El operador de índice con un solo elemento
    //resulta en un tipo posiblemente nulo,
    //por tanto no hay IndexOutOfBoundsException.    
    assert(exists world = twoStringsSeq[1],
            world=="world");

    //Los operadores de índice con rango cerrado
    //y abierto resultan en una secuencia. 
    assert(manyStringsSeq[1..2]==["1", "2"]);
    assert(manyStringsSeq[99...]==["99", "100"]);
    
}

/*
 Podemos acotar una secuencia posiblemente vacía
 (una [T*]) a una secuencia no vacía (una [T+])
 usando el operador nonempty.
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
