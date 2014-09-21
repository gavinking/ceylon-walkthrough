import ceylon.collection {
    HashSet,
    MutableSet
}
/*

 Un tipo unión representa una elección entre varios tipos.
 Un tipo unión se escribe A|B para los tipos A y B.

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

 Manejamos los valores ausentes o "nulos"
 usando tipos unión. La clase Null tiene una
 única instancia llamada null, que representa
 un valor ausente. Por lo tanto, una cadena
 que posiblemente sea nula se representa
 con el tipo Null|String.

 Podemos escribir el tipo "Null|String"
 usando la abreviación sintáctica "String?".
 Esto es simplemente azúcar para la unión
 de un tipo con Null.

 Corre el siguiente programa con y sin un
 argumento de línea de comando. Puedes indicar
 un argumento de línea de comando usando:

   Run > Run Configurations... 
 
*/

void helloArguments() {
    String? name = process.arguments[0];
    if (is String name) { //TODO: usar exists
        print("hello " + name);
    }
    else {
        print("hello world");
    }
}

/*

 EJERCICIO

 Normalmente usamos el operador "exists" en
 vez de "is String" en código como el anterior.
 Modifica tu programa para que use exists.
 ¡Más azúcar sintáctica! 

 Ahora, para hacer el código un poco más
 compacto, modifícalo para que use esta forma
 de if: 
 
   if (is String name = process.arguments[0])

 (Pero usando "exists", no "is String".) 
 
*/

/*

 Los operadores then y else producen y
 consumen valores nulos. 
 
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

 EJERCICIO

 Cambia el programa helloArguments() para que
 utilice un operador en vez del if. 

*/

/*

 Una intersección representa la combinación de
 dos tipos. La intersección de los tipos A y B
 se escribe A&B.

 Los tipos intersección generalmente surgen como
 resultado de acotación de tipos. 

 Nota: La sintaxis {T*} significa una secuencia
 iterable de valores de tipo T. Es azúcar
 sintáctica para la interfaz Iterable. 

*/

T? third<T>({T*} iterable) {
    if (is Correspondence<Integer, T> iterable) {
        //Pon el cursor sobre iterable para ver
        //su tipo acotado dentro de este bloque
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

 Cabe resaltar que el tipo de thrd aquí arriba
 es <Null|Character>&Object, que se expande a
 Null&Object|Character&Object, que se simplifica
 como Nothing|Character, que a su vez se simplifica
 más como Character. El verificador de tipos
 (typechecker) realiza todo este razonamiento
 de manera automática.

 Los tipos unión e intersección son especialmente
 útiles a la hora de hacer inferencia de tipos. 
 
*/

void demoTypeInference() {
    //Pon el cursor sobre joined para ver su tipo
    value joined = concatenate("hello", 1..69);
    Object[] objects = joined;
    print(objects);
}

/*

 Los tipos unión e intersección también
 ayudan a definir correctamente los tipos
 de las operaciones de unión e intersección
 en los conjuntos.

 La unión e intersección de conjuntos se definen
 en término de los métodos intersection() y
 union() en la interfaz Set. Los operadores
 | y & son azúcar sintáctica para estos
 métodos.

 Puedes ver la definición de estos métodos en
 la documentación de Set para ver cómo a su vez
 se definen en términos de la unión/intersección
 de sus tipos. 

*/

void demoSets() {
    Set<Character> chars = HashSet { elements = "hello"; };
    Set<Integer> ints = HashSet { elements = 0..10; };
    //pon el cursor sobre intsAndChars para ver su tipo
    value intsAndChars = chars|ints;
    print(intsAndChars);
    //pon el cursor sobre empty para ver su tipo
    value empty = chars&ints;
    print(empty);
}

/*

 EJERCICIO

 El tipo especial Nothing es el tipo "fondo", un
 tipo que no tiene instancias. 

 Explica por qué el tipo de la intersección
 chars&ints en el código anterior es un Set<Nothing>,
 dado que los tipos Character e Integer son
 tipos disjuntos (no tienen instancias en común).

 P.D. Character e Integer son clases finales,
      no relacionadas por herencia, y por lo tanto 
      disjuntas.

*/

/*
 
 Espera, si Nothing no tiene valores, ¿cuál es el
 significado del siguiente código correctamente
 tipado?
 
*/

void thereIsNoNothing() {
	Nothing n = nothing;
	print(n);
}

/*
 
 Bien, el tipo Nothing indica, en la práctica,
 que la invocación de una función o la evaluación
 de un valor:
 
 - no termina, o
 - lanza una excepción.
 
 Podría parecer que Nothing no es demasiado útil,
 pero ayuda un montón cuando se definen tipos
 genéricos y funciones genéricas.
 
*/

/*

 La función coalesce() es muy útil y demuestra
 una buena aplicación de intersecciones.

 Revisa la definición de coalesce() para ver
 cómo funciona. 

*/

void demoCoalesce() {

    //{String?*} es el tipo de un iterable de
    //cadenas y nulos    
    {String?*} stringsAndNulls = {"hello", null, "world"};
   
    //{String*} es el tipo de un iterable de
    //puras cadenas (sin nulos) 
    {String*} strings = stringsAndNulls.coalesced;
    
    assert (strings.sequence() == ["hello", "world"]);
    
}

/*

 Hay un truco especial que se puede hacer con tipos
 unión que nos ayuda a darle el tipo correcto a
 funciones como max() y min().

 El problema es que cuando tenemos "cero o más"
 cosas, max() puede devolver null. Pero cuando
 tenemos "una o más" cosas, nunca devolverá null.
 Y cuando tenemos exactamente cero cosas, max()
 siempre devolverá null. ¿Cómo se puede capturar
 esto dentro del sistema de tipos?
 
*/

void demoMax() {
    
    Null maxOfZero = max({});
    
    {Integer+} oneOrMore = {1, 2};
    Integer maxOfOneOrMore = max(oneOrMore);
    
    {Integer*} zeroOrMore = {1, 2};
    Integer? maxOfZeroOrMore = max(zeroOrMore);
    
}

/*

 EJERCICIO

 Revisa las definiciones de max() e
 Iterable para descifrar cómo es que lo
 anterior funciona...

*/
