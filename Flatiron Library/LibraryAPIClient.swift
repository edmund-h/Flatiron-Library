//
//  LibraryAPIClient.swift
//  Flatiron Library
//
//  Created by Edmund Holderbaum on 3/13/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import Foundation

class LibraryAPIClient{
    
    static let libraryURL = "https://flatironchallenge.herokuapp.com/books"
    
    class func getBooks (returnBooks: @escaping ([[String:Any]])->() ){
        print ("getBooks called")
        let targetURL = URL(string: libraryURL)
        guard let finalURL = targetURL else {print("return with bad url"); return}
        print("URL check passed")
        DispatchQueue.global(qos: .background).async{
            let session = URLSession.shared
            print("commencing URLSession")
            let task = session.dataTask(with: finalURL, completionHandler: {(data, response, error) in
                do{
                    guard let data = data else {print("no data received"); return}
                    let sessionData = try JSONSerialization.jsonObject(with: data, options: [])
                    DispatchQueue.main.async {
                        if let searchDict = sessionData as? [[String:Any]]{
                            print ("booklist found by API client")
                            returnBooks(searchDict)
                        }else {print ("data improperly formatted")}
                    }
                }catch{}
                
            })
            task.resume()
        }//internet connection happens off main queue
    }
}
