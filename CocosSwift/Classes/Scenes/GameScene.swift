//
//  GameScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

class GameScene: CCScene {

	private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    private let bg:CCSprite = CCSprite(imageNamed: "bgCenario-ipad.png")
    private var energyBar = CCSprite(imageNamed: "energiaVerde-ipad.png")
    
    private var player:Player = Player(imageNamed: "player-ipad.png")
    private var score:CCLabelTTF = CCLabelTTF(string: "Score:", fontName: "Times new Roman", fontSize: 30.0)
	
	// MARK: - Life Cycle
	override init() {
		super.init()
        
        bg.position = CGPointMake(self.screenSize.width, self.screenSize.height)
        bg.anchorPoint = CGPointMake(1.0, 1.0)
        self.addChild(bg)
        
        energyBar.position = CGPointMake(0.0, 0.0)
        energyBar.anchorPoint = CGPointMake(0.0, 0.0)
        self.addChild(energyBar)
        
        //Posicionando o Viking
        player.anchorPoint = CGPointMake(0.0, 0.0)
        player.position = CGPointMake(0, self.screenSize.height/2)
        self.addChild(player)
        
        // Back button
        let backButton:CCButton = CCButton(title: "[ Quit ]", fontName: "Verdana-Bold", fontSize: 26.0)
        backButton.position = CGPointMake(self.screenSize.width-10, self.screenSize.height-10)
        backButton.anchorPoint = CGPointMake(1.0, 1.0)
        backButton.color = CCColor.blackColor()
        backButton.zoomWhenHighlighted = false
        backButton.block = {_ in StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade:true)}
        self.addChild(backButton)
        
        // Pause button
        let pauseButton:CCButton = CCButton(title: "[ Pause ]", fontName: "Verdana-Bold", fontSize: 26.0)
        pauseButton.position = CGPointMake(self.screenSize.width-130, self.screenSize.height-10)
        pauseButton.anchorPoint = CGPointMake(1.0, 1.0)
        pauseButton.color = CCColor.blackColor()
        pauseButton.zoomWhenHighlighted = false
        self.addChild(pauseButton)
        
		//Score label
		score.color = CCColor.blackColor()
        score.position = CGPointMake(self.screenSize.width/2, self.screenSize.height-10)
		score.anchorPoint = CGPointMake(1.0, 1.0)
		self.addChild(score)
        
        //Habilita o toque na tela
        self.userInteractionEnabled = true
    
	}
    
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        
        let touchLocation:CGPoint = CCDirector.sharedDirector().convertTouchToGL(touch)
        self.createAxe(touchLocation)
        
    }
    
	override func onEnter() {
		super.onEnter()
	}

	override func update(delta: CCTime) {

	}

	override func onExit() {
		super.onExit()
	}
    
    
    //===================== CUSTOM FUNCTIONS =====================//
    
    //Cria o machado
    func createAxe(touchLocation: CGPoint){
    
        //Calcula o ponto final do machado
        let finalPoint:CGPoint = self.getFinalPoint(touchLocation)
        
        //Calcula a velocidade do machado
        let velocity:CCTime = self.getVelocity(finalPoint.x)
        
        //Actions
        let rotate:CCAction = CCActionRepeatForever.actionWithAction(CCActionRotateBy.actionWithDuration(1, angle: 180) as! CCActionInterval) as! CCAction;
        let moveTo:CCAction = CCActionMoveTo.actionWithDuration(velocity, position: finalPoint) as! CCAction
        
        //Cria o machado e adiciona as acoes
        let axe:Axe = Axe(imageNamed: "tiro-ipad.png", andDamage: 1.0)
        axe.name = "Axe"
        axe.position = self.player.position
        self.addChild(axe)
        axe.runAction(rotate)
        axe.runAction(moveTo)
    }
    
    //Calcula o ponto final do machado
    func getFinalPoint(touchLocation: CGPoint) -> CGPoint{
        
        var finalPoint:CGPoint = CGPointMake(0.0, 0.0)
        
        let coeficienteAngular:CGFloat = (touchLocation.y - self.player.position.y) / touchLocation.x;
        let zero:CGFloat = CGFloat(0.0)
        
        if(coeficienteAngular > zero){
            let x:CGFloat = (self.screenSize.height - self.player.position.y) / coeficienteAngular
            let y:CGFloat = (x * coeficienteAngular) + self.player.position.y
            finalPoint.x = x
            finalPoint.y = y
        }
        
        if(coeficienteAngular == zero){
            finalPoint.x = self.screenSize.width
            finalPoint.y = self.player.position.y
        }
        
        if(coeficienteAngular < zero){
            let x:CGFloat = (-self.player.position.y) / coeficienteAngular
            let y:CGFloat = (x * coeficienteAngular) + self.player.position.y
            finalPoint.x = x
            finalPoint.y = y
        }
        return finalPoint
    }
    
    //Calcula a velocidade do machado
    func getVelocity(finalPointX:CGFloat) -> CCTime {
        
        let defaultTime:CGFloat = 2.0
        let defaultWidth:CGFloat = self.screenSize.width
        let velocity:CGFloat = (defaultTime * finalPointX) / defaultWidth
        
        let finalVelocity:CCTime = CCTime(velocity)
        
        return finalVelocity
    
    }
    
}