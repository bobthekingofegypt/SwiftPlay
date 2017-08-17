//
//  CirclePointView.swift
//  SwiftPlay
//
//  Created by Richard Martin on 07/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit

class CirclePointView: UIView {
    var color: UIColor!
    
    init(color: UIColor) {
        super.init(frame: CGRect.zero)
        self.color = color
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(rect)
        
        ctx.addEllipse(in: rect)
        ctx.setFillColor(color.cgColor)
        ctx.fillPath()
        
        ctx.addEllipse(in: rect.insetBy(dx: 2.5, dy: 2.5))
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillPath()
    }

}
