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
        //Pon el cursor sobre args y first
        //para ver sus tipos!
        value first = args.first;
        print(first);
    }
}

/*

 Se pueden iterar los índices y los elementos
 de una secuencia (o cualquier otro subtipo
 de List). 
 
*/

void demoForWithIndexes() {
    for (i->s in twoStringsSeq.indexed) {
        print("``i`` -> ``s``");
    }
}

/*

 Las tuplas son un tipo especial de secuencia:
 es una lista ligada y con tipos. Para
 especificar un tipo tupla se listan los tipos
 de los elementos en corchetes, y una tupla
 se crea simplemente listando sus elementos
 entre corchetes.

*/

[Float, Integer, String, String] tuple = 
        [0.0, 22, "hello", "world"];

/*

 Los elementos de una tupla se pueden
 extraer sin perder ninguna información
 de tipo.

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
 
 De hecho, todo esto es simplemente azúcar 
 para la clase Tuple. Siempre utilizamos
 el azúcar en este caso; nunca queremos 
 escribir lo siguiente:
 
 */

void desugaredTuple() {
    Tuple<Float|String,Float,Tuple<String,String,Empty>> pair 
            = Tuple(1.0,Tuple("hello",[]));
    Float float = pair.first;
    String string = pair.rest.first;
    Null nil = pair.rest.rest.first;
}

/*

 EJERCICIO

 ¡Revisa la declaración de la clase Tuple
 para entender cómo funciona todo esto! 

*/

/*
 
 Podemos utilizar el operador spread para pasar
 una tupla conteniendo argumentos a una función.
 Recuerda que un tipo función consta de un tipo
 de retorno y un tipo de tupla que representa
 los tipos de los parámetros. Asi, la tupla de
 argumentos tiene que ser asignable al tipo de
 tupla de los parámetros.
 
*/

void demoSpreadTuple() {
    value args = [(Character c)=>!c.letter, true];
    for (word in "Hello, World! Goodbye.".split(*args)) {
        print(word);
    }
}

/*
 
 Podemos usar tuplas para definir funciones con
 múltiples valores de retorno.
 
 */

//una función que produce una tupla
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
 
 El operador spread y la función unflatten() nos 
 ayudan a componer este tipo de funciones.
 
 */

//una función con múltiples parámetros
String welcome(String first, String? middle, String last) => 
        "Welcome, ``first`` ``last``!";

void demoFunctionComposition() {
    //el operador * "esparce" la tupla
    //resultado de parseName() sobre los
    //parámetros de welcome()
    print(welcome(*parseName("John Doe")));
    
    //pero ¿y si queremos componer parseName()
    //y welcome() sin proporcionar los
    //argumentos por adelantado? Bien, podemos
    //usar compose() y unflatten()
    value greet = compose(print, 
    compose(unflatten(welcome), parseName)); 
    greet("Jane Doe");
    
    //así que en realidad podríamos reescribir el
    //primer ejemplo en términos de unflatten()
    print(unflatten(welcome)(parseName("Jean Doe"))); 
}
