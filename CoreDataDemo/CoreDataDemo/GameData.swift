//
//  GameData.swift
//  CoreDataDemo
//
//  Created by Sujatha Nagarajan on 2/1/17.
//  Copyright © 2017 Sujatha. All rights reserved.
//

import Foundation

class GameData : NSObject, NSCoding
{
	var score : Int32 = 0;
	var highScore : Int32 = 0;
	var missed : Int32 = 0;
	var savefilename : String = "";
	var playername : String?
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(self.score, forKey: "highScore")
		aCoder.encode(self.playername, forKey: "name")
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		self.init(); //because this class extends NSObject, calling init here is fine.
		self.highScore = aDecoder.decodeInt32(forKey: "highScore")
		self.playername = (aDecoder.decodeObject(forKey: "name") as? String?)!
	}
	
	
}
