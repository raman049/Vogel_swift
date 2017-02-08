//
//  GameScene.swift
//  Vogel
//
//  Created by raman maharjan on 12/28/16.
//  Copyright © 2016 raman maharjan. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit
import Darwin
import AVFoundation
import Social

struct PhysicsCategory {
    static let bird : UInt32 = 0x1 << 1
    static let plane : UInt32 = 0x1 << 2
    static let fly : UInt32 = 0x1 << 3
    static let ship : UInt32 = 0x1 << 4
    static let cloud : UInt32 = 0x1 << 5
    static let shark : UInt32 = 0x1 << 6
    static let lightning : UInt32 = 0x1 << 7
    static let tree : UInt32 = 0x1 << 8

}

class GameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate  {

    var bird2 = SKSpriteNode()
    var bird1 = SKSpriteNode()
    var bird = SKSpriteNode()
    var lightning = SKSpriteNode()
    var fruit = SKSpriteNode()
    var boom = SKSpriteNode()
    var shark = SKSpriteNode()
    var fly = SKSpriteNode()
    var wavea = SKSpriteNode()
    var jetpair = SKNode()
    var jetpair2 = SKNode()
    var cloudNode = SKNode()
    var shipNode = SKNode()
    var sharkNode = SKNode()
    var flyNode = SKNode()
    var treeNode = SKNode()
    var waveNode = SKNode()
    var started = Bool()
    var gameOver = Bool()
    var birdHitCloud = Bool()
    var birdHitWave = Bool()
    var birdHitJet = Bool()
    var birdHitFly = Bool()
    var birdHitTree = Bool()
    var fruitBonus = Bool()
    var moveAndRemove = SKAction()
    var moveAndRemove2 = SKAction()
    var moveAndRemoveCloud = SKAction()
    var moveAndRemoveShip = SKAction()
    var moveAndRemoveShark = SKAction()
    var moveAndRemoveFly = SKAction()
    var moveAndRemoveTree = SKAction()
    var moveAndRemoveWave = SKAction()
    var labelHiScore = UILabel()
    var labelHiScoreInt = UILabel()
   // var labelScore = UILabel()
    var scoreLabel = UILabel()
    var labelScoreInt = UILabel()
    var taptoStart = UILabel()
    var bonus = UILabel()
    var finalScoreInt = Int()
    var count = Int()
    var scoreInt = 0
    var replay = UIButton()
    var gameOverText = UILabel()
    var gcButton = UIButton()
    var instructionQueBut = UIButton()
    var player: AVAudioPlayer?
    var playerLight: AVAudioPlayer?
    var playerBubble: AVAudioPlayer?
    var highScore = Int()
    var soundIsland: AVAudioPlayer?
    var latinhorn: AVAudioPlayer?
    var count1: CGFloat = CGFloat(0)
    override func didMove(to view: SKView) {
        getItTogether()

    }

    func getItTogether(){
        authPlayer()
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -2 )
        self.physicsWorld.contactDelegate = self
        backgroundColor = UIColor.init(red: 153/255, green: 204/255, blue: 1, alpha: 1.0)
        //play island sound
        soundIsland = playIsland()
        soundIsland?.numberOfLoops = -1
        soundIsland?.play()
        //add waves
        wavea = SKSpriteNode(imageNamed: "wave2")
        let waveb = SKSpriteNode(imageNamed: "wave2")
        let wavec = SKSpriteNode(imageNamed: "wave2")
        let waved = SKSpriteNode(imageNamed: "wave2")
        let wavee = SKSpriteNode(imageNamed: "wave2")
        let wavef = SKSpriteNode(imageNamed: "wave2")
        let waveSz = CGSize(width: wavea.size.width, height: wavea.size.height)
        wavea.scale(to: waveSz)
        wavea.position = CGPoint(x: (Int) (wavea.size.width/2)  , y: (Int)(wavea.size.height/3))
        addChild(wavea)
        waveb.scale(to: waveSz)
        waveb.position = CGPoint(x: (Int) (wavea.size.width/2) * 3 - 5 , y: (Int) (wavea.size.height/3))
        addChild(waveb)
        wavec.scale(to: waveSz)
        wavec.position = CGPoint(x: (Int) (wavea.size.width/2) * 5 - 10 , y: (Int) (wavea.size.height/3))
        addChild(wavec)
        waved.scale(to: waveSz)
        waved.position = CGPoint(x: (Int) (wavea.size.width/2) * 7 - 20 , y: (Int) (wavea.size.height/3))
        addChild(waved)
        wavee.scale(to: waveSz)
        wavee.position = CGPoint(x: (Int) (wavea.size.width/2) * 9 - 30 , y: (Int) (wavea.size.height/3))
        addChild(wavee)
        wavef.scale(to: waveSz)
        wavef.position = CGPoint(x: (Int) (wavea.size.width/2) * 11 - 40 , y: (Int) (wavea.size.height/3))
        addChild(wavef)
        //add SUn
        let sun = SKSpriteNode(imageNamed: "sun")
        let sunSz = CGSize(width: sun.size.width/2 , height: sun.size.height/2)
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
        labelHiScore.text = "Hi Score: \(highscore3!)"
        self.view?.addSubview(labelHiScore)

        //tap to start
        taptoStart = UILabel(frame: CGRect(x: self.size.width/2 - 250, y: self.size.height/2 - 50, width: 500, height: 100))
        // taptoStart.center = CGPoint(x: self.size.width/2, y: self.size.height/5)
        taptoStart.textAlignment = .center
        taptoStart.textColor = UIColor.yellow
        taptoStart.font = UIFont.init(name: "MarkerFelt-Thin", size: 75)
        taptoStart.text = "Tap To Start"
        self.view?.addSubview(taptoStart)


        //add Birdx
        bird = SKSpriteNode(imageNamed: "bird1")
        let birdSz = CGSize(width: (bird.size.width/3) * 2, height: (bird.size.height/3) * 2)
        let birdPhysicsSz = CGSize(width: bird.size.width/3, height: bird.size.height/3)
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
            if bird.position.y < wavea.size.height { //bird hit water
                birdHitWave = true
            }
            if bird.position.y > self.size.height{   // bird touches sky
                // birdHitCloud = true
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -2))
            }
        }
        if (birdHitCloud){
            addLightning()
            soundIsland?.stop()
            let s3: AVAudioPlayer = playElectric()
            s3.play()
            Timer.scheduledTimer(timeInterval: TimeInterval(0.7), target: self, selector: #selector(GameScene.gameOverMethod), userInfo: nil, repeats: false)
        }
        if (birdHitWave){
            addShark()
            soundIsland?.stop()
            let s5: AVAudioPlayer = playBubble()
            s5.play()
            Timer.scheduledTimer(timeInterval: TimeInterval(0.7), target: self, selector: #selector(GameScene.gameOverMethod), userInfo: nil, repeats: false)
        }
        if (birdHitJet){
            addBoom()
            soundIsland?.stop()
            let soudHitJet: AVAudioPlayer = playBoom()
            soudHitJet.play()
            Timer.scheduledTimer(timeInterval: TimeInterval(0.7), target: self, selector: #selector(GameScene.gameOverMethod), userInfo: nil, repeats: false)
        }
        if birdHitTree == true {
            addFruit()
            scoreInt = scoreInt + 500
            fruitBonus = true
            addBonus()
            birdHitTree = false
        }
        if birdHitFly == true{
            scoreInt = scoreInt + 50
            addBonus()
            birdHitFly = false
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bird.texture = SKTexture(imageNamed:"bird2")
        // add highscore
        if gameOver == false {
            labelHiScore.removeFromSuperview()
           // labelHiScore.textAlignment = .center
            labelHiScore = UILabel(frame: CGRect(x: self.size.width/80 , y: 10, width: 300, height: 30))
            labelHiScore.font = UIFont.init(name: "Georgia-Italic", size: 20)
            labelHiScore.textColor = UIColor.red
            let userDefaults = UserDefaults.standard
            let highscore4 = userDefaults.value(forKey: "highscore")
            let hs = highscore4 as! NSNumber
            labelHiScoreInt.removeFromSuperview()
            //labelHiScoreInt.textAlignment = .center
            labelHiScoreInt = UILabel(frame: CGRect(x: self.size.width/80 , y: 10 + 20, width: 300, height: 30))
            labelHiScoreInt.font = UIFont.init(name: "Georgia-Italic", size: 20)
            labelHiScoreInt.textColor = UIColor.red
            labelHiScore.text = "High Score:"
            labelHiScoreInt.text = "\(hs)"
            self.view?.addSubview(labelHiScore)
            self.view?.addSubview(labelHiScoreInt)

            //add score
            scoreLabel.removeFromSuperview()
            scoreLabel = UILabel(frame: CGRect(x: self.size.width/80 , y: 10 + 40 , width: 150, height: 30))
           // scoreLabel.textAlignment = .center
            scoreLabel.textColor = UIColor.red
            scoreLabel.font = UIFont.init(name:"Georgia-Italic", size: 20)
            labelScoreInt.removeFromSuperview()
            labelScoreInt = UILabel(frame: CGRect(x: self.size.width/80 , y: 10 + 55, width: 150, height: 30))
           // labelScoreInt.textAlignment = .center
            labelScoreInt.textColor = UIColor.red
            labelScoreInt.font = UIFont.init(name:"Georgia-Italic", size: 20)
            scoreLabel.text = "Your Score:"
            labelScoreInt.text = "\(scoreInt)"
            self.view?.addSubview(scoreLabel)
            self.view?.addSubview(labelScoreInt)
        }
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
            let movePlane = SKAction.moveBy(x: -distance , y:0, duration: TimeInterval(5))
            moveAndRemove = SKAction.sequence([movePlane, removeFromParent])
            //move and remove jet2
            let movingJet2 = SKAction.run({
                () in
                self.addjets2()
            })
            let delayJet2 = SKAction.wait(forDuration: 4)   //interval between jets
            let addJet2Delay = SKAction.sequence ([movingJet2, delayJet2])
            let addJet2Forever = SKAction.repeatForever(addJet2Delay)
            self.run(addJet2Forever)
            let movePlane2 = SKAction.moveBy(x: -distance , y:0, duration: TimeInterval(3))
            moveAndRemove2 = SKAction.sequence([movePlane2, removeFromParent])
            //move and remove fly
            let movingFly = SKAction.run({
                () in
                self.addFly()
            })
            let delayFly = SKAction.wait(forDuration: 10)   //interval between jets
            let addFlyDelay = SKAction.sequence ([movingFly, delayFly])
            let addFlyForever = SKAction.repeatForever(addFlyDelay)
            self.run(addFlyForever)
            let moveFly = SKAction.moveBy(x: -distance , y:0, duration: TimeInterval(15))
            moveAndRemoveFly = SKAction.sequence([moveFly, removeFromParent])
            //move and remove tree
            let movingTree = SKAction.run({
                () in
                self.addTree()
            })
            let delayTree = SKAction.wait(forDuration: 29)   //interval between jets
            let addTreeDelay = SKAction.sequence ([movingTree, delayTree])
            let addTreeForever = SKAction.repeatForever(addTreeDelay)
            self.run(addTreeForever)
            let moveTree = SKAction.moveBy(x: -distance , y:0, duration: TimeInterval(30))
            moveAndRemoveTree = SKAction.sequence([moveTree, removeFromParent])

            //move and remove cloud
            let movingCloud = SKAction.run({
                () in
                self.addCloud()
            })
            let delayCloud = SKAction.wait(forDuration: 9)   //interval between jets
            let addCloudDelay = SKAction.sequence ([movingCloud, delayCloud])
            let addCloudForever = SKAction.repeatForever(addCloudDelay)
            self.run(addCloudForever)
            let moveCloud = SKAction.moveBy(x: -distance , y:0, duration: TimeInterval(12))
            moveAndRemoveCloud = SKAction.sequence([moveCloud, removeFromParent])
            //move and remove ship
            let movingShip = SKAction.run({
                () in
                self.addShip()
            })
            let delay2 = SKAction.wait(forDuration: 50)   //interval between jets
            let addShipDelay = SKAction.sequence ([movingShip, delay2])
            let addShipForever = SKAction.repeatForever(addShipDelay)
            self.run(addShipForever)
            let moveShip = SKAction.moveBy(x: distance , y:0, duration: TimeInterval(50))
            moveAndRemoveShip = SKAction.sequence([moveShip, removeFromParent])

            //move and remove Wave
            let movingwave = SKAction.run({
                () in
                self.addWavea()
                self.addWaveb()
                self.addWavec()
                self.addWaved()
                self.addWavee()
            })
            let delayWave = SKAction.wait(forDuration: 0.3)   //interval between jets
            let addWaveDelay = SKAction.sequence ([movingwave, delayWave])
            let addWaveForever = SKAction.repeatForever(addWaveDelay)
            self.run(addWaveForever)
            let moveWave = SKAction.moveBy(x: 200 , y: 0, duration: TimeInterval(1))
            moveAndRemoveWave = SKAction.sequence([moveWave, removeFromParent])

            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3))
        }else{
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3))

        }

        if started == true && gameOver == false {
            scoreInt += 1
            let userDefaults = UserDefaults.standard
            let highScoreValue = userDefaults.value(forKey: "highscore")

            let hsv: Int? = highScoreValue as! Int?
            if hsv! < scoreInt {
                highScore = scoreInt
                userDefaults.setValue(highScore, forKey: "highscore")
                saveHS(number: highScoreValue as! Int)
                userDefaults.synchronize()
            }
        }

    }



    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if started == true && gameOver == false {
            bird.texture = SKTexture(imageNamed:"bird1")
            let s1: AVAudioPlayer = playBird()
            s1.numberOfLoops = 1
            s1.play()
        }
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
        labelHiScore = UILabel(frame: CGRect(x: self.size.width/3 - 150, y: self.size.height/10 , width: 300, height: 30))
        labelHiScore.textAlignment = .center
        labelHiScore.font = UIFont.init(name: "Georgia-Italic", size: 25)
        labelHiScore.textColor = UIColor.init(red: 1, green: 1, blue: 0, alpha: 255/255)
        let userDefaults = UserDefaults.standard
        let highscore5 = userDefaults.value(forKey: "highscore")
        labelHiScoreInt.removeFromSuperview()
        labelHiScoreInt = UILabel(frame: CGRect(x: self.size.width/3 - 150, y: self.size.height/10 + 25 , width: 300, height: 30))
        labelHiScoreInt.textAlignment = .center
        labelHiScoreInt.font = UIFont.init(name: "Georgia-Italic", size: 25)
        labelHiScoreInt.textColor = UIColor.init(red: 1, green: 1, blue: 0, alpha: 255/255)
        labelHiScore.text = "High Score:"
        labelHiScoreInt.text = "\(highscore5!)"
        self.view?.addSubview(labelHiScore)
        self.view?.addSubview(labelHiScoreInt)
        scoreLabel.removeFromSuperview()
        scoreLabel = UILabel(frame: CGRect(x: self.size.width - self.size.width/3 - 150, y: self.size.height/10 , width: 300, height: 30))
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor.init(red: 1, green: 1, blue: 0, alpha: 255/255)
        scoreLabel.font = UIFont.init(name: "Georgia-Italic", size: 25)
        scoreLabel.text = "Your Score:"
        self.view?.addSubview(scoreLabel)

        labelScoreInt.removeFromSuperview()
        labelScoreInt = UILabel(frame: CGRect(x: self.size.width - self.size.width/3 - 150, y: self.size.height/10 + 25, width: 300, height: 30))
        labelScoreInt.textAlignment = .center
        labelScoreInt.textColor = UIColor.init(red: 1, green: 1, blue: 0, alpha: 255/255)
        labelScoreInt.font = UIFont.init(name: "Georgia-Italic", size: 20)
        labelScoreInt.text = "\(scoreInt)"
        self.view?.addSubview(labelScoreInt)


        let InjuredBird = SKSpriteNode(imageNamed: "InjuredBird")
        let InjuredBirdSz = CGSize(width: InjuredBird.size.width * 3, height: InjuredBird.size.height * 3)
        InjuredBird.scale(to: InjuredBirdSz)
        InjuredBird.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        InjuredBird.physicsBody?.isDynamic = false
        InjuredBird.zPosition = 2
        InjuredBird.physicsBody?.allowsRotation = false
        InjuredBird.physicsBody?.affectedByGravity = false
        self.addChild(InjuredBird)
        //add Replay button
        replay = UIButton(frame: CGRect(x: self.size.width - 200, y: self.size.height - 40 , width: 100, height: 20))
        replay.setTitleColor( UIColor.green, for: .normal)
        replay.titleLabel?.font = UIFont.init(name: "Georgia-Italic", size: 25)
        replay.setTitle("Replay", for: .normal)
        replay.addTarget(self, action: #selector(GameScene.restartMethod), for: .touchUpInside)
        self.view?.addSubview(replay)
        // add instruction
        let instructionQueImg = UIImage(named: "instructionQue") as UIImage?
        instructionQueBut.removeFromSuperview()
        instructionQueBut   = UIButton(type: UIButtonType.custom) as UIButton
        instructionQueBut.frame = (frame: CGRect(x: 10, y: self.size.height - 10 - (instructionQueImg?.size.height)!/3, width: (instructionQueImg?.size.width)!/3, height: (instructionQueImg?.size.height)!/3))
        instructionQueBut.setImage(instructionQueImg, for: .normal)
        instructionQueBut.addTarget(self, action: #selector(GameScene.popUp), for: .touchUpInside)
        self.view?.addSubview(instructionQueBut)
        //add gc
        let gcButtonImage = UIImage(named: "scoreboard") as UIImage?
        gcButton.removeFromSuperview()
        gcButton   = UIButton(type: UIButtonType.custom) as UIButton
        gcButton.frame = (frame: CGRect(x: 20 + (gcButtonImage?.size.width)!/3 , y: self.size.height - 10 - (gcButtonImage?.size.height)!/3, width: (gcButtonImage?.size.width)!/3, height: (gcButtonImage?.size.height)!/3))
        gcButton.setImage(gcButtonImage, for: .normal)
        gcButton.addTarget(self, action: #selector(GameScene.showGC), for: .touchUpInside)
        self.view?.addSubview(gcButton)
    }

    var customView = UIView()
    var backButton = UIButton()
    var instruction = UIImageView()
    var scoreboard = UIImageView()

    func popUp()
    {
        //add custom uiview for popup
        customView.removeFromSuperview()
        customView = UIView(frame: CGRect(x: 50, y: 50, width: self.size.width - 100 , height: self.size.height - 100))
        customView.backgroundColor = UIColor.init(red: 196/255, green: 113/255, blue: 245/255, alpha: 255/255)
        //add image in uiview
        instruction.removeFromSuperview()
        instruction = UIImageView(frame:CGRect(x: 50, y: 50, width: self.size.width - 100 , height: self.size.height - 100))
        instruction.image = UIImage(named: "instruction")!
        self.view?.addSubview(customView)
        self.view?.addSubview(instruction)
        // add back button
        let backButtonImg = UIImage(named: "back") as UIImage?
        backButton.removeFromSuperview()
        backButton   = UIButton(type: UIButtonType.custom) as UIButton
        backButton.frame = (frame: CGRect(x: 10, y: 10, width: (backButtonImg?.size.width)!/3, height: (backButtonImg?.size.height)!/3))
        backButton.setImage(backButtonImg, for: .normal)
        backButton.removeFromSuperview()
        backButton.addTarget(self, action: #selector(GameScene.closeView), for: .touchUpInside)
        self.view?.addSubview(backButton)
    }
    func closeView(sender:UIButton)
    {
        // backgroundColor = UIColor.init(red: 0, green: 0, blue: 200/255, alpha: 255/255)
        customView.removeFromSuperview()
        backButton.removeFromSuperview()
        instruction.removeFromSuperview()
    }

    func restartMethod(){
        latinhorn?.stop()
        self.removeAllChildren()
        self.removeAllActions()
        self.removeFromParent()
        gcButton.isEnabled = true
        gcButton.removeFromSuperview()
        instructionQueBut.removeFromSuperview()
        gameOverText.isEnabled = false
        gameOverText.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        replay.removeFromSuperview()
        labelHiScore.removeFromSuperview()
        labelScoreInt.removeFromSuperview()
        labelHiScoreInt.removeFromSuperview()
        gameOver = false
        started = false
        scoreInt = 0
        getItTogether()

    }


    func addjets(){
        jetpair = SKNode()
        let plane = SKSpriteNode(imageNamed: "plane1")
        let heighta = self.size.height - wavea.size.height * 2
        let randomPosition2 = CGFloat(arc4random_uniform(UInt32(heighta)))
        let planeSz = CGSize(width: plane.size.width * 6/5 , height: plane.size.height * 6/5 )
        let planePhysicsSz = CGSize(width: plane.size.width/2 , height: plane.size.height/4)
        plane.scale(to: planeSz)
        plane.position = CGPoint(x: self.size.width + 50 + plane.size.width/3 , y: wavea.size.height + randomPosition2 )
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
    func addjets2(){
        jetpair2 = SKNode()
        let plane2 = SKSpriteNode(imageNamed: "plane2")
        let heighta = self.size.height - wavea.size.height * 2
        let planeSz = CGSize(width: plane2.size.width * 6/5 , height: plane2.size.height * 6/5 )
        let planePhysicsSz = CGSize(width: plane2.size.width/2 , height: plane2.size.height/4)
        plane2.scale(to: planeSz)
        let randomPosition3 = CGFloat(arc4random_uniform(150))
        let randomPosition4 = CGFloat(arc4random_uniform(UInt32(heighta)))
        plane2.position = CGPoint(x: self.size.width + 50 + plane2.size.width/3 + randomPosition3, y: wavea.size.height + randomPosition4 )
        plane2.physicsBody = SKPhysicsBody(rectangleOf: planePhysicsSz)
        plane2.physicsBody?.affectedByGravity = false
        plane2.physicsBody?.categoryBitMask = PhysicsCategory.plane
        plane2.physicsBody?.isDynamic = true
        plane2.physicsBody?.collisionBitMask = PhysicsCategory.bird
        plane2.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        plane2.zPosition = -1
        jetpair2.addChild(plane2)
        jetpair2.run(moveAndRemove2)
        self.addChild(jetpair2)
    }


    func addCloud(){
        cloudNode = SKNode()
        let cloud = SKSpriteNode(imageNamed: "Cloud")
        let cloudImageSz = CGSize(width: cloud.size.width/2 , height:cloud.size.height/2)
        let cloudPhysicsSz = CGSize(width: cloud.size.width/4 , height: cloud.size.height/6)
        let randomPosition2 = CGFloat(arc4random_uniform(UInt32((Float)(self.size.height/6))))
        cloud.scale(to: cloudImageSz)
        cloud.position = CGPoint(x: self.size.width + cloud.size.width/2 - randomPosition2 , y: self.size.height  - randomPosition2 )
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
        let ship = SKSpriteNode(imageNamed: "ship2")
        let shipSz = CGSize(width: ship.size.width * 3/2 , height: ship.size.height * 3/2)
        let shipPhysicsSz = CGSize(width: ship.size.width , height: ship.size.height/3)
        ship.scale(to: shipSz)
        ship.position = CGPoint(x:ship.size.width/2 - 250 , y: 95 )
        ship.physicsBody = SKPhysicsBody(rectangleOf:shipPhysicsSz)
        ship.physicsBody?.affectedByGravity = false
        ship.physicsBody?.categoryBitMask = PhysicsCategory.ship
        ship.physicsBody?.isDynamic = false
        ship.physicsBody?.collisionBitMask = PhysicsCategory.bird
        ship.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        ship.zPosition = -1
        shipNode.addChild(ship)
        shipNode.run(moveAndRemoveShip)
        self.addChild(shipNode)
    }
    func addFly(){
        flyNode = SKNode()
        let fly = SKSpriteNode(imageNamed: "fly2")
        let flySz = CGSize(width: fly.size.width/2 , height: fly.size.height/2 )
        let flyPhysicsSz = CGSize(width: fly.size.width/5, height: fly.size.height/5)
        fly.scale(to: flySz)
        let heighta = self.size.height - wavea.size.height * 2
        let randomPosition2 = CGFloat(arc4random_uniform(UInt32(heighta)))
        fly.position = CGPoint(x: self.size.width + 150 , y: wavea.size.height + randomPosition2 )
        fly.physicsBody = SKPhysicsBody(rectangleOf:flyPhysicsSz)
        fly.physicsBody?.affectedByGravity = false
        fly.physicsBody?.categoryBitMask = PhysicsCategory.fly
        fly.physicsBody?.isDynamic = true
        fly.physicsBody?.collisionBitMask = PhysicsCategory.bird
        fly.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        fly.zPosition = -1



        let moveUp = SKAction.moveBy(x: 0, y: 20, duration: 0.9)

        let sequence = SKAction.sequence([moveUp, moveUp.reversed()])

        flyNode.run(SKAction.repeatForever(sequence), withKey:  "moving")
//
//        let jumpFly = SKAction.moveBy(x: 0 , y:-10, duration: TimeInterval(0.2 ))
//        let actionforever = SKAction.repeatForever(jumpFly)
//        flyNode.run(actionforever)
//
//        let jumpFly2 = SKAction.moveBy(x: 0 , y: 10, duration: TimeInterval(0.2 ))
//        let actionforever2 = SKAction.repeatForever(jumpFly2)
//        flyNode.run(actionforever2)

        flyNode.addChild(fly)
        flyNode.run(moveAndRemoveFly)
        self.addChild(flyNode)
    }
    func addTree(){
        treeNode = SKNode()
        let tree = SKSpriteNode(imageNamed: "tree")
        let treeSz = CGSize(width: tree.size.width  , height: tree.size.height)
        let treePhysicsSz = CGSize(width: tree.size.width/10, height: tree.size.height/2)
        tree.scale(to: treeSz)
        tree.zPosition = -3
        tree.physicsBody = SKPhysicsBody(rectangleOf:treePhysicsSz)
        tree.position = CGPoint(x: tree.size.width/2 + self.size.width  , y: 100 )
        tree.physicsBody?.categoryBitMask = PhysicsCategory.tree
        tree.physicsBody?.collisionBitMask = PhysicsCategory.bird
        tree.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        tree.physicsBody?.isDynamic = false
        tree.physicsBody?.affectedByGravity = false
        treeNode.addChild(tree)
        treeNode.run(moveAndRemoveTree)
        self.addChild(treeNode)

    }

    func addWavea(){
        waveNode = SKNode()
        let wave = SKSpriteNode(imageNamed: "wave2")
        let waveSz = CGSize(width: wave.size.width, height: wave.size.height)
        wave.scale(to: waveSz)
        wave.zPosition = 3
        wave.position = CGPoint(x: (wave.size.width/2) - 50 , y: (wave.size.height/3))
        //wave.position = CGPoint(x: wave.size.width/2 + self.size.width  , y: 100 )
        waveNode.addChild(wave)
        waveNode.run(moveAndRemoveWave)
        self.addChild(waveNode)
    }
    func addWaveb(){
        waveNode = SKNode()
        let wave = SKSpriteNode(imageNamed: "wave2")
        let waveSz = CGSize(width: wave.size.width, height: wave.size.height)
        wave.scale(to: waveSz)
        wave.zPosition = 3
        wave.position = CGPoint(x: (Int) (wave.size.width/2) * 3 - 55 , y: (Int) (wave.size.height/3))
        waveNode.addChild(wave)
        waveNode.run(moveAndRemoveWave)
        self.addChild(waveNode)
    }
    func addWavec(){
        waveNode = SKNode()
        let wave = SKSpriteNode(imageNamed: "wave2")
        let waveSz = CGSize(width: wave.size.width, height: wave.size.height)
        wave.scale(to: waveSz)
        wave.zPosition = 3
        wave.position = CGPoint(x: (Int) (wave.size.width/2) * 5 - 60 , y: (Int) (wave.size.height/3))
        waveNode.addChild(wave)
        waveNode.run(moveAndRemoveWave)
        self.addChild(waveNode)
    }
    func addWaved(){
        waveNode = SKNode()
        let wave = SKSpriteNode(imageNamed: "wave2")
        let waveSz = CGSize(width: wave.size.width, height: wave.size.height)
        wave.scale(to: waveSz)
        wave.zPosition = 3
        wave.position = CGPoint(x: (Int) (wave.size.width/2) * 7 - 70 , y: (Int) (wave.size.height/3))
        waveNode.addChild(wave)
        waveNode.run(moveAndRemoveWave)
        self.addChild(waveNode)
    }
    func addWavee(){
        waveNode = SKNode()
        let wave = SKSpriteNode(imageNamed: "wave2")
        let waveSz = CGSize(width: wave.size.width, height: wave.size.height)
        wave.scale(to: waveSz)
        wave.zPosition = 3
        wave.position = CGPoint(x: (Int) (wave.size.width/2) * 9 - 30 , y: (Int) (wave.size.height/3))
        waveNode.addChild(wave)
        waveNode.run(moveAndRemoveWave)
        self.addChild(waveNode)
    }

    func addShark() {
        sharkNode = SKNode()
        shark.removeFromParent()
        shark = SKSpriteNode(imageNamed: "shark")
        let sharkSz = CGSize(width: shark.size.width , height: shark.size.height)
        shark.scale(to: sharkSz)
        shark.physicsBody?.isDynamic = true
        shark.physicsBody?.affectedByGravity = true
        shark.position = CGPoint(x: bird.position.x - 100  , y: bird.position.y - 100  )
        shark.zPosition = 2
        //move and remove shark
        let moveShark = SKAction.moveBy(x: 80 , y:90, duration: TimeInterval(0.7 ))
        sharkNode.addChild(shark)
        sharkNode.run(moveShark)
        self.addChild(sharkNode)
        birdHitWave = false
    }

    func addLightning() {
        lightning.removeFromParent()
        lightning = SKSpriteNode(imageNamed: "lightning")
        let lightningSz = CGSize(width: lightning.size.width , height: lightning.size.height)
        lightning.scale(to: lightningSz)
        lightning.physicsBody?.isDynamic = true
        lightning.position = CGPoint(x: bird.position.x , y: bird.position.y + 20 )
        lightning.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        lightning.physicsBody?.affectedByGravity = true
        lightning.zPosition = 3
        self.addChild(lightning)
        birdHitCloud = false

    }
    func addFruit() {
        fruit.removeFromParent()
        fruit = SKSpriteNode(imageNamed: "fruit")
        let fruitSz = CGSize(width: fruit.size.width , height: fruit.size.height)
        fruit.scale(to: fruitSz)
        fruit.physicsBody?.isDynamic = true
        fruit.position = CGPoint(x: bird.position.x + 5 , y: bird.position.y - 5 )
        fruit.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        fruit.physicsBody?.affectedByGravity = true
        fruit.zPosition = 3
        let spinFruit = SKAction.rotate(byAngle: CGFloat.pi, duration: 0.7)
        let spinForeverFruit = SKAction.repeatForever(spinFruit)
        let moveFruit = SKAction.moveBy(x: -5 , y: -100, duration: TimeInterval(1))
        let moveAndRemoveFruit = SKAction.sequence([moveFruit, SKAction.removeFromParent()])
        fruit.run(spinForeverFruit)
        fruit.run(moveAndRemoveFruit)
        self.addChild(fruit)
        birdHitTree = false

    }

    func addBoom() {
        boom.removeFromParent()
        boom = SKSpriteNode(imageNamed: "crash")
        let boomSz = CGSize(width: boom.size.width/2 , height: boom.size.height/2)
        boom.scale(to: boomSz)
        boom.physicsBody?.isDynamic = true
        boom.position = CGPoint(x: bird.position.x , y: bird.position.y)
        boom.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        boom.physicsBody?.affectedByGravity = true
        boom.zPosition = 4
        let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 0.7)
        let spinForever = SKAction.repeatForever(spin)
        let sizeUp = SKAction.scale(by: 5 , duration: 0.7)
        boom.run(spinForever)
        boom.run(sizeUp)
        self.addChild(boom)
        birdHitJet = false
    }

    func addBonus(){
        bonus.removeFromSuperview()
        bonus = UILabel(frame: CGRect(x: self.size.width/2 - 250, y: self.size.height/2 - 50, width: 500, height: 100))
        bonus.textAlignment = .center
        bonus.textColor = UIColor.yellow
        bonus.font = UIFont.init(name: "MarkerFelt-Thin", size: 30)
        if fruitBonus == true {
            bonus.text = "+500"
            fruitBonus = false
        }else{
             bonus.text = "+50"
        }
        self.view?.addSubview(bonus)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.2), target: self, selector: #selector(GameScene.removeBonuse), userInfo: nil, repeats: false)

    }
    func removeBonuse(){
        bonus.isEnabled = true
        bonus.isHidden = true
        bonus.removeFromSuperview()

    }

    func didBegin(_ contact: SKPhysicsContact) {

        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        if firstBody.categoryBitMask == PhysicsCategory.bird && secondBody.categoryBitMask == PhysicsCategory.plane
            ||
            firstBody.categoryBitMask == PhysicsCategory.plane && secondBody.categoryBitMask == PhysicsCategory.bird
        {
            birdHitJet = true

        }
        if firstBody.categoryBitMask == PhysicsCategory.bird && secondBody.categoryBitMask == PhysicsCategory.ship
            ||
            firstBody.categoryBitMask == PhysicsCategory.ship && secondBody.categoryBitMask == PhysicsCategory.bird
        {
            // birdHitJet = true
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 2))
        }
        if firstBody.categoryBitMask == PhysicsCategory.bird && secondBody.categoryBitMask == PhysicsCategory.cloud
            ||
            firstBody.categoryBitMask == PhysicsCategory.cloud && secondBody.categoryBitMask == PhysicsCategory.bird
        {
            birdHitCloud = true
        }
        if firstBody.categoryBitMask == PhysicsCategory.bird && secondBody.categoryBitMask == PhysicsCategory.fly
            ||
            firstBody.categoryBitMask == PhysicsCategory.fly && secondBody.categoryBitMask == PhysicsCategory.bird
        {
            birdHitFly = true
        }
        if firstBody.categoryBitMask == PhysicsCategory.bird && secondBody.categoryBitMask == PhysicsCategory.tree
            ||
            firstBody.categoryBitMask == PhysicsCategory.tree && secondBody.categoryBitMask == PhysicsCategory.bird
        {
            birdHitTree = true
        }
    }


    func playlatinHorn() -> AVAudioPlayer {
        guard let soundlatinHorn = NSDataAsset(name: "into1") else {
            //print("sound asset not found")
            return player!
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(data: soundlatinHorn.data, fileTypeHint: AVFileTypeMPEGLayer3)
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
        guard let sound = NSDataAsset(name: "sharkSound") else {
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
    func playBoom() -> AVAudioPlayer {
        guard let sound = NSDataAsset(name: "blast") else {
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

    func saveHS(number: Int){
        if GKLocalPlayer.localPlayer().isAuthenticated{
            let scoreReport = GKScore(leaderboardIdentifier: "HS")
            scoreReport.value = Int64(number)
            let scoreArray: [GKScore] = [scoreReport]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }

    func showGC(){
        let VC = self.view?.window?.rootViewController
        let GCVC = GKGameCenterViewController()
        GCVC.gameCenterDelegate = self
        VC?.present(GCVC, animated: true, completion: nil)

        let userDefaults = UserDefaults.standard
        let highscore7 = userDefaults.value(forKey: "highscore")
        saveHS(number: highscore7 as! Int)
    }
    //shows leaderboard screen
    func showLeader() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.present(gc, animated: true, completion: nil)
    }
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismiss(animated: true, completion: nil)

    }

    func authPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (view, error) -> Void in
            if  view != nil {
                let VC = self.view?.window?.rootViewController
                VC?.present(view!, animated: true, completion: nil)
            }else {
                print(GKLocalPlayer.localPlayer().isAuthenticated)
            }
        }
    }

    func showFacebook() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let mySLComposerSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            mySLComposerSheet?.setInitialText("Check out my high score")
            // mySLComposerSheet?.add(NSURL(string: "http://mysite.com")! as URL!)
            // mySLComposerSheet.
            let VC = self.view?.window?.rootViewController
            VC?.present(mySLComposerSheet!, animated: true, completion: nil)
        }
        else {
            // TODO: Alert user that they do not have a facebook account set up on their device
        }
    }
    
}

