/*

 Nous avons déjà rencontré le type Iterable. Généralement
 nous écrivons :
 
 - {T*} pour indiquer un iterable de zéro ou plus
   instances de T
 - {T+} pour indiquer un iterable de une ou plus
   instances de T
 
 En réalité, ces abréviations signifient respectivement
 Iterable<T,Null> et Iterable<T,Nothing>.
 
 Evidemment, {T+} est un sous-type de {T*}.
 
 Nous pouvons construire des itérables en utilisant
 des accolades.

*/

{String*} noStrings = {};
{String+} twoStrings = {"hello", "world"};
{String+} manyStrings = { for (n in 0..100) n.string };

/*
 
 Iterable définit de nombreuses méthodes pour
 manipuler les flux de données.
 
*/

void demoMapFilterFold() {
    print((1..100)
            .filter((Integer i) => i%3==0)
            .map((Integer i) => i^2)
            //TODO : remplacez fold() par String.join()
            .fold("")
             ((partial, ii) => partial + ", " + ii.string));
}

/*
 
 EXERCISE
 
 Nettoyez le code ci-dessus en utilisant String.join().
 
*/

/*

 Le code ci-dessus est particulièrement bruyant. Il
 est bien plus habituel d'utiliser des compréhensions
 pour exprimer la même chose.

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

 Une compréhension peut avoir plusieurs clauses for
 et if.

*/

{Character*} ss = { 
    for (arg in process.arguments)
        for (c in arg)
            if (c.uppercase)
                c.uppercased
};

/*

 Nous avons souvent le choix entre deux manières
 d'exprimer la même chose :
 
 - en utilisant des fonctions anonymes, ou bien
 - en utilisant une compréhension

*/

Boolean allNumbers1 = manyStrings.every((String s) 
        => parseInteger(s) exists);

Boolean allNumbers2 = every { 
    for (s in manyStrings) 
            parseInteger(s) exists 
};

/*
 
 Une séquence est une liste immuable de valeurs de
 longueur finie. Les types de séquence sont écrits
 [T*] ou [T+]. Pour respecter la tradition, nous
 sommes également autorisés à écrire [T*] en tant
 que T[].
 
 En fait ce sont simplement des abréviations pour
 Sequential<T> et Sequence<T>.
 
 Nous pouvons construire une séquence en utilisant
 des crochets.
 
*/

[String*] noStringsSeq = [];
[String+] twoStringsSeq = ["hello", "world"];
[String+] manyStringsSeq = [ for (n in 0..100) n.string ];

/*
 
 La séquence vide [] est de type Empty, que nous
 écrivons [].
 
*/

[] emptySeq = [];

/*

 Nous pouvons accéder à un élément de la séquence
 (ou tout autre type de List) en utilisant l'opérateur
 d'index.

*/

void testSequenceIndexing() {
    
    //l'opérateur d'index simple
    //peut produire un type possiblement null !
    //(il n'y a pas de IndexOutOfBoundsException)
    assert(exists world = twoStringsSeq[1],
            world=="world");
    
    //l'opérateur d'intervalle ouvert et fermé  
    //produit une séquence
    assert(manyStringsSeq[1..2]==["1", "2"]);
    assert(manyStringsSeq[99...]==["99", "100"]);
    
}

/*
 Nous pouvons restreindre une séquence
 potentiellement vide (une [T*]) à une
 séquence non vide (une [T+]) en utilisant
 l'opérateur nonempty.
*/

void demoNonempty() {
    if (nonempty args = process.arguments) {
        //survolez args et first pour voir
        //leur type
        value first = args.first;
        print(first);
    }
}

/*
 
 Nous pouvons itérer les indexes et éléments d'une
 séquence (ou tout autre type de List).
 
*/

void demoForWithIndexes() {
    for (i->s in twoStringsSeq.indexed) {
        print("``i`` -> ``s``");
    }
}

/*

 Les Tuples sont un type spécial de séquence : 
 une liste chainée typée. Les types de Tuples sont
 définis en listant les types des éléments entre
 crochets, et un tuple est créé en listant ses éléments
 entre crochets. 

*/

[Float, Integer, String, String] tuple 
        = [0.0, 22, "hello", "world"];

/*

 Les éléments d'une tuple peuvent être retrouvés
 sans perte d'information de typage.

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
 
 En fait, tout ceci est simplement du sucre
 syntaxique pour la classe Tuple. Nous utilisons
 systématiquement le sucre dans ce cas ; nous ne
 voulons certainement pas écrire la chose suivante :
 
 */

void desugaredTuple() {
    Tuple<Float|String,Float,Tuple<String,String,Empty>> pair 
            = Tuple(1.0,Tuple("hello",[]));
    Float float = pair.first;
    String string = pair.rest.first;
    Null nil = pair.rest.rest.first;
}

/*

 EXERCICE
 
 Allez voir la déclaration de Tuple pour comprendre
 comment tout cela fonctionne.

*/

/*
 
 Nous pouvons utiliser l'opérateur d'expansion pour
 passer un tuple contenant des arguments à une 
 fonction. Vous vous Souvenez qu'une fonction est
 composée d'un type de retour et d'un type de
 tuple encodant les types de paramètres ? Et bien,
 le tuple des arguments auquel est appliqué
 l'opérateur d'expansion doit être assignable
 à ce type de tuple.
 
 
*/

void demoSpreadTuple() {
    value args = [(Character c) => !c.letter, true];
    for (word in "Hello, World! Goodbye.".split(*args)) {
        print(word);
    }
}

/*
 
 Nous pouvons utiliser des tuples pour définir des
 fonctions avec de valeurs de retour multiples.
 
 */

//une fonction qui produit un tuple
[String, String?, String] parseName(String name) {
    value it = name.split().iterator();
    "first name is required"
    assert (is String first = it.next());
    "last name is required"
    assert (is String second = it.next());
    if (is String third = it.next()) {
        return [first, second, third];
    }
    else {
        return [first, null, second];
    }
}

/*
 
 L'opérateur d'expansion et la fonction unflatten()
 aident à composer ce type de fonction.
 
 */

//une fonction avec des paramètres multiples
String welcome(String first, String? middle, String last) => 
        "Welcome, ``first`` ``last``!";

void demoFunctionComposition() {
    //l'opérateur * expand le tuple résultant 
    //de parseName() sur les paramètres de
    //welcome()
    print(welcome(*parseName("John Doe")));
    
    //Mais comment faire si nous voulons composer
    //parseName() et welcome() sans fournir d'arguments
    //à l'avance ? Et bien nous pouvons utiliser compose()
    //et unflatten()
    value greet = compose(print, 
    compose(unflatten(welcome), parseName)); 
    greet("Jane Doe");
    
    //Donc nous pourrions en fait reformuler le premier
    //exemple uniquement en utilisant unflatten()
    print(unflatten(welcome)(parseName("Jean Doe"))); 
}