//
//  PlayerDetailswindow.swift
//  CoreDataDemo
//
//  Created by Sujatha Nagarajan on 2/1/17.
//  Copyright © 2017 Sujatha. All rights reserved.
//

import Cocoa

class PlayerDataViewController: NSViewController {
	
	lazy var GameVC : GameMenuController = { return self.storyboard!.instantiateController(withIdentifier: "GameMenuControllerID") as! GameMenuController }()
	//lazy var to delay loading of the view controller
	
	lazy var errorVC : NSViewController = { return self.storyboard!.instantiateController(withIdentifier: "EnterPlayerDataControllerID") as! NSViewController }()
	
	//error window
	@IBAction func EnterPlayerDataButton(_ sender: NSButton) {
		self.dismiss(nil)
	}
		
	@IBOutlet var PlayerNameText: NSTextField!

	@IBAction func PlayerDataPlayButtonClick(_ sender: NSButton) {
		let app = NSApplication.shared().delegate as! AppDelegate
		app.data.currentPlayerName = PlayerNameText.stringValue
		app.data.highScore = 0
		if(PlayerNameText.stringValue == "")
		{
			//error window
			self.presentViewControllerAsModalWindow(errorVC)	
		}
		else
		{
			//save player name to Persistent Store
			let CoreDataEntity = NSEntityDescription.entity(forEntityName: "Player", in: app.managedObjectContext)
			var found : Bool = false;
			for player in app.data.playerData{
				let name = player.value(forKey: "name") as! String
				if(name == PlayerNameText.stringValue)
				{
					//avoid duplicate entry
					found = true;
					app.data.highScore = player.value(forKey: "highscore") as! Int32
				}
			}
			if !found {
				let row = NSManagedObject(entity: CoreDataEntity!, insertInto: app.managedObjectContext)
				row.setValue(PlayerNameText.stringValue, forKey: "name")
				row.setValue(0, forKey: "highscore")
			
				do{
					try app.managedObjectContext.save()
					app.data.playerData.append(row);
							
				}
				catch let error as NSError {
					print(error)
				}
			}
			

			//save player to array
			self.presentViewControllerAsSheet(GameVC)	
		}
		
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		
	}

}
