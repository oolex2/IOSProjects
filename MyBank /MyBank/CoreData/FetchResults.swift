import Foundation
import CoreData

final class FetchResults {
    
    private var context: NSManagedObjectContext {
        
        return CoreDataContainer.persistentContainer.viewContext
    }
    
    private var fetchedResultsController: NSFetchedResultsController<Banks>?
    
    public func configureFethedResultController() {
        
        let fetchRequest = NSFetchRequest<Banks>(entityName: "Banks")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "bankTitle", ascending: true)
        ]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil,cacheName: nil)
        
        do {
            
            try fetchedResultsController?.performFetch()
            
        } catch {
            
            print("Error in fetching with fetched result controller - \(error)")
        }
    }
    
    public func getFetchedData() -> [MainData] {
        
        var storedBanks: [MainData] = []
        
        if let fetchedObjects = fetchedResultsController?.fetchedObjects {
            
            var index = 0
            
            if fetchedObjects.count > 29 {
                
                index = fetchedObjects.count - 28
            }
            
            if !fetchedObjects.isEmpty {
                
                for i in index...fetchedObjects.count - 1 {
                    
                    let bank = MainData()
                    
                    let object: Banks? = fetchedObjects[i]
                    
                    bank.title = object?.bankTitle
                    bank.city = object?.bankCity
                    bank.region = object?.bankRegion
                    bank.phoneNumber = object?.bankPhoneNumber
                    bank.addres = object?.bankAdress
                    
                    storedBanks.append(bank)
                }
            }
            
            if fetchedObjects.count > 100 {
                
                deleteData()
            }
        }
        
        return storedBanks
    }
    
    private func deleteData() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Banks")
        fetchRequest.includesPropertyValues = false
        
        do {
            
            let items = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            for i in 0...100 {
                
                context.delete(items[i])
            }
            
            try context.save()
            
        } catch {
            
            print(error)
        }
    }
}


