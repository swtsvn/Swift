//
//  GameScene.swift
//  CoreDataDemo
//
//  Created by Sujatha Nagarajan on 2/1/17.
//  Copyright © 2017 Sujatha. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
	private var scoreLabel : SKLabelNode?
	private var highScoreLabel : SKLabelNode?
	private var missedLabel : SKLabelNode?
	private var bgPlayer : AVAudioPlayer?	
	private var selectPlayer : AVAudioPlayer?
	let snowCategory : UInt32 = 0x1
	let spinnyCategory : UInt32 = 0x1 << 1
	var savefilename : String = ""
	var data = GameData()
	
	override func didMove(to view: SKView) {
		load()
	}
    override func sceneDidLoad() {
	}
	
	func load(){
        
	    self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//CoreDataDemo") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
		self.scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
		self.highScoreLabel = self.childNode(withName: "//highScoreLabel") as? SKLabelNode
		self.missedLabel = self.childNode(withName: "//missedLabel") as? SKLabelNode
		
		
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
			spinnyNode.setScale(0.5)
		    
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 0.5)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.1),
                                              SKAction.fadeOut(withDuration: 0.1),
                                              SKAction.removeFromParent()]))
			spinnyNode.physicsBody = SKPhysicsBody(rectangleOf: spinnyNode.frame.size)
			spinnyNode.physicsBody?.isDynamic = true;
			spinnyNode.physicsBody?.categoryBitMask = spinnyCategory
			spinnyNode.physicsBody?.collisionBitMask = snowCategory
			spinnyNode.physicsBody?.contactTestBitMask = snowCategory
        }
		
		self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.0001)
		self.physicsWorld.contactDelegate = self;
		
		do{
			if let bg = NSDataAsset(name: "bgmusic"){
				bgPlayer = try AVAudioPlayer(data: bg.data)
				bgPlayer!.volume = 0.1
				bgPlayer!.play()
				bgPlayer!.delegate = self
			}
		}
		catch let error as NSError {
			print(error)
		}
		
		loadNSCodingData()
		
		self.scoreLabel?.text = "Score: " + String(data.score);
		self.highScoreLabel?.text = "High Score: " + String(data.highScore);
		self.missedLabel?.text = "Missed: " + String(data.missed);
	}
	
	func saveNSCodingData()
	{
		if(NSKeyedArchiver.archiveRootObject(self.data, toFile: self.savefilename))
		{
			print("successfully written NSCoding save data")
		}
	}
	
	func loadNSCodingData()
	{
		self.savefilename = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/CoreDataDemo/coreDataDemosave.txt"
	
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
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		bgPlayer!.play();
	}
	
    
    func playSelectAnimation(_ snow : SKPhysicsBody, spinny: SKPhysicsBody){
		 if let sn = snow.node as! SKShapeNode! {
			sn.fillColor = NSColor.brown
			sn.strokeColor = NSColor.brown
			sn.alpha = 1
			sn.physicsBody!.isDynamic = false;
			sn.removeAllActions();
			sn.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.1),
										SKAction.removeFromParent()]))	
												
		}
		 if let sp = spinny.node as! SKShapeNode! {
			sp.strokeColor = NSColor.green
			sp.removeAllActions();
			sp.physicsBody!.isDynamic = false;
			sp.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.1),
										SKAction.removeFromParent()]))			
		}
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		if(contact.bodyA.categoryBitMask & spinnyCategory != 0)
		{
			if(contact.bodyB.categoryBitMask & snowCategory != 0)
			{
				data.score += 1
				playSelectSound()
				playSelectAnimation(contact.bodyB, spinny: contact.bodyA)
			}
		}
		if(contact.bodyA.categoryBitMask & snowCategory != 0)
		{
			if(contact.bodyB.categoryBitMask & spinnyCategory != 0)
			{
				data.score += 1
				playSelectSound()
				playSelectAnimation(contact.bodyA, spinny: contact.bodyB)
			}
		}

	}
	
	func playSelectSound()
	{
		do{
			if let select = NSDataAsset(name: "Ping") {
				let selectPlayer = try AVAudioPlayer(data: select.data)
				selectPlayer.volume = 2
				selectPlayer.play()
			}
		}
		catch let error as NSError {
			print(error)
		}
	}
    func touchDown(atPoint pos : CGPoint) {
    
    }
    
    func touchMoved(toPoint pos : CGPoint) {
     
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
			self.addChild(n)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
      /*  switch event.keyCode {
        case 0x31:
            if let label = self.label {
                label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
		*/
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
		
		
		self.scoreLabel?.text = "Score: " + String(data.score);
		self.highScoreLabel?.text = "High Score: " + String(data.highScore);
		self.missedLabel?.text = "Missed: " + String(data.missed);
		
		
		if self.children.count < 10 , let snow = SKShapeNode.init(circleOfRadius: 2) as SKShapeNode?{
			snow.lineWidth = 0.5
			snow.setScale(2.5)
			snow.fillColor = NSColor.white
	        
            snow.run(SKAction.repeatForever(SKAction.scale(by: 2.0, duration: 1)))
		    snow.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
			snow.physicsBody = SKPhysicsBody(circleOfRadius: snow.frame.size.width/2)
			snow.physicsBody!.isDynamic = false;
			snow.physicsBody?.categoryBitMask = snowCategory
			snow.physicsBody?.collisionBitMask = spinnyCategory
			snow.physicsBody?.contactTestBitMask = spinnyCategory
			snow.position = CGPoint(x: Int(arc4random_uniform(2000)), y: Int(arc4random_uniform(100)) + 10)
			self.addChild(snow)
        }
		if(self.children.count >= 11)
		{
			saveNSCodingData();
		}

    }
}
