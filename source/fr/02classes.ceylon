/*

 Toutes les valeurs sont des instances d'une
 classe. Les classes les plus simples combinent
 des états associés en tant qu'attributs.
 
 Les classes ont des membres :
 
 - des paramètres,
 - des méthodes (fonctions membres),
 - des attributs (valeurs membres), et
 - des classes membres.

 Tout membre annoté shared fait partie de l'API
 de la classe et est accessible depuis
 l'extérieur de la classe.
 
 Pour les classes simples, il est souvent
 nécessaire de raffiner les membres string, 
 equals(), and hash qui sont généralement hérité
 du supertype par défaut Basic.
 
 Un membre annoté actual raffine un membre d'un
 supertype de la classe.
 
*/

class Time(shared Integer hour, 
           shared Integer minute) {
    
    shared Integer secondsSinceMidnight =>
            minute%60*60 + hour*60*60;
    
    shared actual Integer hash => 
            secondsSinceMidnight;
    
    shared actual Boolean equals(Object that) {
        //La syntaxe "is Time" teste and
        //restreint le type de la valeur.
        if (is Time that) {
            //c'est à dire le type Time ici
            return secondsSinceMidnight == 
                   that.secondsSinceMidnight;
        }
        else {
            return false;
        }
    }
    
    //si le fait d'écrire "shared actual Type"
    //devient lassant, vous pouvez utiliser 
    //l'abréviation suivante ! 
    string => "``hour``:``minute``";
    
}

void tryOutTime() {
    Time time1 = Time(13,30);
    print(time1);
    Time time2 = Time(37,30);
    print(time2);
    Time time3 = Time(13,29);
    print(time2);
    print(time1==time2);
    print(time1==time3);
    print(time1.secondsSinceMidnight);
}

/*

 Pour tester des classes, les assertions sont
 très utiles. Exécutez cette fonction afin de
 voir une assertion échouer.

*/

//TODO: faite en sorte que l'assertion passe.
void testTime() {
    Time time1 = Time(13,30);
    assert (time1.string=="13:30");
    Time time2 = Time(37,30);
    assert (time2.string=="37:30");
    Time time3 = Time(13,29);
    assert (time3.string=="13:29");
    assert (time1==time2);
    assert (time1!=time3);
    assert (time1.secondsSinceMidnight==48600);
}

/*
  
  EXERCICE
  
  Corrigez la classe Time afin que toutes les
  assertions passent.
  
*/

/*

 Certaines classes ont des états modifiables. Si
 un attribut est modifiable, il doit être annoté
 variable.

*/

class Counter(count=0) {
    shared variable Integer count;
    shared void inc() => count++;
    string => count.string;
}

void testCounter() {
    value counter = Counter();
    assert (counter.count==0);
    counter.inc();
    counter.inc();
    assert (counter.count==2);
    counter.count = 0;
    assert (counter.count==0);
}

/*
 
 EXERCICE
 
 Ajoutez une méthode reset() à Counter. 
 
 Si vous êtes malin, vous pouvez utiliser l'IDE
 afin qu'il écrive presque tout le code pour vous.
 Commencez par décommenter le test ci-dessous, et
 remarquez l'indication d'une zone erreur dans le
 code. Survolez l'indication de l'erreur, ou
 utilisez :
 
   Edit > Quick Fix / Assist
 
 tant que votre curseur est dans la zone d'erreur
 afin que l'IDE vous propose une résolution
 partielle.
 
*/

//TODO : décommentez ce test et faites le passer
//void testReset() {
//    value counter = Counter();
//    assert (counter.count==0);
//    counter.inc();
//    counter.inc();
//    assert (counter.count==2);
//    counter.reset();
//    assert (counter.count==0);
//}

/*
 
 Une classe fille peut étendre notre classe, et
 raffiner ses membres. Un membre d'une classe
 peut être raffiné s'il est annoté default.
  
*/

class SecondTime(Integer hour, 
                 Integer minute, 
                 second) 
        extends Time(hour, minute) {
    
    //Nous pouvons déclarer le type et les annotations
    //d'un paramètre dans le corps de la classe
    //afin d'alléger la liste des paramètres.
    shared Integer second;
    
    /*
    
     Oups ! Le code ci-dessous contient une erreur !
     
     Commencez par décommenter le code, puis corriger
     l'erreur en ajoutant l'annotation 'default' à
     Time.secondsSinceMidnight ci-dessus.
     
    */
    
    //TODO : décommenter et corriger l'erreur !
    //secondsSinceMidnight => 
    //        super.secondsSinceMidnight+second%60;
    
}

/*
 
 EXERCICE
 
 Corrigez l'implémentation de Time et SecondTime
 afin que le test suivant puisse passer.
 
*/

//TODO : faite passer l'assertion
void testSecondTime() {
    Time time = Time(13,30);
    assert (time.string=="13:30");
    SecondTime stime1 = SecondTime(13,30,00);
    SecondTime stime2 = SecondTime(13,30,25);
    assert (time==stime1);
    assert (time!=stime2);
    assert (stime1.string=="13:30:00");
    assert (stime2.string=="13:30:25");
}

/*
 
 Une déclaration de classes anonyme définit 
 une instance. Elle combine une déclaration
 de valeur et de classe.
 
 */

object midnight extends SecondTime(0,0,0) {
    //TODO : décommenter et corriger l'erreur.
    //string => "midnight";
}

/*
 
 Une classe abstraite est une classe qui ne peut
 pas être instanciée. Elle peut déclarer des
 membres formels, qui doivent être implémentés
 par des sous-classes concrètes de la classe
 abstraite.
 
 Un type énuméré est une classes abstraite ou
 une interface qui énumère (restreint) ces sous
 types.
 
*/

abstract class LinkedList<out T>() 
        of Cons<T> | empty {
    shared formal Integer length;
}

//Ce cas du type énuméré est une classe
class Cons<out T>(shared T first,
                  shared LinkedList<T> rest) 
        extends LinkedList<T>() {
    length=>rest.length+1;
}

//ce cas du type énuméré est un objet singleton 
object empty 
        extends LinkedList<Nothing>() {
    length=>0;
}

String formatLinkedList(LinkedList<Object> list) {
    //Nous utilisons une expression switch pour
    //gérer les cas d'un type énuméré. Le
    //compilateur valide que le switch
    //considère bien l'ensemble des cas.
    switch (list)
    case (empty) {
        return "";
    }
    case (is Cons<Object>) {
        value rest = list.rest;
        value firstString = list.first.string;
        switch (rest)
        case (empty) {
            return firstString;
        }
        else {
            return firstString + ", " + 
                    formatLinkedList(rest);
        }
    }
}

void testLinkedList() {
    value list = Cons("Smalltalk", Cons("Java", Cons("Ceylon", empty)));
    assert (list.length==3);
    print(formatLinkedList(list));
}

/*

 EXERCICE
 
 Ecrire un enum façon Java. L'exemple classique
 est celui de l'enum Suit, avec les cas hearts,
 diamonds, clubs, spades.

*/

//TODO : Ecrire la classe Suit ici
