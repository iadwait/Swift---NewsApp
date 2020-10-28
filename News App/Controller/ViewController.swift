//
//  ViewController.swift
//  News App
//
//  Created by Adwait Barkale on 28/10/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NewsAppDelegate,UITextFieldDelegate {
    
    var newsManager = NewsManager()
    var refresher = UIRefreshControl()
    var objNewsData:NewsData!
    var tempNewsData:NewsData!
    var emptyNewsData:NewsData!
    var searchedText = ""
    
    let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=25282fd75a1d44198feb661175707321"
    var flagDataFetched = false
    
    
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        newsTable.delegate = self
        newsTable.dataSource = self
        newsTable.rowHeight = UITableView.automaticDimension
        newsTable.estimatedRowHeight = 320
        newsManager.delegate = self
        txtSearch.delegate = self
        newsManager.performRequest(with: url)
        tempNewsData = objNewsData
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        newsTable.addSubview(refresher)
    }
    
    @objc func refreshData()
    {
        print("Refresh Table Data")
        txtSearch.text = ""
        viewSearch.isHidden = true
        viewTop.isHidden = false
        newsManager.performRequest(with: url)
        refresher.endRefreshing()
    }
    
    func setupUI()
    {
        viewSearch.isHidden = true
        txtSearch.text = "Search News..."
    }
    
    @IBAction func btnSearchTapped(_ sender: UIButton) {
        viewSearch.isHidden = false
        viewTop.isHidden = true
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        viewTop.isHidden = false
        viewSearch.isHidden = true
        view.endEditing(true)
    }
    
    @IBAction func btnCrossTapped(_ sender: UIButton) {
        searchedText = ""
        txtSearch.text = ""
    }
    
    
    func didUpdateNews(_ data: NewsData) {
        objNewsData = data
        tempNewsData = objNewsData
        DispatchQueue.main.async {
            self.flagDataFetched = true
            self.newsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flagDataFetched == false{
            return 0
        }
        return tempNewsData.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTable.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        let data = tempNewsData.articles[indexPath.row]
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtSearch{
            textField.text = ""
            searchedText = ""
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtSearch.text != ""
        {
            searchedText = txtSearch.text!
            updateTableData(searchText: searchedText)
        }
        view.endEditing(true)
        
        return true
    }
    
    func updateTableData(searchText:String)
    {
        print(searchedText)
        //tempNewsData = emptyNewsData
        tempNewsData.articles.removeAll()
        //flagDataFetched = false
        let articlesCount = objNewsData.articles.count
        
        if articlesCount > 0{
            for search in 0..<articlesCount{
                let data = objNewsData.articles[search].title
                let range = data?.lowercased().range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil{
                    self.tempNewsData.articles.append(objNewsData.articles[search])
                    flagDataFetched = true
                }
            }
        }
        if tempNewsData.articles.count == 0{
            tempNewsData = objNewsData
            flagDataFetched = true
        }
        newsTable.reloadData()
    }
    
}
//@objc func searchText()
//{
//    self.tempArray.removeAll()
//
//    if txtSearchField.text?.count != 0
//    {
//        for search in 0..<arrChatData.count{
//
//            let data = arrChatData[search].name
//            guard let nameToSearch = txtSearchField.text else{ return }
//            let range = data.lowercased().range(of: nameToSearch, options: .caseInsensitive, range: nil, locale: nil)
//            if range != nil{
//                self.tempArray.append(arrChatData[search])
//            }
//
//        }        }else{
//        for obj in arrChatData{
//            self.tempArray.append(obj)
//        }
//    }
//    tableViewChat.reloadData()
//}
