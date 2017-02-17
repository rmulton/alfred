//
//  constants.swift
//  Alfred
//
//  Created by rob on 15/02/2017.
//  Copyright © 2017 rmulton. All rights reserved.
//

import Foundation

// Exemple of accurate get request : https://newsapi.org/v1/articles?source=the-economist&sortBy=top&apiKey=3c27230ba85b4451952ba7f6fd04f956
let BASE_URL = "https://newsapi.org/v1/articles?"
let SOURCE = "source="
let SORT_BY = "&sortBy=top"
let API_KEY = "&apiKey=3c27230ba85b4451952ba7f6fd04f956"
let THE_ECONOMIST = "https://newsapi.org/v1/articles?source=the-economist&sortBy=top&apiKey=3c27230ba85b4451952ba7f6fd04f956"
let HACKER_NEWS = "https://newsapi.org/v1/articles?source=hacker-news&sortBy=top&apiKey=3c27230ba85b4451952ba7f6fd04f956"

typealias DownloadComplete = () -> ()


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
