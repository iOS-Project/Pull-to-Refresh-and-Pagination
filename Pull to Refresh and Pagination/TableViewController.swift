//
//  TableViewController.swift
//  Pull to Refresh and Pagination
//
//  Created by Lun Sovathana on 12/17/16.
//  Copyright © 2016 DevCambodia. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var page = 1
    var limit = 15
    var totalPage = 10

    var items = [Int]()
    
    var paggingView : UIActivityIndicatorView?
    var searchController : UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Item for initial
        for i in 1...limit{
            items.append(i)
        }
        
        // Add Pull to Refresh
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = UIColor.red
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        // Add Pagination
        addPagination()
        
        addSearcchController()
    }
    
    func addPagination(){
        let activityView = UIView()
        var frame = activityView.frame
        frame.size.width = tableView.bounds.width
        frame.size.height = 50
        activityView.frame = frame
        activityView.backgroundColor = UIColor.red

        paggingView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        paggingView?.center = activityView.center
        paggingView?.tintColor = UIColor.black
        //paggingView?.hidesWhenStopped = true
        paggingView?.startAnimating()
        activityView.addSubview(paggingView!)
        tableView.tableFooterView = activityView
    }
    
    func addSearcchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.delegate = self
        tableView.tableHeaderView = searchController?.searchBar
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                pagging()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        
        cell.textLabel?.text = "Items \(items[indexPath.row])"
        
        return cell
    }
    
}

extension TableViewController{
    func refresh(){
        // Show refresh animation
        tableView.refreshControl?.beginRefreshing()
        // Load Data from Service
        
        let timer = Timer.init(timeInterval: 1000, target: self, selector: #selector(updateData), userInfo: nil, repeats: false)
        
        timer.fire()
    }
    
    func updateData(){
        // When Delegate from Service stop the refresh
        tableView.refreshControl?.endRefreshing()
    }
    
    // Pagination
    func pagging(){
        if page < totalPage{
            page += 1
            
            tableView.tableFooterView?.isHidden = false
            
            let timer = Timer.init(timeInterval: 10, repeats: false, block: { timer in
                self.loadData(page: self.page, limit: self.limit)
            })
            
            timer.fire()
        }
    }
    
    // Suppost this func is server that retrieve from API
    func loadData(page: Int, limit: Int){
        
        var arr = [Int]()
        
        for i in 1...limit{
            arr.append(i)
        }
        
        // Call Delegate
        paggingDidEnd(data: arr)
        
    }
    
    func paggingDidEnd(data : [Int]){
        
        for i in data {
            items.append(i)
        }
        
        tableView.tableFooterView?.isHidden = false
        
        self.tableView.reloadData()
    }
}

extension TableViewController : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel Clicked")
    }
}
