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

func presentMyName () {
    print ("Mein Name ist Manu")
}

func addFiller () {
    print("Und!")
}

func presentMyAge () {
    print("Ich über 30 Jahre alt 🙌")
}

presentMyName()
addFiller()
presentMyAge()


/*:
 B. Ein- und Rückgabeparameter
 
 Nun macht es natürlich Sinn, auch Logik in Funktionen zu verpacken, die man an unterschiedlichen Stellen in seinem Programm wieder ausführen möchte. Deshalb gibt es die Möglichkeit, Parameter zu definieren und ihnen einen Namen zu geben - sogar zwei! ;)
 Eingabeparameter werden in runden Klammern (..) direkt hinter dem Funktionsnamen geschrieben. Hat man mehrere Werte, die man einer Funktion übergeben möchte, so trennt man diese einfach mit einem ",". Jeder Wert bekommt also einen sprechenden Namen und muss auch seinen Typ nennen.
 Der Rückgabeparameter wird nach den runden Klammern und nach einem "->" angegeben. Streng genommen gibt es nur einen Wert, der von einer Funktion zurückgegeben werden kann, aber wir werden sehen, dass es hierzu (fast) mehr Aussnahmen als Regeln selbst gibt.
 */

func age (yob : Int) -> Int {
    return 2021 - yob
}

func age (_ yob : Int) -> Int {
    return 2021 - yob
}

func age (birthYear: Int) -> Int {
    return 2021 - birthYear
}

func calcMyAgeWith (birthYear: Int) -> Int {
    let calendar = Calendar.current
    let date = Date()
    
    let components = calendar.dateComponents([.year], from: date)
    
    let myAge = components.year! - birthYear
    return myAge
}

age(yob: 1990)
age(1990)
age(birthYear: 1990)
calcMyAgeWith(birthYear: 1990)

func calcAgesFor (birthYears: [Int]) -> [Int] {
    let calendar = Calendar.current
    let date = Date()
    
    let components = calendar.dateComponents([.year], from: date)
    
    var ages = [Int]()
    for year in birthYears {
        let age = components.year! - year
        ages.append(age)
        print("Das Alter der Person mit Geburtsdatum \(year) ist \(age)")
    }
    
    return ages
}

calcAgesFor(birthYears: [1978, 1990, 1999, 2001])



/*:
C. inout Parameter
 
 Wenn man innerhalb einer Funktionen bestimmte Werte nicht neu definieren möchte sondern sie selbst manipulieren will, dann eignen sich "inout" Parameter dafür bestens. Das heisst, dass man der Funktion vereinfacht gesagt nur einen "Link" zu einem Wert gibt. Die Funktion nimmt sich dann den Wert von diesem Link, tut was sie zu tun hat und schreibt dann den veränderten Wert exakt wieder an die gleiche Stelle, auf die der Link zeigt.
 */

func double(number: inout Int) {
    number *= 2
}

var myNumber = 2
print("MyNumber vor der Verändeurung: \(myNumber)")
double (number: &myNumber)
print("MyNumber nach der Verändeurung: \(myNumber)")

/*:
D. Completionblocks
 
 Wenn es für eine Funktion nicht ausreicht, einen Wert zurückzugeben, sondern ein ganzes Stück Code auszuführen, dann verwendet man dafür am Besten Completionblocks. Das ist nichts anderes als ein Paramter einer Funktion, der mit einem Namen versehen ist und selbst ein Stückchen Code ist. Zum passenden Zeitpunkt ruft die Funktion dann über den Parameter diesen Code auf. So kann sehr gut auf asynchrone Prozesse eingehen, wo man nicht weiss, wann man das Ergebnis haben wird - und warten ist ja auch doof!
 */
 
func fetchLatestInfo (for url: URL, completion: @escaping (_ news: String) -> Void) {
    let task = URLSession.shared.downloadTask(with: url, completionHandler: {
        localURL, urlResponse, error in
        if let localURL = localURL {
            if let string = try? String(contentsOf: localURL) {
                completion(string)
            }
        }
    })
    task.resume()
}

func showLatestNews () {
    fetchLatestInfo(for: URL(string: "https://rss.orf.at/news.xml")!) { news in
        let articles = news.components(separatedBy:"<title>")
        
        print("\n\n+++++++ BREAKING (\(articles.count))+++++++")
        
        var count = 0
        for article in articles {
            let articleParts = article.components(separatedBy: "</title>")
            if count > 1 {
                print(" 🗞 " + articleParts.first!)
            }
            count += 1
        }
        
        print("+++++++++++++++++++++++++\n\n")
    }
}

showLatestNews()

