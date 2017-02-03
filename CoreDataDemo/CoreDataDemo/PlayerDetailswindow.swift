//
//  PlayerDetailswindow.swift
//  CoreDataDemo
//
//  Created by Sujatha Nagarajan on 2/1/17.
//  Copyright © 2017 Sujatha. All rights reserved.
//

import Cocoa

class PlayerDataViewController: NSViewController {
	
	lazy var GameVC : ViewController = { return self.storyboard!.instantiateController(withIdentifier: "GameViewControllerID") as! ViewController }()
	//lazy var to delay loading of the view controller
	
	lazy var errorVC : NSViewController = { return self.storyboard!.instantiateController(withIdentifier: "EnterPlayerDataControllerID") as! NSViewController }()
	
	//error window
	@IBAction func EnterPlayerDataButton(_ sender: NSButton) {
		self.dismiss(nil)
	}
		
	@IBOutlet var PlayerNameText: NSTextField!

	@IBAction func PlayerDataPlayButtonClick(_ sender: NSButton) {
		
		if(PlayerNameText.stringValue == "")
		{
			//error window
			self.presentViewControllerAsModalWindow(errorVC)	
		}
		else
		{
			//save player name.
			let app = NSApplication.shared().delegate as! AppDelegate
			app.data.playername = PlayerNameText.stringValue
			self.presentViewControllerAsSheet(GameVC)	
		}
		
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		
	}

}
