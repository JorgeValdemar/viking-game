//
//  GameScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

class GameScene: CCScene, CCPhysicsCollisionDelegate {

    var physicsWorld:CCPhysicsNode = CCPhysicsNode()
	let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    let bg:CCSprite = CCSprite(imageNamed: "bgCenario.png")
    var energyBar = EnergyBar(imageNamed: "energiaVerde.png", life: 3.0)
    var player:Player = Player(imageNamed: "player.png")
    var scoreLabel:CCLabelTTF = CCLabelTTF(string: "Score: 0", fontName: "Times new Roman", fontSize: 30.0)
    var scoreValue:Int = 0
	var canPlay:Bool = true
    var canTap:Bool = true
    var powerUp:Bool = false
    var enemyAmount:Int = 1
    var enemyDelay:Int = 3
    
	override init() {
		super.init()
        
        // Define o mundo
        self.physicsWorld.gravity = CGPointZero
        self.physicsWorld.collisionDelegate = self
        self.addChild(self.physicsWorld)
        
        //Background
        bg.position = CGPointMake(self.screenSize.width, self.screenSize.height)
        bg.anchorPoint = CGPointMake(1.0, 1.0)
        self.physicsWorld.addChild(bg)
        
        //Barra de energia
        energyBar.position = CGPointMake(0.0, 0.0)
        energyBar.anchorPoint = CGPointMake(0.0, 0.0)
        self.physicsWorld.addChild(energyBar)
        
        //Posicionando o Viking
        player.anchorPoint = CGPointMake(0.0, 0.0)
        player.position = CGPointMake(0, self.screenSize.height/2)
        self.physicsWorld.addChild(player)
        
        // Back button
        let backButton:CCButton = CCButton(title: "[ Quit ]", fontName: "Verdana-Bold", fontSize: 26.0)
        backButton.position = CGPointMake(self.screenSize.width-10, self.screenSize.height-10)
        backButton.anchorPoint = CGPointMake(1.0, 1.0)
        backButton.color = CCColor.blackColor()
        backButton.zoomWhenHighlighted = false
        backButton.block = {_ in StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade:true)}
        self.physicsWorld.addChild(backButton)
        
        // Pause button
        let pauseButton:CCButton = CCButton(title: "[ Pause ]", fontName: "Verdana-Bold", fontSize: 26.0)
        pauseButton.position = CGPointMake(self.screenSize.width-130, self.screenSize.height-10)
        pauseButton.anchorPoint = CGPointMake(1.0, 1.0)
        pauseButton.color = CCColor.blackColor()
        pauseButton.zoomWhenHighlighted = false
        self.physicsWorld.addChild(pauseButton)
        
		//Score label
		scoreLabel.color = CCColor.blackColor()
        scoreLabel.position = CGPointMake(self.screenSize.width/2, self.screenSize.height-10)
		scoreLabel.anchorPoint = CGPointMake(1.0, 1.0)
		self.physicsWorld.addChild(scoreLabel)
        
        //Habilita o toque na tela
        self.userInteractionEnabled = true
        
        DelayHelper.sharedInstance.callFunc("createEnemys", onTarget: self, withDelay: 0.5)
        
	}
    
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        if(self.canPlay){
            let touchLocation:CGPoint = CCDirector.sharedDirector().convertTouchToGL(touch)
            self.createAxe(touchLocation)
        }else{
            SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.SoundFXButtonTap)
            StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade: true)
        }
    }
    
	override func onEnter() {
		super.onEnter()
	}

	override func update(delta: CCTime) {
        
        if(self.canPlay){
            if(50 == self.scoreValue){
                self.enemyAmount = 3
                self.enemyDelay = 2
            }
        }
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
        let axe:Axe = Axe(imageNamed: "tiro.png", andDamage: 2.0)
        axe.position = self.player.position
        axe.runAction(rotate)
        axe.runAction(CCActionSequence.actionOne(moveTo as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
            axe.removeFromParentAndCleanup(true)
        }) as! CCActionFiniteTime) as! CCAction)
        self.physicsWorld.addChild(axe, z:ObjectsLayers.Shot.rawValue)
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
                    self.createEnemyWithAnimation(10001, plistName: "PirataPerneta.plist", textureFile: "PirataPerneta.png", enemyLife: 3.0, enemySpeed: 6.0)
                }else{
                    self.createEnemyWithAnimation(20001, plistName: "PirataPeixe.plist", textureFile: "PirataPeixe.png", enemyLife: 7.0, enemySpeed: 3.0)
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
        enemy.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
        enemy.physicsBody.type = CCPhysicsBodyType.Kinematic
        enemy.physicsBody.friction = 1.0
        enemy.physicsBody.elasticity = 0.1
        enemy.physicsBody.mass = 100.0
        enemy.physicsBody.density = 100.0
        enemy.physicsBody.collisionType = "Enemy"
        enemy.physicsBody.collisionCategories = ["Enemy"]
        enemy.physicsBody.collisionMask = ["Axe", "EnergyBar"]
        
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
        
        self.physicsWorld.addChild(enemy, z:ObjectsLayers.Foes.rawValue)
        enemy.runAction(CCActionSequence.actionOne(moveTo as! CCActionFiniteTime, two: CCActionCallBlock.actionWithBlock({ _ in
            	enemy.removeFromParentAndCleanup(true)
            }) as! CCActionFiniteTime) as! CCAction)
    }
    
    //Controle da colisao entre o machado e os piratas inimigos
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, Axe anAxe:Axe!, Enemy anEnemy:Enemy!) -> Bool {
        
        anEnemy.life -= anAxe.damage
        
        if(0 >= anEnemy.life){
            SoundPlayHelper.sharedInstance.playSoundWithControl(GameMusicAndSoundFx.SoundFXPuf)
            self.createParticle(anEnemy.position)
            self.generatePowerUp(anEnemy.position)
            anEnemy.removeFromParentAndCleanup(true)
            self.updateScore()
        }
        anAxe.removeFromParentAndCleanup(true)
        return true
    }
    
    //Controle da colisao entre o machado e os piratas inimigos
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, EnergyBar energyBar:EnergyBar!, Enemy anEnemy:Enemy!) -> Bool {
        
        self.energyBar.life -= 1
        
        if(2 == self.energyBar.life){
            self.energyBar.texture = EnergyBar.spriteWithImageNamed("energiaAmarela.png").texture
        }
        
        else if(1 == self.energyBar.life){
            self.energyBar.texture = EnergyBar.spriteWithImageNamed("energiaVermelha.png").texture
        }
            
        else if(0 >= self.energyBar.life){
            self.gameOver()
        }
        
        return true
    }
    
    //Cria as particulas
    func createParticle(position:CGPoint){
        var particle:CCParticleSystem = CCParticleExplosion(totalParticles: 3)
        particle.texture = CCSprite.spriteWithImageNamed("fire.png").texture
        particle.color = CCColor.redColor()
        particle.startColor = CCColor.redColor()
        particle.endColor = CCColor.redColor()
        particle.position = position
        particle.autoRemoveOnFinish = true
        self.addChild(particle, z:ObjectsLayers.Player.rawValue)
    }
    
    //Atualiza a pontuacao
    func updateScore(){
        self.scoreValue += 1
        self.scoreLabel.string = "Score: \(self.scoreValue)"
    }
    
    //Gera aleatoriamente o PowerUp
    func generatePowerUp(position:CGPoint){
    
        let randomPower:Int = Int(arc4random_uniform(10))
        if(!self.powerUp && 1 == randomPower){
            let powerUp:PowerUp = PowerUp(imageNamed: "powerUP.png")
            powerUp.position = position
            self.physicsWorld.addChild(powerUp)
        }
    }
    
    //Game over
    func gameOver(){
        self.canPlay = false
        
        // Cancela todas as acoes na cena
        self.stopAllActions()
        
        // Registra o novo best score caso haja
        ScoreHelper.sharedInstance.setScore(self.scoreValue)
        
        // Exibe o texto para retry
        let label:CCLabelTTF = CCLabelTTF(string:"_== GAME OVER ==_", fontName:"Times New Roman", fontSize:60.0)
        label.color = CCColor.redColor()
        label.position = CGPointMake(self.screenSize.width/2, self.screenSize.height/2)
        label.anchorPoint = CGPointMake(0.5, 0.5)
        
        let subLabel:CCLabelTTF = CCLabelTTF(string:"Tap to restart", fontName:"Times New Roman", fontSize:45.0)
        subLabel.color = CCColor.redColor()
        subLabel.position = CGPointMake(self.screenSize.width/2, (self.screenSize.height/2) - 55)
        subLabel.anchorPoint = CGPointMake(0.5, 0.5)
        
        self.addChild(label, z: 4)
        self.addChild(subLabel, z: 4)
    }
    
    
}
