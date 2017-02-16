//
//  DetailsTableViewController.swift
//  Alfred
//
//  Created by rob on 10/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import UIKit
import CoreData

class DetailsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var category: Category?
    var detailController: NSFetchedResultsController<Detail>!
    var details: [[Detail]]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = category?.title
        loadDetails()
        
        // Adapt presentation to the content size
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 130.0;
    }

    
    // MARK: - Core data binding
    
    func loadDetails(){
        fetchDetailsOfThisCategory()
        
        if let sections = detailController.sections{
            
            details = [[Detail]]()
            
            for section in sections{
                details!.append(section.objects as! [Detail])
            }
            
        }
        
    }
    
    func fetchDetailsOfThisCategory(){
        
        if category != nil{
            
            let fetchRequest: NSFetchRequest<Detail> = Detail.fetchRequest()
            
            // WARNING : the sort descriptor must use the same key as the one used in sectionNameKeyPath by the controller (see below)
            let sortDescriptor = NSSortDescriptor(key: "toDetailSection.title", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            // Filter to get the details from the required category
            fetchRequest.predicate = NSPredicate(format: "toDetailSection.toCategory.title = %@", category!.title!)
            
            let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "toDetailSection.title", cacheName: nil)
            
            self.detailController = controller
            
            do{
                try controller.performFetch()
            } catch {
                let error = error as NSError
                print("\(error)")
            }
            
        }
            
        else{
            print("Category has no title")
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if let details = details{
            //print(details.count)
            return details.count
        }
        else{
            print("We found no section in this category")
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let details = details{
            //print(details[section].count)
            return details[section].count
        }
        else{
            print("We found no detail in this detailSection")
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell

        // Configure the cell...
        
        if let details = details{
            let detail = details[indexPath.section][indexPath.row]
            cell.updateUI(detail: detail)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if details != nil{
            
            if let listOfDetails = details?[section]{
                
                let firstDetail = listOfDetails[0]
                
                if let detailSection = firstDetail.toDetailSection as DetailSection?{
                    
                    return detailSection.title
                    
                }
                
            }
        }
        
        return "Ups, missing title"
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}
