import ceylon.collection {
    HashSet,
    HashMap
}
/*
 
 When a function has many parameters, it's
 better to list its arguments by name. Named
 argument lists are enclosed in braces, and
 individual arguments are separated by 
 semicolons.
 
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
 
 Even within a named argument list, we're 
 allowed to list the first arguments 
 positionally. (The reason for this will 
 become clear below.)
 
 */

void namedArgListsWithPositionalArgs() {
    Entry { 1; item = "once"; };
    Entry { 2; "twice"; };
    parseInteger { "1000101"; radix = 2; };
    parseInteger { "1000101"; 16; };
}

/*
 
 At the end of a named argument list, we may
 list additional arguments, separated by
 commas, which are interpreted as arguments
 to the first parameter of type Iterable
 which does not already have an argument.
 
 This is the usual syntax we use for 
 instantiating container types with an 
 initially fixed list of elements.
 
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
 
 In Ceylon, anywhere we can write an 
 arbitrary-length list of values, we can also
 write a comprehension or use the spread
 operator.
 
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
 
 We can pass a function as an argument using
 a very natural syntax.
 
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
 
 All this seems like a lot of new syntax! But
 there's a deeper purpose behind it: named 
 argument lists provide us with a very
 flexible syntax for defining tree-like 
 structures. This has many applications, from
 build scripts to user interfaces.
 
 The following classes define the "schema" of
 a mini-language for defining tables.
 
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
 
 Now we can define a table using a very
 natural syntax, where the code represents
 the structure of the table itself:
 
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