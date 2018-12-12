//
//  GradientLayer.swift
//  ipas
//
//  Created by 韋儒朱 on 2018/12/12.
//  Copyright © 2018 韋儒朱. All rights reserved.
//

import UIKit

class Colors {
    let colorStart = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
    let colorEnd = UIColor(red: 34.0/255.0, green: 116.0/255.0, blue: 165.0/255.0, alpha: 1.0).cgColor
    
    let gl: CAGradientLayer
    
    init() {
        gl = CAGradientLayer()
        gl.colors = [colorStart, colorEnd]
        gl.locations = [0.0 , 1.0]
        gl.startPoint = CGPoint(x: 0.0, y: 1.0)
        gl.endPoint = CGPoint(x: 1.0, y: 0.0)

    }
}
