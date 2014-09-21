/*
 
 Une interface définie un contrat qui peut être
 satisfait par une classe. Les interfaces peuvent
 avoir des membres formels, ou même des membres
 concrets :
 
 - méthodes,
 - getters et setters, et
 - classes membres.
 
 Mais une interface ne peux pas :
 
 - avoir un attribut qui conserve une référence
   sur une valeur, ou
 - définir une logique d'initialisation.
 
 Ainsi, nous pouvons dire que les interfaces
 sont sans état. Cela signifie que les héritages
 en "diamant" ne sont pas un problème en Ceylon.
 
 */

interface Writer {
    
    shared formal void write(String string);
    
    shared void writeLine(String string) {
        write(string + operatingSystem.newline);
    }
    
}

/*
 
 Une classe peut satisfaire une interface,
 héritant alors de ses membres.
 
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
 
 Une classe peut satisfaire plusieurs interfaces.
 Nous utilisons le symbole & pour séparer les
 supertypes car conceptuellement ils forment
 une intersection de types.
 
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
    
    // "x in category" signifie "category.contains(x)" 
    // où category est une instance de Category
    assert(":-)" in textWriter);
    
}

/*
 
 Il est particulièrement répandu d'avoir des
 classes anonymes qui satisfont une interface.
 
 */

object consoleWriter satisfies Writer {
    write = process.write;
}

void testConsoleWriter() {
    consoleWriter.writeLine("Hello!");
    consoleWriter.writeLine("Bye!");
}

/*
 
 La classe anonyme ci-dessus est un singleton,
 car sa déclaration est au premier niveau.
 Néanmoins, toutes les classes anonymes ne sont
 pas des singletons. 
 
 */

//cette classe anonyme est un singleton
object naturals 
        satisfies Iterable<Integer> {
    
    shared actual Iterator<Integer> iterator() {
        //une nouvelle instance de cette classes
        //anonyme est créée à chaque fois que
        //iterator() est appelé
        object iterator 
                satisfies Iterator<Integer> {
            variable value int = 1;
            next() => int++;
        }
        return iterator;
    }
    
}

/*
 
 La classe anonyme ci-dessus satisfait Iterable.
 Nous pouvons donc l'itérer avec une boucle for.
 
 */

void loop() {
    for (n in naturals) {
        print(n);
    }
}

/*
 
 De nombreuses constructions syntaxiques intégrées
 au langage sont définies via des interfaces
 que vos propres classes peuvent implémenter.
 En particulier, la plupart des opérateurs
 sont définis en termes d'interfaces.
 
 Voyons comment définir un type de nombre
 complexe qui fonctionne de la même manière
 que les types numériques fournis par le
 langage.
 
 */

"Une classes de nombre complexe illustrant le
 polymorphisme d'opérateur en Ceylon"
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

    "Accepte des puissances non-négatives"
    shared actual Complex power(Integer other) {
        "L'exposant doit être non-négatif"
        assert(other>=0);
        //impl simpliste
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
 
 EXERCICE
 
 Ecrire une classe Vector, qui supporte l'addition vectorielle
 avec + (via l'interface Summable) et le produit scalaire 
 avec ** (via l'interface Scalable). 
 
 */