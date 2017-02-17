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
        updateCategories()
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
    
    func downloadFromSource(category: Category, urlString: String){
        
        let currentNewsURL = URL(string: urlString)
        
        Alamofire.request(currentNewsURL!).responseJSON { (response) in
            
            
            let result = response.result
            if let dict = result.value as? Dictionary<String, Any>{
                
                // News api
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
                
                //  Quandl api
                if let dataset = dict["dataset"] as? Dictionary<String, Any>{
                    
                    let detailSection = DetailSection(context: context)
                    detailSection.title = "France" // to change
                    detailSection.toCategory = category
                    
                    if let name = dataset["name"] as? String, let data = dataset["data"] as? [[Any]]{
                        let detail = Detail(context: context)
                        detail.title = name
                        detail.source = "ODA"
                        detail.descript = "\(data[5][1])"
                        detail.toDetailSection = detailSection
                    }
                    
                }
                
                
                
                
            }
        }

    }
    
    func loadNewsCategory(){
        let urlStrings = [THE_ECONOMIST, HACKER_NEWS]
        let category = Category(context: context)
        category.title = "Today's headlines"
        category.descript = "I summed it up for you !"
        category.image = #imageLiteral(resourceName: "news")
        for urlString in urlStrings{
            downloadFromSource(category: category, urlString: urlString)
        }
    }
    
    func loadEconomicDataCategory(){
        
        let category = Category(context: context)
        category.title = "Economic figures"
        category.descript = "Important figures to follow"
        category.image = #imageLiteral(resourceName: "economics")
        
        let urlStrings = [
            "https://www.quandl.com/api/v3/datasets/ODA/FRA_LUR.json?api_key=AMPx4_PVr83RgqPR6uUy",
            "https://www.quandl.com/api/v3/datasets/ODA/FRA_PCPIPCH.json?api_key=AMPx4_PVr83RgqPR6uUy",
            "https://www.quandl.com/api/v3/datasets/ODA/FRA_TMG_RPCH.json?api_key=AMPx4_PVr83RgqPR6uUy",
            "https://www.quandl.com/api/v3/datasets/ODA/FRA_TXG_RPCH.json?api_key=AMPx4_PVr83RgqPR6uUy"
        ]
        
        for urlString in urlStrings{
            downloadFromSource(category: category, urlString: urlString)
        }
    }
    
    func updateCategories(){
        
        loadNewsCategory()
        loadEconomicDataCategory()
        ad.saveContext()
    
    }
    
}
