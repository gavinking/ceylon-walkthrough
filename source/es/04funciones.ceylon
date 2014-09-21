/*

 Como en casi cualquier lenguaje moderno, una
 función es un valor. El tipo de una función
 se representa con las interfaces Callable y Tuple,
 pero por lo general ocultamos dichas interfaces
 usando azúcar sintáctica. 

 El tipo de una función se escribe X(P,Q,R)
 donde X es el tipo de retorno y P,Q,R son
 los tipos de los parámetros. Además: 

 - P* es un parámetro variádico de tipo P, y
 - P= es un parámetro de tipo P con un valor
   por defecto. 

 A un valor cuyo tipo es una función
 generalmente lo llamamos "referencia a función".
 
*/

//El tipo de retorno de una función void es Anything
Anything(Anything) printFun = print;

//Para una función parametrizada, se deben especificar
//los argumentos de tipo, ya que un valor no puede
//tener parámetros libres.
Float(Float, Float) plusFun = plus<Float>;

//sum() tiene un parámetro variádico.
Integer(Integer*) sumFun = sum;

//¡Las clases también son funciones!
Singleton<Integer>(Integer) singletonFun =
        Singleton<Integer>;

//Incluso los métodos son funciones
String({String*}) joinWithCommasFun = ", ".join;

//split() tiene parámetros por defecto, indicados con =
{String*}(Boolean(Character)=, Boolean=, Boolean=) splitFun 
        = "Hello, world! Goodbye :-(".split;

//a "static" reference to an attribute of a type
//is another sort of function!
{Integer*}({Integer?*}) coalesceFun = 
        Iterable<Integer?>.coalesced;


/*

 Dado un valor con un tipo función, se puede
 hacer casi cualquier cosa que se puede hacer
 con la función referida.
 
 (Nota: lo que no se puede hacer es pasar
 argumentos con nombre.)
 
*/

void demoFunctionRefs() {
    printFun("Hello!");
    print(sumFun(3, 7, 0));
    print(plusFun(3.0, 7.0));
    print(singletonFun(0));
}

/*

 Los tipos función exhiben la varianza
 correcta respecto de sus tipos de retorno
 y de parámetros. Esto es tan sólo una
 consecuencia de los parámetros de tipo de
 Callable y Tuple. 

 Es decir, una función con tipos de parámetro
 más generales y un tipo de retorno más
 específico, es asignable a un tipo función.
 Suena complicado, pero de hecho la manera
 en que funciona es bastante intuitiva. 
 
*/

//Una función que acepta Anything también
//acepta String
Anything(String) printStringFun = printFun;

//Una función que retorna Singleton también
//es una función que retorna Iterable.
{Integer+}(Integer) iterableFun = singletonFun;

//¡Una función con un parámetro variádico también
//es una función que acepta dos parámetros!
Integer(Integer, Integer) sumBothFun = sumFun;

/*

 Generalmente usamos referencias a funciones para
 pasarlas a otras funciones.

*/

//TODO: cambiar la declaración de op para usar un
//tipo función
Float apply(Float op(Float x, Float y), Float z)
        => op(z/2,z/2);

void testApply() {
    assert (apply(plus<Float>, 1.0)==1.0);
    assert (apply(times<Float>, 3.0)==2.25);
}

/*
 EJERCICIO 

 El parámetro op() de apply() está declarado
 en "estilo de función", con sus parámetros
 listados después del nombre del parámetros,
 y el tipo de retorno al principio. Cambia la
 declaración para usar "estilo de valor",
 con un tipo función antes del nombre del
 parámetro.
 
*/

/*

 Incluso es posible escribir una función
 "anónima", embebida (inline) dentro de una
 expresión. 
 
*/

//TODO: cambiar la definición de la función a tipo "normal"
Float(Float, Float) timesFun = 
        (Float x, Float y) => x*y;

//TODO: Cambiar la definición de la función a tipo "normal"
Anything(String) printTwiceFun =
        void (String s) { 
            print(s); 
            print(s);
        };

/*

 EJERCICIO 

 ¡Lo que está escrito arriba es un MUY MAL estilo!
 El objetivo de las funciones anónimas es pasarlas
 como argumentos a otras funciones.
 Arregla ese código, reescribiéndolo usando la
 sintaxis declarativa normal tipo C.
 
*/

/*

 Por lo general pasamos funciones anónimas
 como argumentos a otras funciones.  
  
*/

void demoAnonFunction() {
    
    {String*} result = mapPairs(
            (String s, Integer i) => 
                    s.repeat(i), 
            "pues hola mundo adios".split(), 
            1..10);
    
    print(" ".join(result));
    
}

/*

 Una función currificada es una función
 con múltiples listas de parámetros.

*/

String repeat(Integer times)(String s) =>
   (" "+s).repeat(times)[1...];

void demoCurriedFunction() {
    String(String) thrice = repeat(3);
    print(thrice("hello"));
    print(thrice("bye"));
}

/*
 
 Hay un sitio en el que encontramos comúnmente
 funciones en forma currificada: referencias
 "estáticas" a métodos.
 
 */

String({String*})(String) staticJoinFun = String.join;

void testStaticMethodRef() {
    value joinWithCommas = staticJoinFun(", ");
    value string = joinWithCommas({"hello", "world"});
    print(string);
}

/*
 
 Las referencias estáticas a atributos son
 especialmente útiles, sobre todo en combinación
 con el método map().
 
 */

void testStaticAttributeRef() {
    value words = {"hi", "hello", "hola", "jambo"};
    value lengths = words.map(String.size);
    print(lengths);
}

/*

 Debido a que los tipos función se definen
 en términos de las interfaces Callable y 
 Tuple, que son tipos normales de Ceylon,
 es posible escribir funciones que abstraen
 varios tipos función al mismo tiempo. Esto
 generalmente no es posible en otros lenguajes.

 Las funciones más útiles de este tipo son
 compose(), curry(), shuffle(), y uncurry(). 
 ¡Estas son funciones normales, escritas
 completamente en Ceylon!

*/

void demoGenericFunctions() {

    //TODO: cambiar este código de una línea a
    //tres líneas    
    value fun = uncurry(compose(curry(plus<Float>), 
            (String s) => parseFloat(s) else 0.0));
    
    assert(fun("3.0", 1.0)==4.0);
    
}

/*

 EJERCICIO

 El código anterior es demasiado compacto para
 ser fácilmente entendible. Utiliza la opción
 Source > Extract Value para sacar de ahí las
 subexpresiones y ver el tipo de cada una.

*/

/*

Ya hemos empezado a ver unos tipos bastante complicados.
Para facilitar el manejo de tipos así, les podemos
dar nombres más simples.

*/

alias Predicate<T> => Boolean(T);
alias StringPredicate => Predicate<String>;

Boolean both<T>(Predicate<T> p, T x, T y) =>
        p(x) && p(y);

void testPredicates() {
    StringPredicate length5 = (String s)=>s.size==5;
    assert(both(length5, "hello", "world"));
    assert(!both(length5, "goodbye", "world"));
}
