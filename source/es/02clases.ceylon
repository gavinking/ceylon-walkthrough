/*

 Un valor es una instancia de una clase. Las
 clases más simples lo único que hacen es
 juntar cierto estado relacionado en atributos.

 Las clases tienen miembros:

 - parámetros,
 - métodos (funciones miembro),
 - atributos (valores miembro), y
 - clases miembro.
 
 Cualquier miembro anotado como "shared" forma
 parte del API de la clase y se puede acceder
 a él desde fuera de la misma.

 Para clases simples, por lo general hay que
 refinar los miembros string, equals() y hash,
 que son heredados de Basic, el supertipo por
 defecto.

 Un miembro anotado como "actual" refina un
 miembro de un supertipo de la clase. 
 
*/

class Time(shared Integer hour, 
           shared Integer minute) {
    
    shared Integer secondsSinceMidnight =>
            minute%60*60 + hour*60*60;
    
    shared actual Integer hash => 
            secondsSinceMidnight;
    
    shared actual Boolean equals(Object that) {
        //"is Time" prueba y acota el tipo
        //del valor.
        if (is Time that) {
            //"that" es de tipo Time en este bloque
            return secondsSinceMidnight == 
                   that.secondsSinceMidnight;
        }
        else {
            return false;
        }
    }
    
    //si te aburre escribir "shared actual Type",
    //puedes usar esta abreviación
    string => "``hour``:``minute``";
    
}

void tryOutTime() {
    Time time1 = Time(13,30);
    print(time1);
    Time time2 = Time(37,30);
    print(time2);
    Time time3 = Time(13,29);
    print(time2);
    print(time1==time2);
    print(time1==time3);
    print(time1.secondsSinceMidnight);
}

/*

 Las aserciones son muy útiles para probar
 clases. Corre esta función para ver cómo
 ocurre una falla de aserción.

*/

//TODO:  hacer que las aserciones pasen
void testTime() {
    Time time1 = Time(13,30);
    assert (time1.string=="13:30");
    Time time2 = Time(37,30);
    assert (time2.string=="37:30");
    Time time3 = Time(13,29);
    assert (time3.string=="13:29");
    assert (time1==time2);
    assert (time1!=time3);
    assert (time1.secondsSinceMidnight==48600);
}

/*
 
 EJERCICIO
 
 Modificar la clase Time para que las aserciones 
 pasen.
 
 */

/*

 Algunas clases tienen estado mutable. Si un
 atributo es mutable, debe ser anotado "variable".

*/

class Counter(count=0) {
    shared variable Integer count;
    shared void inc() => count++;
    string => count.string;
}

void testCounter() {
    value counter = Counter();
    assert (counter.count==0);
    counter.inc();
    counter.inc();
    assert (counter.count==2);
    counter.count = 0;
    assert (counter.count==0);
}

/*

 EJERCICIO 

 Agregar un método reset() a la clase Counter. 

 Si eres ingenioso, puedes lograr que el IDE
 escriba casi todo el código por ti. Primero
 descomenta el código de prueba aquí abajo,
 y observa el error que te indica el IDE.
 Pon el mouse sobre el error, o utiliza:
 
   Edit > Quick Fix / Assist

 con el cursor sobre el error, para que el IDE
 te proponga una solución parcial. 
 
*/

//TODO: descomentar esta prueba y hacer que pase
//void testReset() {
//    value counter = Counter();
//    assert (counter.count==0);
//    counter.inc();
//    counter.inc();
//    assert (counter.count==2);
//    counter.reset();
//    assert (counter.count==0);
//}

/*

 Una subclase puede extender nuestra clase, y
 refinar sus miembros. Un miembro de clase puede
 ser refinado sólo si está anotado como "default". 
  
*/

class SecondTime(Integer hour, 
                 Integer minute, 
                 second) 
        extends Time(hour, minute) {
    
    //Podemos declarar el tipo y las
    //anotaciones de un parámetro en el cuerpo
    //de la clase, para dejar más limpia la lista
    //de parámetros.
    shared Integer second;
    
    /*
    
     Ups, el siguiente código tiene un error...
     
     Primero descomenta el código, y luego
     arréglalo agregando una anotación "default"
     a Time.secondsSinceMidnight arriba.
     
    */
    
    //TODO: descomentar y arreglar el error
    //secondsSinceMidnight => 
    //        super.secondsSinceMidnight+second%60;
    
}

/*

 EJERCICIO 

 Arreglar la implementación de Time y SecondTime
 para que las siguientes pruebas pasen. 
 
*/

//TODO: hacer que estas aserciones pasen.
void testSecondTime() {
    Time time = Time(13,30);
    assert (time.string=="13:30");
    SecondTime stime1 = SecondTime(13,30,00);
    SecondTime stime2 = SecondTime(13,30,25);
    assert (time==stime1);
    assert (time!=stime2);
    assert (stime1.string=="13:30:00");
    assert (stime2.string=="13:30:25");
}

//TODO: Traducir:

/*
 
 An anonymous class declaration defines an 
 instance. It's a combination value and
 class declaration.
 
 */

object midnight extends SecondTime(0,0,0) {
    //TODO: uncomment and fix the error
    //string => "midnight";
}

/*

 Una clase abstracta es una clase que no se
 puede instanciar. Puede declarar miembros
 "formal", que deben ser implementados por
 subclases concretas de la clase abstracta. 
 
 Un tipo enumerado es una clase o interfaz
 abstracta que enumera (restringe) sus
 subtipos.
 
*/

abstract class LinkedList<out T>() 
        of Cons<T> | empty {
    shared formal Integer length;
}

//Este caso del tipo enumerado es
//una clase
class Cons<out T>(shared T first,
                  shared LinkedList<T> rest) 
        extends LinkedList<T>() {
    length=>rest.length+1;
}

//Ese caso del tipo enumerado es un
//objeto singleton
object empty 
        extends LinkedList<Nothing>() {
    length=>0;
}

String formatLinkedList(LinkedList<Object> list) {
    //Usamos el switch para manejar los casos
    //de un tipo enumerador. El compilador valida
    //que el switch considere todos los casos.
    switch (list)
    case (empty) {
        return "";
    }
    case (is Cons<Object>) {
        value rest = list.rest;
        value firstString = list.first.string;
        switch (rest)
        case (empty) {
            return firstString;
        }
        else {
            return firstString + ", " + 
                    formatLinkedList(rest);
        }
    }
}

void testLinkedList() {
    value list = Cons("Smalltalk", Cons("Java", Cons("Ceylon", empty)));
    assert (list.length==3);
    print(formatLinkedList(list));
}

/*

 EJERCICIO

 Escribe un enum estilo Java pero en Ceylon.
 El ejemplo clásico es el de la baraja, con
 los casos corazones, diamantes, espadas y tréboles. 

*/

//TODO: escribir una clase Baraja
