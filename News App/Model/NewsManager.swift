//
//  NetworkManager.swift
//  News App
//
//  Created by Adwait Barkale on 28/10/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import Foundation

//https://newsapi.org/v2/top-headlines?country=us&apiKey=yourapikey
//Api Key - 25282fd75a1d44198feb661175707321


protocol NewsAppDelegate{
    func didUpdateNews(_ data: NewsData)
}

struct NewsManager{
    
    //let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=25282fd75a1d44198feb661175707321"
    var delegate: NewsAppDelegate?
    
    func performRequest(with url:String)
    {
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil
                {
                    
                }else{
                    if let safeData = data{
                        if let newsData = self.parseJSON(safeData){
                            self.delegate?.didUpdateNews(newsData)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> NewsData?
    {
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(NewsData.self, from: data)
            print(decodedData.articles[0].title ?? "N/A")
            //print(decodedData.articles[0].author)
            //print(decodedData.articles[0].articleDescription)
            //print(decodedData.articles[0].urlToImage)
            return decodedData
        }catch let err{
            print(err)
            return nil
        }
    }
    
}
