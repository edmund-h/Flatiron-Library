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
        let session = URLSession.shared
        print("commencing URLSession")
        let task = session.dataTask(with: finalURL, completionHandler: {(data, response, error) in
            
                do{
                    guard let data = data else {print("no data received"); return}
                    let sessionData = try JSONSerialization.jsonObject(with: data, options: [])
                    DispatchQueue.main.async {
                        if let searchDict = sessionData as? [[String:Any]]{
                            print ("booklist found by API client")
                            print (searchDict)
                            returnBooks (searchDict)
                            print ("apiclient called completion")
                        }else {print ("data improperly formatted")}
                        }
                }catch{}
            
        })
        task.resume()
    }
    
    class func submitBook (bookData: [String:String], success: @escaping (Int)->()){
        print ("submitBook called")
        let targetURL = URL(string: libraryURL)
        guard let finalURL = targetURL else {print("return with bad url"); return}
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = "POST"
        let session = URLSession.shared
        do{
            print("initiating session with server")
            let jsonData = try JSONSerialization.data(withJSONObject: bookData, options: [])
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            let dataTask = session.dataTask(with: urlRequest, completionHandler: {(data, error, response) in
                if let data = data{
                    do{
                        print ("response received from server")
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        if let responseDict = responseJSON as? [String:Any]{ print(responseDict) }
                        else {print("could not serialize response JSON")}
                    }catch{print ("could not parse response data")}
                }else{print("no data received in response")}
                if let response = response as? HTTPURLResponse{
                    success(response.statusCode)
                
                }else{print("no response code from server")}
            })
            dataTask.resume()
        }catch{print ("JSON Serialization invalid")}
        
        
    }
    
    class func checkoutBook (checkout: String, id: Int, success: @escaping ([String:Any])->()){
        print ("submitBook called")
        let targetURL = URL(string: "\(libraryURL)/\(id)")
        guard let finalURL = targetURL else {print("return with bad url"); return}
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = "PUT"
        let session = URLSession.shared
        let bookData: [String: Any] = ["lastcheckedoutby": checkout, "lastcheckedout": true]
        do{
            print("initiating session with server")
            let jsonData = try JSONSerialization.data(withJSONObject: bookData, options: [])
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            let dataTask = session.dataTask(with: urlRequest, completionHandler: {(data, error, response) in
                if let data = data{
                    do{
                        print ("response received from server")
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        if let responseDict = responseJSON as? [String:Any]{ success(responseDict) }
                        else {print("could not serialize response JSON")}
                    }catch{print ("could not parse response data")}
                }else{print("no data received in response")}
            })
            dataTask.resume()
        }catch{print ("JSON Serialization invalid")}
    }
    
    class func deleteBook (toDelete: Int, id: Int){
        print ("deleteBook called")
        let targetURL = URL(string: "\(libraryURL)/\(id)")
        guard let finalURL = targetURL else {print("return with bad url"); return}
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = "DELETE"
        let session = URLSession.shared
            print("initiating session with server")
            let dataTask = session.dataTask(with: urlRequest, completionHandler: {(data, error, response) in
                if let data = data{
                    do{
                        print ("response received from server")
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        if let responseDict = responseJSON as? [String:Any]{ print(responseDict) }
                        else {print("could not serialize response JSON")}
                    }catch{print ("could not parse response data")}
                }else{print("no data received in response")}
            })
        dataTask.resume()
    }
}


