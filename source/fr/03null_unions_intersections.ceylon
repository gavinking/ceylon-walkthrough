import ceylon.collection {
    HashSet
}
/*

 Une union représente un choix possible entre
 plusieurs types. Un type union est écrit A|B
 pour tous types A et B. Il se lit "A ou B".

*/

void printDouble(String|Integer|Float val) {
    String|Integer|Float double;
    switch (val)
    case (is String) { double = val+val; }
    case (is Integer) { double = 2*val; }
    case (is Float) { double = 2.0*val; }
    print("double ``val`` is ``double``");
}

shared void testDouble() {
    printDouble("hello");
    printDouble(111);
    printDouble(0.111);
}

/*
 
 Nous gérons les valeurs manquantes ou "null" en
 utilisant des types union. La classe Null a une
 seule instance nommée null, qui représente une
 valeur manquante. Ainsi, une chaîne de caractère
 potentiellement manquante est représentée par le
 type Null|String.
 
 Nous pouvons écrire le type "Null|String" en
 utilisant la syntaxe d'abréviation "String?".
 Il s'agit simplement de sucre syntaxique pour
 les types union. Le type "String?" se lit
 "String peut-être".
 
 Lancez le programme suivant d'abord avec, puis
 sans un argument de ligne de commande. Vous
 pouvez positionner un argument de ligne de
 commande en utilisant :
 
   Run > Run Configurations... 
 
*/

shared void helloArguments() {
    String? name = process.arguments[0];
    if (is String name) { //TODO: use exists
        print("hello " + name);
    }
    else {
        print("hello world");
    }
}

/*

 EXERCICE
 
 Nous utilisons généralement l'opérateur "exists"
 en lieu et place de "is String" dans ce type
 de code. Modifiez le programme ci-dessus afin
 d'utiliser exists. Encore du sucre syntaxique !
 
 Puis, pour rendre le code un peu plus compact,
 modifier le code pour utiliser cette forme
 de l'expression if :
 
   if (is String name = process.arguments[0])
 
 (Mais en utilisant "exists", au lieu de 
 "is String".)
 
*/

/*
 
 Les opérateurs 'then' and 'else' produisent et
 consomment des valeurs null.
 
*/

shared void thenAndElse() {
    Integer n = 5;
    
    print(n>0 then n);
    print(n<=0 then n);
    
    print(n>=0 then "positive" else "strictly negative");
    
    print("123456789"[n] else "out of bounds");    
    print("12345"[n] else "out of bounds");
}

/*

 EXERCICE
 
 Modifier le programme helloArguments() ci-dessus,
 afin d'utiliser un opérateur au lieu de if/else.

*/

/*

 Une intersection représente une combinaison
 de deux types. Une intersection est écrite
 A&B pour tous types A et B. Elle se lit
 "A et B".
 
 Une intersection résulte souvent d'une
 restriction de type.
 
 Note: La syntaxe {T*} représente une séquence
 iterable de valeurs de type T. C'est du sucre
 syntaxique pour l'interface Iterable.

*/

T? third<T>({T*} iterable) {
    if (is Correspondence<Integer, T> iterable) {
        //Survolez iterable pour voir son
        //type restreint à l'intérieur de ce block!
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

shared void testThird() {
    assert (exists thrd = third("hello"), 
            thrd =='l');
}

/*

 Détail intéressant: le type de 'thrd' ci-dessus
 est <Null|Character>&Object, qui se développe
 en Null&Object|Character&Object, qui se simplifie
 en Nothing|Character, qui se simplifie encore 
 en Character. Le vérificateur de type de Ceylon
 fait ce raisonnement automatiquement.
 
 Les types union et intersection sont particulièrement
 utiles pour l'inférence de type.
*/

shared void demoTypeInference() {
    //survolez joined pour voir son type !
    value joined = concatenate("hello", 1..69);
    Object[] objects = joined;
    print(objects);
}

/*

 Les types union et intersection aident également
 lorsqu'il s'agit de typer correctement les
 opérations union et intersection sur des Sets
 
 Les unions et intersections de Sets sont
 définis via les méthodes intersection() et
 union() de l'interface Set. Les opérateurs
 | et & sont du sucre syntaxique pour ces
 méthodes.
 
 Allez voir les définitions de ces méthodes
 dans Set afin de constater qu'elles sont
 à leur tour définies en termes de types
 union/intersection.

*/

shared void demoSets() {
    Set<Character> chars = HashSet { elements="hello"; };
    Set<Integer> ints = HashSet { elements=0..10; };
    //survolez intsAndChars pour voir son type!
    value intsAndChars = chars|ints;
    print(intsAndChars);
    //survolez empty pour voir son type!
    value empty = chars&ints;
    print(empty);
}

/*

 EXERCICE
 
 Le type spécial Nothing est le type "bottom" ;
 un type sans instance.
 
 Expliquez pourquoi le type de l'intersection
 chars&ints ci-dessus est Set<Nothing>, étant
 donné que les types Character et Integer sont
 des types disjoints (n'ont pas d'instances en
 commun).
 
 P.S. Character et Integer sont des classes
      finales, sans lien d'héritage, et par
      conséquent disjoints.

*/

/*
 
 Une seconde ! Si Nothing n'a pas de valeur, quelle
 est la signification du code suivant qui est
 correctement typé par ailleurs ?
 
*/

shared void thereIsNoNothing() {
    Nothing n = nothing;
    print(n);
}

/*
 
 Et bien, le type Nothing indique en pratique
 qu'un appel de fonction ou bien l'évaluation
 d'une valeur, au choix :
 
 - ne se termine pas, ou
 - envoie une exception.
 
 On pourrait croire que Nothing n'est pas très
 utile, mais en réalité il aide grandement
 lorsqu'il s'agit de définir des types
 génériques et des fonctions génériques.
 
*/

/*

 L'attribut 'coalesced' illustre également
 une autre utilisation des intersections.
 
 Allez voir la définition de coalesce()
 afin de comprendre son fonctionnement.

*/

shared void demoCoalesce() {
    
    //{String?*} est le type d'un itérable de
    //chaînes de caractères et de nulls
    {String?*} stringsAndNulls = {"hello", null, "world"};
    
    //{String*} est le type d'un itérable de
    //chaînes de caractères uniquement (sans nulls)
    {String*} strings = stringsAndNulls.coalesced;
    
    assert (strings.sequence() == ["hello", "world"]);
    
}

/*

 Il existe une astuce avec les types union
 qui nous permet de donner aux fonctions comme
 max() et min() un typage correcte.
 
 Le problème vient du fait que quand nous avons
 "zéro éléments ou plus", max() peut retourner
 null. Mais quand nous avons "un élément ou
 plus", ce n'est pas possible. Et quand nous
 avons exactement zéro éléments, max() retourne
 toujours null. Comment capturer ceci
 dans le système de type ?
 
*/

shared void demoMax() {
    
    Null maxOfZero = max({});
    
    {Integer+} oneOrMore = {1, 2};
    Integer maxOfOneOrMore = max(oneOrMore);
    
    {Integer*} zeroOrMore = {1, 2};
    Integer? maxOfZeroOrMore = max(zeroOrMore);
    
}

/*

 EXERCICE

 Aller voir la définition de max() et Iterable
 puis tentez de comprendre comment ceci
 fonctionne.
 
 La solution fait intervenir Rien ;-)
 (Nothing) 

*/
