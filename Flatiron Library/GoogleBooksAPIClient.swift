//
//  GoogleBooksAPIClient.swift
//  Flatiron Library
//
//  Created by Edmund Holderbaum on 3/14/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import Foundation

class GoogleBooksAPIClient{
    class func getRandomBook (returnBookData: @escaping ([String:String])->() ){
        print ("getBooks called")
        let targetURL = URL(string: "https://www.googleapis.com/books/v1/volumes?q=programming")
        guard let finalURL = targetURL else {print("return with bad url"); return}
        print("URL check passed")
        let session = URLSession.shared
        print("commencing URLSession")
        let task = session.dataTask(with: finalURL, completionHandler: {(data, response, error) in
            
            do{
                guard let data = data else {print("no data received"); return}
                let sessionData = try JSONSerialization.jsonObject(with: data, options: [])
                    if let searchDict = sessionData as? [String:Any]{
                        if let items = searchDict["items"] as? [[String:Any]]{
                            print("getting a random result from Google JSON")
                            let num = Int(arc4random_uniform(UInt32(items.count)))
                            let googleBook = items[num]
                            if let volumeInfo = googleBook["volumeInfo"] as? [String:Any]{
                                var dict:[String:String] = [:]
                                if let authors = volumeInfo["authors"] as? [String]{
                                    var author = ""
                                    authors.forEach({ author.append($0 + " ")})
                                    dict["author"] = author
                                }else{dict["author"] = "err"}
                                if let myTitle = volumeInfo["title"] as? String {
                                    dict["title"] = myTitle
                                }else{dict["title"] = "err"}
                                if let myPublisher = volumeInfo["publisher"] as? String {
                                    dict["publisher"] = myPublisher
                                }else{dict["publisher"] = "err"}
                                if let urlurlurl = volumeInfo["canonicalVolumeLink"] as? String {
                                    dict["url"] = urlurlurl
                                }else{dict["url"] = "err.com"}
                                print(dict)
                                returnBookData(dict)
                            }
                        }else{print("couldn't get items")}
                    }else {print ("data improperly formatted")}
            }catch{}
            
        })
        task.resume()
    }
}
