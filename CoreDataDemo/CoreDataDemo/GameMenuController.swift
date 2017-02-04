//
//  GameMenuController.swift
//  CoreDataDemo
//
//  Created by Sujatha Nagarajan on 2/3/17.
//  Copyright © 2017 Sujatha. All rights reserved.
//

import Foundation
import Cocoa
class GameMenuController : NSViewController{
	
	lazy var GamePlayVC : ViewController = { return self.storyboard!.instantiateController(withIdentifier: "GameViewControllerID") as! ViewController }()
	//lazy var to delay loading of the view controller
	
	lazy var ScoreBoardVC : ScoreBoardViewController = { return self.storyboard!.instantiateController(withIdentifier: "ScoreBoardControllerID") as! ScoreBoardViewController }()
	//lazy var to delay loading of the view controller
	
	@IBAction func scoreBoardClick(_ sender: Any) {
		self.presentViewControllerAsSheet(ScoreBoardVC)
	}
	
		
	@IBAction func playButtonClick(_ sender: NSButton) {
		//show the game
		self.presentViewControllerAsSheet(GamePlayVC)
	}
}
