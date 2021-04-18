import Foundation


/*:
 # Level 5 - The Bonus
 
 Oben drauf gibt es nun etwas Zucker. Zum einen sehen wir uns an, was Optionals sind, wie sie funktionieren, aber vor allem wie sie unseren Code sicherer gestalten.
 
 In dem Zuge werfen wir auch gleich ein Auge auf Typinferenz - ein Feature, dass eins der grundlegenden Basiskonzepte von Swift ist. Typen werden implizit eruiert und nur wenn es kein eindeutiges Ergebnis gibt, muss man selbst Typen nennen.
 
 Und zu guter Letzt sehen wir uns an, wie man Fehler werfen kann, diese selbst definiert und auch im Programm darauf reagieren kann - sogar mit Optionals.
 
 * callout(Level 5 - The Bonus):
 - A. Optionals
 - B. Nebenschauplatz Typinferenz
 - C. Error Handling
 */


/*
 A. Optionals ?!
 
 In Swift sind Optionals ein tolles Werkzeug, um sicher mit etwaig leeren Werten umzugehen.
 Grundsätzlich gibt es Swift keine leeren Werte - Variablen und Konstanten werden per se als initialisiert und mit einem Wert belegt angenommen. Da dies aber nicht immer praktikabel und umsetzbar ist, wurden Optionals ins Leben gerufen
 */


/*
 
 public enum ImplicitlyUnwrappedOptional<Wrapped> : ExpressibleByNilLiteral {
 
         /// The absence of a value. Typically written using the nil literal, `nil`.
         case none
 
         /// The presence of a value, stored as `Wrapped`.
         case some(Wrapped)
 
         /// Creates an instance that stores the given value.
         public init(_ some: Wrapped)
 
         /// Creates an instance initialized with `nil`.
         ///
         /// Do not call this initializer directly. It is used by the compiler when
         /// you initialize an `Optional` instance with a `nil` literal. For example:
         /// let i: Index! = nil
         public init(nilLiteral: ())
 }
 
 */

// Definition eines Optionals
var userFirstName = ""          // Wert darf nicht leer == nil sein
var userMiddleName : String?    // Wert darf auch leer sein
//var userMiddleName : Optional<String>
var userLastName = ""           // Wert darf nicht leer == nil sein

//userFirstName = nil
userMiddleName = nil
userMiddleName = Optional.some("Sylvia")
userMiddleName = "Sylvia"

print(userMiddleName)
print(userMiddleName!)

userMiddleName = ""

//print(userMiddleName!)

// Optional binding via conditional unwrapping
if let middleName = userMiddleName {
    print(middleName)
} else {
    print("no value set to middleName")
}


/* Definition eines implizit unwrapped Optionals - also definitiv vorhandener Wert. Mit $Typ! gibt man dem Compiler Bescheid, dass sichergestellt ist, dass dieser Wert immer belegt sein wird. Ist das nicht der Fall, kommt es zu einem Laufzeitfehler. Kann wie ein Optional behandelt werden aber gleichzeitig auch wie ein normaler Wert.
 
 Wozu verwendet? Hauptsächlich während Klassen/Struct Initialisierung - Variable wird erst auf einen Typ festgelegt, aber Wert wird erst frühestens via Konstruktor zugewiesen. */

var userSecondMiddleName : String!

print(userSecondMiddleName) // <-- kein Rufzeichen notwendig

if let secondMiddleName = userSecondMiddleName {
    print(secondMiddleName)
} else {
    print("no value for secondMiddleName")
}





/*
 B. Typinferenz
 */

var measure : Float = 24.1
var angle = 23.5
//var calcVal = measure + angle
var calcVal = measure + Float(angle)


var age = 50
//age = 50 + 2.0
age = 50 + Int(2.0)



let name = "Mayer"
let first = "Max"

var persons : [String : String] = [:]

persons[name] = first

persons.forEach { (key, val) in
    print("person -> \(key), \(val)")
}


//var otherPersons = ["name" : "Mayer"]
//otherPersons[1] = "Mueller"



/*
 C. Error Handling
 */

enum CalculationError: Error {
    case angleError(String)
}

func calculateAdjustmentofAngle(_ angle: Float) throws -> Float  {
    if angle < 0 {
        throw CalculationError.angleError("value way too small")
    }
    
    return angle
}

do {
    try calculateAdjustmentofAngle(5)
} catch CalculationError.angleError(let errorMessage) {
    print(errorMessage)
} catch {
    print("unknown error occured")
}

// will man im Falle eines Fehlers auf keine Details reagieren, kann man das Ergebnis einfach in ein Optional konvertieren. Im positiven Fall landet das Ergebnis in dem Optional, im Negativfall bleibt das Optional leer
let success = try? calculateAdjustmentofAngle(-9)

if let hadSuccess = success {
    print(hadSuccess)
} else {
    print("something went wrong with the calulcation of angles")
}

if let success = try? calculateAdjustmentofAngle(-9) {
    print(success)
} else {
    print("something went wrong with the calulcation of angles")
}
