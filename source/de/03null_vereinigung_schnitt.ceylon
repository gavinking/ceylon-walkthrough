import ceylon.collection {
    HashSet
}
/*

 Ein Vereinigungstyp (union type) steht für
 eine Auswahlmöglichkeit zwischen mehreren
 Typen. Die Vereinigung der Typen A und B
 wird als A|B notiert.

*/

void printDouble(String|Integer|Float val) {
    String|Integer|Float double;
    switch (val)
    case (is String) { double = val+val; }
    case (is Integer) { double = 2*val; }
    case (is Float) { double = 2.0*val; }
    print("Das Doppelte von ``val`` ist ``double``");
}

void testDouble() {
    printDouble("Hallo");
    printDouble(111);
    printDouble(0.111);
}

/*

 Wir behandeln fehlende ("null") Werte durch
 Vereinigungstypen. Die Klasse Null hat einen ein-
 zigen Wert, null, welcher für einen fehlenden
 Wert steht. Damit kann ein möglicherweise fehlen-
 der String durch den Typ Null|String beschrieben
 werden.
 
 Wir können den Typ "Null|String" abgekürzt als
 "String?" schreiben. Dabei handelt es sich nur
 um syntaktischen Zucker für den Vereinigungstyp.
 
 Lass das folgende Programm einmal mit und einmal
 ohne Argumente laufen. Du kannst Argumente hinzu-
 fügen unter:
 
   Run > Run Configurations...

*/

void helloArguments() {
    String? name = process.arguments[0];
    if (is String name) { // TODO: exists verwenden
        print("Hallo " + name);
    }
    else {
        print("Hallo Welt");
    }
}

/*

 ÜBUNG
 
 Normalerweise verwenden wir den "exists"-Operator,
 anstatt wie oben "is String" zu schreiben. Passe
 das obige Programm an, so dass exists verwendet wird.
 Mehr syntaktischer Zucker!
 
 Als nächstes kannst du, um den Code noch kompakter
 zu machen, diese Form des if-Statements verwenden:
 
   if (is String name = process.arguments[0])
 
 (Nur eben mit exists, nicht "is String".)

*/

/*

 Die then- und else-Operatoren erzeugen und
 verarbeiten null-Werte.

*/

void thenAndElse() {
    Integer n = 5;
    
    print(n>0 then n);
    print(n<=0 then n);
    
    print(n>=0 then "Positiv" else "Echt negativ");
    
    print("123456789"[n] else "Außer Bereich");    
    print("12345"[n] else "Außer Bereich");
}

/*

 ÜBUNG
 
 Passe das helloArguments()-Programm von oben
 so an, dass ein Operator anstelle von if/else
 verwendet wird.

*/

/*

 Ein Schnitttyp (intersection type) steht für
 eine Kombination zweier Typen. Der Schnitt der
 Typen A und B wird als A&B notiert.
 
 Schnitttypen treten häufig bei der Verfeinerung
 von Typen auf.
 
 Hinweis: Die Syntax {T*} steht für eine Aufzählung
 von Werten des Typs T. Dabei handelt es sich um
 syntaktischen Zucker für die Iterable-Schnittstelle.

*/

T? third<T>({T*} iterable) {
    if (is Correspondence<Integer, T> iterable) {
        // Halte den Mauszeiger über iterable,
        // um den verfeinerten Typ innerhalb
        // dieses Blocks zu sehen!
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
    assert (exists thrd = third("Hallo"), 
            thrd =='l');
}

/*

 Kleine Bemerkung am Rande: Der Typ von "thrd"
 oben ist <Null|Character>&Object, was zu
 Null&Object|Character&Object verteilt wird,
 was zu Nothing|Character vereinfacht wird,
 welches wiederum zu Character vereinfacht wird.
 Das alles macht der Compiler - genauer gesagt,
 der "Typechecker", welcher alle Typen überprüft -
 automatisch.
 
 Vereinigungs- und Schnitttypen sind besonders
 hilfreich, wenn Typen rückgeschlossen werden.

*/

void demoTypeInference() {
    // Halte den Mauszeiger über joined,
    // um den ermittelten Typ zu sehen!
    value joined = concatenate("Hallo", 1..69);
    Object[] objects = joined;
    print(objects);
}

/*

 Vereinigungs- und Schnitttypen helfen auch
 dabei, den korrekten Typ für die Vereinigung
 und den Schnitt mehrerer Mengen zu benennen.
 
 Vereinigung und Schnitt von Mengen sind über
 die Methoden union() und intersection() der
 Set-Schnittstelle definiert. Die Operatoren
 | und & sind syntaktischer Zucker für diese
 Methoden.
 
 Du kannst dir die Definition dieser Methoden
 anschauen, um zu sehen, wie ihre Rückgabetypen
 durch Vereinigungs- und Schnitttypen definiert
 sind.

*/

void demoSets() {
    Set<Character> chars = HashSet { elements="Hallo"; };
    Set<Integer> ints = HashSet { elements=0..10; };
    // Halte den Mauszeiger über intsAndChars,
    // um den Typ zu sehen!
    value intsAndChars = chars|ints;
    print(intsAndChars);
    // Halte den Mauszeiger über empty,
    // um den Typ zu sehen!
    value empty = chars&ints;
    print(empty);
}

/*

 ÜBUNG
 
 Der spezielle Typ Nothing ("nichts") ist der
 "Boden"-Typ, ein Typ ohne Instanzen.
 
 Überlege dir, warum der Typ der oberen Schnitt-
 menge chars&ints Set<Nothing> ist, wenn du weißt,
 dass Character und Integer disjunkte Typen sind
 (sie haben keine gemeinsamen Instanzen).
 
 P.S.: Character und Integer sind unableitbare
       Klassen (mit final annotiert), nicht über
       Vererbung verwandt, und daher disjunkt.

*/

/*

 Moment mal. Wenn es keine Werte vom Typ Nothing gibt,
 was bedeuted dann der folgende Code? (Alle Typen sind
 korrekt.)

*/

void thereIsNoNothing() {
    Nothing n = nothing;
    print(n);
}

/*

 In der Praxis bedeutet der Typ Nothing, dass der
 Aufruf einer Funktion, oder das Auswerten eines
 Werts, entweder:
 
 - nie terminiert, oder
 - eine Ausnahme wirft.
 
 Es sieht vielleicht so aus, als wäre Nothing
 nutzlos, aber wenn man generische Typen und
 Funktionen definiert, kann es sehr hilfreich sein.

*/

/*

 Das nützliche coalesced-Attribut demonstriert
 auch eine hübsche Anwendung von Schnitttypen.
 
 Schau dir die Definition von coalesced an,
 um zu sehen, wie das funktioniert.

*/

void demoCoalesce() {
    
    // {String?*} ist der Typ einer Folge von
    // String-Werten und null-Werten
    {String?*} stringsAndNulls = {"Hallo", null, "Welt"};
    
    // {String*} ist der Typ einer Folge von
    // String-Werten (ohne null-Werte)
    {String*} strings = stringsAndNulls.coalesced;
    
    assert (strings.sequence() == ["Hallo", "Welt"]);
    
}

/*

 Es gibt einen speziellen Trick mit Vereinigungs-
 typen, der uns hilft, Funktionen wie max() und min()
 den korrekten Typ zu geben.
 
 Das Problem ist, dass bei "null oder mehr" Werten
 max() den null-Wert zurückgeben kann. Aber wenn
 wir "einen oder mehr" Werte haben, kann das nicht
 passieren. Und wenn wir genau null Werte haben,
 gibt max() immer den null-Wert zurück. Wie können wir
 das im Typsystem darstellen?

*/

void demoMax() {
    
    Null maxOfZero = max({});
    
    {Integer+} oneOrMore = {1, 2};
    Integer maxOfOneOrMore = max(oneOrMore);
    
    {Integer*} zeroOrMore = {1, 2};
    Integer? maxOfZeroOrMore = max(zeroOrMore);
    
}

/*

 ÜBUNG
 
 Schau dir die Definion von max() und Iterable
 an und finde heraus, wie das funktioniert!
 
 Tipp: Nothing (nichts) spielt eine Rolle ;-)

*/
