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
