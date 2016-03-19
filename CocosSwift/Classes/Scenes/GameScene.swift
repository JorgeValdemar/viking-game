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
    private var scoreValue:Int = 0
	private var canPlay:Bool = true
    private var canTap:Bool = true
    private var enemyAmount:Int = 1
    private var enemyDelay:Int = 3
    
	override init() {
		super.init()
        
        //Background
        bg.position = CGPointMake(self.screenSize.width, self.screenSize.height)
        bg.anchorPoint = CGPointMake(1.0, 1.0)
        self.addChild(bg)
        
        //Barra de energia
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
        
        DelayHelper.sharedInstance.callFunc("createEnemys", onTarget: self, withDelay: 0.5)
        
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
        axe.runAction(CCActionSequence.actionOne(moveTo as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
            axe.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime) as! CCAction)
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
    
    //Cria aleatoriamente os inimigos
    func createEnemys(){
        
        if (self.canPlay) {
            
            for (var i = 0; i < self.enemyAmount; i++) {
                
                let enemyIndex:Int = Int(arc4random_uniform(10))
                if(enemyIndex <= 7){
                    self.createEnemyWithAnimation(10001, plistName: "PirataPerneta-ipad.plist", textureFile: "PirataPerneta-ipad.png", enemyLife: 3.0, enemySpeed: 6.0)
                }else{
                    self.createEnemyWithAnimation(20001, plistName: "PirataPeixe-ipad.plist", textureFile: "PirataPeixe-ipad.png", enemyLife: 7.0, enemySpeed: 3.0)
                }
            }
            
            DelayHelper.sharedInstance.callFunc("createEnemys", onTarget: self, withDelay: 3.0)
        }
    }
    
    //Cria os inimigos com animacao e movimentacao
    func createEnemyWithAnimation(indexImage:Int, plistName:String, textureFile:String, enemyLife:CGFloat, enemySpeed:CGFloat){
        
        CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile(plistName, textureFilename: textureFile)
        var animFrames:Array<CCSpriteFrame> = Array()
        
        for (var i = indexImage; i <= indexImage+17; i++) {
            let name:String = "Pirata \(i).png"
            let pirataPernetaFrame:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed(name) as! CCSpriteFrame
            animFrames.append(pirataPernetaFrame)
        }
        
        //Cria as acoes
        let animation:CCAnimation = CCAnimation(spriteFrames: animFrames, delay: 0.06)
        let animationAction:CCActionAnimate = CCActionAnimate(animation: animation)
        let actionForever:CCActionRepeatForever = CCActionRepeatForever(action: animationAction)
        let ccFrameName:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("Pirata \(indexImage).png") as! CCSpriteFrame
        let enemy:Enemy = Enemy.spriteWithSpriteFrame(ccFrameName) as! Enemy
        enemy.life = enemyLife
        enemy.speed = enemySpeed
        
        //Cria o ponto Y aleatorio
        let minScreenY:CGFloat = enemy.boundingBox().size.height
        let maxScreenY:UInt32 = UInt32(screenSize.height - (enemy.boundingBox().size.height + minScreenY))
        let yPosition:CGFloat = minScreenY + CGFloat(arc4random_uniform(maxScreenY))
        
        //Cria o movimento
        let finalPoint:CGPoint = CGPointMake(0.0, yPosition)
        let moveTo:CCAction = CCActionMoveTo.actionWithDuration(CCTime(enemy.speed), position: finalPoint) as! CCAction
        
        
        //Atribui os valores ao enemy
        enemy.position = CGPointMake(self.screenSize.width, yPosition)
        enemy.anchorPoint = CGPointMake(0.5, 0.5)
        enemy.runAction(actionForever)
        
        self.addChild(enemy)
        enemy.runAction(CCActionSequence.actionOne(moveTo as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
            	enemy.removeFromParentAndCleanup(true)
            }) as! CCActionFiniteTime) as! CCAction)
        
    }
    
    
}
