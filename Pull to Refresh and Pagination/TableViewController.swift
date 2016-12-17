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
    var limit = 50
    var totalPage = 10

    var items = [Int]()
    
    var paggingView : UIActivityIndicatorView?
    
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
        paggingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        paggingView?.tintColor = UIColor.black
        paggingView?.hidesWhenStopped = true
        tableView.addSubview(paggingView!)
    }
    
    func refresh(){
        // Show refresh animation
        tableView.refreshControl?.beginRefreshing()
        // Load Data from Service
        
        let timer = Timer.init(timeInterval: 10, target: self, selector: #selector(updateData), userInfo: nil, repeats: false)
        
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
            paggingView?.startAnimating()
            loadData(page: page, limit: limit)
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
        
        paggingView?.stopAnimating()
        self.tableView.reloadData()
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
