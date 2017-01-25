//
//  GameScene.swift
//  Vogel
//
//  Created by raman maharjan on 12/28/16.
//  Copyright © 2016 raman maharjan. All rights reserved.
//

import SpriteKit
import GameplayKit
import Darwin
import AVFoundation

struct PhysicsCategory {
    static let bird : UInt32 = 0x1 << 1
    static let plane : UInt32 = 0x1 << 2
    static let plane2 : UInt32 = 0x1 << 3
    static let ship : UInt32 = 0x1 << 4
    static let cloud : UInt32 = 0x1 << 5
    static let shark : UInt32 = 0x1 << 6
    static let lightning : UInt32 = 0x1 << 7
    static let InjuredBird : UInt32 = 0x1 << 8
}

class GameScene: SKScene, SKPhysicsContactDelegate  {

    var bird2 = SKSpriteNode()
    var bird1 = SKSpriteNode()
    var bird = SKSpriteNode()
    var started = Bool()
    var gameOver = Bool()
    var pause1 = Bool()
    var pause2 = Bool()
    var birdHitCloud = Bool()
    var birdHitWave = Bool()
    var moveAndRemove = SKAction()
    var moveAndRemoveCloud = SKAction()
    var moveAndRemoveShip = SKAction()
    var jetpair = SKNode()
    var cloudNode = SKNode()
    var labelHiScore = UILabel()
    var labelScore = UILabel()
    var taptoStart = UILabel()
    var shipNode = SKNode()
    var finalScoreInt = Int()
    var count = Int()
    var scoreLabel = UILabel()
    var scoreInt = 0
    var replay = UIButton()
    var gameOverText = UILabel()
    var exitButton = UIButton()
    var player: AVAudioPlayer?
    var playerLight: AVAudioPlayer?
    var playerBubble: AVAudioPlayer?
    var highScore = Int()
    var soundIsland: AVAudioPlayer?
    var latinhorn: AVAudioPlayer?
    var lightning = SKSpriteNode()
    var shark = SKSpriteNode()
    override func didMove(to view: SKView) {
        getItTogether()

    }

    func getItTogether(){
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -2.0 )
        self.physicsWorld.contactDelegate = self
        backgroundColor = UIColor.init(red: 153/255, green: 204/255, blue: 1, alpha: 1.0)
        //play island sound
        soundIsland = playIsland()
        soundIsland?.numberOfLoops = -1
        soundIsland?.play()
        //add waves
        let wavea = SKSpriteNode(imageNamed: "wave2")
        let waveb = SKSpriteNode(imageNamed: "wave2")
        let wavec = SKSpriteNode(imageNamed: "wave2")
        let waved = SKSpriteNode(imageNamed: "wave2")
        let wavee = SKSpriteNode(imageNamed: "wave2")
        let waveSz = CGSize(width: wavea.size.width/3, height: wavea.size.height/3)
        wavea.scale(to: waveSz)
        wavea.position = CGPoint(x: (Int) (wavea.size.width/2)  , y: (Int)(wavea.size.height/3))
        addChild(wavea)
        waveb.scale(to: waveSz)
        waveb.position = CGPoint(x: (Int) (wavea.size.width/2) * 3 - 5 , y: (Int) (wavea.size.height/3))
        addChild(waveb)
        wavec.scale(to: waveSz)
        wavec.zPosition = 2
        wavec.physicsBody?.isDynamic = false
        wavec.scale(to: waveSz)
        wavec.position = CGPoint(x: (Int) (wavea.size.width/2) * 5 - 10 , y: (Int) (wavea.size.height/3))
        addChild(wavec)
        waved.scale(to: waveSz)
        waved.position = CGPoint(x: (Int) (wavea.size.width/2) * 7 - 20 , y: (Int) (wavea.size.height/3))
        addChild(waved)
        wavee.scale(to: waveSz)
        wavee.position = CGPoint(x: (Int) (wavea.size.width/2) * 9 - 30 , y: (Int) (wavea.size.height/3))
        addChild(wavee)

        //add sun
        let sun = SKSpriteNode(imageNamed: "sun")
        let sunSz = CGSize(width: 50 , height: 50)
        sun.scale(to: sunSz)
        sun.zRotation = CGFloat(M_PI/2.0)
        sun.anchorPoint = CGPoint(x:CGFloat(0.5),y:CGFloat(0.5))
        sun.position = CGPoint(x: size.width - sun.size.width - 5, y: size.height - sun.size.height)
        let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        sun.run(spinForever)
        addChild(sun)

        //add HighScore
        labelHiScore = UILabel(frame: CGRect(x: self.size.width/2 - 100, y: self.size.height/5 - 10, width: 200, height: 30))
        labelHiScore.textAlignment = .center
        labelHiScore.textColor = UIColor.red
        labelHiScore.font = UIFont.init(name: "MarkerFelt-Thin", size: 20)
        let userDefaults = UserDefaults.standard
        let highscore3 = userDefaults.value(forKey: "highscore")
        labelHiScore.text = "High Score: \(highscore3!)"
        self.view?.addSubview(labelHiScore)

        //tap to start
        taptoStart = UILabel(frame: CGRect(x: self.size.width/2 - 250, y: self.size.height/2 - 50, width: 500, height: 100))
        // taptoStart.center = CGPoint(x: self.size.width/2, y: self.size.height/5)
        taptoStart.textAlignment = .center
        taptoStart.textColor = UIColor.yellow
        taptoStart.font = UIFont.init(name: "MarkerFelt-Thin", size: 75)
        taptoStart.text = "Tap To Start"
        self.view?.addSubview(taptoStart)


        //add Bird
        bird = SKSpriteNode(imageNamed: "bird1")
        let birdSz = CGSize(width: bird.size.width/4, height: bird.size.height/4)
        let birdPhysicsSz = CGSize(width: bird.size.width/6, height: bird.size.height/6)
        bird.scale(to: birdSz)
        bird.position = CGPoint(x: self.size.width/3, y: self.size.height/2 - 10 )
        bird.physicsBody = SKPhysicsBody(rectangleOf: birdPhysicsSz)
        bird.physicsBody?.isDynamic = true
        bird.zPosition = 2
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.collisionBitMask = PhysicsCategory.plane | PhysicsCategory.cloud | PhysicsCategory.ship
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.plane | PhysicsCategory.cloud | PhysicsCategory.ship
        self.addChild(bird)
    }


    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if started == true && gameOver == false {
            if bird.position.y < self.size.height/8 { //bird hit water
                birdHitWave = true
            }
            if bird.position.y > self.size.height - self.size.height/9 {   // bird touches sky
                birdHitCloud = true
            }
        }
        if (birdHitCloud){
           // birdHitCloud = false
            addLightning()
            soundIsland?.stop()
            let s3: AVAudioPlayer = playElectric()
            s3.play()
            Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.gameOverMethod), userInfo: nil, repeats: false)
        }
        if (birdHitWave){
            addShark()
            soundIsland?.stop()
            let s5: AVAudioPlayer = playBubble()
            s5.play()
            Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.gameOverMethod), userInfo: nil, repeats: false)
        }
        if gameOver == true {
            soundIsland?.stop()
            gameOverMethod()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bird.texture = SKTexture(imageNamed:"bird2")
        // add highscore
        labelHiScore.removeFromSuperview()
        labelHiScore.textAlignment = .left
        labelHiScore = UILabel(frame: CGRect(x: self.size.width/90 , y: self.size.height - self.size.height/10 , width: 300, height: 30))
        labelHiScore.font = UIFont.init(name: "Georgia-Italic", size: 20)
        labelHiScore.textColor = UIColor.red
        let userDefaults = UserDefaults.standard
        let highscore4 = userDefaults.value(forKey: "highscore")
        labelHiScore.text = "High Score: \(highscore4!)"
        self.view?.addSubview(labelHiScore)

        //add score
        scoreLabel.removeFromSuperview()
        scoreLabel = UILabel(frame: CGRect(x: self.size.width - self.size.width/6 , y: self.size.height - self.size.height/10 , width: 100, height: 30))
        scoreLabel.textAlignment = .left
        scoreLabel.textColor = UIColor.red
        scoreLabel.font = UIFont.init(name: "Georgia-Italic", size: 20)
        scoreLabel.text = "Score: \(scoreInt)"
        self.view?.addSubview(scoreLabel)

        if started == false {
            started = true
            taptoStart.isHidden = true
            bird.physicsBody?.affectedByGravity = true
            //creates a block
//move and remove jet
            let removeFromParent = SKAction.removeFromParent()
            let distance = CGFloat(self.frame.width  + jetpair.frame.width + 275 )
            let movingJet = SKAction.run({
                () in
                self.addjets()
            })
            let delay = SKAction.wait(forDuration: 2)   //interval between jets
            let addJetDelay = SKAction.sequence ([movingJet, delay])
            let addJetForever = SKAction.repeatForever(addJetDelay)
            self.run(addJetForever)
            let movePlane = SKAction.moveBy(x: -distance , y:0, duration: TimeInterval(0.005 * distance ))
            moveAndRemove = SKAction.sequence([movePlane, removeFromParent])
//move and remove cloud
            let movingCloud = SKAction.run({
                () in
                self.addCloud()
            })
            let delayCloud = SKAction.wait(forDuration: 2.5)   //interval between jets
            let addCloudDelay = SKAction.sequence ([movingCloud, delayCloud])
            let addCloudForever = SKAction.repeatForever(addCloudDelay)
            self.run(addCloudForever)
            let moveCloud = SKAction.moveBy(x: distance , y:0, duration: TimeInterval(0.0099 * distance ))
            moveAndRemoveCloud = SKAction.sequence([moveCloud, removeFromParent])
//move and remove ship
            let movingShip = SKAction.run({
                () in
                self.addShip()
            })
            let delay2 = SKAction.wait(forDuration: 8)   //interval between jets
            let addShipDelay = SKAction.sequence ([movingShip, delay2])
            let addShipForever = SKAction.repeatForever(addShipDelay)
            self.run(addShipForever)
            let moveShip = SKAction.moveBy(x: distance , y:0, duration: TimeInterval(0.02 * distance ))
            moveAndRemoveShip = SKAction.sequence([moveShip, removeFromParent])

            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7))
        }else{
            if gameOver == true {
                gameOverMethod()
            }else{
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7))
            }
        }

        if started == true && gameOver == false {
            scoreInt += 1
            let userDefaults = UserDefaults.standard
            let highScoreValue = userDefaults.value(forKey: "highscore")

            let hsv: Int? = highScoreValue as! Int?
            if hsv! < scoreInt {
                highScore = scoreInt
                userDefaults.setValue(highScore, forKey: "highscore")
                userDefaults.synchronize()
            }
        }


    }



    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bird.texture = SKTexture(imageNamed:"bird1")
        let s1: AVAudioPlayer = playBird()
        s1.numberOfLoops = 1
        s1.play()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
           }

    func gameOverMethod() {
        gameOver = true
        soundIsland?.stop()
        self.removeAllChildren()
        self.removeAllActions()
        replay.isHidden = true
        //play spanish horn music
        latinhorn = playlatinHorn()
        latinhorn?.numberOfLoops = -1
        latinhorn?.play()
        backgroundColor = UIColor.init(red: 0, green: 0, blue: 200/255, alpha: 255/255)
        labelHiScore.removeFromSuperview()
        labelHiScore.textAlignment = .center
        labelHiScore = UILabel(frame: CGRect(x: self.size.width/2 - 150, y: self.size.height/10 , width: 300, height: 30))
        labelHiScore.font = UIFont.init(name: "Georgia-Italic", size: 25)
        labelHiScore.textColor = UIColor.init(red: 1, green: 1, blue: 0, alpha: 255/255)
        let userDefaults = UserDefaults.standard
        let highscore5 = userDefaults.value(forKey: "highscore")
        labelHiScore.text = "High Score:  \(highscore5!)"
        self.view?.addSubview(labelHiScore)
        scoreLabel.removeFromSuperview()
        scoreLabel = UILabel(frame: CGRect(x: self.size.width/2 - 50, y: self.size.height/5 , width: 100, height: 30))
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor.init(red: 1, green: 1, blue: 0, alpha: 255/255)
        scoreLabel.font = UIFont.init(name: "Georgia-Italic", size: 20)
        scoreLabel.text = "Score:  \(scoreInt)"
        self.view?.addSubview(scoreLabel)


        let InjuredBird = SKSpriteNode(imageNamed: "InjuredBird")
        let InjuredBirdSz = CGSize(width: InjuredBird.size.width, height: InjuredBird.size.height)
        InjuredBird.scale(to: InjuredBirdSz)
        InjuredBird.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        InjuredBird.physicsBody?.isDynamic = false
        InjuredBird.zPosition = 2
        InjuredBird.physicsBody?.allowsRotation = false
        InjuredBird.physicsBody?.affectedByGravity = false
        self.addChild(InjuredBird)
        //add Replay button
        replay = UIButton(frame: CGRect(x: self.size.width/7 , y: self.size.height/2 + self.size.height/14 , width: 200, height: 50))
        replay.setTitleColor( UIColor.green, for: .normal)
        replay.titleLabel?.font = UIFont.init(name: "Georgia-Italic", size: 25)
        replay.setTitle("Replay", for: .normal)
        replay.addTarget(self, action: #selector(GameScene.restartMethod), for: .touchUpInside)
        self.view?.addSubview(replay)

        //add Exit button
        exitButton.removeFromSuperview()
         exitButton = UIButton(frame: CGRect(x: self.size.width/2 + self.size.width/6, y: self.size.height/2 + self.size.height/14 , width: 200, height: 50))
        exitButton.setTitleColor( UIColor.green, for: .normal)
        exitButton.titleLabel?.font = UIFont.init(name: "Georgia-Italic", size: 25)
        exitButton.setTitle("Exit", for: .normal)
        exitButton.addTarget(self, action: #selector(GameScene.exit), for: .touchUpInside)
        self.view?.addSubview(exitButton)
    }

    func exit()
    {
      UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }

    func restartMethod(){
        //latinhorn?.stop()
        self.removeAllChildren()
        self.removeAllActions()
        self.removeFromParent()
        exitButton.isEnabled = true
        exitButton.removeFromSuperview()
        gameOverText.isEnabled = false
        gameOverText.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        replay.removeFromSuperview()
        labelHiScore.removeFromSuperview()
        gameOver = false
        started = false
        scoreInt = 0
        getItTogether()

    }


    func addjets(){
        jetpair = SKNode()
        let plane = SKSpriteNode(imageNamed: "plane1")
        let randomPosition2 = CGFloat(arc4random_uniform(250))
        let planeSz = CGSize(width: plane.size.width/3 , height: plane.size.height/3)
        let planePhysicsSz = CGSize(width: plane.size.width/4 , height: plane.size.height/6)
        plane.scale(to: planeSz)   
        plane.position = CGPoint(x: self.size.width + 100 + plane.size.width/3 , y: 100 + randomPosition2 )
        plane.physicsBody = SKPhysicsBody(rectangleOf: planePhysicsSz)
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.categoryBitMask = PhysicsCategory.plane
        plane.physicsBody?.isDynamic = true
        plane.physicsBody?.collisionBitMask = PhysicsCategory.bird
        plane.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        plane.zPosition = -1
        jetpair.addChild(plane)
        jetpair.run(moveAndRemove)
        self.addChild(jetpair)

    
    }

    func addCloud(){
        cloudNode = SKNode()
        let cloud = SKSpriteNode(imageNamed: "Cloud")
        let cloudImageSz = CGSize(width: cloud.size.width/3 , height: cloud.size.height/4)
        let cloudPhysicsSz = CGSize(width: cloud.size.width/4 , height: cloud.size.height/6)
        let randomPosition2 = CGFloat(arc4random_uniform(UInt32((Float)(self.size.height/6))))
        cloud.scale(to: cloudImageSz)
        cloud.position = CGPoint(x:cloud.size.width/2 - 100 , y: self.size.height  - randomPosition2 )
        cloud.physicsBody = SKPhysicsBody(rectangleOf: cloudPhysicsSz)
        cloud.physicsBody?.affectedByGravity = false
        cloud.physicsBody?.isDynamic = true
        cloud.physicsBody?.categoryBitMask = PhysicsCategory.cloud
        cloud.physicsBody?.collisionBitMask = PhysicsCategory.bird
        cloud.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        cloud.zPosition = 1
        cloudNode.addChild(cloud)
        cloudNode.run(moveAndRemoveCloud)
        self.addChild(cloudNode)
    }
    func addShip(){
        shipNode = SKNode()
        let ship = SKSpriteNode(imageNamed: "ship")
        let shipSz = CGSize(width: ship.size.width/2 , height: ship.size.height/3)
        let shipPhysicsSz = CGSize(width: ship.size.width/3 , height: ship.size.height/12)
        ship.scale(to: shipSz)
        let randomPosition2 = CGFloat(arc4random_uniform(8))
        ship.position = CGPoint(x:ship.size.width/2 - 250 , y: 70 + randomPosition2 )
        ship.physicsBody = SKPhysicsBody(rectangleOf:shipPhysicsSz)
        ship.physicsBody?.affectedByGravity = false
        ship.physicsBody?.categoryBitMask = PhysicsCategory.ship
        ship.physicsBody?.isDynamic = true
        ship.physicsBody?.collisionBitMask = PhysicsCategory.bird
        ship.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        ship.zPosition = -1
        shipNode.addChild(ship)
        shipNode.run(moveAndRemoveShip)
        self.addChild(shipNode)

    }
    func addShark() {
        shark.removeFromParent()
        shark = SKSpriteNode(imageNamed: "shark")
        let sharkSz = CGSize(width: shark.size.width/3 , height: shark.size.height/3)
        shark.scale(to: sharkSz)
        shark.position = CGPoint(x: bird.position.x , y: bird.position.y - shark.size.height/6  )
       // shark.physicsBody = SKPhysicsBody(rectangleOf: sharkSz)
        shark.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        shark.physicsBody?.affectedByGravity = true
        shark.physicsBody?.isDynamic = true
        shark.zPosition = 3
        bird.physicsBody?.isDynamic = true
        self.addChild(shark)
        birdHitWave = false
    }

    func addLightning() {
        lightning.removeFromParent()
        lightning = SKSpriteNode(imageNamed: "lightning")
        let lightningSz = CGSize(width: lightning.size.width/4 , height: lightning.size.height/4)
        lightning.scale(to: lightningSz)
        lightning.position = CGPoint(x: bird.position.x , y: bird.position.y - lightning.size.height/3 )
        lightning.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        lightning.physicsBody?.affectedByGravity = false
        lightning.physicsBody?.isDynamic = true
        lightning.zPosition = 3
        self.addChild(lightning)
        birdHitCloud = false

    }

    func didBegin(_ contact: SKPhysicsContact) {

        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        if firstBody.categoryBitMask == PhysicsCategory.bird && secondBody.categoryBitMask == PhysicsCategory.plane
            ||
            firstBody.categoryBitMask == PhysicsCategory.plane && secondBody.categoryBitMask == PhysicsCategory.bird
        {
            gameOver = true
        }
        if firstBody.categoryBitMask == PhysicsCategory.bird && secondBody.categoryBitMask == PhysicsCategory.ship
            ||
            firstBody.categoryBitMask == PhysicsCategory.ship && secondBody.categoryBitMask == PhysicsCategory.bird
        {
            gameOver = true
        }
        if firstBody.categoryBitMask == PhysicsCategory.bird && secondBody.categoryBitMask == PhysicsCategory.cloud
            ||
            firstBody.categoryBitMask == PhysicsCategory.cloud && secondBody.categoryBitMask == PhysicsCategory.bird
        {
            birdHitCloud = true
        }
    }


    func playlatinHorn() -> AVAudioPlayer {
        guard let sound = NSDataAsset(name: "latinHorn") else {
            //print("sound asset not found")
            return player!
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return player!
    }
    func playElectric() -> AVAudioPlayer {
        guard let sound = NSDataAsset(name: "soundElectric") else {
            print("sound asset not found")
            return playerLight!
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)

            playerLight = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)

            // player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return playerLight!
    }
    func playBubble() -> AVAudioPlayer {
        guard let sound = NSDataAsset(name: "soundBubble") else {
            print("sound asset not found")
            return playerBubble!
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)

            playerBubble = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)

        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return playerBubble!
    }
    func playBird() -> AVAudioPlayer {
        guard let sound = NSDataAsset(name: "soundBird") else {
            print("sound asset not found")
            return player!
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)

            // player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return player!
    }
    func playIsland() -> AVAudioPlayer {
        guard let sound = NSDataAsset(name: "soundIsland") else {
            print("sound asset not found")
            return player!
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)

            // player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return player!
    }

}


// background red
class GameScene2: SKScene{
    var labelHiScore2 = UILabel()
    var labelVogel = UILabel()
    var playButton = UIButton()
    var player: AVAudioPlayer?
    var s1: AVAudioPlayer?

    override func didMove(to view: SKView) {
        //red background
          backgroundColor = UIColor.init(red: 1, green: 0, blue: 0.0, alpha: 1.0)
        //vogel label
        labelVogel = UILabel(frame: CGRect(x: self.size.width/2 - 250 , y: self.size.height/8, width: 500, height: 150))
        labelVogel.textAlignment = .center
        labelVogel.textColor = UIColor.blue
        labelVogel.font = UIFont.init(name: "MarkerFelt-Thin", size: 150)
        labelVogel.text = "VOGEL"
        self.view?.addSubview(labelVogel)
        // add highscore
        labelHiScore2 = UILabel(frame: CGRect(x: self.size.width/2 - 150, y: self.size.height - self.size.height/5 , width: 300, height: 30))
        labelHiScore2.textAlignment = .center
        labelHiScore2.textColor = UIColor.yellow
        labelHiScore2.font = UIFont.init(name: "MarkerFelt-Thin", size: 25)
        let userDefaults = UserDefaults.standard
        var highscore3 = userDefaults.value(forKey: "highscore")
        if highscore3 == nil {
            userDefaults.setValue(0, forKey: "highscore")
        }
        highscore3 = userDefaults.value(forKey: "highscore")
        labelHiScore2.text = "High Score: \(highscore3!)"
        self.view?.addSubview(labelHiScore2)
        self.view?.addSubview(labelHiScore2)
        // add fly button
        playButton = UIButton(frame: CGRect(x: self.size.width/2 - 60 , y: self.size.height/2 + 10 , width: 120, height: 25))
        playButton.setTitleColor( UIColor.green, for: .normal)
        playButton.titleLabel?.font = UIFont.init(name: "MarkerFelt-Thin", size: 25)
        playButton.titleLabel?.textColor = UIColor.green
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(GameScene2.page1), for: .touchUpInside)
        self.view?.addSubview(playButton)

        let s1 = playlatinHorn2()
        s1.numberOfLoops = -1
        s1.play()

    }
    func page1(){
       // Thread.sleep(forTimeInterval: 0.5)
        labelVogel.removeFromSuperview()
        labelHiScore2.removeFromSuperview()
        playButton.removeFromSuperview()

        let scene = GameScene(size: (view?.bounds.size)!)
        let skView = self.view
        skView?.showsFPS = true
        skView?.showsNodeCount = true
        skView?.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView?.presentScene(scene)
        }

    func playlatinHorn2() -> AVAudioPlayer {
        guard let sound = NSDataAsset(name: "latinHorn") else {
            //print("sound asset not found")
            return player!
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return player!
    }
}

