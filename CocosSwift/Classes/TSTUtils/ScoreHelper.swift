//
//  ScoreHelper.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 12/03/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

import Foundation

class ScoreHelper {
    
    // MARK: - Singleton
    class var sharedInstance:ScoreHelper {
        struct Static {
            static var instance: ScoreHelper?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ScoreHelper()
        }
        
        return Static.instance!
    }

    
    
    func getScore() -> Int {
        
        return 0
    }
    
    func setScore(newScore:Int) {
        score:Int = self.getScore()
        
        
    }
    
}
