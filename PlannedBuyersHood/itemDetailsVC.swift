//
//  itemDetailsVC.swift
//  PlannedBuyersHood
//
//  Created by Jesse Tellez on 4/20/16.
//  Copyright © 2016 Jesse Tellez. All rights reserved.
//

import UIKit
import CoreData

class itemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var newStoreTxtField: CustomTextField!
    //@IBOutlet weak var itemImage: UIImageView!
    
    let convertQueue = dispatch_queue_create("convertQueue", DISPATCH_QUEUE_CONCURRENT)
    let saveQueue = dispatch_queue_create("saveQueue", DISPATCH_QUEUE_CONCURRENT)
    
    @IBOutlet weak var ItemImage: UIButton!
    
    var imagePicker: UIImagePickerController!
    var stores = [Store]()
    var selectedItem: Item?
    var imageForItem: Image!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        getStores()
        
        if selectedItem != nil {
            loadItemData()
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        ItemImage.setBackgroundImage(image, forState: UIControlState.Normal)
        
        //beginSavingImage(image)
    }
    
//    func beginSavingImage(image: UIImage) {
//        //use as unique id
//        
//        //let date: Double = NSDate().timeIntervalSince1970
//        
//        dispatch_async(convertQueue) {
//            guard let imageData = UIImageJPEGRepresentation(image, 1) else {
//                print("jpg error")
//                return
//            }
//            
//            self.saveImage(imageData)
//            
//        }
//    }
    
//    func saveImage(imageData: NSData) {
//        dispatch_barrier_sync(saveQueue) {
//            let image = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: appDelegate.managedObjectContext) as! Image
//            image.image = imageData
//            //image.item =
//           // appDelegate.saveContext()
//        }
//    }
    
    func loadItemData() {
        
        
        if let price = selectedItem?.price {
            priceTextField.text = "\(price)"
        }
        
        if let title = selectedItem?.title {
            titleTextField.text = title
        }
        
        if let details = selectedItem?.details {
            detailsTextField.text = details
        }
        
        if let store = selectedItem?.store {
            
            var index = 0
            
            repeat {
                let s = stores[index]
                if s.name == store.name {
                    storePicker.selectRow(index, inComponent: 0, animated: false)
                    break
                }
                
                index += 1
                
            } while (index < stores.count)
            
        }
        
        if let image = selectedItem!.image?.getItemImage() {
            ItemImage.setImage(image, forState: UIControlState.Normal)
        }
    }
    
    func getStores() {
        let fetchReq = NSFetchRequest(entityName: "Store")
        
        do {
            
            self.stores = try appDelegate.managedObjectContext.executeFetchRequest(fetchReq) as! [Store]
            self.storePicker.reloadAllComponents()
            
        } catch {
            let error = error as NSError
            print("\(error), \(error.userInfo)")
            //handle error
        }
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        //how many columns is picker going to have
        return 1
        //store name
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        
        return store.name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        
    }
    
    
    
    @IBAction func savePressed(sender: AnyObject) {
        
        var item: Item!
        var image: Image!
        
        //check if in new or editing mode
        
        if selectedItem == nil {
            item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
            image = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: appDelegate.managedObjectContext) as! Image
            item.image = image
        } else {
            item = selectedItem
        }
        
        if let title = titleTextField.text {
            item.title = title
        }
        
        if let price = priceTextField.text {
            
            let priceString = NSString(string: price)
            let priceDouble = priceString.doubleValue
            item.price = NSNumber(double: priceDouble)
        }
        
        if let detials = detailsTextField.text {
            item.details = detials
        }
        
        item.store = stores[storePicker.selectedRowInComponent(0)]
        
        if let descImage = ItemImage.currentBackgroundImage {
            item.image?.setItemImage(descImage)
        }
        
        appDelegate.saveContext()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func deletePressed(sender: AnyObject) {
        
        //if we making new item
        
        if selectedItem != nil {
            appDelegate.managedObjectContext.deleteObject(selectedItem!)
            appDelegate.saveContext()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    @IBAction func AddStorePressed(sender: AnyObject) {
        
        if let text = newStoreTxtField.text where text != "" {
            
            let newStore: Store!
            
            newStore = NSEntityDescription.insertNewObjectForEntityForName("Store", inManagedObjectContext: appDelegate.managedObjectContext) as! Store
            
            newStore.name = text
            appDelegate.saveContext()
            
            newStoreTxtField.text = ""
            
            getStores()
        }
    }
    
    @IBAction func addImagePressed(sender: AnyObject) {
       presentViewController(imagePicker, animated: true, completion: nil)
        
        
        
        
    }
    
}
