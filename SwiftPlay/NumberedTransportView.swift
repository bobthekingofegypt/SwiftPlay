//
//  NumberedTransportView.swift
//  SwiftPlay
//
//  Created by Richard Martin on 07/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit
import GoogleMaterialDesignIcons

enum NumberedTransportViewSize {
    case big
    case small
}

class NumberedTransportView: UIView {
    private var iconLabel: UILabel!
    private var numberLabel: UILabel!
    private var numberView: UIView!

    init() {
        super.init(frame: CGRect.zero)
        
        iconLabel = UILabel()
        iconLabel.font = UIFont(name: GoogleIconName, size: 14.0)
        iconLabel.textColor = UIColor.white
        
        numberView = createNumberView()
        
        self.addSubview(iconLabel);
        self.addSubview(numberView);
        
        iconLabel.snp.makeConstraints { (make) -> Void in
            make.top.left.equalToSuperview()
        }
        
        numberView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(iconLabel.snp.right).offset(2)
            make.centerY.equalTo(iconLabel)
        }
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    override var intrinsicContentSize: CGSize {
        let iconLabelSize = iconLabel.intrinsicContentSize
        let numberLabelSize = numberLabel.intrinsicContentSize
        return CGSize(width: iconLabelSize.width + numberLabelSize.width + 10, height: iconLabelSize.height)
    }
    
    private func createNumberView() -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 5
        container.layer.backgroundColor = UIColor.white.cgColor
        
        numberLabel = UILabel()
        numberLabel.font = UIFont(name: "Helvetica Neue", size: 9.0)
        numberLabel.textColor = UIColor.black
        numberLabel.textAlignment = .center
        
        container.addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 4, bottom: 1, right: 4))
        }
        
        return container
    }
    
    public func set(type: TransportType, number: Int, size: NumberedTransportViewSize, invertColors: Bool) {
        let black = UIColor(red: 42/255, green: 42/255, blue: 43/255, alpha: 1.0)
        if invertColors {
            iconLabel.textColor = black
            numberLabel.textColor = .white
            numberView.backgroundColor = black
        } else {
            iconLabel.textColor = .white
            numberLabel.textColor = black
            numberView.backgroundColor = .white
        }
        
        switch type {
        case .bus:
            iconLabel.text = GoogleIcon.eb3f
        default:
            iconLabel.text = GoogleIcon.eb47
        }
        
        switch size{
        case .big:
            numberLabel.font = UIFont(name: "Helvetica Neue", size: 11.0)
            iconLabel.font = UIFont(name: GoogleIconName, size: 16.0)
            numberView.layer.cornerRadius = 7
        default:
            numberLabel.font = UIFont(name: "Helvetica Neue", size: 9.0)
            iconLabel.font = UIFont(name: GoogleIconName, size: 14.0)
            numberView.layer.cornerRadius = 5
        }
        
        numberLabel.text = String(number)
        
        self.invalidateIntrinsicContentSize()
    }
}
