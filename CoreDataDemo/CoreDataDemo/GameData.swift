//
//  GameData.swift
//  CoreDataDemo
//
//  Created by Sujatha Nagarajan on 2/1/17.
//  Copyright © 2017 Sujatha. All rights reserved.
//

import Foundation
import CoreData

class PlayerGameData
{
	var playername : String?
	var highScore : Int32 = 0;
	
	init(_ score : Int32, name : String)
	{
		playername = name
		highScore = score
	}
}

//this is the data model for the table view
class GameData : NSObject
{
	var playerData = [NSManagedObject]()
	var score : Int32 = 0;
	var currentPlayerName : String = ""
	var highScore : Int32 = 0;
	
	
}
//NScoding data
/*
class GameData : NSObject, NSCoding
{
	var score : Int32 = 0;
	var missed : Int32 = 0;
	var savefilename : String = "";
	var playerData = [PlayerGameData]()
	var currentPlayerName : String = ""
	func encode(with aCoder: NSCoder) {
		
		aCoder.encode(self.score, forKey: "highScore")
		aCoder.encode(self.currentPlayerName, forKey: "name")
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		self.init(); //because this class extends NSObject, calling init here is fine.
		let highScore = aDecoder.decodeInt32(forKey: "highScore")
		if let playername = aDecoder.decodeObject(forKey: "name") as? String{
			self.playerData.append(PlayerGameData(highScore, name: playername))
		}
	}
	
	
}
*/
