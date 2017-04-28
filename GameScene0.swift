//
//  GSMethods.swift
//  Vogel
//
//  Created by raman maharjan on 2/3/17.
//  Copyright © 2017 raman maharjan. All rights reserved.
//

import Foundation

import SpriteKit
import GameplayKit
import GameKit
import Darwin
import AVFoundation
import Social


class GameScene0: SKScene, GKGameCenterControllerDelegate{
    var labelHiScore2 = UILabel()
    var labelVogel = UILabel()
    var playButton = UIButton()
    var player: AVAudioPlayer?
    var s2: AVAudioPlayer?
    var instructionQueButP1 = UIButton()
    var gcButtonP1 = UIButton()

    override func didMove(to view: SKView) {
        //gc validation
        authPlayer2()
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
        labelHiScore2 = UILabel(frame: CGRect(x: self.size.width/2 - 150, y: self.size.height - self.size.height/5 , width: 300, height: 50))
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
        // add play button
        let playImage = UIImage(named: "play") as UIImage?
        playButton = UIButton(type: UIButtonType.custom) as UIButton
        playButton.frame =  CGRect(x: self.size.width/2 - (playImage?.size.width)!/6 , y: self.size.height/2 + 10 , width:(playImage?.size.width)!/3, height: (playImage?.size.height)!/3)
        playButton.setImage(playImage, for: .normal)
        playButton.addTarget(self, action: #selector(GameScene0.page1), for: .touchUpInside)
        self.view?.addSubview(playButton)
        //add instruction and scoreboard
        // add instruction
        let instructionQueImg = UIImage(named: "instructionQue") as UIImage?
        instructionQueButP1.removeFromSuperview()
        instructionQueButP1   = UIButton(type: UIButtonType.custom) as UIButton
        instructionQueButP1.frame =  CGRect(x: 10, y: self.size.height - 10 - (instructionQueImg?.size.height)!/3, width: (instructionQueImg?.size.width)!/3, height: (instructionQueImg?.size.height)!/3)
        instructionQueButP1.setImage(instructionQueImg, for: .normal)
        instructionQueButP1.addTarget(self, action: #selector(GameScene0.popUpP1), for: .touchUpInside)
        self.view?.addSubview(instructionQueButP1)
        //add gc
        let gcButtonImage = UIImage(named: "scoreboard") as UIImage?
        gcButtonP1.removeFromSuperview()
        gcButtonP1 = UIButton(type: UIButtonType.custom) as UIButton
        gcButtonP1.frame = CGRect(x: 20 + (gcButtonImage?.size.width)!/3 , y: self.size.height - 10 - (gcButtonImage?.size.height)!/3, width: (gcButtonImage?.size.width)!/3, height: (gcButtonImage?.size.height)!/3)
        gcButtonP1.setImage(gcButtonImage, for: .normal)
        gcButtonP1.addTarget(self, action: #selector(GameScene0.showGCP2), for: .touchUpInside)
        self.view?.addSubview(gcButtonP1)

        s2 = playlatinHorn2()
        s2?.numberOfLoops = -1
        s2?.play()

    }

    var customViewP1 = UIView()
    var backButtonP1 = UIButton()
    var instructionP1 = UIImageView()

    func popUpP1()
    {
        //add custom uiview for popup
        customViewP1.removeFromSuperview()
        customViewP1 = UIView(frame: CGRect(x: 50, y: 50, width: self.size.width - 100 , height: self.size.height - 100))
        customViewP1.backgroundColor = UIColor.init(red: 196/255, green: 113/255, blue: 245/255, alpha: 255/255)
        //add image in uiview
        instructionP1.removeFromSuperview()
        instructionP1 = UIImageView(frame:CGRect(x: 50, y: 50, width: self.size.width - 100 , height: self.size.height - 100))
        instructionP1.image = UIImage(named: "instruction2")!
        self.view?.addSubview(customViewP1)
        self.view?.addSubview(instructionP1)
        // add back button
        let backButtonImg = UIImage(named: "close") as UIImage?
        backButtonP1.removeFromSuperview()
        backButtonP1   = UIButton(type: UIButtonType.custom) as UIButton
        backButtonP1.frame =  CGRect(x: 10, y: 10, width: (backButtonImg?.size.width)!/3, height: (backButtonImg?.size.height)!/3)
        backButtonP1.setImage(backButtonImg, for: .normal)
        backButtonP1.removeFromSuperview()
        backButtonP1.addTarget(self, action: #selector(GameScene0.closeViewP1), for: .touchUpInside)
        self.view?.addSubview(backButtonP1)
    }

    func closeViewP1(sender:UIButton)
    {
        customViewP1.removeFromSuperview()
        backButtonP1.removeFromSuperview()
        instructionP1.removeFromSuperview()
    }

    func saveHS2(number: Int){
        if GKLocalPlayer.localPlayer().isAuthenticated{
            let scoreReport = GKScore(leaderboardIdentifier: "HS")
            scoreReport.value = Int64(number)
            let scoreArray: [GKScore] = [scoreReport]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }

    func showGCP2(){

        let VC1 = self.view?.window?.rootViewController
        let GCVC1 = GKGameCenterViewController()
        GCVC1.gameCenterDelegate = self
        VC1?.present(GCVC1, animated: true, completion: nil)

        let userDefaults = UserDefaults.standard
        let highscore8 = userDefaults.value(forKey: "highscore")
        saveHS2(number: highscore8 as! Int)
    }
    func authPlayer2() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (view, error) in
            if  view != nil {
                let VC = self.view?.window?.rootViewController
                VC?.present(view!, animated: true, completion: nil)
            }else {
                print(GKLocalPlayer.localPlayer().isAuthenticated)
            }
        }
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
    func page1(){
        s2?.stop()
        labelVogel.removeFromSuperview()
        labelHiScore2.removeFromSuperview()
        playButton.removeFromSuperview()
        gcButtonP1.removeFromSuperview()
        instructionQueButP1.removeFromSuperview()

        let scene = GameScene(size: (view?.bounds.size)!)
        let skView = self.view
        skView?.showsFPS = false
        skView?.showsNodeCount = false
        skView?.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView?.presentScene(scene)
    }

//    func playlatinHorn2() -> AVAudioPlayer {
//
//        guard let sound = NSDataAsset(name: "intro1") else {
//            //print("sound asset not found")
//            return player!
//        }
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
//        } catch let error as NSError {
//            print("error: \(error.localizedDescription)")
//        }
//        return player!
//    }
    var audioPlayer = AVAudioPlayer()
    func playlatinHorn2() -> AVAudioPlayer {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "intro1", ofType: "wav")!))
            audioPlayer.prepareToPlay()
        }catch let error as NSError{
            print("error: \(error.localizedDescription)")
        }
        return audioPlayer
    }


}
