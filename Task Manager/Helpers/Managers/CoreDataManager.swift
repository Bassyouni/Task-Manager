//
//  CoreDataManager.swift
//  Task Manager
//
//  Created by Bassyouni on 5/25/19.
//  Copyright © 2019 Bassyouni. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    
    static let shared = CoreDataManager()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    var managedContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveContext(completion: ((_ success: Bool) -> ())?) {
        do
        {
            try managedContext.save()
            completion?(true)
        }
        catch
        {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion?(false)
        }
    }
    
    func fetchModels<T: NSFetchRequestResult>(entityType: T.Type) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        
        do
        {
            return try managedContext.fetch(fetchRequest)
        }
        catch
        {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteAllData(_ entity:String) {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(batchDeleteRequest)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteObject(_ object: NSManagedObject, completion: ((_ success: Bool) -> ())? ) {
        managedContext.delete(object)
        saveContext(completion: completion)
    }
    
}
