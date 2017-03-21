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
        let targetURL = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(randomSubject())")
        //i have hard coded the parameter into the url as there is only one parameter determined internally
        guard let finalURL = targetURL else {print("return with bad url"); return}
        let session = URLSession.shared
        let task = session.dataTask(with: finalURL, completionHandler: {(data, response, error) in
            do{
                guard let data = data else {print("no data received"); return}
                let sessionData = try JSONSerialization.jsonObject(with: data, options: [])
                    if let searchDict = sessionData as? [String:Any]{
                        if let randomBook = unwrapGoogleJSON(searchDict){
                            returnBookData(randomBook)
                        }else {print("could not unwrap google JSON")}
                    }else {print ("data improperly formatted")}
            }catch{}
            
        })
        task.resume()
    }//This function gets a random book from google to pass to VC in [String:String] form.
    
    private class func unwrapGoogleJSON (_ data: [String:Any])->[String:String]?{
        if let items = data["items"] as? [[String:Any]]{
            let num = Int(arc4random_uniform(UInt32(items.count)))
            let googleBook = items[num]
            if let volumeInfo = googleBook["volumeInfo"] as? [String:Any]{
                
                var dict:[String:String] = [:]
                if let authors = volumeInfo["authors"] as? [String]{
                    var author = ""
                    authors.forEach({ author.append($0 + " ")})
                    dict["author"] = author
                }else{dict["author"] = "err"}
                
                dict["title"] = volumeInfo["title"] as? String ?? "err"
                dict["publisher"] = volumeInfo["publisher"] as? String ?? "err"
                dict["url"] = volumeInfo["canonicalVolumeLink"] as? String ?? "err"
                
                return dict
            }else{print("couldn't get volumeInfo")}
        }else{print("couldn't get items")}
        return nil
    }//This function attempts to unwrap JSON from google books API into a dictionary of [String:String] for use in VC
    
    private class func randomSubject()-> String {
        let subjects = ["programming","swift+ios","xcode","computer+science","science","history+of+science"]
        let num = arc4random_uniform(UInt32(subjects.count))
        return subjects[Int(num)]
    }
}
