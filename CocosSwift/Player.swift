//
//  Player.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 05/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import Foundation

class Player : CCSprite {

    override init() {
        super.init()
    }
    
    override init(imageNamed imageName: String!) {
        super.init(imageNamed: imageName)
        
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
    
    override func onEnter() {
        // Chamado apos o init quando entra no director
        super.onEnter()
    }
    
    deinit {
        // Chamado no momento de desalocacao
    }
}
