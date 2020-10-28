//
//  ViewController.swift
//  News App
//
//  Created by Adwait Barkale on 28/10/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import UIKit



class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NewsAppDelegate {
    
    var newsManager = NewsManager()
    var objNewsData:NewsData!
    let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=25282fd75a1d44198feb661175707321"
    var flagDataFetched = false
    
    
    @IBOutlet weak var newsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newsTable.delegate = self
        newsTable.dataSource = self
        newsTable.rowHeight = UITableView.automaticDimension
        newsTable.estimatedRowHeight = 320
        newsManager.delegate = self
        newsManager.performRequest(with: url)
    }
    
    func setupUI()
    {
        
    }
    
    func didUpdateNews(_ data: NewsData) {
        objNewsData = data
        DispatchQueue.main.async {
            self.flagDataFetched = true
            self.newsTable.reloadData()
        }
     }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flagDataFetched == false{
            return 0
        }
        return objNewsData.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTable.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        let data = objNewsData.articles[indexPath.row]
        cell.lblTitle.text = data.title
        cell.lblDescription.text = data.articleDescription
        cell.imgNews.contentMode = .scaleAspectFill
        if let strUrl = data.urlToImage{
            cell.imgNews.load(url: URL(string: strUrl) ?? URL(string: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")!)
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 320
//    }

}

