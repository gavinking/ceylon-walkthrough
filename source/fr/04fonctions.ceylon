/*
 
 Comme dans tout langage moderne, une fonction
 est une valeur. Le type d'une fonction est
 représenté en utilisant les interfaces Callable
 et Tuple, mais ces interfaces sont généralement
 masquées par le sucre syntaxique.
 
 Le type d'une fonction est écrit X(P,Q,R)
 où X est le type retourné, et P, Q, R sont 
 les types des paramètres. De plus :
 
 - P* représente un paramètre variadique de
   type P, et  
 - P= représente un paramètre de type P avec
   une valeur par défaut. 
 
 Une valeur dont le type est un type de fonction
 est parfois appelé une "référence de fonction".
 
*/

//le type de retour d'une fonction void est Anything
Anything(Anything) printFun = print;

//pour une fonction paramétrisée, les arguments
//de types doivent être indiqués, puisqu'une
//valeur ne peut pas avoir de paramètres 
//non spécifiés.
Float(Float, Float) plusFun = plus<Float>;

//sum() a un paramètre variadique.
Integer(Integer*) sumFun = sum;

//les classes sont également des fonctions !
String({Character*}) strFun = String;

//même les méthodes sont des fonctions
String({String*}) joinWithCommasFun = ", ".join;

//quelques exemples tordus (ne vous cassez pas trop la tête la dessus)
{Integer*}({Integer?*}) coalesceFun = Iterable<Integer?>.coalesced;

String[]({String*}*) joinFun = concatenate<String>;

{String*}(Boolean(Character)=, Boolean=, Boolean=) 
splitFun = "Hello, world! Goodbye :-(".split;

/*
 
 Etant donné une valeur avec un type de fonction,
 nous pouvons en faire tous ce que ne ferions
 avec la vraie fonction.
 
 (Note: la seule chose que nous ne pouvons pas
 faire, c'est passer des arguments nommés)
 
*/

void demoFunctionRefs() {
    printFun("Hello!");
    print(sumFun(3, 7, 0));
    print(plusFun(3.0, 7.0));
    print(strFun({'h','e','l','l','o'}));
}

/*
 
 Les types de fonction exposent la vraie variance
 concernant leur type de retour et leurs de paramètres.
 Ceci est simplement la conséquence de la
 variance des paramètres de type des types
 Callable et Tuple.
 
 C'est à dire, une fonction avec des types de
 paramètre plus généraux, et un type de retour
 plus spécifique, est assignable à un type donné
 de fonction. Cela semble compliqué, mais en 
 pratique cela fonctionne de manière plutôt
 intuitive.
 
*/

//Une fonction qui accepte Anything est également
//une fonction qui accepte String
Anything(String) printStringFun = printFun;

//une fonction qui retourne String est aussi une
//fonction qui retourne un Iterable<Character>
{Character*}({Character*}) iterableFun = strFun;

//une fonction avec un paramètre variadique est
//également une fonction avec deux paramètres !
Integer(Integer, Integer) sumBothFun = sumFun;

/*

 Généralement nous passons des références de
 fonctions à d'autres fonctions.

*/

//TODO : modifiez la déclaration de op afin d'utiliser un type de fonction 
Float apply(Float op(Float x, Float y), Float z)
        => op(z/2,z/2);

void testApply() {
    assert (apply(plus<Float>, 1.0)==1.0);
    assert (apply(times<Float>, 3.0)==2.25);
}

/*
 
 EXERCICE
 
 Le paramètre op() de apply() est déclaré
 avec un "style fonction", les paramètres étant
 listés après le nom de paramètre, et le type
 de retour étant en premier. Modifiez la déclaration
 afin d'utiliser un "style valeur", avec
 un type de fonction avant le nom du paramètre.
 
*/

/*
 
 Il est également possible d'écrire une fonction
 "anonyme", en ligne, à l'intérieur de l'expression.
 
*/

//TODO: transformez en définition de fonction classique
Float(Float, Float) timesFun 
        = (Float x, Float y) => x*y;

//TODO: transformez en définition de fonction classique
Anything(String) printTwiceFun 
        = void (String s) { 
            print(s); 
            print(s);
        };

/*
 
 EXERCICE
 
 Ce que nous venons d'écrire est du très mauvais
 style. Le but des fonctions anonymes est d'être
 passé en argument à d'autres fonctions. Corrigez
 le code ci-dessus en le réécrivant en utilisant
 la syntaxe de déclaration classique des fonctions
 façon langage C.
 
*/

/*
  
  Généralement nous passons des fonctions anonymes
  en tant qu'arguments d'autres fonctions.
  
*/

void demoAnonFunction() {
    
    {String*} result = mapPairs(
            (String s, Integer i) 
                => s.repeat(i), 
            "well hello world goodbye".split(), 
            1..10);
    
    print(" ".join(result));
    
}

/*

  Une fonction "curryfiée" est une fonction
  avec plusieurs listes de paramètres.
  
*/

String repeat(Integer times)(String s) 
        => (" "+s).repeat(times)[1...];

void demoCurriedFunction() {
    String(String) thrice = repeat(3);
    print(thrice("hello"));
    print(thrice("bye"));
}

/*
  
  Il y a un endroit où nous rencontrons
  fréquemment des fonctions dans une forme
  curryfiée : les références de méthodes
  "statiques".
  
*/

String({String*})(String) staticJoinFun = String.join;

void testStaticMethodRef() {
    value joinWithCommas = staticJoinFun(", ");
    value string = joinWithCommas({"hello", "world"});
    print(string);
}

/*
  
 Les références d'attributs statiques sont particulièrement
 utiles, tout particulièrement quand elle sont combinées
 avec la méthode map()
  
*/

void testStaticAttributeRef() {
    value words = {"hi", "hello", "hola", "jambo"};
    value lengths = words.map(String.size);
    print(lengths);
}

/*

 Parce que les types de fonctions sont définis
 via les interfaces Callable et Tuple qui sont
 parfaitement ordinaires, il est possible d'écrire
 des fonctions qui abstraient plusieurs types de
 fonctions à la fois. (Ce n'est typiquement pas
 possible dans d'autres langages)
 
 Ces fonctions les plus utiles sont compose(),
 curry(), shuffle(), et uncurry(). Ce sont des
 fonction totalement ordinaires, écrites entièrement
 en Ceylon !

*/

void demoGenericFunctions() {
    
    //TODO: change this "one-liner" to three lines
    value fun = uncurry(compose(curry(plus<Float>), 
            (String s) => parseFloat(s) else 0.0));
    
    assert(fun("3.0", 1.0)==4.0);
    
}

/*

 EXERCICE
 
 Le code ci-dessus est trop "compact" pour être
 compréhensible. Utilisez Source > Extract Value afin
 d'extraire les sous-expressions et voir chacun de leur
 type.

*/

/*

 Nous avons maintenant rencontré des types
 plutôt compliqués. Pour qu'il soit plus simple
 d'exploiter de tels types, nous pouvons leur
 donner des noms.
 
*/

alias Predicate<T> => Boolean(T);
alias StringPredicate => Predicate<String>;

Boolean both<T>(Predicate<T> p, T x, T y) 
        => p(x) && p(y);

void testPredicates() {
    
    StringPredicate length5 
            = (String s) => s.size==5;
    
    assert(both(length5, "hello", "world"));
    assert(!both(length5, "goodbye", "world"));
    
}

