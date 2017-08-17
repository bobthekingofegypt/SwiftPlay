//
//  DepartureListViewController.swift
//  SwiftPlay
//
//  Created by Richard Martin on 03/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMaterialDesignIcons

protocol DepartureListViewControllerDelegate {
    func departureSelected(indexPath: IndexPath, route: Route)
}

class DepartureListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let kDepartureListCellReuseIdentifier = "DepartureListTableViewCell"
    static let kCellHeight: CGFloat = 60.0
    
    var myTableView: UITableView!
    var selectedIndexPath: IndexPath!
    var delegate: DepartureListViewControllerDelegate?
    var routes: [Route]!
    
    init(routes: [Route]) {
        super.init(nibName: nil, bundle: nil)
        self.routes = routes
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        myTableView = UITableView()
        self.view.addSubview(myTableView)
        myTableView.isUserInteractionEnabled = false
        myTableView.backgroundColor = UIColor.black
        myTableView.separatorStyle = .singleLine
        myTableView.separatorColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        myTableView.cellLayoutMarginsFollowReadableWidth = false
        myTableView.register(DepartureListTableViewCell.self, forCellReuseIdentifier: DepartureListViewController.kDepartureListCellReuseIdentifier)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.rowHeight = DepartureListViewController.kCellHeight
        myTableView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(self.view)
        }
       
        self.navigationController?.navigationBar.backItem?.title = "" 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        myTableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
        myTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        myTableView.cellForRow(at: indexPath)?.contentView.alpha = 1.0
        
        selectedIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //this gets rid of the annoying double border at the start of the cell separators
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //as the frame is adjusted due to views resizing by dragging we want to make 
        //sure the selected cell is always on screen
        myTableView.scrollToRow(at: selectedIndexPath, at: .middle, animated: false)
        adjustCellAlpha()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustCellAlpha()
    }
    
    func adjustCellAlpha() {
        let visibleCells = myTableView.visibleCells
        
        if visibleCells.count == 0 {
            return
        }
        
        guard let bottomCell = visibleCells.last else {
            return
        }
        
        guard let topCell = visibleCells.first else {
            return
        }
        
        for cell in visibleCells {
            cell.contentView.alpha = 1.0
        }
        
        let cellHeight = topCell.frame.size.height - 1
        let tableViewTopPosition = myTableView.frame.origin.y
        let tableViewBottomPosition = myTableView.frame.origin.y + myTableView.frame.size.height
        
        let topCellPositionInTableView = myTableView.rectForRow(at: myTableView.indexPath(for: topCell)!)
        let bottomCellPositionInTableView = myTableView.rectForRow(at: myTableView.indexPath(for: bottomCell)!)
        let topCellPosition = myTableView.convert(topCellPositionInTableView, to: myTableView.superview).origin.y
        let bottomCellPosition = myTableView.convert(bottomCellPositionInTableView, to: myTableView.superview).origin.y + cellHeight
        
        let modifier: CGFloat = 1
        let topCellOpacity = 1.0 - ((tableViewTopPosition - topCellPosition) / cellHeight) * modifier
        let bottomCellOpacity = 1.0 - ((bottomCellPosition - tableViewBottomPosition) / cellHeight) * modifier
        
        topCell.contentView.alpha = topCellOpacity
        bottomCell.contentView.alpha = bottomCellOpacity
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = routes[indexPath.row]
        selectedIndexPath = indexPath
        delegate?.departureSelected(indexPath: indexPath, route: route)
        
        let cell = myTableView.cellForRow(at: indexPath)
        if let c = cell as? DepartureListTableViewCell {
            c.animateSelection()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:DepartureListViewController.kDepartureListCellReuseIdentifier, for:indexPath)
        if let departureCell = cell as? DepartureListTableViewCell {
            departureCell.showRoute(route: routes[indexPath.row])
        }
        return cell
    }
}
