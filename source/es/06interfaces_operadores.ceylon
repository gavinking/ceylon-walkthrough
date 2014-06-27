import ceylon.collection { StringBuilder }
/*
 
 Una interfaz define un contrato que puede ser
 satisfecho por una clase. Las interfaces pueden
 tener miembros formales, o incluso miembros
 concretos:
 
 - métodos,
 - getters y setters, y
 - clases miembro.
 
 Pero una interfaz no puede:
 
 - tener un atributo que mantenga una referencia
   a un valor, o
 - definir lógica de inicialización.
 
 Por tanto, decimos que las interfaces no tienen
 estado. Esto significa que la herencia "diamante"
 no es un problema en Ceylon.
 
 */

interface Writer {
    
    shared formal void write(String string);
    
    shared void writeLine(String string) {
        write(string + operatingSystem.newline);
    }
    
}

/*
 
 Una clase puede satisfacer la interfaz,
 heredando sus miembros.
 
 */

class FunctionWriter(void fun(String string)) 
        satisfies Writer {
    write = fun;
}

void testFunctionWriter() {
    FunctionWriter(process.write).writeLine("Hello!");
    FunctionWriter(process.writeError).writeLine("Ooops!");
}

/*
 
 Una clase puede satisfacer múltiples interfaces. 
 Usamos el símbolo & para separar los supertipos
 porque conceptualmente forman una intersección
 de tipos.
 
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
    textWriter.writeLine("Hello :-)");
    textWriter.writeLine("Goodbye :-(");
    
    // "x in category" significa "category.contains(x)" 
    // donde category es una instancia de Category
    assert(":-)" in textWriter);
    
}

/*
 
 Es especialmente común tener clases anónimas
 que satisfacen una interfaz.
 
 */

object consoleWriter satisfies Writer {
    write = process.write;
}

void testConsoleWriter() {
    consoleWriter.writeLine("Hello!");
    consoleWriter.writeLine("Bye!");
}

/*
 
 La clase anónima de arriba es un singleton,
 porque está declarada en el primer nivel. Pero
 no todas las clases anónimas son singleton.
 
 */

//esta clase anónima es un singleton
object naturals 
        satisfies Iterable<Integer> {
    
    shared actual Iterator<Integer> iterator() {
        //una nueva instancia de esta clase
        //anónima se crea cada vez que se llama
        //a iterator()
        object iterator 
                satisfies Iterator<Integer> {
            variable value int = 1;
            next() => int++;
        }
        return iterator;
    }
    
}

/*
 
 La clase anónima de arriba satisface Iterable.
 Esto significa que podemos iterarla con un
 bucle for.
 
 */

void loop() {
    for (n in naturals) {
        print(n);
    }
}

/*
 
 Muchas de las construcciones intrínsecas al
 lenguaje se definen en términos de interfaces
 que tus propias clases pueden implementar.
 En particular, la mayoría de los operadores se
 definen en términos de interfaces.
 
 Veamos como podemos definir un tipo "número
 complejo" que funcione exactamente igual que
 los tipos numéricos intrínsecos.
 
 */

"A complex number class demonstrating operator 
 polymorphism in Ceylon."
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

    "Accepts non-negative powers."
    shared actual Complex power(Integer other) {
        "exponent must be non-negative"
        assert(other>=0);
        //impl pobre
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
 
 EJERCICIO
 
 Escribe una clase Vector, que soporte suma de
 vectores con + (a través de la interfaz
 Summable) y producto escalar con ** (a través
 de la interfaz Scalable).
 
 */