import Foundation

/*:
 # Level 3 - But wait! There is more!
 
 Typen und Inferenz sind nun also in unserer Swift Werkzeugkiste gelandet, ebenso wie Arrays, Dictionaries und Tuples.
 Nun kanns nahtlos weitergehen mit etwas Ablauflogik!
 
 * callout(Level 3 - But wait! There is more!):
   - A. Funktionen allgemein
   - B. Ein- und Ausgabeparameter
   - C. inout Parameter
   - D. Completionblocks

Hier wird's richtig spannend! Denn Code möchte auch ausgeführt werden, und das am besten mehrfach und von verschiedenen Stellen aus.
Mit Funktionen haben wir die Möglichkeit
 - Code zu gemeinsam nutzbaren Blöcken zusammenzufassen
 - ihnen einen Namen zu geben und
 - ihre Ein- und Ausgabewerte zu defnieren.
 - YEY!
 */
/*:
 A. Funktionen allgemein - Definition und Nutzung

 Hier sehen wir uns an, was eine Funktion ist, welche Bestandteile sie hat und wie wir sie nutzen können. Keine Sorge, die ersten Schritte sind besonders einfach!
 Wir starten immer mit dem Keyword "func", dann dem Namen der Funktion und dicht gefolgt von der Definition der Parameter für die Ein- und Ausgabe.
 */



//presentMyName()
//addFiller()
//presentMyAge()


/*:
 B. Ein- und Rückgabeparameter
 
 Nun macht es natürlich Sinn, auch Logik in Funktionen zu verpacken, die man an unterschiedlichen Stellen in seinem Programm wieder ausführen möchte. Deshalb gibt es die Möglichkeit, Parameter zu definieren und ihnen einen Namen zu geben - sogar zwei! ;)
 Eingabeparameter werden in runden Klammern (..) direkt hinter dem Funktionsnamen geschrieben. Hat man mehrere Werte, die man einer Funktion übergeben möchte, so trennt man diese einfach mit einem ",". Jeder Wert bekommt also einen sprechenden Namen und muss auch seinen Typ nennen.
 Der Rückgabeparameter wird nach den runden Klammern und nach einem "->" angegeben. Streng genommen gibt es nur einen Wert, der von einer Funktion zurückgegeben werden kann, aber wir werden sehen, dass es hierzu (fast) mehr Aussnahmen als Regeln selbst gibt.
 */


//age(yob: 1990)
//age(1990)
//age(birthYear: 1990)
//calcMyAgeWith(birthYear: 1990)




//calcAgesFor(birthYears: [1978, 1990, 1999, 2001])



/*:
C. inout Parameter
 
 Wenn man innerhalb einer Funktionen bestimmte Werte nicht neu definieren möchte sondern sie selbst manipulieren will, dann eignen sich "inout" Parameter dafür bestens. Das heisst, dass man der Funktion vereinfacht gesagt nur einen "Link" zu einem Wert gibt. Die Funktion nimmt sich dann den Wert von diesem Link, tut was sie zu tun hat und schreibt dann den veränderten Wert exakt wieder an die gleiche Stelle, auf die der Link zeigt.
 */



//var myNumber = 2
//print("MyNumber vor der Verändeurung: \(myNumber)")
//double (number: &myNumber)
//print("MyNumber nach der Verändeurung: \(myNumber)")

/*:
D. Completionblocks
 
 Wenn es für eine Funktion nicht ausreicht, einen Wert zurückzugeben, sondern ein ganzes Stück Code auszuführen, dann verwendet man dafür am Besten Completionblocks. Das ist nichts anderes als ein Paramter einer Funktion, der mit einem Namen versehen ist und selbst ein Stückchen Code ist. Zum passenden Zeitpunkt ruft die Funktion dann über den Parameter diesen Code auf. So kann sehr gut auf asynchrone Prozesse eingehen, wo man nicht weiss, wann man das Ergebnis haben wird - und warten ist ja auch doof!
 */
 
func fetchLatestInfo (for url: URL, completion: @escaping (_ news: String) -> Void) {

    //TODO: fill in logic here to fetch data from remote source
}

func showLatestNews () {
    
    //TODO: Use the fetchLatestInfo function to fetch the info/news
    //      and print it out to the console!
}

showLatestNews()

