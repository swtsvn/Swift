//
//  ScoreBoardViewController.swift
//  CoreDataDemo
//
//  Created by Sujatha Nagarajan on 2/3/17.
//  Copyright © 2017 Sujatha. All rights reserved.
//

import Foundation
import Cocoa


class ScoreBoardViewController : NSViewController, NSTableViewDataSource, NSTableViewDelegate{
	@IBOutlet weak var tableView: NSScrollView!
	let appdelegate = NSApplication.shared().delegate as! AppDelegate
	override func viewDidLoad() {
		super.viewDidLoad()
		let tv = tableView.documentView as! NSTableView
		tv.delegate = self
		tv.dataSource = self
	//	tv.addTableColumn(NSTableColumn(identifier: "playerNameColumn"))
		
	}
	
	//informs how many rows the table will have. 
	func numberOfRows(in tableView: NSTableView) -> Int {
		return appdelegate.data.playerData.count
	}
	
	//tell view to display for a specific cell and column
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
			let s = NSTableCellView();
			s.objectValue = "empty"
			return s
		}
	

}
