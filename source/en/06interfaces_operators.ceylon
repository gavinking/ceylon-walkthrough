/*
 
 An interface defines a contract that can be 
 satisfied by a class. Interfaces may have formal
 members, or even concrete members:
 
 - methods,
 - getters and setters, and
 - member classes.
 
 But an interface may not:
 
 - have an attribute that holds a reference to a 
   value, or
 - define initialization logic.
 
 Thus, we say that interfaces are stateless. This
 means that "diamond" inheritance is unproblematic
 in Ceylon.
 
 */

interface Writer {
    
    shared formal void write(String string);
    
    shared void writeLine(String string) {
        write(string + operatingSystem.newline);
    }
    
}

/*
 
 A class may satisfy the interface, inheriting its 
 members.
 
 */

class FunctionWriter(void fun(String string)) 
        satisfies Writer {
    write = fun;
}

shared void testFunctionWriter() {
    FunctionWriter(process.write).writeLine("Hello!");
    FunctionWriter(process.writeError).writeLine("Ooops!");
}

/*
 
 A class may satisfy multiple interfaces. We 
 use the & symbol to separate the supertypes
 because they conceptually form an intersection
 of types.
 
 */

class TextWriter(StringBuilder stringBuilder)
        satisfies Writer & Category {
    
    contains(Object element)
            => element in stringBuilder.string;
    
    write(String string)
            => stringBuilder.append(string);
    
}

shared void testTextWriter() {
    
    value textWriter = TextWriter(StringBuilder());
    textWriter.writeLine("Hello :-)");
    textWriter.writeLine("Goodbye :-(");
    
    // "x in category" means "category.contains(x)" 
    // where category is an instance of Category
    assert(":-)" in textWriter);
    
}

/*
 
 It's especially common to have anonymous classes
 that satisfy an interface.
 
 */

object consoleWriter satisfies Writer {
    write = process.write;
}

shared void testConsoleWriter() {
    consoleWriter.writeLine("Hello!");
    consoleWriter.writeLine("Bye!");
}

/*
 
 The above anonymous class is a singleton, because
 it occurs as a toplevel declaration. But not
 every anonymous class is a singleton.
 
 */

//this anonymous class is a singleton
object naturals 
        satisfies Iterable<Integer> {
    
    shared actual Iterator<Integer> iterator() {
        //a new instance of this anonymous class 
        //is created each time iterator() is 
        //called
        object iterator 
                satisfies Iterator<Integer> {
            variable value int = 1;
            next() => int++;
        }
        return iterator;
    }
    
}

/*
 
 The anonymous class above satisfies Iterable.
 That means we can iterate it with a for loop.
 
 */

shared void loop() {
    for (n in naturals) {
        print(n);
    }
}

/*
 
 Many of the "built-in" language constructs are
 defined in terms of interfaces that your own
 classes may implement. In particular, most of the
 operators are defined in terms of interfaces.
 
 Let's see how we can define a complex number type
 that works just like the built-in numeric types.
 
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
        //lame impl
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

shared void testComplex() {
    
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
 
 EXERCISE
 
 Write a Vector class, that supports vector
 addition with + (via the Summable interface) and
 scalar multiplication with ** (via the Scalable
 interface).
 
 */