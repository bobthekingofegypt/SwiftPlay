//
//  DirectionsViewController.swift
//  SwiftPlay
//
//  Created by Richard Martin on 04/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMaterialDesignIcons

class DirectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let kDirectionsCellReuseIdentifier = "DepartureListTableViewCell"
    static let kDirectionsWalkCellReuseIdentifier = "DirectionWalkTableViewCell"
    static let kDirectionsFinalCellReuseIdentifier = "FinalDestinationCell"
    
    private var myTableView: UITableView!
    var route: Route!
    var displayedStages: [Transport] = []
    var animating: Bool = false
    
    init(route: Route) {
        super.init(nibName: nil, bundle: nil)
        self.route = route
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let lineView = UIView()
        self.view.addSubview(lineView)
        lineView.backgroundColor = Constants.Colors.LightGray
        
        myTableView = UITableView()
        self.view.addSubview(myTableView)
        myTableView.backgroundColor = UIColor.clear
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.separatorStyle = .none
        myTableView.allowsSelection = false
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        myTableView.cellLayoutMarginsFollowReadableWidth = false
        myTableView.register(DirectionTableViewCell.self, forCellReuseIdentifier: DirectionsViewController.kDirectionsCellReuseIdentifier)
        myTableView.register(DirectionWalkTableViewCell.self, forCellReuseIdentifier: DirectionsViewController.kDirectionsWalkCellReuseIdentifier)
        myTableView.register(FinalDestinationCellTableViewCell.self, forCellReuseIdentifier: DirectionsViewController.kDirectionsFinalCellReuseIdentifier)
        myTableView.dataSource = self
        myTableView.delegate = self
        
        lineView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(self.view)
            make.width.equalTo(1)
            make.top.equalTo(self.view)
            make.left.equalTo(self.view).offset(65)
        }
        
        myTableView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(self.view)
            make.top.left.equalTo(self.view)
        }
        
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.displayedStages.append(contentsOf: self.route.stages)
        myTableView.reloadData()
    }
    
    func set(route: Route) {
        self.route = route
        animateInCells()
    }
    
    func animateInCells() {
        self.animating = true
        self.displayedStages.removeAll()
        myTableView.reloadData()
        
        var indexPaths: [IndexPath] = []
        for i in 0 ..< route.stages.count + 1 {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        //delay a bit just to let the height constraint be updated so cells animate from the bottom correctly
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(0.05)) {
            self.displayedStages.append(contentsOf: self.route.stages)
            self.myTableView.beginUpdates()
            self.myTableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.bottom)
            self.myTableView.endUpdates()
        }
        //these timings should all match, they really dont - it doesn't matter for now
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(0.1 * Double(route.stages.count) + 0.3)) {
            self.animating = false
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        if (self.animating) {
            let frame = cell.frame
            cell.alpha = 0
            cell.frame = CGRect(x: 0, y: myTableView.frame.height, width: frame.width, height: frame.height)
            UIView.animate(withDuration: 0.6, delay: (0.2 * Double(indexPath.row)), options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                cell.frame = frame
            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: (0.2 * Double(indexPath.row)) + 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                cell.alpha = 1.0
            }, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == displayedStages.count {
            return 46
        }
        
        let stage = displayedStages[indexPath.row]
        switch stage {
        case _ as WalkTransport:
            return 60
        default:
            return 87
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayedStages.count == 0 {
            return 0
        }
        
        return displayedStages.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == displayedStages.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: DirectionsViewController.kDirectionsFinalCellReuseIdentifier, for: indexPath as IndexPath)
            let finalCell = cell as! FinalDestinationCellTableViewCell
            finalCell.set(time: "18:36", location: route.destination)
            return cell
        }
        
        let stage = displayedStages[indexPath.row]
        let travelStage = { () -> TravelStage in
            switch indexPath.row {
            case 0:
                return .begining
            case route.stages.count - 1:
                return .ending
            default:
                return .normal
            }
        }()
        
        switch stage {
        case let stage as WalkTransport:
            let cell = tableView.dequeueReusableCell(withIdentifier: DirectionsViewController.kDirectionsWalkCellReuseIdentifier, for: indexPath as IndexPath)
            let walkCell = cell as! DirectionWalkTableViewCell
            walkCell.set(transport: stage, travelStage: travelStage)
            return walkCell
        default:
            let stage = stage as! NumberedTransport
            let cell = tableView.dequeueReusableCell(withIdentifier: DirectionsViewController.kDirectionsCellReuseIdentifier, for: indexPath as IndexPath)
            let numberedCell = cell as! DirectionTableViewCell
            numberedCell.set(transport: stage, travelStage: travelStage)
            return numberedCell
        }
    }
}
