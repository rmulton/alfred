//
//  MainTableViewController.swift
//  Alfred
//
//  Created by rob on 06/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class MainTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var controller: NSFetchedResultsController<Category>!
    
    override func viewWillAppear(_ animated: Bool) {
        resetDatabase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCategory()
        fetchCategories()
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
        return 1 // For design purpose
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: CategoryCell, indexPath: IndexPath){
        if let results = controller.sections{
            if let categories = results[0].objects{
                let category = categories[indexPath.section] as! Category
                cell.updateUI(category: category)
            }
        }
    }

    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    func fetchCategories(){
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        
        do{
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("Error in fetchCategories")
            print("\(error)")
        }
    }
    
    // WHY IS IT UNUSED ???
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // WHY IS IT UNUSED ???
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // WHY IS IT UNUSED ???
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case.insert:
            if let indexPath = newIndexPath {
                print("A category was inserted")
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            print("A category was deleted")
            if let indexPath = newIndexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            print("A category was updated")
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! CategoryCell
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
        case.move:
            print("A category was moved")
            if let indexPath = newIndexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }

    func resetDatabase(){
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
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    
    
    // Mark: - Downloading data from news api
    
    func downloadFromSource(category: Category, urlString: String, resetDatabase: Bool){
        
        let currentNewsURL = URL(string: urlString)
        
        Alamofire.request(currentNewsURL!).responseJSON { (response) in
            
            if resetDatabase{
                self.resetDatabase() // must be here because of asynchronous thread
            }
            
            let result = response.result
            if let dict = result.value as? Dictionary<String, Any>{
                let source = dict["source"] as? String
                if let articles = dict["articles"] as? [Dictionary<String, Any>]{
                    let detailSection = DetailSection(context: context)
                    detailSection.title = source
                    detailSection.toCategory = category
                    for article in articles{
                        
                        if let title = article["title"] as? String, let author = article["author"] as? String, let descript = article["description"] as? String{
                            
                                let detail = Detail(context: context)
                                detail.title = title
                                detail.source = author
                                detail.descript = descript
                                detail.title = title
                                detail.toDetailSection = detailSection
                            
                        }
                        
                    }
                }
            }
        }

    }
    
    func updateCategory(){
        
        let category = Category(context: context)
        category.title = "Today's headlines"
        category.descript = "I summed it up for you !"
        category.image = #imageLiteral(resourceName: "economics")
        
        downloadFromSource(category: category, urlString: THE_ECONOMIST, resetDatabase: false) // reset mis à false pour tenter dans viewWillAppear
        downloadFromSource(category: category, urlString: HACKER_NEWS, resetDatabase: false)
        
        ad.saveContext()
    
    }
    
    
    
    
    // Mark: - Used during developement
    
    /* Not used anymore
    func generateSampleData(){
        

        // Sample data
        
            // Categories
        let category0 = Category(context: context)
        category0.title = "Press review"
        category0.descript = "I summed up the headlines for you :)"
        category0.image = #imageLiteral(resourceName: "news")
        
        let category1 = Category(context: context)
        category1.title = "The world today"
        category1.descript = "Facts and figures to know"
        category1.image = #imageLiteral(resourceName: "economics")
        
        let category2 = Category(context: context)
        category2.title = "Review bookmarked articles"
        category2.descript = "3 articles a day keep the mess away"
        category2.image = #imageLiteral(resourceName: "write")

        // Detail sections
        let detailSection00 = DetailSection(context: context)
        detailSection00.title = "Europe"
        detailSection00.toCategory = category0
        
        let detailSection01 = DetailSection(context: context)
        detailSection01.title = "USA"
        detailSection01.toCategory = category0
        
        let detailSection10 = DetailSection(context: context)
        detailSection10.title = "Economic figures"
        detailSection10.toCategory = category1
        
        // Details
        let detail00 = Detail(context: context)
        detail00.title = "François Bayrou se présente à l'élection présidentielle"
        detail00.source = "Le Monde"
        detail00.descript = "Pour la quatrième fois, le représentant du centre libre se présente à l'élection reine de la 5eme république"
        detail00.toDetailSection = detailSection00
        
        let detail01 = Detail(context: context)
        detail01.title = "Angela Merkel annonce un plan de relance budgétaire en Allemagne"
        detail01.source = "Les Échos"
        detail01.descript = "Le plan de relance se compose d'une injection de 50 milliards dans l'économie industrielle et d'une dotation d'un milliard à l'éducation."
        detail01.toDetailSection = detailSection00
        
        let detail02 = Detail(context: context)
        detail02.title = "Le président Trump multiplie les mésures contre l'imigration"
        detail02.source = "AFP"
        detail02.descript = "Le président a décidé d'interdire l'entrée dans le pays aux ressortissants de 7 pays musulmans."
        detail02.toDetailSection = detailSection01
        
        let detail10 = Detail(context: context)
        detail10.title = "Inflation UE : 3.5%"
        detail10.source = "Yahoo finance"
        detail10.descript = "USA 4% | JAP 2% || 2016 | USA 5% | UE 1% | JAP 4%"
        detail10.toDetailSection = detailSection10
        
        let detail11 = Detail(context: context)
        detail11.title = "Croissance UE : 1.5%"
        detail11.source = "Yahoo finance"
        detail11.descript = "USA 3% | JAP 1% || 2016 : USA 0.6% | UE 1% | JAP 4%"
        detail11.toDetailSection = detailSection10
        
        ad.saveContext()
    }
    */

}
