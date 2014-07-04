/*

 Jeder Wert ist eine Instanz einer Klasse. Die
 einfachsten Klassen gruppieren einfach etwas
 zusammengehörigen Zustand in Attributen.
 
 Klassen haben Member:
 
 - Parameter,
 - Methoden (Member-Funktionen),
 - Attribute (Member-Werte), und
 - Member-Klassen.
 
 Jeder Member, der mit shared annotiert ist,
 ist Teil der API der Klasse und von außerhalb
 der Klasse zugänglich.
 
 Für einfache Klassen müssen wir normalerweise
 die Member string, equals() und hash verfeinern,
 die von der Standard-Superklasse Basic geerbt werden.
 
 Ein Member, der mit actual annotiert ist, verfeinert
 einen Member der Superklasse.

*/

class Time(shared Integer hour, 
           shared Integer minute) {
    
    shared Integer secondsSinceMidnight =>
            minute%60*60 + hour*60*60;
    
    shared actual Integer hash => 
            secondsSinceMidnight;
    
    shared actual Boolean equals(Object that) {
        // "is Time" überprüft den Typ des Werts
        // und schränkt ihn ein
        if (is Time that) {
            // hier hat that den Typ Time
            return secondsSinceMidnight == 
                   that.secondsSinceMidnight;
        }
        else {
            return false;
        }
    }
    
    // Falls du keine Lust hast,
    // "shared actual Type" zu schreiben, kannst
    // du die folgende, abgekürzte Syntax verwenden:
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

 Um Klassen zu testen, sind Assertions sehr
 nützlich. Lasse diese Funktion laufen, um
 eine fehlgeschlagene Assertion zu sehen.

*/

// TODO: Assertion-Fehler beheben
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

 ÜBUNG
 
 Passe die Time-Klasse so an, dass alle Assertions
 erfolgreich sind.

*/

/*

 Der Zustand mancher Klassen ist veränderlich.
 Wenn ein Attribut veränderlich ist, muss es
 variable annotiert sein.

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

 ÜBUNG
 
 Füge eine reset()-Methode zu Counter hinzu.
 
 Wenn du willst, kannst du die IDE fast die ganze
 Arbeit für dich machen lassen. Entferne zunächst
 die Kommentarzeichen aus dem Code unten. Die
 IDE wird einen Fehler anzeigen, und wenn du den
 Mauszeiger über den Fehler hältst, oder
 
   Edit > Quick Fix / Assist
 
 verwendest, während der Cursor auf dem Fehler ist,
 kann dir die IDE eine teilweise Korrektur vorschlagen.

*/

// TODO: diesen Test wieder reinkommentieren
//       und zum Funktionieren bringen
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

 Eine Unterklasse kann unsere Klasse ableiten
 und ihre Member verfeinern. Ein Member kann
 verfeinert werden, wenn er default annotiert ist.

*/

class SecondTime(Integer hour, 
                 Integer minute, 
                 second) 
        extends Time(hour, minute) {

    // Wir können den Typ und die Annotationen
    // eines Parameters im Körper der Klasse
    // deklarieren, damit die Parameterliste
    // aufgräumter aussieht.
    shared Integer second;
    
    /*
     
     Ups - der folgende Code ist fehlerhaft!
     
     Kommentiere ihn zunächst wieder rein, und
     behebe dann den Fehler, indem du eine
     default-Annotation zu Time.secondsSinceMidnight
     (oben) hinzufügst.
     
    */
    
    //TODO: reinkommentieren, Fehler beheben!
    //secondsSinceMidnight => 
    //        super.secondsSinceMidnight+second%60;
    
}

/*

 ÜBUNG
 
 Behebe die Fehler in Time und SecondTime,
 so dass die folgenden Tests erfolgreich durchlaufen.

*/

// TODO: Assertion-Fehler beheben
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

/*

 Eine anonyme Klassendeklaration definiert
 eine Instanz. Damit wird gleichzeitig eine
 Klasse und ihr einziger Wert deklariert.

*/

object midnight extends SecondTime(0,0,0) {
    // TODO: reinkommentieren, Fehler beheben
    //string => "midnight";
}

/*

 Eine abstrakte Klasse ist eine Klasse, die
 nicht instanziiert werden kann. Sie kann
 Member deklarieren, die formal annotiert sind
 und dann von konkreten Unterklassen implementiert
 werden müssen.
 
 Ein aufgezählter Typ ist eine abstrakte Klasse oder
 eine Schnittstelle, die ihre Untertypen aufzählt
 und damit einschränkt.

*/

abstract class LinkedList<out T>() 
        of Cons<T> | empty {
    shared formal Integer length;
}

// Dieser Fall des aufgezählten Typs ist eine Klasse
class Cons<out T>(shared T first,
                  shared LinkedList<T> rest) 
        extends LinkedList<T>() {
    length=>rest.length+1;
}

// Dieser Fall des aufgezählten Typs ist ein Singleton-Objekt
object empty 
        extends LinkedList<Nothing>() {
    length=>0;
}

String formatLinkedList(LinkedList<Object> list) {
    // Wir verwenden ein switch-Statement,
    // um die verschiedenen Fälle des aufgezählten
    // Typs abzuhandeln. Der Compiler stellt sicher,
    // dass alle Fälle ausgeschöpft werden.
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

 ÜBUNG
 
 Schreibe eine Java-mäßige enum in Ceylon. Das
 klassische Beispiel sind die Farben einer Spielkarte:
 Kreuz, Pik, Herz, Karo.

*/

// TODO: Schreibe hier eine Farbe-Klasse
