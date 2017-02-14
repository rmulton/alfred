//
//  MainTableViewController.swift
//  Alfred
//
//  Created by rob on 06/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import UIKit
import CoreData


class MainTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var controller: NSFetchedResultsController<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateSampleData()
        attemptCategoriesFetch()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if controller != nil{
            
            if let results = controller.sections{
                
                let numberOfResults = results[0].numberOfObjects
                return numberOfResults
                
            }
            else{
                return 0
            }
            
        }
        else{
            return 0
        }
     
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1 // For design purpose
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell

        // Configure the cell...
        
        if let results = controller.sections{
            
            if let categories = results[0].objects{
                
                let category = categories[indexPath.section] as! Category
                cell.updateUI(category: category)
                
            }
        }
        
        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "mainToDetails"{
            if let indexPath = tableView.indexPathForSelectedRow{
                
                if let categories = controller.sections?[0].objects as? [Category]{
                    
                    let destination = segue.destination as! DetailsTableViewController
                    destination.category = categories[indexPath.section]
                
                }
            }
        }
        
        
    }
    
    
    
    // MARK: - Core data binding
    
    func attemptCategoriesFetch(){
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.controller = controller
        
        do{
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case.insert:
            if let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = newIndexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = newIndexPath {
                //self.tableView.cellForRow(at: indexPath) as! CategoryCell
                // update the cell data
            }
            break
        case.move:
            if let indexPath = newIndexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    func generateSampleData(){
        
        // Delete existing data
        
        let categoriesFetchRequest = NSFetchRequest<Category>(entityName: "Category")
        let categoriesDeleteRequest = NSBatchDeleteRequest(fetchRequest: categoriesFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        let detailFetchRequest = NSFetchRequest<Category>(entityName: "Detail")
        let detailDeleteRequest = NSBatchDeleteRequest(fetchRequest: detailFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        let detailSectionFetchRequest = NSFetchRequest<Category>(entityName: "DetailSection")
        let detailSectionDeleteRequest = NSBatchDeleteRequest(fetchRequest: detailSectionFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do{
            try context.execute(categoriesDeleteRequest)
            try context.execute(detailDeleteRequest)
            try context.execute(detailSectionDeleteRequest)
            
        }catch{
            print(error)
        }
        
        // Sample data
        
            // Details
        let detail00 = Detail(context: context)
        detail00.title = "François Bayrou se présente à l'élection présidentielle"
        detail00.source = "Le Monde"
        detail00.descript = "Pour la quatrième fois, le représentant du centre libre se présente à l'élection reine de la 5eme république"
        
        let detail01 = Detail(context: context)
        detail01.title = "Angela Merkel annonce un plan de relance budgétaire en Allemagne"
        detail01.source = "Les Échos"
        detail01.descript = "Le plan de relance se compose d'une injection de 50 milliards dans l'économie industrielle et d'une dotation d'un milliard à l'éducation."
        
        let detail02 = Detail(context: context)
        detail02.title = "Le président Trump multiplie les mésures contre l'imigration"
        detail02.source = "AFP"
        detail02.descript = "Le président a décidé d'interdire l'entrée dans le pays aux ressortissants de 7 pays musulmans."
        
        let detail10 = Detail(context: context)
        detail10.title = "Inflation UE : 3.5%"
        detail10.source = "Yahoo finance"
        detail10.descript = "USA 4% | JAP 2% || 2016 | USA 5% | UE 1% | JAP 4% ||"
        
        let detail11 = Detail(context: context)
        detail11.title = "Croissance UE : 1.5%"
        detail11.source = "Yahoo finance"
        detail11.descript = "USA 3% | JAP 1% || 2016 : USA 0.6% | UE 1% | JAP 4% ||"

            // Detail sections
        let detailSection00 = DetailSection(context: context)
        detailSection00.title = "Europe"
        detailSection00.toDetails = [detail00, detail01]
        
        let detailSection01 = DetailSection(context: context)
        detailSection01.title = "USA"
        detailSection01.toDetails = [detail02]
        
        let detailSection10 = DetailSection(context: context)
        detailSection10.title = "Economic figures"
        detailSection10.toDetails = [detail10, detail11]
        
        
            // Categories
        let category0 = Category(context: context)
        category0.title = "Press review"
        category0.descript = "I summed up the headlines for you :)"
        category0.image = #imageLiteral(resourceName: "news")
        category0.toDetailSections = [detailSection00, detailSection10]
        
        let category1 = Category(context: context)
        category1.title = "The world today"
        category1.descript = "Facts and figures to know"
        category1.image = #imageLiteral(resourceName: "economics")
        category1.toDetailSections = [detailSection10]
        
        let category2 = Category(context: context)
        category2.title = "Review bookmarked articles"
        category2.descript = "3 articles a day keep the mess away"
        category2.image = #imageLiteral(resourceName: "write")

        
        ad.saveContext()
    }


}
