//
//  BottlesViewController.swift
//  PotableWater
//
//  Created by Voicu Narcis on 03/09/2016.
//  Copyright © 2016 Voicu Narcis. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BottlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var bottleName = [Bottles]()
    var filteredBottles = [Bottles]()
    var showResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchController()
        
        DataService.waterItemsReference.child("bottles").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get values from Firebase
            var newBottles = [Bottles]()
            for item in snapshot.children{
                let bottle = Bottles(snapshot: item as! FIRDataSnapshot)
                newBottles.append(bottle)
            }
            self.bottleName = newBottles
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView delegate functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showResults == true && searchController.searchBar.text != ""{
            return filteredBottles.count
        } else {
            return bottleName.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("bottle")!
        
        if showResults == true && searchController.searchBar.text != ""{
            cell.textLabel?.text = filteredBottles[indexPath.row].name
            cell.detailTextLabel?.text = filteredBottles[indexPath.row].addedBy
        } else {
            cell.textLabel?.text = bottleName[indexPath.row].name
            cell.detailTextLabel?.text = bottleName[indexPath.row].addedBy
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //performSegueWithIdentifier("bottlesDetailsSegue", sender: view)
        print(bottleName[indexPath.row].name)
    }
    
    // MARK: - Search Bar
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.endEditing(true)
        return true
    }
    
    func configureSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search bottle here..."
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if showResults == false {
            showResults = true
            tableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        showResults = false
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        showResults = true
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchData = searchController.searchBar.text
        filteredBottles = bottleName.filter  ({ (bottle) -> Bool in
            return bottle.name.lowercaseString.containsString((searchData?.lowercaseString)!)
        })
        
        tableView.reloadData()
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "bottlesDetailsSegue"{
            if let bottleDetails = segue.destinationViewController as? BottlesDetailsViewController{
                if let bottleIndex = tableView.indexPathForSelectedRow?.row {
                    bottleDetails.bottleName = bottleName[bottleIndex].name as String
                    print("Numele sticlei: \(bottleDetails.bottleName)")
                }
            }
        }
    }
    
    
    

}
