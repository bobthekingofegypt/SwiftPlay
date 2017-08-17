//
//  DirectionWalkTableViewCell.swift
//  SwiftPlay
//
//  Created by Richard Martin on 08/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit
import GoogleMaterialDesignIcons

class DirectionWalkTableViewCell: UITableViewCell {
    var locationLabel: UILabel!
    var distanceLabel: UILabel!
    var leftContainer: DirectionTableViewCellLeftView!
    var travelTimeLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
        
        setup()
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

    private func setup() {
        leftContainer = DirectionTableViewCellLeftView()
        self.contentView.addSubview(leftContainer)
        leftContainer.snp.makeConstraints { (make) -> Void in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(66)
        }
        
        locationLabel = UILabel()
        self.contentView.addSubview(locationLabel)
        locationLabel.font = Constants.Fonts.defaultBoldFont(size: 10.5)
        locationLabel.textColor = Constants.Colors.Black
        
        let container = UIView()
        self.contentView.addSubview(container)
        
        distanceLabel = UILabel()
        container.addSubview(distanceLabel)
        distanceLabel.font = Constants.Fonts.defaultFont(size: 9)
        distanceLabel.textColor = .gray
        
        travelTimeLabel = UILabel()
        container.addSubview(travelTimeLabel)
        travelTimeLabel.font = Constants.Fonts.defaultBoldFont(size: 8)
        travelTimeLabel.textColor = Constants.Colors.Blue
        
        travelTimeLabel.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview().offset(3)
        }
        
        locationLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(leftContainer.snp.right).offset(10)
            make.top.equalToSuperview().offset(3)
        }
        
        container.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(leftContainer.snp.right).offset(10)
            make.right.equalToSuperview()
            make.top.equalTo(locationLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        distanceLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(leftContainer.snp.right).offset(10)
            make.centerY.equalToSuperview().offset(3)
        }
    }
    
    func set(transport: WalkTransport, travelStage: TravelStage) {
        locationLabel.text = transport.location
        distanceLabel.text = "On foot \(transport.distance)m"
        leftContainer.set(transport: transport, travelStage: travelStage)
        travelTimeLabel.text = "\(transport.travelTime)min"
    }
}
