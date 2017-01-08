//
//  GameScene.swift
//  Vogel
//
//  Created by raman maharjan on 12/28/16.
//  Copyright © 2016 raman maharjan. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let bird1 : UInt32 = 0x1 << 1
    static let plane : UInt32 = 0x1 << 2
    static let plane2 : UInt32 = 0x1 << 3

}

class GameScene: SKScene {

    let wavea = SKSpriteNode(imageNamed: "wave2")
    let waveb = SKSpriteNode(imageNamed: "wave2")
    let wavec = SKSpriteNode(imageNamed: "wave2")
    let sun = SKSpriteNode(imageNamed: "sun")
    let bird1 = SKSpriteNode(imageNamed: "bird1")
    let bird2 = SKSpriteNode(imageNamed: "bird2")
    let cloud = SKSpriteNode(imageNamed: "Cloud")
    let InjuredBird = SKSpriteNode(imageNamed: "InjuredBird")
    let lightning = SKSpriteNode(imageNamed: "lightning")

    let ship = SKSpriteNode(imageNamed: "ship")
   // var moving = SKNode()
    var started = Bool()
    var gameOver = Bool()
    var moveAndRemove = SKAction()
    var jetpair = SKNode()
    var label = UILabel()
    var hideScore = false
    override func didMove(to view: SKView) {

        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -5.0 )
    
        backgroundColor = UIColor.init(red: 153/255, green: 204/255, blue: 1, alpha: 1.0)
        //add waves
        let waveSz = CGSize(width: wavea.size.width/2, height: wavea.size.height/2)
        wavea.scale(to: waveSz)
        wavea.position = CGPoint(x: (Int) (wavea.size.width/2)  , y: (Int) (wavea.size.height/3))
        addChild(wavea)
        waveb.scale(to: waveSz)
        waveb.position = CGPoint(x: (Int) (wavea.size.width/2) * 3  , y: (Int) (wavea.size.height/3))
        addChild(waveb)
        wavec.scale(to: waveSz)
        wavec.position = CGPoint(x: (Int) (wavea.size.width/2) * 5  , y: (Int) (wavea.size.height/3))
        addChild(wavec)

        //add sun
        let sunSz = CGSize(width: 50 , height: 50)
        sun.scale(to: sunSz)
        sun.position = CGPoint(x: size.width - sun.size.width - 5, y: size.height - sun.size.height)
         sun.physicsBody?.velocity = CGVector(dx: -20, dy: -100)
        addChild(sun)
        //add HighScore
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: self.size.width/2, y: self.size.height/5)
        label.textAlignment = .center
        label.text = "High Score: " + "0000"
        self.view?.addSubview(label)

        //add Bird
        let birdSz = CGSize(width: bird1.size.width/4, height: bird1.size.height/4)
        bird1.scale(to: birdSz)
        bird1.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bird1.physicsBody = SKPhysicsBody(circleOfRadius: bird1.size.height / 4.0)
        bird1.physicsBody?.isDynamic = true
        bird1.zPosition = 2
        bird1.physicsBody?.allowsRotation = false
        bird1.physicsBody?.affectedByGravity = false
        bird1.physicsBody?.categoryBitMask = PhysicsCategory.bird1
        bird1.physicsBody?.collisionBitMask = PhysicsCategory.plane
        bird1.physicsBody?.collisionBitMask = PhysicsCategory.plane2
        addChild(bird1)


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if started == false {
            started = true
            label.isHidden = true
            bird1.physicsBody?.affectedByGravity = true
            //creates a block
            let movingJet = SKAction.run({
                () in
                self.addjets()

            })
            let delay = SKAction.wait(forDuration: 2)   //interval between jets
            let addJetDelay = SKAction.sequence ([movingJet, delay])
            let addJetForever = SKAction.repeatForever(addJetDelay)
            self.run(addJetForever)
            let distance = CGFloat(self.frame.width + jetpair.frame.width )
            let movePlane = SKAction.moveBy(x: -distance , y:0, duration: TimeInterval(0.01 * distance ))
            let removePlane = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePlane, removePlane])
            bird1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))

        }else{
            bird1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))

        }

        if gameOver == true {
            print("game over")
        }

    }

    func addjets(){
        jetpair = SKNode()
        let plane = SKSpriteNode(imageNamed: "plane")
        let plane2 = SKSpriteNode(imageNamed: "plane2")
        let planeSz = CGSize(width: plane.size.width/4 , height: plane.size.height/4)
        plane.scale(to: planeSz)
        plane2.scale(to: planeSz)
        plane.position = CGPoint(x: self.size.width - plane.size.width/2 , y: self.size.height/2 + 100)

        plane2.position = CGPoint(x: self.size.width - plane.size.width/2 , y: self.size.height/2-50)
        plane.physicsBody = SKPhysicsBody(rectangleOf: planeSz)
        plane2.physicsBody = SKPhysicsBody(rectangleOf: planeSz)
        plane.physicsBody = SKPhysicsBody(circleOfRadius: plane.size.height / 6.0)
        plane2.physicsBody = SKPhysicsBody(circleOfRadius: plane2.size.height / 6.0)
        plane.physicsBody?.affectedByGravity = false
        plane2.physicsBody?.affectedByGravity = false
        plane.physicsBody?.isDynamic = true
        plane2.physicsBody?.isDynamic = true
        plane.zPosition = -1
        plane2.zPosition = -1
        jetpair.addChild(plane)
        jetpair.addChild(plane2)
        jetpair.run(moveAndRemove)
        self.addChild(jetpair)

    }

}




// background red
class GameScene2: SKScene{
    override func didMove(to view: SKView) {
        //red background
          backgroundColor = UIColor.init(red: 1, green: 0, blue: 0.0, alpha: 1.0)
        }

}
class GameScene3: SKScene{
    override func didMove(to view: UIView) {
        //red background
        backgroundColor = UIColor.init(red: 1, green: 0, blue: 0.0, alpha: 1.0)
    }

}
