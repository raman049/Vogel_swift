//
//  GameViewController.swift
//  Vogel
//
//  Created by raman maharjan on 12/28/16.
//  Copyright © 2016 raman maharjan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {


    var player: AVAudioPlayer?
    var s1: AVAudioPlayer?
    @IBOutlet var backgroundRed: [SKView]!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //for red background
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene2(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        s1 = scene.playSound()
        s1?.numberOfLoops = -1
        //s1?.play()
    }
}






