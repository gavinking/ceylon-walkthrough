import ceylon.collection {
    HashSet,
    HashMap
}
/*
 
 Cuando una función tiene muchos parámetros, es
 mejor listar sus argumentos por nombre. Los
 argumentos con nombre van rodeados por llaves,
 y cada argumento individual se separa por punto
 y coma.
 
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
 
 Incluso dentro de una lista de argumentos con
 nombre, se permite listar los primeros
 argumentos posicionalmente. (La razón para esto
 quedará más clara más abajo.)
 
 */

void namedArgListsWithPositionalArgs() {
    Entry { 1; item = "once"; };
    Entry { 2; "twice"; };
    parseInteger { "1000101"; radix = 2; };
    parseInteger { "1000101"; 16; };
}

/*
 
 Al final de una lista de argumentos con nombre,
 podemos listar argumentos adicionales, separados
 por comas, que se interpretan como argumentos al
 primer parámetro de tipo Iterable que no tenga
 ya un argumento.
 
 Esta es la sintaxis que habitualmente usamos para
 instanciar tipos contenedor con una lista fija
 inicial de elementos.
 
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
 
 En Ceylon, donde se pueda escribir una lista de
 valores de longitud arbitraria, también se puede
 escribir una comprensión o utilizar el operador
 spread.
 
 */

void namedArgListsWithComprehensionArgs() {
    value hello = String { for (c in "HELLO") c.lowercased };
    value iter = sequence { "never", "once", "twice", "thrice" };
    value set = HashSet { *(-1..1) };
    value map = HashMap { *iter.indexed };
    print(hello);
    print(iter);
    print(set);
    print(map);
}

/*
 
 Podemos pasar una función como un argumento
 utilizando una sintaxis muy natural.
 
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
 
 ¡Todo esto parece un montón de nueva sintaxis!
 Pero hay un propósito más profundo detrás de
 ello: las listas de argumentos con nombre nos
 proporcionan una sintaxis muy flexible para
 definir estructuras con forma de árbol. Esto
 tiene muchas aplicaciones, desde scripts de
 construcción a interfaces de usuario.
 
 Las siguientes clases definen el "esquema" de
 un mini-lenguaje para definir tablas.
 
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
 
 Ahora podemos definir una tabla utilizando una
 sintaxis muy natural, donde el código
 representa la estructura de la tabla en sí:
 
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