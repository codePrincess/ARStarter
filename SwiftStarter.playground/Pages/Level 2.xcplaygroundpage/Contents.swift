import Foundation

/*:
 # Level 2 - The Semi-Pro
 
 Typen und Inferenz sind nun also in unserer Swift Werkzeugkiste gelandet, ebenso wie Arrays, Dictionaries und Tuples.
 Nun kanns nahtlos weitergehen mit etwas Ablauflogik!
 
 * callout(Level 2 - The Semi-Pro):
   - A. Alles kommt zusammen
     - Boolsche Logik
     - Gleichheit
     - If-Statement
   - B. Ternäre Operatoren
   - C. Schleifen
   - D. Switch-Anweisungen

 
 Dann lasst uns loslegen und keine Zeit mehr verlieren :)
 */

/*
 A. Alles kommt zusammen
 
 Ablauflogik brauchst erstmal Aussagen, auf die sie sich berufen kann. Somit müssen wir JA und NEIN generieren können, wenn wir bei unserer Logik IF-THEN-ELSE oder Switch-Statements in Auftrag geben :) Auch Vergleiche und Verneinungen spielen hier eine wesentliche Rolle
 */

//Boolsche Logik

var a = 1
var b = 2
a == b
a != b
!(a == b)
a < b
a >= b

a < b && b < 5
(b % 2) > 0 && a > 0
(b % 2) > 0 || a > 0

//Gleichheit, besonders bei Strings

let firstName = "manu"
let lastName = "rink"
var lovedPet = "😺"
let sameFirstLastName = firstName == lastName
let order = firstName < lastName

//IF-Statement

if a == b {
    print("equal 🤘")
} else {
    print("not equal ☹️")
}

if firstName != "manu" {
    print("This is not \(firstName)")
} else {
    print("Ohai \(firstName)")
    lovedPet = "🐶"
}
print("\(firstName) loves \(lovedPet)")

if a > b || b < 5 {
    let c = 30
    a *= c
    print("condition true")
}
//print(c)

/*
 B. Ternäre Operatoren
 */

let min = a < b ? a : b
let max = a > b ? a : b

a > b ? print("a is bigger") : print("b is bigger")
a > b ? print("a is bigger") : ()

var aText = a > 10 ? "wow big A is BIG" : "sweet lil A"

var text = ""
if a > 10 {
    text = "wow big A is BIG"
} else {
    text = "sweet lil A"
}


/*
 C. Schleifen
 */

//While-Schleife
while a > 0 {
    print(a)
    a -= 5
}

a = 50
while true {
    a -= 5
    if a < 10 {
        break
    }
    print(a)
}

//Repeat-While-Schleife

a = 0
repeat {
    a += 10
} while a < 100

//For-Schleife

var count = 10
var sum = 1
var lastSum = 0

for _ in 0..<count {
    lastSum = sum
    sum += lastSum
}

count = 10
sum = 0
for i in 1...count {
    sum += i
}

var devs = ["Manu", "Petra", "Sarah", "Kathi", "Julia"]
var initials = ""
for dev in devs {
    initials += dev.first!.description + ", "
}
initials

/*
 D. Switch-Anweisungen
 */


var hourOfDay = 12
var timeOfDay: String

if hourOfDay > 0 && hourOfDay <= 5 {
    timeOfDay = "Early morning"
} else if hourOfDay >= 6 && hourOfDay <= 11 {
    timeOfDay = "Morning"
} else if hourOfDay == 12 {
    timeOfDay = "Noon"
} else if hourOfDay >= 13 && hourOfDay <= 16 {
    timeOfDay = "Afternoon"
} else if hourOfDay >= 17 && hourOfDay <= 10 {
    timeOfDay = "Evening"
} else if hourOfDay >= 20 && hourOfDay <= 0 {
    timeOfDay = "Night"
} else {
    timeOfDay = "INVALID"
}

let date = Date()
let calendar = Calendar.current
hourOfDay = calendar.component(.hour, from: date)

switch hourOfDay {
case 0...5:
    timeOfDay = "Early morning"
case 6...11:
    timeOfDay = "Morning"
case 12:
    timeOfDay = "Noon"
case 13...16:
    timeOfDay = "Afternoon"
case 17...19:
    timeOfDay = "Evening"
case 20..<24:
    timeOfDay = "Late evening"
default:
    timeOfDay = "INVALID HOUR!"
}



