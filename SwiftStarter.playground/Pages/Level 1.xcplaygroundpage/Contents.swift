import Foundation

/*:
 # Level 1 - The motivated Beginner
 
 Nachdem wir nun wissen, was Variablen und Konstanten sind, wie wir sie mit Werten füllen und grundlegende Operationen ausführen können, widmen wir uns nun wichtigen Dingen: Typen und Typ-Inferenz.
 
 Typ-Inferenz ist ein Kernelement von Swift, was zum einen die Mächtigkeit der Sprache unterstreicht, den Programmierer aber auch zur schieren Verzweiflung treiben kann. Wir legen klar Fokus auf Ersteres :D
 
 Weiters werfen wir einen kurzen Blick in die Welt der Strings und sehen uns an, wie wir Gruppen von Werten flott zusammenfassen können.
 
 * callout(Level 1 - The motivated Beginner):
   - A. Operationen mit unterschiedlichen Typen
   - B. Collection-Types
   - C. Strings
   - D. Tuples

 Dann lasst uns loslegen und keine Zeit mehr verlieren :)
 */

/*
 A. Operationen mit unterschiedlichen Typen und Typ-Inferenz
 
 Swift bietet eine handvoll unterschiedlicher Basis-Typen an: Int, Float, Double, Bool, String.
 */

var index : Int = 0
index = 3
var floatingIndex : Double = 1.5
floatingIndex = 2.5
//index = floatingIndex
//index = Int(floatingIndex)
//floatingIndex = Double(index)

var otherIndex = 0
var otherFloatingIndex = 1.5
//otherIndex = otherFloatingIndex

var flexible = false
flexible = true


/*
 B. Collection-Types
 
 Weiters gibt es Collection-Types, die im Grunde nur eine Zusammenfassung von Werten erlauben, mal mit, mal ohne Index :) : Array, Set und Dictionary
 */

//Arrays
var devs = ["Manu", "Petra", "Sarah", "Kathi", "Julia"]
devs[0]
var employeeName = devs[2]

//Dictionaries
var personData = ["eNumber" : "93291", "dob" : "1982-01-01", "firstName" : "Manu", "lastName" : "Rink"]
personData["dob"]
personData["firstName"]
var employees = ["development" : devs, "service" : ["Peter", "Anna", "George"]]
employees["development"]

/*
 C. Strings
 */
var firstName = "Manu"
firstName += "ela"

var name = "Manu"
var age = 35
var countryOfOrigin = "Austria"
var decoratedName = name + " from " + countryOfOrigin
//decoratedName += " with the age of " + age.description
//decoratedName += " with the age of " + String(age)
//decoratedName = name + " from \(countryOfOrigin) with the age of \(age)"

//... and guess what! we can use emojis in strings and even as constant and variable names!!!11eleven
var myAnimals = ["😺", "🐶", "🐹", "🐭"]
"I love my \(myAnimals)"
"I love my " + myAnimals.description

var 🐴💩 = "This is horse poop"
var dayDescription = "Getting stuck in coding? " + 🐴💩


/*
 D. Tuples
 */

var person = ("Manu", "Rink")
person.0
var thePerson = (first: "Manu", last: "Rink")
thePerson.last

thePerson.last = "TheRink!"
thePerson
thePerson.1 = "Rink"
thePerson

let coordinates3D = (x: 2, y: 3, z: 1)
let coordX = coordinates3D.x
let (x, y, z) = coordinates3D
x
y

/*:
 * callout(Nun noch ne Übunge gefällig?):
 Falls du noch Zeit und Lust hast, schau dir die Übungsaufgaben unter folgender URL in der Section "Challenges" an. Sie sind kurz und knackig und helfen enorm, um das grade eben Gehörte gut zu verankern :)
 
 [Ray Wenderlich - Swift Tutorial Part 2](https://www.raywenderlich.com/143885/swift-tutorial-part-2-types-operations)
 */









