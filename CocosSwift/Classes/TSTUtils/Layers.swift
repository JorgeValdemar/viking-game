	//
//  Layers.swift
//  CocosSwift
//
//  Created by rsekine on 3/18/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    
// Layers dos objetos
enum ObjectsLayers:Int {
    case HUD = 5
    case Shot = 4
    case Player = 3
    case Foes = 2
    case Background = 1
}

