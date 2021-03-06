//
//  Enemy.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 12/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//
class Enemy : CCSprite {

    var life:CGFloat = 3.0
    var speed:CGFloat = 7.0
    
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
    
    override func onEnter() {
        // Chamado apos o init quando entra no director
        super.onEnter()
    }
    
    deinit {
        // Chamado no momento de desalocacao
    }
}