import UIKit
import CoreData

final class Database {
    
    private var context: NSManagedObjectContext {
        
        return CoreDataContainer.persistentContainer.viewContext
    }
    
    public func save() {
        
        CoreDataContainer.saveContext()
    }
    
    public func writeToDatabase(bankTitle: String, bankCity: String, bankPhoneNumber: String, bankRegion: String, bankAdress: String) {
        
        if let objectDescription = NSEntityDescription.entity(forEntityName: "Banks", in: context) {
            
            let object = NSManagedObject(entity: objectDescription, insertInto: context)
            
            object.setValue(bankTitle, forKey: "bankTitle")
            object.setValue(bankCity, forKey: "bankCity")
            object.setValue(bankPhoneNumber, forKey: "bankPhoneNumber")
            object.setValue(bankRegion, forKey: "bankRegion")
            object.setValue(bankAdress, forKey: "bankAdress")
        }
    }
}
