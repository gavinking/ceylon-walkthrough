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

 hola() y print() son ejemplos de funciones de
 primer nivel - no necesitamos una instancia
 de un objeto para invocarlas.

 Para ver la definición de print(), haz click
 sobre su nombre con la tecla CTRL/CMD oprimida.

 Una función de primer nivel puede aceptar
 argumentos y devolver un valor, en cuyo caso
 debemos especificar los tipos de los parámetros,
 así como el tipo de retorno.

 Un parámetro puede tener un valor por defecto. 

*/

String greeting(String nombre = "Mundo") {
    //Las expresiones interpoladas se rodean
    //con doble "backtick" dentro de una cadena.
    return "Hola, ``nombre``!";
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

Integer sum(Integer* numeros) {
    variable value sum = 0; //Los valores asignables deben anotarse con "variable"
    for (x in numeros) {
        sum+=x;
    }
    return sum;
}

void calculateSums() {
    
    //Una suma sin números
    print(sum());
    
    //La suma de dos números
    print(sum(2, 2));
    
    //La suma de los números del 1 al 10
    //inclusive, usando el operador de rango ..
    print(sum(*(0..10)));
   
    //Y para algo más interesante, la suma
    //de todos los números cuadrados del 0 al 100.
    //El operator ^ es para exponenciar. 
    print(sum(for (n in 0..10) n^2));
    
}

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

 Utiliza los objetos [[process]] y [[language]]
 definidos en `ceylon.language`, el módulo
 de lenguaje de Ceylon." 
void printInfo() =>
        print("Máquina virtual: ``process.vm``
               versión: ``process.vmVersion``
               lenguaje: ``language.version`` (``language.versionName``)");
              //tip: Intenta usar el atributo "normalized" de la cadena.

/*

 Las anotaciones especifican metadatos de un elemento de programa.

*/

by ("Gavin")
throws (Exception)
deprecated ("BIen, este programa no es muy útil.
             Prueba [[hello]] mejor.")
see (hello)
void failNoisily() {
    throw Exception("aaaaarrrrrggggghhhhhhh");
}

/*

 EJERCICIO
 
 Escribe un programa que imprima todos los
 números primos entre 1 y 100. No olvides documentar
 tu trabajo! 
  
*/

//TODO: imprimir los números primos
