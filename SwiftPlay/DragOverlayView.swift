//
//  DragOverlayView.swift
//  SwiftPlay
//
//  Created by Richard Martin on 13/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit

protocol DragOverlayTouchDelegate {
    func dragOverlayTouchBegan(dragOverlay: DragOverlayView, touch: UITouch)
    func dragOverlayTouchMoved(dragOverlay: DragOverlayView, touch: UITouch)
    func dragOverlayTouchEnded(dragOverlay: DragOverlayView, touch: UITouch)
}

class DragOverlayView: UIView {
    var delegate: DragOverlayTouchDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(isHidden)
        if (isHidden) { return }
        guard let touch = touches.first else { return }
        delegate?.dragOverlayTouchBegan(dragOverlay: self, touch: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isHidden) { return }
        guard let touch = touches.first, let event = event else { return }
        
        if let predictedTouch = event.predictedTouches(for: touch)?.last {
            delegate?.dragOverlayTouchMoved(dragOverlay: self, touch: predictedTouch)
            return
        }
        
        delegate?.dragOverlayTouchMoved(dragOverlay: self, touch: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isHidden) { return }
        guard let touch = touches.first else { return }
        delegate?.dragOverlayTouchEnded(dragOverlay: self, touch: touch)
    }

}
