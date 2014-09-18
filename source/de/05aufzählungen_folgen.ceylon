/*

 Wir sind dem Typ Iterable für Aufzählungen
 bereits begegnet. Meistens schreiben wir:
 
 - {T*} für eine Aufzählung von null oder
   mehr Instanzen von T
 - {T+} für eine Aufzählung von einem oder
   mehr Instanzen von T
 
 Diese Abkürzungen stehen für Iterable<T,Null>
 und Iterable<T,Nothing>.
 
 Natürlich ist {T+} ein Untertyp von {T*}.
 
 Wir können eine Aufzählung mit geschweiften
 Klammern erstellen.

*/

{String*} noStrings = {};
{String+} twoStrings = { "Hallo", "Welt" };
{String+} manyStrings = { for (n in 0..100) n.string };

/*

 Iterable definiert eine große Anzahl Methoden,
 um mit Datenströmen zu arbeiten. Zum Beispiel
 hat es die bekannten Methoden map(), filter(),
 und fold().

*/

void demoMapFilterFold() {
    print((1..100)
            .filter((Integer i) => i%3==0)
            .map((Integer i) => i^2)
            //TODO: fold() mit String.join() ersetzen
            .fold("")((partial, ii) 
                    => partial + ", " + ii.string));
}

/*

 ÜBUNG
 
 Räum den obigen Code durch Verwendung von
 String.join() etwas auf.

*/

/*

 Der obige Code ist schwer zu verstehen.
 Normalerweise verwenden wir für so etwas
 eher Comprehensions.

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

 Eine Comprehension kann mehrere for- und
 if-Klauseln haben.

*/

{Character*} ss = { 
    for (arg in process.arguments)
        for (c in arg)
            if (c.uppercase)
                c.uppercased
};

/*

 Oft haben wir also die Wahl zwischen zwei
 verschiedenen Ausdrucksweisen:
 
 - anonyme Funktionen, oder
 - Comprehensions.

*/

Boolean allNumbers1 = manyStrings.every((String s) 
        => parseInteger(s) exists);

Boolean allNumbers2 = every { 
    for (s in manyStrings) 
            parseInteger(s) exists 
};

/*

 Eine Folge (Sequence) ist eine unveränderliche,
 endlich lange Liste von Werten. Folgentypen
 werden als [T*] oder [T+] abgekürzt; aus
 traditionellen Gründen ist für [T*] auch
 die Schreibweise T[] erlaubt und gebräuchlich.
 
 Dabei handelt es sich lediglich um Abkürzungen
 für Sequential<T> und Sequence<T>.
 
 Wir können eine Folge mit eckigen Klammern erstellen.

*/

[String*] noStringsSeq = [];
[String+] twoStringsSeq = ["Hallo", "Welt"];
[String+] manyStringsSeq = [for (n in 0..100) n.string];

/*

 Die leere Folge [] hat den Typ Empty, den wir
 ebenfalls als [] schreiben.

*/

[] emptySeq = [];

/*

 Wir können auf die Elemente einer Folge (oder
 einer beliebigen anderen Liste) mit dem Index-
 Operator zugreifen.

*/

void testSequenceIndexing() {
    
    // Zugriff über einen einzelnen Index
    // liefert einen möglicherweise fehlenden Wert!
    // (Es gibt keine IndexOutOfBoundsException.)
    assert(exists world = twoStringsSeq[1],
            world=="world");
    
    // Die Operatoren für Zugriff auf
    // abgeschlossene und offene Intervalle
    // ergeben eine Folge
    assert(manyStringsSeq[1..2]==["1", "2"]);
    assert(manyStringsSeq[99...]==["99", "100"]);
    
}

/*

 Wir können eine möglicherweise leere Folge
 ([T*]) mit dem nonempty-Operator zu einer
 garantiert nicht leeren Folge machen.

*/

void demoNonempty() {
    if (nonempty args = process.arguments) {    
        // Halte den Mauszeiger über args
        // und first, um ihren Typ zu sehen!
        value first = args.first;
        print(first);
    }
}

/*

 Wir können über die Indexe und Elemente
 einer Folge (oder einer beliebigen anderen
 Liste) iterieren.

*/

void demoForWithIndexes() {
    for (i->s in twoStringsSeq.indexed) {
        print("``i`` -> ``s``");
    }
}

/*

 Tupel sind eine besondere Art von Folgen:
 Getypte verkettete Listen. Tupel-Typen
 werden als Auflistung der Elementtypen in
 eckigen Klammern notiert, und ein Tupel
 wird erstellt, indem seine Elemente
 in eckigen Klammern aufgezählt werden.

*/

[Float, Integer, String, String] tuple 
        = [0.0, 22, "Hallo", "Welt"];

/*

 Es ist möglich, auf Elemente eines Tupels
 zuzugreifen, ohne Information über ihren
 Typ zu verlieren.

*/

void demoTupleIndexing() {
    Null nil1 = tuple[-1];
    Float float = tuple[0];
    Integer int = tuple[1];
    String string1 = tuple[2];
    String string2 = tuple[3];
    Null nil2 = tuple[4];
}

/*

 In Wirklichkeit ist das alles nur syntaktischer
 Zucker für die Tuple-Klasse. Hier verwenden wir        
 immer den syntaktischen Zucker; wir wollen nie
 das hier schreiben:

*/

void desugaredTuple() {
    Tuple<Float|String,Float,Tuple<String,String,Empty>> pair 
            = Tuple(1.0,Tuple("Hallo",[]));
    Float float = pair.first;
    String string = pair.rest.first;
    Null nil = pair.rest.rest.first;
}

/*

 ÜBUNG
 
 Schau dir die Deklaration von Tuple an,
 um zu verstehen, wie das funktioniert!

*/

/*

 Wir können den Verteilungs-Operator (spread-Operator)
 verwenden, um ein Tupel von Argumenten an eine Funktion
 zu übergeben. Weißt du noch, dass ein Funktionstyp
 einen Rückgabetyp und einen Tupel-Typ, der die
 Parametertypen enthält, hat? Der Typ des verteilten
 Tupels muss zu diesem Tupel-Typ zuweisbar sein,
 d. h. ein Untertyp davon sein.

*/

void demoSpreadTuple() {
    value args = [(Character c) => !c.letter, true];
    for (word in "Hallo, Welt! Tschüss.".split(*args)) {
        print(word);
    }
}

/*

 Wir können Tupel verwenden, um Funktionen zu
 definieren, die mehrere Werte zurückgeben.

*/

// Eine Funktion, die ein Tupel produziert
[String, String?, String] parseName(String name) {
    value it = name.split().iterator();
    "Vorname erforderlich"
    assert (is String first = it.next());
    "Nachname erforderlich"
    assert (is String second = it.next());
    if (is String third = it.next()) {
        return [first, second, third];
    }
    else {
        return [first, null, second];
    }
}

/*

 Der Verteilungs-Operator und die unflatten()-
 Funktion helfen uns dabei, solche Funktionen
 zu kombinieren.

*/

// Eine Funktion mit mehreren Parametern
String welcome(String first, String? middle, String last) => 
        "Willkommen, ``first`` ``last``!";

void demoFunctionComposition() {
    // Der * Operator verteilt das Tupel aus
    // parseName() über die Parameter von welcome()
    print(welcome(*parseName("Max Mustermann")));
    
    // Aber was ist, wenn wir parseName() und
    // welcome() kombinieren wollen, ohne gleich
    // Argumente zu übergeben? Dazu können wir
    // compose() und unflatten() verwenden.
    value greet = compose(print, 
    compose(unflatten(welcome), parseName)); 
    greet("Maria Mustermann");
    
    // Jetzt könnten wir auch das erste Beispiel
    // mit unflatten() umschreiben
    print(unflatten(welcome)(parseName("Martina Mustermann"))); 
}
