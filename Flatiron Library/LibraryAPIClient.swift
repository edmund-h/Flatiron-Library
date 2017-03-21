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
    private static let session = URLSession.shared
    
    class func getBooks (returnBooks: @escaping ([[String:Any]])->() ){
        print ("in api")
        let targetURL = URL(string: libraryURL)
        guard let finalURL = targetURL else {print("return with bad url"); return}
        let task = session.dataTask(with: finalURL, completionHandler: {(data, response, error) in
                do{
                    guard let data = data else {print("no data received"); return}
                    let sessionData = try JSONSerialization.jsonObject(with: data, options: [])
                    if let searchDict = sessionData as? [[String:Any]]{
                        print("about to call completion from api")
                        returnBooks (searchDict)
                    }else {print ("data improperly formatted")}
                }catch{}
        })
        task.resume()
    }
    
    class func submitBook (bookData: [String:String], success: @escaping (Bool)->()){        let targetURL = URL(string: libraryURL)
        guard let finalURL = targetURL else {print("return with bad url"); return}
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = "POST"
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: bookData, options: [])
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            let dataTask = session.dataTask(with: urlRequest, completionHandler: {(data, error, response) in
                if let response = response as? HTTPURLResponse{
                    switch response.statusCode{
                    case 200...299:
                        success(true)
                    default:
                        success(false)
                    }
                
                }else{print("no response code from server")}
            })
            dataTask.resume()
        }catch{print ("JSON Serialization invalid")}
        
        
    }
    
    class func checkoutBook (with message: String, bookId: Int, success: @escaping ([String:Any])->()){
        let targetURL = URL(string: "\(libraryURL)/\(bookId)")
        guard let finalURL = targetURL else {print("return with bad url"); return}
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = "PUT"
        let bookData: [String: Any] = ["lastcheckedoutby": message, "lastcheckedout": true]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: bookData, options: [])
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            let dataTask = session.dataTask(with: urlRequest, completionHandler: {(data, error, response) in
                if let data = data{
                    do{
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        if let responseDict = responseJSON as? [String:Any]{
                            success(responseDict)
                        }//return response dictionary to VC for use in filling tablefields with new info
                        else {print("could not serialize response JSON")}
                    }catch{print ("could not parse response data")}
                }else{print("no data received in response")}
            })
            dataTask.resume()
        }catch{print ("JSON Serialization invalid")}
    }//this function takes the checkout info that the user wants to send and the book's identifier and sends that to the API
    
    class func deleteBook (id: Int){
        let targetURL = URL(string: "\(libraryURL)/\(id)")
        guard let finalURL = targetURL else {print("return with bad url"); return}
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = "DELETE"
            let dataTask = session.dataTask(with: urlRequest, completionHandler: {(data, error, response) in })
        dataTask.resume()
    }//this function simply sends a delete command to the
}


