//
//  RandomNumberGenerator.swift
//  FlappyBirdGame
//
//  Created by Pragun Sharma on 27/06/17.
//  Copyright © 2017 Pragun Sharma. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    
    public static func randomNumberFunction() -> CGFloat {
        
        return CGFloat(Float(arc4random())) / 0xFFFFFFFF
    }
    
    public static func randomRange(min : CGFloat, max: CGFloat) -> CGFloat {
        
        return CGFloat.randomNumberFunction() * (max-min) + min
    }
}
