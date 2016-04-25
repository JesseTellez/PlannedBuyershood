//
//  ViewController.swift
//  PlannedBuyersHood
//
//  Created by Jesse Tellez on 4/17/16.
//  Copyright © 2016 Jesse Tellez. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!

    
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        attempFetch()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        attempFetch()
        tableView.reloadData()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            let sectionInfo =  sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let secitons = fetchedResultsController.sections {
            let sectionInfo = secitons[section].name
            return sectionInfo
            
        }
        return "Unassigned Store"
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 145.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ListCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let newView = UITableViewHeaderFooterView()
        newView.textLabel?.text = fetchedResultsController.sectionNameKeyPath
        
        
        return newView
    }
    
    func configureCell(cell: ListCell, indexPath: NSIndexPath) {
        
        if let item = fetchedResultsController.objectAtIndexPath(indexPath) as? Item {
            //update data
            cell.configCell(item)
            
        }
    }
    
    func attempFetch() {
        //make sure fetch controller has the appropriate data in it
        
        setFetchedResults()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error), \(error.userInfo)")
        }
    }
    
    func setFetchedResults() {
        //make sure all data is correct
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let section: String? = segment.selectedSegmentIndex == 1 ? "store.name" : nil
       
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: section, cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultsController = controller
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch (type) {
        case .Insert:
            let indexSet = NSIndexSet(index: sectionIndex)
            tableView.insertSections(indexSet, withRowAnimation: .Fade)
        case .Delete:
            let indexSet = NSIndexSet(index: sectionIndex)
            tableView.deleteSections(indexSet, withRowAnimation: .Fade)
        default:
            ""
        }
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        //this is listening for specific changes in data in the tableview so no large reload is needed
        
        //listen different result change types
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Delete:
            if let indexPath =  indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! ListCell
                configureCell(cell, indexPath: indexPath)
            }
            break
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break
        }
    }
    
    func generateTestData() {
        
        //insert new object into managed object context
        
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        
        item.title = "Cool Lego Set"
        item.price = 45.99
        item.details = "This is my favorite lego set of all time its like the best thing ever."
        
        
        
        let item2 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        item2.title = "Cool Target NickNack"
        item2.price = 4.99
        item2.details = "This is usually found in front of the store and Sarah loves these items because they are kawaii"
        
        
        let item3 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        
        item3.title = "tsum tsum"
        item3.price = 15.99
        item3.details = "This is sarahs new favorite plushies, they make her smile because they are super cute"
        
        appDelegate.saveContext()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let objects = fetchedResultsController.fetchedObjects where objects.count > 0 {
            let itemToPass = objects[indexPath.row] as! Item
            performSegueWithIdentifier("itemDetailsVC", sender: itemToPass)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "itemDetailsVC" {
            let vc = segue.destinationViewController as! itemDetailsVC
            
            vc.selectedItem = sender as? Item
        }
    }

    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        //there is bug here
        
        attempFetch()
        tableView.reloadData()
    }

}

