//
//  DirectionTableViewCellLeftView.swift
//  SwiftPlay
//
//  Created by Richard Martin on 08/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMaterialDesignIcons

class DirectionTableViewCellLeftView: UIView {
    var timeLabel: UILabel!
    var numberedTransportView: NumberedTransportView!
    var journeyStageLineView: JourneyStageLineView!
    var startCircleHeight: Constraint? = nil
    var walkLabelHeight: Constraint? = nil
    var numberedTrasportHeight: Constraint? = nil

    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    private func setup() {
        timeLabel = UILabel()
        self.addSubview(timeLabel)
        timeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 9.0)
        
        let startCircle = CirclePointView(color: Constants.Colors.Green)
        self.addSubview(startCircle)
        
        numberedTransportView = NumberedTransportView()
        numberedTransportView.clipsToBounds = true
        self.addSubview(numberedTransportView)
        
        journeyStageLineView = JourneyStageLineView()
        self.addSubview(journeyStageLineView)
        
        let walkLabel = UILabel()
        self.addSubview(walkLabel)
        walkLabel.font = UIFont(name: GoogleIconName, size: 13.0)
        walkLabel.textColor = UIColor.black
        walkLabel.text = GoogleIcon.eb4b
        
        timeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(3)
            make.centerX.equalToSuperview()
        }
        
        startCircle.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(8)
            self.startCircleHeight = make.height.equalTo(8).constraint
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(2)
        }
        
        walkLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(startCircle.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            self.walkLabelHeight = make.height.equalTo(14).constraint
        }
        
        numberedTransportView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(walkLabel.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            self.numberedTrasportHeight = make.height.equalTo(16).constraint
        }
        
        journeyStageLineView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(numberedTransportView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(10)
            make.bottom.equalToSuperview()
        }
        
        let dividerLine = UIView()
        self.addSubview(dividerLine)
        dividerLine.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 238/255, alpha: 1.0)
        
        dividerLine.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
    }

    func set(transport: Transport, travelStage: TravelStage) {
        timeLabel.text = transport.time
        
        if let numberedTransport = transport as? NumberedTransport {
            numberedTransportView.set(type: transport.type, number: numberedTransport.number, size: .big, invertColors: true)
        }
        journeyStageLineView.set(type: transport.type, stage: travelStage)
        
        switch transport.type {
        case .walk:
            walkLabelHeight?.update(offset: 14)
            numberedTrasportHeight?.update(offset: 0)
        default:
            walkLabelHeight?.update(offset: 0)
            numberedTrasportHeight?.update(offset: 16)
        }
        
        switch travelStage {
        case .begining:
            startCircleHeight?.update(offset: 8)
            timeLabel.textColor = Constants.Colors.Green
        default:
            startCircleHeight?.update(offset: 0)
            timeLabel.textColor = Constants.Colors.Black
        }
        
        self.layoutIfNeeded()
    }
}
