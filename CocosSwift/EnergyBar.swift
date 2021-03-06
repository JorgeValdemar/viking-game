//
//  EnergyBar.swift
//  CocosSwift
//
//  Created by rsekine on 3/19/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//
class EnergyBar : CCSprite {
    
    var life:CGFloat = 0.0
    
    override init() {
        super.init()
    }
    
    override init(CGImage image: CGImage!, key: String!) {
        super.init(CGImage: image, key: key)
    }
    
    override init(spriteFrame: CCSpriteFrame!) {
        super.init(spriteFrame: spriteFrame)
    }
    
    override init(texture: CCTexture!) {
        super.init(texture: texture)
    }
    
    override init(texture: CCTexture!, rect: CGRect) {
        super.init(texture: texture, rect: rect)
    }
    
    override init(texture: CCTexture!, rect: CGRect, rotated: Bool) {
        super.init(texture: texture, rect: rect, rotated: rotated)
    }
    
    override init(imageNamed imageName: String!) {
        super.init(imageNamed: imageName)
    }
    
    convenience init(imageNamed imageName: String!, life:CGFloat){
        self.init(imageNamed: imageName)
        self.life = life
        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
        self.physicsBody.type = CCPhysicsBodyType.Kinematic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 100.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "EnergyBar"
        self.physicsBody.collisionCategories = ["EnergyBar"]
        self.physicsBody.collisionMask = ["Enemy"]
    }
    
    override func onEnter() {
        // Chamado apos o init quando entra no director
        super.onEnter()
    }
    
    deinit {
        // Chamado no momento de desalocacao
    }
}