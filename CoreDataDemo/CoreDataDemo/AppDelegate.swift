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
	
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
		
		loadNSCodingData()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
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
	

    
}
