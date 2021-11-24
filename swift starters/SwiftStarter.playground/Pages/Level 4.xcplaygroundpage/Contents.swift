import Foundation


/*:
 # Level 4 - The Real-Pro
 
 Wie wird nun Code zusammgefasst und schlau wiederverwendet? Und wie kann man bestehenden Code nach eigenen Bedürfnissen erweitern?
 All das lernen wir nun hier mit Klassen, Strukturen und Extensions
 
 * callout(Level 4 - The Real Pro):
   - A. Vererbung
   - B. Klassen und Structs
   - C. Extensions
 
 Dann lasst uns loslegen und keine Zeit mehr verlieren :)
 */


/*
 A. Vererbung
 
 ... ist das Konzept der kontextuellen Erweiterung von Daten um Felder, Funktionen und Logiken.
 Zu abstrakt? Dann kommt hier gleich mal ein Beispiel zur Klärung :D
 */

class MyAnimal {
    var category : String
    var name : String
    var numberOfLegs : Int
    
    init(category animalCategory: String, name animalName: String, numberOfLegs nol: Int) {
        category = animalCategory
        name = animalName
        numberOfLegs = nol
    }
    
    func describe () -> String {
        return "Der \(name) gehört zur Kategorie der \(category)(e) und bewegt sich auf \(numberOfLegs) Beinen."
    }
}

class MyPetAnimal : MyAnimal {
    var favoriteToy : String?
    
    override func describe() -> String {
        var text = super.describe()
        
        if let toy = favoriteToy {
            text += " Und spielt am liebsten mit \(toy)."
        }
        
        return text
    }
}

let theDog = MyPetAnimal(category: "Säugetier", name: "Pudel", numberOfLegs: 4)
theDog.favoriteToy = "Quietscheball"
print(theDog.describe())

/*
 B. Klassen und Structs
 
 Sieht nahezu gleich aus, ist es aber nicht. Structs erlauben keine Vererbung, können jedoch durch Protokolle und Extensions erweitert werden.
 MERKE: IdR reichen Structs, um zusammenhängende Informationen zu beschreiben
 */


struct PetAnimals {
    var category : String
    var name : String
    var numberOfLegs : Int
    
    init(category animalCategory: String, name animalName: String, numberOfLegs nol: Int) {
        category = animalCategory
        name = animalName
        numberOfLegs = nol
    }
    
    func describe () -> String {
        return "Der \(name) gehört zur Kategorie der \(category)(e) und bewegt sich auf \(numberOfLegs) Beinen."
    }
}

extension PetAnimals {
    func describeEN () -> String {
        return "The \(name) belongs to the category \(category) and moves on \(numberOfLegs) legs."
    }
}

let cat = PetAnimals(category: "Säugetier", name: "Siamkatze", numberOfLegs: 4)
print(cat.describe())
print(cat.describeEN())

/*
 C. Extensions
 
 Um etwaige bestehende Funktionalität einer Klasse oder eines Structs zu erweitern, kann man dafür Extensions nutzen. Diese sind auch praktisch, um iOS eigene Objekte zu erweitern.
 */

import UIKit

extension UIColor {
    public class var favColor : UIColor { return UIColor.red } //computed property
    
    public class func myFavColor () -> UIColor {
        return UIColor.red
    }
    
    func makeItRed () -> UIColor {
        return UIColor.red
    }
}

UIColor.favColor
UIColor.myFavColor()

var myColor = UIColor.blue
myColor.makeItRed()

