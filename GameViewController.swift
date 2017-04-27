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
import Firebase;
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate {


    var player: AVAudioPlayer?
    var s1: AVAudioPlayer?
    @IBOutlet var backgroundRed: [SKView]!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //for red background
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene0(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)

    }
    
}





