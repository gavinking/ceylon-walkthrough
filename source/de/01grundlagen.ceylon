/*

 Ein Programm ist einfach eine Funktion oberster
 Ebene ohne Parameter. Um das Programm auszuführen,
 wähle den Funktionsnamen aus und starte:
 
   Run > Run As > Ceylon Java Application

*/

void hello() {
    print("Hallo, Welt!");
}

/*

 ÜBUNG
 
 Du willst vermutlich wissen, was print() macht!
 Dazu kannst du:
 
 - den Mauszeiger über den Funktionsnamen halten,
   um die Dokumentation der Funktion zu sehen, oder
 - die Strg- bzw. Befehlstaste gedrückt halten und
   gleichzeitig den Funktionsnamen klicken, um die
   Funktionsdeklaration aufzurufen.

*/

/*

 hello() und print() sind Beispiele für Funktionen
 oberster Ebene - wir brauchen keine Instanz eines
 Objekts, um sie aufzurufen.
 
 Eine Funktion oberster Ebene kann Argumente entgegen-
 nehmen und Werte zurückgeben; in diesem Fall müssen
 wir sowohl die Typen der Parameter als auch den Typ
 des zurückgegebenen Werts angeben.
 
 Ein Parameter kann einen Standardwert haben.

*/

String greeting(String name = "Welt") {
    // Wenn ein String-Literal in doppelte "Backticks"
    // eingeschlossene Ausdrücke enthält, werden diese
    // ausgewertet und das Ergebnis in den String eingefügt.
    return "Hallo, ``name``!";
}

/*

 Wenn eine Funktion nur einen Ausdruck zurückgibt,
 können wir das mit einem Zuweisungspfeil abkürzen.

*/

void helloName() => print(greeting("Ceylon"));

void helloWorld() => print(greeting());

/*

 Ein Parameter kann variadisch sein,
 d. h. mehrere Werte entgegennehmen.

*/

Integer sum(Integer* numbers) {
    variable value sum = 0; // Veränderliche Werte müssen "variable" annotiert sein
    for (x in numbers) {
        sum+=x;
    }
    return sum;
}

void calculateSums() {
    
    // Leere Summe
    print(sum());
    
    // Summe zweier Zahlen
    print(sum(2, 2));
    
    // Die Summe aller Zahlen von 0 bis 10
    // (jeweils inklusive), unter Verwendung
    // des Bereichs-Operators .. (range-Operator)
    // und des Verteilungs-Operators * (spread-Operator)
    print(sum(*(0..10)));
    
    // Um deinen Appetit anzuregen:
    // Die Summe aller Quadratzahlen von 0 bis 100!
    // Der ^-Operator potenziert Zahlen.
    print(sum(for (n in 0..10) n^2));
    
}

/*

 Variablen heißen in Ceylon "Werte" ("values"),
 weil sie standardmäßig gar nicht variabel sind!
  
*/

void greet() {
    String greeting = "hei verden";
    // TODO: verwende die IDE, um den Rest hinzuzufügen!
}

/*

 ÜBUNG
 
 Schreibe den Rest dieser Funktion. Nein,
 wir wollen nicht, dass du einen einfachen
 print()-Aufruf von Hand schreibst. Wir wollen,
 dass du die IDE für dich arbeiten lässt:
 
 - Tippe einen Teil des Namens derjenigen Funktion,
   die du aufrufen willst.
 
 - Strg+Leertaste löst Autovervollständigung aus.
 
 - Wenn du eine Funktion auswählst, kommst du in den
   verknüpften Modus, wo du die Argumente schnell
   einfügen kannst. Mit der Tabulatortaste kannst du
   zwischen den verschiedenen Argumenten navigieren.
 
 - Wenn du die Esc-Taste drückst oder außerhalb
   des verknüpften Modus eine Taste drückst, verlässt du
   den verknüpften Modus.

*/

/*

 Ein Wert kann eine Konstante (im aktuellen Rahmen),
 eine Variable oder ein Getter sein.

*/

// Eine Konstante oberster Ebene
Integer zero = 0;

// Eine Variable mit anfänglichem Wert
variable Integer int = zero;

// Ein Getter, durch einen fetten Pfeil definiert
Integer intSquared => int^2;

// Ein Getter, durch einen Block definiert
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

 Für lokale Deklarationen kann der Compiler
 den Wert rückschließen. Halte den Mauszeiger über
 das Schlüsselwort "value" oder "function",
 um den ermittelten Wert der Deklaration zu sehen.
 
 Der Typ eines Funktionsparameters kann nicht
 ermittelt werden.

*/

void inferredTypes() {
    value time = system.milliseconds;
    value nl = operatingSystem.newline;
    function sqr(Float float) => float*float;
}

/*

 ÜBUNG
 
 Platziere den Cursor über einem Wert oder
 einer Funktion und wähle:
 
   Source > Quick Fix / Assist
 
 Und wähle dann 'Specify type' aus dem Menü.
 
 Oder: wähle die ganze Funktion aus, und wähle:
 
   Source > Reveal Inferred Types

*/


/*

 Unicode-Umschaltcodes sind sehr nützlich.
 Zum Beispiel kannst du Pi als \{#03C0} schreiben.
 
 Dummerweise ist die Eclipse-Konsole zu blöd und wählt
 die falsche Kodierung... gehe zu
 
   Project > Properties > Resource
 
 und setze deine Kodierung für Textdateien auf UTF-8,
 bevor du dieses Programm laufen lässt.

*/

void helloPi() => print(greeting("\{#03C0}"));

/*

 Alternativ - der Code wird länger, aber auch
 deutlich lesbarer - kannst du auch den vollen
 Unicode-Namen des Zeichens verwenden.

*/

void helloPi2() => print(greeting("\{GREEK SMALL LETTER PI}"));


/*

 Was, wenn wir tatsächlich "\{#03C0}" ausgeben
 wollen? Wir können eine Backslash-Umschaltsequenz
 oder einen wörtlichen String (eine besondere Art
 String-Literal) verwenden.

*/

void printTheUnicodeEscapesForPi() {
    
    // Die Sequenz \\ steht für einen Backslash
    print("\\{#03C0}");
    
    // Dreifache doppelte Anführunszeichen
    // markieren ein String-Literal, das keine
    // Umschaltsequenzen enthält. 
    print("""\{GREEK SMALL LETTER PI}""");
    
}

/*

 String-Literale können sich über mehrere
 Zeilen erstrecken. Wir verwenden mehrzeilige
 String-Literale besonders häufig, um Dokumentation
 im Markdown-Format zu schreiben. Halte den Maus-
 zeiger über den Namen dieser Funktion, um die
 Dokumentation zu sehen.

*/

"Dieses Programm gibt folgendes aus:
 
 - den _Namen der virtuellen Maschine_,
 - die _Version der virtuellen Maschine_, und
 - die _Version der Ceylon-Programmiersprache_.
 
 Es verwendet die Objekte [[operatingSystem]]
 und [[language]], die im `ceylon.language`-Modul
 definiert sind, dem Ceylon-Sprachmodul."
void printInfo() =>
        print("Virtuelle Maschine: ``operatingSystem.name``
               Version: ``operatingSystem.version``
               Sprache: ``language.version`` (``language.versionName``)");
              // Tipp: Probier mal, das "normalized"-Attribut
              //       von String zu verwenden

/*

 Annotationen geben Metadaten über ein Programm-
 element an. Halte den Mauszeiger über den Namen
 dieser Funktion.

*/

by ("Gavin")
throws (`class Exception`)
deprecated ("Naja, das ist kein sehr nützliches
             Programm. Probier's mal mit [[hello]].")
see (`function hello`)
void failNoisily() {
    throw Exception("Aaaaarrrrrggggghhhhhhh");
}

/*

 ÜBUNG
 
 Schreibe ein Programm, das alle Primzahlen
 zwischen 1 und 100 ausgibt. Denk daran, deine
 Arbeit ordentlich zu dokumentieren!

*/

// TODO: Primzahlen ausgeben!
