//
//  HomeScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

// MARK: - Class Definition
class HomeScene : CCScene {
	// MARK: - Public Objects

	// MARK: - Private Objects
	private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    private let bgHome:CCSprite = CCSprite(imageNamed: "bgCenario.png")
    private let backImageViking:CCSprite = CCSprite(imageNamed: "player.png")

	// MARK: - Life Cycle
	override init() {
		super.init()

        bgHome.position = CGPointMake(self.screenSize.width, self.screenSize.height)
        bgHome.anchorPoint = CGPointMake(1.0, 1.0)
        self.addChild(bgHome)
        
        //Criacao das imagens da tela inicial
        backImageViking.position = CGPointMake(0.0, 150)
        backImageViking.anchorPoint = CGPointMake(0.0, 0.0)
        backImageViking.scale = 3.0
        self.addChild(backImageViking)
        
        CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("PirataPerneta.plist", textureFilename: "PirataPerneta.png")
        let ccFrameName:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("Pirata 10001.png") as! CCSpriteFrame
        let backImagePirataPerneta:CCSprite = CCSprite.spriteWithSpriteFrame(ccFrameName) as! CCSprite
        backImagePirataPerneta.position = CGPointMake(self.screenSize.width/2+200, self.screenSize.height/2)
        backImagePirataPerneta.scale = 2.5
        self.addChild(backImagePirataPerneta)
        
        CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("PirataPeixe.plist", textureFilename: "PirataPeixe.png")
        let ccFrameName2:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("Pirata 20001.png") as! CCSpriteFrame
        let backImagePirataPeixe:CCSprite = CCSprite.spriteWithSpriteFrame(ccFrameName2) as! CCSprite
        backImagePirataPeixe.position = CGPointMake(self.screenSize.width/2, self.screenSize.height/2-200)
        backImagePirataPeixe.scale = 2.5
        self.addChild(backImagePirataPeixe)
        //

		//Title
		let label:CCLabelTTF = CCLabelTTF(string: "The Ultimate Viking", fontName: "Times New Roman", fontSize: 100.0)
		label.color = CCColor.blackColor()
        label.position = CGPointMake(self.screenSize.width/2, self.screenSize.height/2 + 200)
		label.anchorPoint = CGPointMake(0.5, 0.5)
		self.addChild(label)

		// ToGame Button
		let toGameButton:CCButton = CCButton(title: "[ Start ]", fontName: "Verdana-Bold", fontSize: 38.0)
        toGameButton.color = CCColor.blackColor()
		toGameButton.position = CGPointMake(self.screenSize.width/2.0, self.screenSize.height/2.0)
		toGameButton.anchorPoint = CGPointMake(0.5, 0.5)
		toGameButton.block = {_ in StateMachine.sharedInstance.changeScene(StateMachineScenes.GameScene, isFade:true)}
		self.addChild(toGameButton)
        
        //Best Score
        let score:Int = ScoreHelper.sharedInstance.getScore()
        let bestScore:CCLabelTTF = CCLabelTTF(string: "Best Score: \(score)", fontName: "Times New Roman", fontSize: 36.0)
        bestScore.color = CCColor.blackColor()
        bestScore.position = CGPointMake(self.screenSize.width/2, 50)
        bestScore.anchorPoint = CGPointMake(0.5, 0.5)
        
        SoundPlayHelper.sharedInstance.playMusicWithControl(GameMusicAndSoundFx.MusicInGame, withLoop: true)
        
        self.addChild(bestScore)
	}

	override func onEnter() {
		// Chamado apos o init quando entra no director
		super.onEnter()
	}

	// MARK: - Death Cycle
	override func onExit() {
		// Chamado quando sai do director
		super.onExit()
	}
}
