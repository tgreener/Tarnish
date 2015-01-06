//
//  GameViewController.swift
//  Tarnish
//
//  Created by Todd Greener on 1/5/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//
import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func loadView() {
        super.loadView();
        
        let gameView : SKView = SKView(frame: UIScreen.mainScreen().bounds)
        
        self.view = gameView;
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let spriteView : SKView = self.view as SKView
        spriteView.showsNodeCount = true
        spriteView.showsFPS = true
        spriteView.ignoresSiblingOrder = true
        
        let helloScene : TitleScene = TitleScene()
        
        spriteView.presentScene(helloScene)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
