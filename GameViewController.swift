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


class GameViewController: UIViewController {

    @IBOutlet weak var vogelLable: UILabel!

    @IBOutlet weak var background: SKView!
    @IBOutlet weak var highScoreLabel: UILabel!

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
        

    }
var buttt = false

    @IBAction func fly(_ sender: UIButton) {

        vogelLable.removeFromSuperview()
        highScoreLabel.removeFromSuperview()
        sender.removeFromSuperview()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        buttt = true
           }

    @IBOutlet var skdlj: SKView!
    @IBAction func tap2s(_ sender: UITapGestureRecognizer) {
        print("sdjfkj")
    }
    }






