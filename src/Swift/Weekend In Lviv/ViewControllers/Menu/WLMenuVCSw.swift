//
//  WLMenuVCSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit


enum WLMenuSection: Int {
    case Home = 0, Articles, About, NumberOfSection
}


class WLMenuVCSw: UITableViewController, UISearchDisplayDelegate, UISearchBarDelegate {

    // Instance variables
    var filteredSource:WLPlace[] = []
    var detailView:WLHomeVCSw? = nil
    var searchBar:UISearchBar? = nil
    var searchDisplayControllerCustom:UISearchDisplayController? = nil
    var searchActive:Bool = false
    
    struct Static {
        static let cellIdentifier:String = "Cell"
    }
    
    // Instance methods
    init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar = UISearchBar(frame:CGRectMake(0, 0, 320, 40))
        self.searchBar!.delegate = self

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.navigationItem.titleView = self.searchBar!

        NSNotificationCenter.defaultCenter()!.addObserver(self.tableView!, selector:Selector("reloadData"), name:"ArticleStatusChanged", object:nil)
        
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView.backgroundColor = RGB(48, 23, 0)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        self.searchBar!.resignFirstResponder()
    }

    //pragma mark -  Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int
    {
        return WLMenuSection.NumberOfSection.toRaw()
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int
    {
        if section == WLMenuSection.Home.toRaw() {
            return 1;
        }
        if section == WLMenuSection.About.toRaw() {
            return 1;
        }
        if (self.searchActive) {
            return self.filteredSource.count
        }
        return WLDataManager.sharedManager.placesList.count
    }

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell?
    {
        var cell:WLMenuCellSw? = tableView!.dequeueReusableCellWithIdentifier(Static.cellIdentifier) as? WLMenuCellSw

        if let cell_ = cell? {
        }
        else{
            cell = NSBundle.mainBundle()!.loadNibNamed("WLMenuCellSw", owner:nil, options:nil)[0] as? WLMenuCellSw
        }
        
        if indexPath!.section == WLMenuSection.Home.toRaw() {
            cell!.imgFavoriteFlag.hidden = true
            cell!.imgIcon.image = UIImage(named:"FakeMenuItem")
            cell!.lblTitle.text = "Home"
        }
        else if indexPath!.section == WLMenuSection.About.toRaw() {
            cell!.imgFavoriteFlag.hidden = true
            cell!.imgIcon.image = UIImage(named:"image_about")
            cell!.lblTitle.text = "About"
        }
        else {
            var place:WLPlace? = nil
            
            if self.searchActive {
                place = (self.filteredSource)[indexPath!.row]
            }
            else {
                place = (WLDataManager.sharedManager.placesList)[indexPath!.row]
            }
            cell!.lblTitle.text = place!.title.capitalizedString
            cell!.imgIcon.image = WLDataManager.sharedManager.imageWithPath(place!.placeMenuImagePath)
            cell!.imgFavoriteFlag.hidden = !(place!.placeFavourite)
        }
        
        var selectedView = UIView()
        selectedView.backgroundColor = RGB(58, 33, 10)
        cell!.selectedBackgroundView = selectedView

        return cell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        return 75
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == WLMenuSection.Home.toRaw() {
            return 0
        }
        return 50
    }

    override func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView!
    {
        var headerView:WLMenuHeaderViewSw? = nil
        
        if let menuSection = WLMenuSection.fromRaw(section) {
            
            switch menuSection {
                
            case .Articles:
                headerView = NSBundle.mainBundle()!.loadNibNamed("WLMenuHeaderViewSw", owner:nil, options:nil)[0] as? WLMenuHeaderViewSw
                headerView!.setTitle("Architecture")
                
            case .About:
                headerView = NSBundle.mainBundle()!.loadNibNamed("WLMenuHeaderViewSw", owner:nil, options:nil)[0] as? WLMenuHeaderViewSw
                headerView!.setTitle("About")
                
            case .Home:
                println("\(menuSection) is a menuSection, do nothing")
                
            default:
                println("\(menuSection) is not a menuSection")
            }

        }
        
        return headerView
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var newPlace:WLPlace? = nil
        
        switch (indexPath!.section) {
        case WLMenuSection.Articles.toRaw():
            if self.searchActive {
                newPlace = (self.filteredSource)[indexPath.row]
                let index:UInt = UInt(WLDataManager.sharedManager.placesList.bridgeToObjectiveC().indexOfObject(newPlace))
                self.detailView!.switchToViewControllerWithIndex(index: index, animated:true)
            }
            else {
                self.detailView!.switchToViewControllerWithIndex(index: UInt(indexPath!.row), animated: true)
            }
            
        case WLMenuSection.Home.toRaw():
            self.detailView!.popToRootAnimated(true)
            
        case WLMenuSection.About.toRaw():
            if !(self.detailView!.navigationController!.topViewController!.isMemberOfClass(WLAboutVCSw)) {
                let aboutVC = WLAboutVCSw(nibName: "WLAboutVCSw", bundle: nil)
                self.detailView!.navigationController!.pushViewController(aboutVC, animated:true)
            }
            
        default:
            println("\(indexPath!.section) is not a menuSection")
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated:false)
        self.mm_drawerController!.toggleDrawerSide(MMDrawerSide.Left, animated:true, completion:nil)
    }
    
    //pragma mark - UISearchBarDelegate
    func searchBar(searchBar:UISearchBar, textDidChange searchText:String)
    {
        if searchText.bridgeToObjectiveC().length > 0 {
            
            self.searchActive = true
            self.filteredSource.removeAll(keepCapacity: false)
            
            var predicate = NSPredicate(format: "SELF CONTAINS[cd] %@", argumentArray: [searchText])
            
            for place in WLDataManager.sharedManager.placesList {
                
                if predicate.evaluateWithObject(place.title) {
                    self.filteredSource.append(place)
                }
                else {
                    for block in place.placesTextBlocks {
                        
                        if predicate.evaluateWithObject(block.blockTitle) {
                            self.filteredSource.append(place)
                            break
                        }
                    }
                }
            }
        }
        else {
            self.searchActive = false
        }
        self.tableView!.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar:UISearchBar)
    {

    }
}















