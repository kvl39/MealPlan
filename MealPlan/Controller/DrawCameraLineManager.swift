//
//  DrawCameraLineManager.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/25.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class DrawCameraLineManager {
    
    func addCameraLines(on layer: CALayer) {
        let cameraWidth = UIScreen.main.bounds.height - 150
        let cameraHeight = UIScreen.main.bounds.width
        
        drawOneLine(on: layer,
                    startPoint: CGPoint(x: 0, y: cameraHeight/3),
                    stopPoint: CGPoint(x: cameraWidth, y: cameraHeight/3), color: UIColor.white.cgColor)
        drawOneLine(on: layer,
                    startPoint: CGPoint(x: 0, y: cameraHeight*2/3),
                    stopPoint: CGPoint(x: cameraWidth, y: cameraHeight*2/3), color: UIColor.white.cgColor)
        drawOneLine(on: layer,
                    startPoint: CGPoint(x: cameraWidth/3, y: 0),
                    stopPoint: CGPoint(x: cameraWidth/3, y: cameraHeight), color: UIColor.white.cgColor)
        drawOneLine(on: layer,
                    startPoint: CGPoint(x: cameraWidth*2/3, y: 0),
                    stopPoint: CGPoint(x: cameraWidth*2/3, y: cameraHeight), color: UIColor.white.cgColor)
    }
    
    func drawOneLine(on layer: CALayer, startPoint: CGPoint, stopPoint: CGPoint, color: CGColor)           -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: stopPoint)
        line.path = linePath.cgPath
        line.strokeColor = color
        line.lineWidth = 1
        line.lineJoin = kCALineJoinRound
        layer.addSublayer(line)
        return line
    }
}
