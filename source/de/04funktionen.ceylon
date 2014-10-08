/*

 Wie auch in den meisten modernen Programmier-
 sprachen ist eine Funktion in Ceylon ein Wert.
 Ihr Typ wird durch die Schnittstellen Callable
 und Tuple repräsentiert, die wir aber üblicher-
 weise hinter etwas syntaktischem Zucker verstecken.
 
 Der Typ einer Funktion wird als X(P,Q,R) geschrie-
 ben, wobei X der Rückgabewert und P, Q, und R die
 Parametertypen sind. Weiterhin bedeutet:
 
 - P* einen variadischen Parameter vom Typ P, und
 - P= einen Parameter vom Typ P mit einem Standard-
   wert.
 
 Ein Wert, dessen Typ ein Funktionstyp ist, wird
 manchmal "Funktionsreferenz" genant.

*/

// Der Rückgabetyp einer void-Funktion ist Anything
Anything(Anything) printFun = print;

// Für eine Funktion mit Typparametern müssen Typ-
// argumente angegeben werden, da ein Wert keine
// freien Typparameter haben kann.
Float(Float, Float) plusFun = plus<Float>;

// sum() hat einen variadischen Parameter
Integer(Integer*) sumFun = sum;

// Klassen sind auch Funktionen!
String({Character*}) strFun = String;

Singleton<Integer>(Integer) singletonFun 
        = Singleton<Integer>;

// Selbst Methoden sind Funktionen
String({String*}) joinWithCommasFun = ", ".join;

// split() has Parameter mit Standardwert, durch = angezeigt
{String*}(Boolean(Character)=, Boolean=, Boolean=) splitFun 
        = "Hello, world! Goodbye :-(".split;

// Eine "statische" Referenz auf ein Attribut
// eines Typs ist eine weitere Funktion!
{Integer*}({Integer?*}) coalesceFun = 
        Iterable<Integer?>.coalesced;

/*

 Mit einem Wert mit Funktionstyp können wir fast alles
 machen, was wir mit der echten Funktion machen können.
 
 (Das einzige, was nicht geht, ist benannte Argumente
 zu übergeben.)

*/

void demoFunctionRefs() {
    printFun("Hallo!");
    print(sumFun(3, 7, 0));
    print(plusFun(3.0, 7.0));
    print(strFun({'H','a','l','l','o'}));
    print(singletonFun(0));
}

/*

 Funktionstypen haben die korrekte Varianz
 in Bezug auf ihre Rückgabe- und Parametertypen.
 Das ergibt sich direkt aus der Varianz der
 Typparameter der Typen Callable und Tuple.
 
 Das heißt, eine Funktion mit generelleren
 Parametertypen und einem spezielleren Rückgabe-
 typ kann einem Funktionstyp zugewiesen werden.
 Das klingt kompliziert, funktioniert aber in
 der Praxis ziemlich intuitiv.

*/

// Eine Funktion, die Anything (irgendwas)
// entgegennimmt, ist auch eine Funktion, die
// einen String entgegennimmt
Anything(String) printStringFun = printFun;

// Eine Funktion, die einen String zurückgibt,
// ist auch eine Funktion, die eine Aufzählung
// von Zeichen (Characters) zurückgibt
{Character*}({Character*}) iterableFun1 = strFun;
{Integer+}(Integer) iterableFun2 = singletonFun;

// Eine Funktion mit einem variadischen Parameter
// ist auch eine Funktion mit zwei Parametern!
Integer(Integer, Integer) sumBothFun = sumFun;

/*

 Üblicherweise geben wir Funktionsreferenzen
 an andere Funktionen weiter.

*/

// TODO: die Deklaration von op so verändern, dass
// ein Funktionstyp verwendet wird
Float apply(Float op(Float x, Float y), Float z)
        => op(z/2,z/2);

void testApply() {
    assert (apply(plus<Float>, 1.0)==1.0);
    assert (apply(times<Float>, 3.0)==2.25);
}

/*

 ÜBUNG
 
 Der Parameter op() von apply() ist im "funktionalen
 Stil" deklariert, wobei die Parameter nach dem
 Parameternamen gelistet sind und der Rückgabe-
 typ zuerst kommt. Ändere die Deklaration zum "Wert-
 Stil", wo der Funktionstyp vor dem Parameternamen steht.

*/

/*

 Es ist sogar möglich, eine "anonyme" Funktion
 innerhalb eines Ausdrucks zu schreiben.

*/

// TODO: zu einer regulären Funktionsdefinition ändern
Float(Float, Float) timesFun 
        = (Float x, Float y) => x*y;

// TODO: zu einer regulären Funktionsdefinition ändern
Anything(String) printTwiceFun 
        = void (String s) { 
            print(s); 
            print(s);
        };

/*

 ÜBUNG
 
 Was ich da gerade geschrieben habe, ist sehr
 schlechter Stil! Anonyme Funktionen sind dazu
 gedacht, als Argumente an andere Funktionen
 übergeben zu werden. Schreibe den Code oben
 so um, dass es sich um reguläre Funktionsdefinitionen
 handelt, wie sie aus Java und C bekannt sind.

*/

/*

 Normalerweise geben wir anonyme Funktionen
 als Argumente an andere Funktionen weiter.

*/

void demoAnonFunction() {
    
    {String*} result = mapPairs(
            (String s, Integer i) 
                => s.repeat(i), 
            "Hallo Welt Tschüss".split(), 
            1..10);
    
    print(" ".join(result));
    
}

/*

 Eine Funktion kann mehrere Parameterlisten haben;
 dies wird als "Currying" bezeichnet.

*/

String repeat(Integer times)(String s) 
        => (" "+s).repeat(times)[1...];

void demoCurriedFunction() {
    String(String) thrice = repeat(3);
    print(thrice("hello"));
    print(thrice("bye"));
}

/*

 Teilweise angewendete Funktionen treffen
 wir besonders häufig an einer Stelle an:
 Bei "statischen" Referenzen auf Methoden.

*/

String({String*})(String) staticJoinFun = String.join;

void testStaticMethodRef() {
    value joinWithCommas = staticJoinFun(", ");
    value string = joinWithCommas({"hello", "world"});
    print(string);
}

/*

 Statische Attribut-Referenzen sind besonders
 in Verbindung mit der map()-Methode nützlich.

*/

void testStaticAttributeRef() {
    value words = {"hi", "hello", "hola", "jambo"};
    value lengths = words.map(String.size);
    print(lengths);
}

/*

 Weil Funktionstypen durch die regulären Schnittstellen
 Callable und Tuple definiert sind, ist es möglich,
 Funktionen zu schreiben, die über viele Funktionstypen
 zugleich abstrahieren. (Dies ist in anderen Sprachen
 meistens nicht möglich.)
 
 Die nützlichsten solchen Funktionen sind compose(),
 curry(), shuffle() und uncurry(). Das sind ganz
 gewöhnliche, in Ceylon geschriebene Funktionen!

*/

void demoGenericFunctions() {
    
    // TODO: Diesen "Einzeiler" in drei Zeilen aufteilen
    value fun = uncurry(compose(curry(plus<Float>), 
            (String s) => parseFloat(s) else 0.0));
    
    assert(fun("3.0", 1.0)==4.0);
    
}

/*

 ÜBUNG
 
 Der Code oben ist zu kompakt, um leicht verständlich
 zu sein. Verwende Source > Extract Value, um
 Unterausdrücke herauszuholen und ihren jeweiligen
 Typ zu sehen.

*/

/*

 Wir haben jetzt schon ein paar ziemlich
 komplizierte Typen gesehen. Um den Umgang
 mit ihnen zu vereinfachen, können wir sie
 benennen.

*/

alias Predicate<T> => Boolean(T);
alias StringPredicate => Predicate<String>;

Boolean both<T>(Predicate<T> p, T x, T y) 
        => p(x) && p(y);

void testPredicates() {
    
    StringPredicate length5 
            = (String s) => s.size==5;
    
    assert(both(length5, "Hallo", "Welt!"));
    assert(!both(length5, "Adieu", "Welt"));
    
}
