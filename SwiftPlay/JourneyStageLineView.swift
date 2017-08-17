//
//  JourneyStageLineView.swift
//  SwiftPlay
//
//  Created by Richard Martin on 07/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit

class JourneyStageLineView: UIView {
    var type: TransportType?
    var stage: TravelStage?
    
    func set(type: TransportType, stage: TravelStage) {
        self.type = type
        self.stage = stage
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let type = type else {
            return;
        }
        guard let stage = stage else {
            return;
        }
        
        let ctx = UIGraphicsGetCurrentContext()!;
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(rect)
        
        switch (type) {
        case .walk:
            drawDottedLine(rect)
        default:
            drawGrayLine(rect, stage: stage)
        }
    }
    
    private func drawDottedLine(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: (self.frame.width/2), y: 5))
        path.addLine(to: CGPoint(x: (self.frame.width/2), y: rect.height))
        path.lineWidth = 3
        
        let dashes: [CGFloat] = [path.lineWidth * 0, path.lineWidth * 2]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.round
        
        let gray = UIColor(red: 181/255, green: 182/255, blue: 183/255, alpha: 1.0)
        
        let ctx = UIGraphicsGetCurrentContext()!;
        ctx.setStrokeColor(gray.cgColor)
        path.stroke()
    }
    
    private func drawGrayLine(_ rect: CGRect, stage: TravelStage) {
        let gray = UIColor(red: 181/255, green: 182/255, blue: 183/255, alpha: 1.0)
        
        let ctx = UIGraphicsGetCurrentContext()!;
        ctx.setStrokeColor(gray.cgColor)
        ctx.setLineWidth(3)
        ctx.setLineCap(.round)
        ctx.move(to: CGPoint(x: (self.frame.width/2), y: 5))
        ctx.addLine(to: CGPoint(x: (self.frame.width/2), y: rect.height - 7))
        ctx.strokePath();
        
        if (stage == .normal || stage == .begining) {
            ctx.addEllipse(in: CGRect(x: (self.frame.width/2)-3, y: rect.height - 7, width: 6, height: 6))
            ctx.setStrokeColor(gray.cgColor)
            ctx.setLineWidth(1)
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.drawPath(using: .eoFillStroke)
        } else {
            let circleRect = CGRect(x: (self.frame.width/2)-4, y: rect.height - 8, width: 8, height: 8)
            ctx.addEllipse(in: circleRect)
            ctx.setFillColor(Constants.Colors.LightBlue.cgColor)
            ctx.fillPath()
            
            ctx.addEllipse(in: circleRect.insetBy(dx: 2.5, dy: 2.5))
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.fillPath()
        }
    }

}
