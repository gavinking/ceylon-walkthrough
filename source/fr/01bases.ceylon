/*

 Un programme est simplement une fonction de
 de premier niveau sans paramètres. Pour exécuter 
 le programme, sélectionnez le nom de la fonction
 et utilisez :
 
 Run > Run As > Ceylon Java Application
   
*/

void hello() {
    print("Hello, World!");
}

/*
  
  EXERCICE
  
  Vous souhaitez probablement savoir à quoi
  sert print() !
  Vous pouvez pour cela au choix :
  - survoler le nom de la fonction afin de voir
    sa documentation, ou bien
  - garder enfoncée la touche ctrl ou command et 
    cliquer sur le nom de la fonction pour
    naviguer vers sa déclaration.
  
*/

/*

 hello() et  print() sont des exemples de
 fonction de premier niveau. Nous n'avons
 pas besoin d'une instance d'objet pour les
 appeler. 

 Une fonction de premier niveau peut prendre
 des arguments et retourner une valeur, dans
 ce cas nous devons indiquer le type des paramètres,
 et le type de valeur retournée.
    
 Un paramètre peu avoir une valeur par défaut.

*/

String greeting(String name = "World") {
    //Les expressions interpolées sont encadrées
    //de double guillemets obliques à l'intérieur
    //des chaînes de caractère.
    return "Hello, ``name``!";
}

/*

 Quand une fonction retourne simplement
 une expression, nous pouvons l'abréger
 avec une grosse flèche.
 
*/

void helloName() => print(greeting("Ceylon"));

void helloWorld() => print(greeting());

/*
 
 Un paramètre peut être variadique, c'est
 à dire accepter des valeurs multiples. 
 
*/

Integer sum(Integer* numbers) {
    variable value sum = 0; //les valeurs modifiables doivent être annotées
    for (x in numbers) {
        sum+=x;
    }
    return sum;
}

void calculateSums() {
    
    //une somme sans nombres
    print(sum());
    
    //une somme de deux nombres
    print(sum(2, 2));
    
    //la somme de tous les nombres de 0 à 10 
    //inclusif, en utilisant l'opérateur d'intervalle ..
    //et l'opérateur d'expansion *
    print(sum(*(0..10)));
    
    //Et simplement pour vous mettre en appétit,
    //la somme de tous les carrés des nombres de
    // 0 à 100 !
    //l'opérateur ^ correspond à l'exponentiation.
    print(sum(for (n in 0..10) n^2));
    
}

/*
  
  Les variables sont appelées "valeurs" en Ceylon,
  car elles ne sont en fait pas variables par
  défaut !
  
*/

void greet() {
    String greeting = "hei verden";
    //TODO : Utilisez l'IDE pour remplir le reste
}

/*
  
  EXERCICE
  
  Complétez cette fonction. Non, nous ne cherchons 
  pas à vous faire écrire manuellement un simple
  appel à print(). Nous souhaitons que vous
  laissiez l'IDE le faire pour vous:
  
  - Saisissez une partie du nom de la fonction
    que vous voulez appeler.
  
  - ctrl-espace active l'autocompletion.
  
  - Sélectionner une fonction vous fait basculer
    en mode lié, dans lequel vous pouvez rapidement
    saisir les arguments. Utilisez tabulation
    pour naviguer entre eux.
  
  - echap ou bien le fait de taper un caractère
    en dehors d'un champs du mode lié, vous fait
    quitter le mode lié.
  
*/

/*
 
 Une valeur peut être constante (dans une portée
 donnée), une variable, ou bien un getter.

*/

//une constante de premier niveau
Integer zero = 0;

//une variable avec sa valeur initiale
variable Integer int = zero;

//un getter défini en utilisant une grosse flèche
Integer intSquared => int^2;

//un getter défini en utilisant un block 
Integer intFactorial {
    variable value fac = 1;
    for (i in 1..int) {
        fac*=i;
    }
    return fac;
}

void values() {
    int = 3;
    print("i = ``int``");
    print("i^2 = ``intSquared``");
    print("i! = ``intFactorial``");
    int = 4;
    print("i = ``int``");
    print("i^2 = ``intSquared``");
    print("i! = ``intFactorial``");
}

/*

 Le type d'une déclaration locale peut être
 inférée par le compilateur. Survolez le mot clé
 value ou fonction pour voir le type inféré de
 la déclaration.
 
 Le type d'un paramètre de fonction ne peut pas
 être inféré.

*/

void inferredTypes() {
    value time = system.milliseconds;
    value nl = operatingSystem.newline;
    function sqr(Float float) => float*float;
}

/*
 
 EXERCICE
 
 Positionnez le curseur sur le mot clé value ou
 fonction et sélectionnez:
 
   Source > Quick Fix / Assist
 
 Puis sélectionnez l'entrée 'Specify type' dans
 le menu pop-up.
 
 Ou bien : sélectionnez l'ensemble de la fonction, et
 sélectionnez :
 
   Source > Reveal Inferred Types
 
*/


/*
 
 L'échappement des caractères unicodes est réellement
 utile. Par exemple, pi peut être écrit \{#03C0}. 
 
 Oups, La console d'Eclipse est stupide!
 Allez à:
 
   Project > Properties > Resource
 
 et réglez l'encodage de votre fichier texte à
 UTF-8 avant d'exécuter ce programme.
 
*/

void helloPi() => print(greeting("\{#03C0}"));

/*

  Ou encore, plus verbeux, mais également
  bien plus lisible, nous pouvons utiliser le
  nom de caractère unicode.

*/

void helloPi2() => print(greeting("\{GREEK SMALL LETTER PI}"));


/*

 Comment faire si nous souhaitons littéralement
 afficher la chaîne de caractère "\{#03C0}"? Nous
 pouvons utiliser un échappement via backslash,
 ou une chaîne de caractère verbatim.

*/

void printTheUnicodeEscapesForPi() {
    
    //L'échappement \\ est un backslash littéral
    print("\\{#03C0}");
    
    //les triples-doubles-guillemets délimitent une
    //chaîne de caractère verbatim qui n'échappe pas
    // les caractères 
    print("""\{GREEK SMALL LETTER PI}""");
    
}

/*

 Les chaînes de caractère littérales peuvent
 s'étendre sur plusieurs lignes. En particulier
 nous les utilisons pour écrire des documentations
 d'API en format markdown. Survolez le nom de
 cette fonction pour voir sa documentation. 
 
*/

"Ce programme affiche: 
 
 - le _nom de la machine virtuelle,_
 - la _version de la machine virtuelle,_ et
 - la _version du langage Ceylon._
 
 Il utilise les objets [[operatingSystem]] et
 [[language]] définis dans `ceylon.language`, le
 module du langage Ceylon."
void printInfo() =>
        print("virtual machine: ``operatingSystem.name``
               version: ``operatingSystem.version``
               language: ``language.version`` (``language.versionName``)");
              //conseil: essayez d'utiliser l'attribut 
              //'normalized' de String

/*

 Les annotations fournissent des meta-données
 concernant les éléments d'un programme.
 Survolez le nom de cette fonction.

*/

by ("Gavin")
throws (`class Exception`)
deprecated ("Boaf, ce programme n'est pas très 
             utile. Essayer plutôt [[hello]].")
see (`function hello`)
void failNoisily() {
    throw Exception("aaaaarrrrrggggghhhhhhh");
}

/*

 EXERCICE
  
 Ecrire un programme qui affiche tous les nombres
 premiers entre 1 et 100. N'oubliez pas de documenter
 correctement votre travail !
  
*/

//TODO : écrire les nombres premiers !
