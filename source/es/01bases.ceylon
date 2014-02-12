/*

 Un programa es simplemente una función de
 primer nivel sin parámetros. Para correr el
 programa, selecciona el nombre de la función y
 ve a:
 
   Run > Run As > Ceylon Application
   
*/

void hello() {
    print("¡Hola, Mundo!");
}

/*
 
 EJERCICIO
 
 ¡Probablemente quieras saber lo que hace
 print()! Puedes:
 - poner el cursor sobre el nombre de la
   función para ver su documentación, o
 - mantener pulsada la tecla ctrl o command
   mientras haces click sobre el nombre de la
   función para navegar a su declaración.
 
*/

/*

 hola() y print() son ejemplos de funciones de
 primer nivel - no necesitamos una instancia
 de un objeto para invocarlas.

 Una función de primer nivel puede aceptar
 argumentos y devolver un valor, en cuyo caso
 debemos especificar los tipos de los parámetros,
 así como el tipo de retorno.

 Un parámetro puede tener un valor por defecto. 

*/

String greeting(String name = "Mundo") {
    //Las expresiones interpoladas se rodean
    //con doble "backtick" dentro de una cadena.
    return "Hola, ``name``!";
}

/*

 Cuando una función sólo devuelve una expresión,
 se puede abreviar usando la fecha gorda.
 
*/

void helloName() => print(greeting("Ceylon"));

void helloWorld() => print(greeting());

/*

 Un parámetro puede ser variádico, es decir,
 puede aceptar múltiples valores. 
 
*/

Integer sum(Integer* numbers) {
    variable value sum = 0; //Los valores asignables deben anotarse con "variable"
    for (x in numbers) {
        sum+=x;
    }
    return sum;
}

void calculateSums() {
    
    //Una suma sin números
    print(sum());
    
    //La suma de dos números
    print(sum(2, 2));
    
    //La suma de los números del 0 al 10
    //inclusive, usando el operador de rango ..
    //y el operador spread *
    print(sum(*(0..10)));
   
    //Y para algo más interesante, la suma
    //de todos los números cuadrados del 0 al 100.
    //El operator ^ es para exponenciar. 
    print(sum(for (n in 0..10) n^2));
    
}

/*
 
 Las variables se llaman "valores" en Ceylon,
 ¡porque realmente no son variables por defecto!
 
*/

void greet() {
	String greeting = "hei verden";
	//TODO: ¡usa el IDE para rellenar el resto!
}

/*
 
 EJERCICIO
 
 Rellena el resto de esta función. No, no
 queremos que escribas a mano una llamada
 trivial a print(). Queremos que dejes al IDE
 hacerlo por ti:
 
 - Teclea parte del nombre de la función a la que
   quieres llamar.
 
 - ctrl-espacio activa el autocompletado.
 
 - Seleccionar una función te lleva al modo
   enlazado, donde puedes rellenar rápidamente
   los argumentos. Utiliza el tabulador para
   navegar entre ellos.
 
 - esc o un caracter tecleado fuera de los
   campos del modo enlazado abandona el modo
   enlazado.
 
*/


/*

 Un valor puede ser una constante (dentro
 de cierto alcance), una variable, o un
 accesor de lectura (getter)

*/

//Una constante de primer nivel
Integer zero = 0;

//Una variable con valor inicial
variable Integer int = zero;

//Un getter definido con flecha gorda
Integer intSquared => int^2;

//Un getter con todo un bloque de código
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

El compilador puede inferir el tipo de una
declaración local. Pon el cursor sobre la
palabra reservada "value" o "function" para
ver el tipo inferido de la declaración.

El tipo de un parámetro de una función no
puede ser inferido.

*/

void inferredTypes() {
    value time = system.milliseconds;
    value nl = operatingSystem.newline; 
    function sqr(Float float) => float*float;
}

/*

 EJERCICIO
 
 Pon el cursor sobre una palabra reservada
 "value" o "function" y selecciona en el menú:
 
   Source > Quick Fix / Assist
 
 Y luego selecciona 'Specify type' del menú
 emergente.
 
 O, selecciona la función completa, y la opción:
 
   Source > Reveal Inferred Types
 
*/

/*

 Se pueden escapar caracteres Unicode.
 Por ejemplo "pi" puede escribirse \{#03C0}. 

 ups... la consola de Eclipse está idiota.
 Ve a:
 
   Project > Properties > Resource

 y configura la codificación de tus archivos
 de texto a UTF-8 para correr este programa
 y que salga bien el resultado. 
 
*/

void helloPi() => print(greeting("\{#03C0}"));

/*

 Pero, ¿y si queremos imprimir "\{#03C0}"?
 Podemos usar un escape de diagonal inversa,
 o un string verbatim.

*/

void printTheUnicodeEscapeForPi() {

     //La doble diagonal inversa se convierte en su literal    
    print("\\{#03C0}");
   
    //Las comillas triples delimitan una cadena
    //verbatim donde no se interpretan secuencias
    //de escape. 
    print("""\{#03C0}""");
    
}

/*

 Hay cadenas que pueden abarcar varias líneas,
 especialmente cuando documentamos nuestro
 código en formato markdown. Deja el puntero
 del mouse sobre el nombre de esta función
 para ver su documentación.
 
*/

"Este programa imprime:

 - El _nombre de la máquina virtual,_
 - La _versión de la máquina virtual,_ y
 - La _versión de Ceylon._ 

 Utiliza los objetos [[operatingSystem]] y [[language]]
 definidos en `ceylon.language`, el módulo
 de lenguaje de Ceylon." 
void printInfo() =>
        print("Máquina virtual: ``operatingSystem.name``
               versión: ``operatingSystem.version``
               lenguaje: ``language.version`` (``language.versionName``)");
              //tip: Intenta usar el atributo "normalized" de la cadena.

/*

 Las anotaciones especifican metadatos de un elemento de programa.

*/

by ("Gavin")
throws (`class Exception`)
deprecated ("Bien, este programa no es muy útil.
             Prueba [[hello]] mejor.")
see (`function hello`)
void failNoisily() {
    throw Exception("¡aaaaarrrrrggggghhhhhhh!");
}

/*

 EJERCICIO
 
 Escribe un programa que imprima todos los
 números primos entre 1 y 100. ¡No olvides documentar
 tu trabajo! 
  
*/

//TODO: imprimir los números primos
