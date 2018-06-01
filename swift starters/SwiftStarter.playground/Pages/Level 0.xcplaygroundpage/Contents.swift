import Foundation

/*:
 # Level 0 - The eager Noob
 
 Die wichtigen Dinge zuerst! Bevor wir losstarten mit der ARKit Programmierung, holen wir uns erst ein paar Coding-Werkzeuge
 
 * callout(Level 0 - The eager Noob):
 In diesem Level beschäftigen wir uns mit den ersten Grundlagen von Swift. Wir sehen uns folgende Themenbereiche etwas näher an:
   - A. Zahlen und Operationen
   - B. Mathematische Funktionen
   - C. Konstanten und Variablen
   - D. Namenskonvention
   - E. Inkrement und Dekrement
 
 Dann lasst uns loslegen und keine Zeit mehr verlieren :)
 */

/*
 A. Zahlen und Operationen
 */

//Achtung vor Blanks!
2+6
2 + 6
//2+ 6
//2 +6
2 * 6
6 / 2

//Gleitkommazahlen
2.6 * 6.2
6.2 / 2.6

//Modulo-Funktion
11 % 2

//Reihenfolge beachten!
(2 + 6) * 3 + 4
(2 + 6) * (3 + 4)

/*
 B. Zahlen und Operationen
 */

Double.pi
Double.pi * 10

sqrt(Double.pi)
min(Double.pi, sqrt(Double.pi))
max(Double.pi, sqrt(Double.pi))

/*
 C. Konstanten und Variablen
 */

let pi = Double.pi
pi
pi * 2
//pi = 10

var mutablePi = Double.pi
mutablePi
mutablePi * 2
mutablePi = 10

var index : Int = 0
index = 3
index = 2_000_000

/*
 D. Namenskonventionen
 */

var age : Int = 35
var personAge = 35
var address1 = "Münchenstr. 64"
var personAddress = "Münchenstr. 64"

/*
 E. Inkrement und Dekrement
 */

var myIndex = 0
myIndex = myIndex + 1
myIndex = myIndex - 1

//einfache Kurzvarianten
myIndex += 3
myIndex -= 5
myIndex /= 2
myIndex *= -10

/*:
 * callout(Nun noch ne Übunge gefällig?):
 Falls du noch Zeit und Lust hast, schau dir die Übungsaufgaben unter folgender URL in der Section "Challenges" an. Sie sind kurz und knackig und helfen enorm, um das grade eben Gehörte gut zu verankern :)
 
     [Ray Wenderlich - Swift Tutorial Part 1](https://www.raywenderlich.com/143771/swift-tutorial-part-1-expressions-variables-constants)
 */








