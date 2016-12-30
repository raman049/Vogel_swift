//
//  GameScene.swift
//  Vogel
//
//  Created by raman maharjan on 12/28/16.
//  Copyright © 2016 raman maharjan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    let wave = SKSpriteNode(imageNamed: "wave2")
    let sun = SKSpriteNode(imageNamed: "sun")

    override func didMove(to view: SKView) {

        backgroundColor = UIColor.init(red: 153/255, green: 204/255, blue: 1, alpha: 1.0)
        let waveSz = CGSize(width: wave.size.width/2, height: wave.size.height/2)
        wave.scale(to: waveSz)

        wave.position = CGPoint(x: (Int) (wave.size.width/2)  , y: (Int) (wave.size.height/2))
        addChild(wave)
        //  wave.position = CGPoint(x: 0 + wave.size.width/2 * 3 , y:  wave.size.height/2)
       // addChild(wave)


        let sunSz = CGSize(width: 100, height: 100)
        sun.scale(to: sunSz)
        sun.position = CGPoint(x: size.width - sun.size.width - 5, y: size.height - sun.size.height)
        addChild(sun)

    }

}
