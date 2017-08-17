//
//  DepartureListTableViewCell.swift
//  SwiftPlay
//
//  Created by Richard Martin on 03/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit
import GoogleMaterialDesignIcons
import SwiftDate

class DepartureListTableViewCell: UITableViewCell {
    var cellSelected = false
    var travelTimeLabel : UILabel!
    var departureTimeLabel: UILabel!
    var container: UIView!
    var transportContainer: UIView!
    var route: Route?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.black
        self.contentView.backgroundColor = UIColor.black
        
        setup()
    }

    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    private func setup() {
        container = UIView()
        contentView.addSubview(container)
        
        let departureTimeDescriptionLabel = UILabel()
        container.addSubview(departureTimeDescriptionLabel)
        departureTimeDescriptionLabel.text = "Departure on:"
        departureTimeDescriptionLabel.textColor = UIColor.white
        departureTimeDescriptionLabel.font = Constants.Fonts.defaultFont(size: 9)
        
        departureTimeLabel = UILabel()
        container.addSubview(departureTimeLabel)
        
        travelTimeLabel = UILabel()
        container.addSubview(travelTimeLabel)
        
        transportContainer = UIView()
        container.addSubview(transportContainer)
        
        container.snp.makeConstraints { (make) -> Void in
            make.width.height.greaterThanOrEqualTo(contentView).inset(UIEdgeInsetsMake(8, 8, 8, 8))
            make.edges.lessThanOrEqualTo(contentView).inset(UIEdgeInsetsMake(8, 8, 8, 8))
        }
        
        departureTimeDescriptionLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview()
            make.width.equalTo(300)
        }
        
        departureTimeLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(4)
            make.width.equalTo(300)
        }
        
        travelTimeLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(85)
            make.top.equalToSuperview()
        }
        
        transportContainer.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(85)
            make.bottom.equalToSuperview().inset(8)
        }
        
        configureDepartureTime();
        configureTravelTime();
    }
    
    private func configureTransportContainer() {
        //this is inefficient as hell but hey, who cares
        guard let route = route else {
            return
        }
        
        transportContainer.subviews.forEach({ $0.removeFromSuperview() })
        var lastView: UIView? = nil
        var currentView: UIView? = nil
        
        for (index, stage) in route.stages.enumerated() {
            switch stage {
            case _ as WalkTransport:
                let walkLabel = UILabel()
                transportContainer.addSubview(walkLabel)
                walkLabel.font = UIFont(name: GoogleIconName, size: 13.0)
                walkLabel.textColor = UIColor.white
                walkLabel.text = GoogleIcon.eb4b
                
                currentView = walkLabel
            case let numberedTransport as NumberedTransport:
                let numberedTransportView = NumberedTransportView()
                transportContainer.addSubview(numberedTransportView)
                numberedTransportView.set(type: numberedTransport.type, number: numberedTransport.number, size: .small, invertColors: false)
                
                currentView = numberedTransportView
            default:
                print("not sure what to do here, it should never happen but I dont want to declare throws??")
            }
            
            currentView!.snp.makeConstraints { (make) -> Void in
                if (index == 0) {
                    make.left.equalToSuperview()
                } else {
                    make.left.equalTo(lastView!.snp.right)
                }
                make.bottom.equalToSuperview()
            }
                
            
            if index != (route.stages.count - 1) {
                let spacerLabel = UILabel()
                transportContainer.addSubview(spacerLabel)
                spacerLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 10.0)
                spacerLabel.textColor = UIColor.white
                spacerLabel.text = " > "
                
                spacerLabel.snp.makeConstraints { (make) -> Void in
                    make.bottom.equalToSuperview().inset(2)
                    make.left.equalTo(currentView!.snp.right)
                }
                
                lastView = spacerLabel
            }
        }
    }
    
    private func numberLabel(number: String) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 5
        container.layer.backgroundColor = UIColor.white.cgColor
    
        let tramNumberLabel = UILabel()
        tramNumberLabel.font = UIFont(name: "Helvetica Neue", size: 9.0)
        tramNumberLabel.textColor = UIColor.black
        tramNumberLabel.text = number
        tramNumberLabel.textAlignment = .center
        
        container.addSubview(tramNumberLabel)
    
        tramNumberLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
        }
        
        return container
    }
    
    private func configureTravelTime() {
        let travelTimeAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.white]
        let dotAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.darkGray]
        let entryAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: Constants.Colors.Yellow]
        
        if let route = route {
            let arrivalTime = route.departureDate + route.totalTime.minutes
    
            let partOne = NSMutableAttributedString(string: "Travel time: ", attributes: travelTimeAttributes)
            let partTwo = NSMutableAttributedString(string: "\(route.totalTime) min", attributes: entryAttributes)
            let partThree = NSMutableAttributedString(string: " \u{2022} ", attributes: dotAttributes)
            let partFour = NSMutableAttributedString(string: "\(arrivalTime.string(format: .custom("HH:mm"))) ", attributes: entryAttributes)
            
            let combination = NSMutableAttributedString()
            
            combination.append(partOne)
            combination.append(partTwo)
            combination.append(partThree)
            combination.append(partFour)
            
            travelTimeLabel.attributedText = combination
            travelTimeLabel.font = UIFont(name: "Helvetica Neue", size: 9)
        }
    }
    
    private func configureDepartureTime() {
        if let route = route {
            let color = self.cellSelected ? Constants.Colors.Red : UIColor.white
            let partOneAttributes: [String : AnyObject] =
                [NSForegroundColorAttributeName: color, NSFontAttributeName: Constants.Fonts.defaultBoldFont(size: 35)!]
            let partTwoAttributes: [String : AnyObject] =
                [NSForegroundColorAttributeName: color, NSFontAttributeName: Constants.Fonts.defaultBoldFont(size: 11)!]
            
            let minutesTillDeparture = (Constants.Dates.currentDate()! - route.departureDate).in(.minute)
        
            let partOne = NSMutableAttributedString(string: String(format: "%02d", minutesTillDeparture!), attributes: partOneAttributes)
            let partTwo = NSMutableAttributedString(string: " min", attributes: partTwoAttributes)
        
            let combination = NSMutableAttributedString()
        
            combination.append(partOne)
            combination.append(partTwo)
            
            departureTimeLabel.attributedText = combination
        }
    }
    
    func showRoute(route: Route) {
        self.route = route
        self.configureDepartureTime()
        self.configureTravelTime()
        self.configureTransportContainer();
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellSelected = false
        self.contentView.alpha = 1
    }
    
    func animateSelection() {
        let startingPosition = container.layer.position
        let newPosition = CGPoint(x: startingPosition.x + 4, y: startingPosition.y)
        let bounceAnim = CABasicAnimation(keyPath:"position")
        bounceAnim.autoreverses = true
        bounceAnim.isRemovedOnCompletion = true
        bounceAnim.fromValue = NSValue(cgPoint: container.layer.position)
        bounceAnim.toValue = NSValue(cgPoint: newPosition)
        bounceAnim.duration = Double(0.2)
        container.layer.add(bounceAnim, forKey: "AnimateFrame")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        cellSelected = selected
        configureDepartureTime()
    }

}
