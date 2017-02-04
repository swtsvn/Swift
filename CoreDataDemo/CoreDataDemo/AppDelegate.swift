//
//  AppDelegate.swift
//  CoreDataDemo
//
//  Created by Sujatha Nagarajan on 2/1/17.
//  Copyright © 2017 Sujatha. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var data = GameData()
	var savefilename : String = ""
	
	lazy var persistentContainer: NSPersistentContainer = {

    let container = NSPersistentContainer(name: "you_model_file_name")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error {

            fatalError("Unresolved error \(error)")
        }
    })
    return container
}()

	lazy var managedObjectContext: NSManagedObjectContext = {
	    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
	    let coordinator = self.persistentStoreCoordinator
	    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
	    managedObjectContext.persistentStoreCoordinator = coordinator
	    return managedObjectContext
	}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
	    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.) This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
	    let fileManager = FileManager.default
	    var failError: NSError? = nil
	    var shouldFail = false
	    var failureReason = "There was an error creating or loading the application's saved data."

	    // Make sure the application files directory is there
	    do {
	        let properties = try self.applicationDocumentsDirectory.resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
	        if !properties.isDirectory! {
	            failureReason = "Expected a folder to store application data, found a file \(self.applicationDocumentsDirectory.path)."
	            shouldFail = true
	        }
	    } catch  {
	        let nserror = error as NSError
	        if nserror.code == NSFileReadNoSuchFileError {
	            do {
	                try fileManager.createDirectory(atPath: self.applicationDocumentsDirectory.path, withIntermediateDirectories: true, attributes: nil)
	            } catch {
	                failError = nserror
	            }
	        } else {
	            failError = nserror
	        }
	    }
		    
	    // Create the coordinator and store
	    var coordinator: NSPersistentStoreCoordinator? = nil
	    if failError == nil {
	        coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
	        let url = self.applicationDocumentsDirectory.appendingPathComponent("test.storedata")
	        do {
	            try coordinator!.addPersistentStore(ofType: NSXMLStoreType, configurationName: nil, at: url, options: nil)
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	             
	            /*
	             Typical reasons for an error here include:
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            failError = error as NSError
	        }
	    }
	    
	    if shouldFail || (failError != nil) {
	        // Report any error we got.
	        if let error = failError {
	            NSApplication.shared().presentError(error)
	            fatalError("Unresolved error: \(error), \(error.userInfo)")
	        }
	        fatalError("Unsresolved error: \(failureReason)")
	    } else {
	        return coordinator!
	    }
	}()
	
	lazy var applicationDocumentsDirectory: Foundation.URL = {
	    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.apple.toolsQA.CocoaApp_CD" in the user's Application Support directory.
	    let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
	    let appSupportURL = urls[urls.count - 1]
	    return appSupportURL.appendingPathComponent("com.apple.toolsQA.CocoaApp_CD")
	}()

	lazy var managedObjectModel: NSManagedObjectModel = {
	    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
	    let modelURL = Bundle.main.url(forResource: "ScoreBoard", withExtension: "momd")!
	    return NSManagedObjectModel(contentsOf: modelURL)!
	}()


	    

    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    /*
	func loadNSCodingData()
	{
		self.savefilename = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/coreDataDemosave.txt"
	
		do
		{
			if let decodedData = NSData(contentsOfFile: self.savefilename){
				self.data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedData) as! GameData
			}
		}
		catch let error as NSError{
			print(error);
		}
			
	}
	
	func saveNSCodingData()
	{
		if(NSKeyedArchiver.archiveRootObject(self.data, toFile: self.savefilename))
		{
			print("successfully written NSCoding save data")
		}
	}
	*/
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
		do{
			let results = try self.managedObjectContext.fetch(fetchRequest)
			
			data.playerData = results as! [NSManagedObject]
			}
			catch let error as NSError{
				print(error)
			}
	}


	func saveData() {
	
		// Insert code here to initialize your application
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
		var found : Bool = false
		do{
			let results = try self.managedObjectContext.fetch(fetchRequest)
			let players = results as! [NSManagedObject]
			for r in players{
				let name = r.value(forKey: "name") as! String
				if(name == self.data.currentPlayerName)
				{
					//avoid duplicate entry
					found = true
					r.setValue(self.data.score, forKey: "highscore")
					break;
				}
			}
		}
		catch let error as NSError{
				print(error)
		}
		let app = NSApplication.shared().delegate as! AppDelegate
			
		if(!found)
		{
			
			let CoreDataEntity = NSEntityDescription.entity(forEntityName: "Player", in: app.managedObjectContext)
			let row = NSManagedObject(entity: CoreDataEntity!, insertInto: app.managedObjectContext)
		
			row.setValue(self.data.currentPlayerName, forKey: "name")
			row.setValue(self.data.score, forKey: "highscore")
			
		}
		
		do{
				try app.managedObjectContext.save()
			}
			catch let error as NSError {
				print(error)
			}

	}


    
}
