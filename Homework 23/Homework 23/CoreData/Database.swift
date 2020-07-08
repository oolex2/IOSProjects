import UIKit
import CoreData

final class Database {
    
    private var context: NSManagedObjectContext {
        
        return CoreDataContainer.persistentContainer.viewContext
    }
    
    public func save() {
        
        CoreDataContainer.saveContext()
    }
    
    public func writeToDatabase(postTitle: String, postDescription: String, postRaiting: Int, postImageUrl: String, postUrl: String, searchWord: String) {
        
        if let firstObjectDescription = NSEntityDescription.entity(forEntityName: "Repository", in: context) {
            
            let object = NSManagedObject(entity: firstObjectDescription, insertInto: context)
            object.setValue(postTitle, forKey: "postTitle")
            object.setValue(postDescription, forKey: "postDescription")
            object.setValue(String(postRaiting), forKey: "postRaiting")
            object.setValue(postImageUrl, forKey: "postImageUrl")
            object.setValue(postUrl, forKey: "postUrl")
            object.setValue(searchWord, forKey: "searchWord")
        }
        
        if let secondObjectDescription = NSEntityDescription.entity(forEntityName: "Query", in: context) {
            
            let object = NSManagedObject(entity: secondObjectDescription, insertInto: context)
            object.setValue(searchWord, forKey: "searchWord")
        }
    }

    public func fetchObjectWithPredefinedPredicate(_ message : String) -> Bool {
        
        var finalResult = false
         let fetchRequest: NSFetchRequest<NSManagedObject>? = CoreDataContainer.persistentContainer.managedObjectModel.fetchRequestFromTemplate(withName: "FetchRequest", substitutionVariables: [
             "WORD" : message
             ]) as? NSFetchRequest<NSManagedObject>
        
        if  let currentFetchRequest = fetchRequest {
        
        do {
            
            let result = try context.fetch(currentFetchRequest) as [NSManagedObject]
            
            if result.isEmpty {
                
                finalResult = false
                
            } else {
                
                finalResult = true
            }
            
        } catch {
            
            print("Error while fetch - \(error)")
        }
    }
        
        return finalResult
    }
}
