import Foundation
import CoreData

final class FetchResults {
    
    private var context: NSManagedObjectContext {
        
       return CoreDataContainer.persistentContainer.viewContext
     }

    private var fetchedResultsController: NSFetchedResultsController<Repository>?
    
    private var fetchedQueryController: NSFetchedResultsController<Query>?

    public func configureFethedResultController() {
        
        let fetchRequest = NSFetchRequest<Repository>(entityName: "Repository")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "searchWord", ascending: true)
        ]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil,cacheName: nil)
        
        do {
            
            try fetchedResultsController?.performFetch()
            
        } catch {
            
            print("Error in fetching with fetched result controller - \(error)")
        }
    }
    
    public func configureFetchedQueryController() {
        
        let fetchRequest = NSFetchRequest<Query>(entityName: "Query")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "searchWord", ascending: true)
        ]
        
        fetchedQueryController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil,cacheName: nil)
        
        do {
            
            try fetchedQueryController?.performFetch()
            
        } catch {
            
            print("Error in fetching with fetched result controller - \(error)")
        }
    }
    
    public func getFetchedData(_ searchWord: String) -> [Post] {
        
        var storedPosts: [Post] = []
        
        if let fetchedObjects = fetchedResultsController?.fetchedObjects {
            
            for i in 0...fetchedObjects.count - 1 {
                
                let post = Post()
                
                let object: Repository? = fetchedObjects[i]
                
                if object?.searchWord == searchWord {
                    
                    post.title = object?.postTitle
                    post.description = object?.postDescription
                    post.raiting = Int((object?.postRaiting!)!)
                    post.imageUrl = object?.postImageUrl
                    post.urlToOpen = object?.postUrl
                    storedPosts.append(post)
                }
            }
        }
        
        return storedPosts
    }
    
    public func getSearchWords() -> [String] {
        
        var searchWords: [String] = []
        
        if let fetchedObjects = fetchedQueryController?.fetchedObjects {
            
            if !fetchedObjects.isEmpty {
                
                for i in 0...fetchedObjects.count - 1 {
                    
                    let object: Query = fetchedObjects[i]
                    searchWords.append(object.searchWord!)
                }
                
                searchWords = searchWords.reduce([], { $0.contains($1) ? $0 : $0 + [$1]})
            }
        }
        
        return searchWords
    }
}


