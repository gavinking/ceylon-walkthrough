import ceylon.collection { HashMap, HashSet, StringBuilder }
/*
 
 Quand une fonction a de nombreux paramètres,
 il vaut mieux lister ses arguments par nom.
 Les listes d'arguments nommés sont encadrées
 par des accolades, et les arguments eux même
 sont séparés par des points-virgules.  
 
 */

void namedArgLists() {
    value entry1 = Entry { key = 1; item = "once"; };
    value entry2 = Entry { item = "twice"; key = 2; };
    value int1 = parseInteger { string = "1000101"; radix = 2; };
    value int2 = parseInteger { radix = 16; string = "1000101";  };
    print(entry1);
    print(entry2);
    print(int1);
    print(int2);
}

/*
 
 Même à l'intérieur d'une liste d'arguments
 nommés, nous pouvons lister le premier
 élément de manière positionnelle. (La raison
 de cela sera explicité ci-dessous)
 
 */

void namedArgListsWithPositionalArgs() {
    Entry { 1; item = "once"; };
    Entry { 2; "twice"; };
    parseInteger { "1000101"; radix = 2; };
    parseInteger { "1000101"; 16; };
}

/*
 
 A la fin d'une liste d'arguments nommés,
 nous pouvons lister des arguments
 additionnels, séparés par des virgules,
 qui sont interprétés en tant qu'arguments
 du premier paramètre de type Iterable qui
 n'a pas déjà un argument.
 
 C'est la syntaxe habituelle que nous
 utilisons pour instancier les types de
 container avec une liste initiale
 d'éléments.
 
 */

void namedArgListsWithIterableArgs() {
    value hello = String { 'H', 'e', 'l', 'l', 'o' };
    value iter = sequence { "once", "twice", "thrice" };
    value set = HashSet { 0, 1, -1 };
    value map = HashMap { 1->"once", 2->"twice", 3->"thrice", 0->"never" };
    print(hello);
    print(iter);
    print(set);
    print(map);
}

/*
 
 En Ceylon, aux endroits où nous pouvons
 écrire une liste de valeurs de longueur
 arbitraire, nous pouvons également écrire
 une compréhension ou utiliser l'opérateur
 d'expansion.
 
 */

void namedArgListsWithComprehensionArgs() {
    value hello = String { for (c in "HELLO") c.lowercased };
    value iter = sequence { "once", "twice", "thrice" };
    value set = HashSet { *hello };
    value map = HashMap { 0->"never", *iter.indexed };
    print(hello);
    print(iter);
    print(set);
    print(map);
}

/*
 
 Nous pouvons passer une fonction en tant
 qu'argument via une syntaxe très naturelle.
 
 */

void namedFunctionalArg() {
    value iter = mapPairs {
        firstIterable = 1..5; 
        secondIterable = {
            "once", 
            "twice", 
            "thrice", 
            "four times", 
            "five times"
        };
        function collecting(Integer num, String word)
                => num -> word + " hello".repeat(num);
    };
    print(iter);
}

/*
 
 Tout ceci semble représenter beaucoup de
 nouvelles syntaxes! Mais il y a un but plus
 profond derrière ceci : les listes
 d'arguments nommés nous fournissent un
 moyen extrêmement flexible pour définir
 des structures d'arbre. Ceci a de nombreuses
 applications, depuis les scripts de build
 jusqu'aux interfaces utilisateur.
 
  La classe suivante définit le "schema"
  d'un mini-langage pour définir des
  tables. 
 
 */

String center(String content, Integer size) {
    value padding = size-content.size;
    value paddingBefore = padding/2;
    value paddingAfter = padding-paddingBefore;
    return " ".repeat(paddingBefore) + content + 
            " ".repeat(paddingAfter);
}

class Cell({String*} content) {
    shared actual String string {
        value result = StringBuilder();
        for (s in content) {
            result.append(s);
        }
        return result.string;
    }
}

class Row({Cell*} cell) {
    shared Cell[] cells = cell.sequence();
    shared actual String string {
        value result = StringBuilder();
        result.append("|");
        for (cell in cells) {
            result.append(center(cell.string, 45));
            result.append("|");
        }
        return result.string;
    }
}

class Table(String title, Row header, {Row*} rows) {
    shared actual String string {
        value result = StringBuilder();
        value size = header.cells.size*46+1;
        result.append(center(title, size) + "\n");
        result.append(center("-".repeat(title.size), size) + "\n");
        result.append(header.string.replace("|", " ")+"\n");
        result.append("-".repeat(size) + "\n");
        for (row in rows) {
            result.append(row.string+"\n");
            result.append("-".repeat(row.cells.size*46+1) + "\n");
        }
        return result.string;
    }
}

/*
 
 Maintenant nous pouvons définir une table
 en utilisant une syntaxe particulièrement
 intuitive, ou le code représente la
 structure de la table elle-même :
 
 */

Table table = Table {
    title = "Ceylon Project";
    header = Row {
        Cell { "Module" },
        Cell { "Description" },
        Cell { "URL" }
    };
    Row {
        Cell { "ceylon-spec" },
        Cell { "The specification and typechecker" },
        Cell { "https://github.com/ceylon/ceylon-spec" }
    },
    Row {
        Cell { "ceylon-compiler" },
        Cell { "The backend for the JVM" },
        Cell { "https://github.com/ceylon/ceylon-compiler" }
    },
    Row {
        Cell { "ceylon-js" },
        Cell { "The backend for JavaScript" },
        Cell { "https://github.com/ceylon/ceylon-js" }
    },
    Row {
        Cell { "ceylon.language" },
        Cell { "The language module" },
        Cell { "https://github.com/ceylon/ceylon.language" }
    }
};

void printTable() {
    print(table);
}