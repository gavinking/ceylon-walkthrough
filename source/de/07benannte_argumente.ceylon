import ceylon.collection {
    HashSet,
    HashMap
}
/*

 Wenn eine Funktion viele Parameter hat, ist es
 oft besser, ihre Argumente mit Namen versehen
 zu notieren. Listen benannter Argumente werden
 in geschweifen Klammern eingeschlossen, und die
 einzelnen Argumente sind durch Strichpunkte
 getrennt.

*/

shared void namedArgLists() {
    value entry1 = Entry { key = 1; item = "einmal"; };
    value entry2 = Entry { item = "zweimal"; key = 2; };
    value int1 = Integer.parse { string = "1000101"; radix = 2; };
    value int2 = Integer.parse { radix = 16; string = "1000101";  };
    print(entry1);
    print(entry2);
    print(int1);
    print(int2);
}

/*

 Selbst innerhalb einer Liste benannter Argumente
 dürfen wir die ersten Argumente nur nach ihrer
 Position auflisten. (Der Grund dafür wird gleich
 klar.)

*/

shared void namedArgListsWithPositionalArgs() {
    Entry { 1; item = "einmal"; };
    Entry { 2; "zweimal"; };
    Integer.parse { "1000101"; radix = 2; };
    Integer.parse { "1000101"; 16; };
}

/*

 Am Ende einer Liste benannter Argumente dürfen
 wir zusätzliche Argumente angeben, durch Kommas
 getrennt, die als Argumente für den ersten
 Parameter vom Typ Iterable, der noch kein
 Argument hat, gelten.
 
 Das ist die Syntax, die wir meist verwenden,
 um Container-Typen mit einer anfangs festen
 Menge an Elementen zu instanziieren.

*/

shared void namedArgListsWithIterableArgs() {
    value hallo = String { 'H', 'a', 'l', 'l', 'o' };
    value iter = sequence { "einmal", "zweimal", "dreimal" };
    value set = HashSet { 0, 1, -1 };
    value map = HashMap { 1->"einmal", 2->"zweimal", 3->"dreimal", 0->"nie" };
    print(hallo);
    print(iter);
    print(set);
    print(map);
}

/*

 In Ceylon können wir überall, wo wir eine
 beliebig lange Liste von Werten angeben können,
 auch eine Comprehension oder den Verteilungs-
 Operator verwenden.

*/

shared void namedArgListsWithComprehensionArgs() {
    value hallo = String { for (c in "HALLO") c.lowercased };
    value iter = sequence { "nie", "einmal", "zweimal", "dreimal" };
    value set = HashSet { *(-1..1) };
    value map = HashMap { *iter.indexed };
    print(hallo);
    print(iter);
    print(set);
    print(map);
}

/*

 Mit der folgenden, sehr natürlichen Syntax können
 wir eine Funktion als Argument übergeben.

*/

shared void namedFunctionalArg() {
    value iter = mapPairs {
        firstIterable = 1..5; 
        secondIterable = {
            "einmal", 
            "zweimal", 
            "dreimal", 
            "viermal", 
            "fünfmal"
        };
        function collecting(Integer num, String word)
                => num -> word + " Hallo".repeat(num);
    };
    print(iter);
}

/*

 Das sieht wie eine Menge neuer Syntax aus! Aber
 es gibt einen tieferen Sinn dahinter: Listen
 benannter Argument geben uns eine sehr flexible
 Syntax, um baumartige Strukturen zu definieren.
 Dafür gibt es viele Anwendungen, von Build-
 Skripten bis zu Benutzeroberflächen.
 
 Die folgenden Klassen definieren das "Schema" für
 eine Mini-Sprache, um Tabellen zu definieren.

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

 Jetzt können wir eine Tabelle mit einer sehr
 natürlichen Syntax definieren, wobei der Code
 die Struktur der Tabelle selbst darstellt:

*/

Table table = Table {
    title = "Ceylon-Project";
    header = Row {
        Cell { "Modul" },
        Cell { "Beschreibung" },
        Cell { "URL" }
    };
    Row {
        Cell { "ceylon-spec" },
        Cell { "Die Spezifikation und der Typechecker" },
        Cell { "https://github.com/ceylon/ceylon-spec" }
    },
    Row {
        Cell { "ceylon-compiler" },
        Cell { "Das Backend für die JVM" },
        Cell { "https://github.com/ceylon/ceylon-compiler" }
    },
    Row {
        Cell { "ceylon-js" },
        Cell { "Das Backend für JavaScript" },
        Cell { "https://github.com/ceylon/ceylon-js" }
    },
    Row {
        Cell { "ceylon.language" },
        Cell { "Das Sprachmodul" },
        Cell { "https://github.com/ceylon/ceylon.language" }
    }
};

shared void printTable() {
    print(table);
}
