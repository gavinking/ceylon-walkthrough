/*

 Eine Schnittstelle (interface) definiert einen
 Vertrag, der von einer Klasse erfüllt werden
 kann. Schnittstellen können Member definieren,
 die "formal" annotiert sind, oder sogar konkrete
 Member:
 
 - Methoden,
 - Getter und Setter, und
 - Member-Klassen.
 
 Aber eine Schnittstelle kann nicht
 
 - ein Attribut, das einen Verweis auf einen Wert
   enthält, haben, oder
 - Initialisierungslogik definieren.
 
 Deshalb nennen wir Schnittstellen zustandslos.
 Das bedeutet, dass "Rauten-Vererbung" in Ceylon
 kein Problem darstellt.

*/

interface Writer {
    
    shared formal void write(String string);
    
    shared void writeLine(String string) {
        write(string + operatingSystem.newline);
    }
    
}

/*

 Eine Klasse kann eine Schnittstelle erfüllen und
 ihre Member erben.

*/

class FunctionWriter(void fun(String string)) 
        satisfies Writer {
    write = fun;
}

void testFunctionWriter() {
    FunctionWriter(process.write).writeLine("Hallo!");
    FunctionWriter(process.writeError).writeLine("Uups!");
}

/*

 Eine Klasse kann mehrere Schnittstellen erfüllen.
 Wir verwenden das '&'-Symbol, um die erfüllten
 Schnittstellen zu trennen, weil sie prinzipiell
 einen Schnitttyp darstellen.

*/

class TextWriter(StringBuilder stringBuilder)
        satisfies Writer & Category {
    
    contains(Object element)
            => element in stringBuilder.string;
    
    write(String string)
            => stringBuilder.append(string);
    
}

void testTextWriter() {
    
    value textWriter = TextWriter(StringBuilder());
    textWriter.writeLine("Hallo :-)");
    textWriter.writeLine("Tschüss :-(");
    
    // "x in category" heißt "category.contains(x)"
    // wobei category eine Instanz von Category ist
    assert(":-)" in textWriter);
    
}

/*

 Es ist besonders häufig, anonyme Klassen zu haben,
 die eine Schnittstelle erfüllen.

*/

object consoleWriter satisfies Writer {
    write = process.write;
}

void testConsoleWriter() {
    consoleWriter.writeLine("Hallo!");
    consoleWriter.writeLine("Tschüss!");
}

/*

 Die obige anonyme Klasse ist ein Singleton
 (Einweg-Object), weil die Deklaration auf oberster
 Ebene steht und nicht verschachtelt ist. Aber
 nicht jede anonyme Klasse ist ein Singleton.

*/

// Diese anonyme Klasse ist ein Singleton
object naturals 
        satisfies Iterable<Integer> {
    
    shared actual Iterator<Integer> iterator() {
        // Jedes Mal, wenn iterator() aufgerufen
        // wird, wird eine neue Instanz dieser
        // anonymen Klasse erstellt
        object iterator 
                satisfies Iterator<Integer> {
            variable value int = 1;
            next() => int++;
        }
        return iterator;
    }
    
}

/*

 Die obige anonyme Klasse erfüllt Iterable.
 Damit können wir sie mit einer for-Schleife
 durchlaufen.

*/

void loop() {
    for (n in naturals) {
        print(n);
    }
}

/*

 Viele der "eingebauten" Sprachkonstrukte sind
 über Schnittstellen definiert, die deine eigenen
 Klassen erfüllen können. Insbesondere sind fast
 alle Operatoren über Schnittstellen definiert.
 
 Schauen wir mal, wie wir einen Typ für komplexe
 Zahlen definieren können, der genauso wie die
 eingebauten numerischen Typen funktioniert.

*/

"Eine Klasse für komplexe Zahlen, die
 Operatorpolymorphismus in Ceylon demonstriert."
class Complex(shared Float re, shared Float im=0.0) 
        satisfies Exponentiable<Complex,Integer> {
    
    negated => Complex(-re,-im);

    plus(Complex other) => Complex(re+other.re, im+other.im);

    minus(Complex other) => Complex(re-other.re, im-other.im);

    times(Complex other) =>
            Complex(re*other.re-im*other.im, 
                    re*other.im+im*other.re);
    
    shared actual Complex divided(Complex other) {
        Float d = other.re^2 + other.im^2;
        return Complex((re*other.re+im*other.im)/d, 
                       (im*other.re-re*other.im)/d);
    }

    "Akzeptiert nichtnegative Exponenten."
    shared actual Complex power(Integer other) {
        "Exponent darf nicht negativ sein"
        assert(other>=0);
        // einfache, langsame Implementierung
        variable Complex result = Complex(1.0, 0.0);
        for (i in 0:other) {
            result*=this;
        }
        return result;
    }

    string => im<0.0 then "``re``-``-im``i" 
                     else "``re``+``im``i";
    
    hash => re.hash + im.hash;
    
    shared actual Boolean equals(Object that) {
        if (is Complex that) {
            return re==that.re && im==that.im;
        }
        else {
            return false;
        }
    }
    
}

Complex i = Complex(0.0, 1.0);

void testComplex() {
    
    Complex one = Complex(1.0);
    Complex zero = Complex(0.0);
    
    Complex sum = one+i+zero;
    assert (sum==Complex(1.0, 1.0));
    
    Complex zeroProduct = one*zero;
    assert (zeroProduct==zero);
    
    Complex nonzeroProduct = one*i;
    assert (nonzeroProduct==i);
    
    Complex diff = -one-zero-i;
    assert (diff==Complex(-1.0, -1.0));
    
    Complex power = i^3;
    assert (power==Complex(-0.0, -1.0));
    
    Complex quot = one/i;
    assert(quot==-i);
    
}

/*

 ÜBUNG
 
 Schreibe eine Vektor-Klasse, die Vektoraddition
 mit + (über die Summable-Schnittstelle) und
 skalare Multiplikation mit ** (über die Scalable-
 Schnittstelle) unterstützt.

*/
