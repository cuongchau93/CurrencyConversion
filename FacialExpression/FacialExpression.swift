//
//  FacialExpression.swift
//  SimpleSwiftApp
//
//  Created by Chau, Cuong | DCMS on 2020/11/01.
//  Copyright © 2020 Chau, Cuong | DCMS. All rights reserved.
//

import Foundation

struct FacialExpression {
    
    let eyes: Eyes
    let mouth: Mouth
    
    enum Eyes: Int {
        case open
        case close
        case squinting
    }
    
    enum Mouth: Int {
        case frown
        case smirk
        case neutral
        case grin
        case smile
        
        var sadder: Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }

        var happier: Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
    
    var sadder: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    var happier: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
}
