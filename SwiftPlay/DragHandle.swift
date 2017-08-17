//
//  SeparatorView.swift
//  SwiftPlay
//
//  Created by Richard Martin on 04/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit
import SnapKit

protocol DragHandleTouchDelegate {
    func dragHandleTouchBegan(dragHandle: DragHandle, touch: UITouch)
    func dragHandleTouchMoved(dragHandle: DragHandle, touch: UITouch)
    func dragHandleTouchEnded(dragHandle: DragHandle, touch: UITouch)
}

class DragHandle: UIView {
    var delegate: DragHandleTouchDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        self.isUserInteractionEnabled = true
        self.backgroundColor = .black
        
        let indicatorView = UIView()
        self.addSubview(indicatorView)
        indicatorView.layer.cornerRadius = 1
        indicatorView.backgroundColor = UIColor.gray
        indicatorView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(20)
            make.height.equalTo(2)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.dragHandleTouchBegan(dragHandle: self, touch: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let event = event else { return }
        
        if let predictedTouch = event.predictedTouches(for: touch)?.last {
            delegate?.dragHandleTouchMoved(dragHandle: self, touch: predictedTouch)
            return
        }
        
        delegate?.dragHandleTouchMoved(dragHandle: self, touch: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.dragHandleTouchEnded(dragHandle: self, touch: touch)
    }
}
