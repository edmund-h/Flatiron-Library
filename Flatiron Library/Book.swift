//
//  Book.swift
//  Flatiron Library
//
//  Created by Edmund Holderbaum on 3/14/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import Foundation
import UIKit

struct Book {
    //critical value:
    let id: Int
    //required values:
    let title: String
    let author: String
    let publisher: String
    //optional values:
    var googleURL: URL? = nil
    var lastCheckoutDate: String? = nil
    var lastCheckoutName: String? = nil
    
    init (title: String, author: String, publisher: String, id: Int){
        self.author = author
        self.title = title
        self.publisher = publisher
        self.id = id
    }//initialize with required values
    
    init?(bookInfo: [String:Any]){
        //return nil if critical value does not exist:
        guard let idInfo = bookInfo["id"] as? Int else {return nil}
        //unwrap required values with a default value of "nil":
        let authorInfo = bookInfo["author"] as? String ?? "nil"
        let titleInfo = bookInfo["title"] as? String ?? "nil"
        let publisherInfo = bookInfo["publisher"] as? String ?? "nil"
        //finally, unwrap optional values as optionals:
        let lastCheckoutDay = bookInfo["lastcheckedout"] as? String? ?? nil
        let lastCheckoutBy = bookInfo["lastcheckedoutby"] as? String? ?? nil
        var url: URL? = nil
        if let urlStr = bookInfo ["url"] as? String{
            url = URL(string: urlStr)
        }//determine if there is a url and if it is a proper url
        //now call init by required values and set optional values:
        self.init(title: titleInfo, author: authorInfo, publisher: publisherInfo, id: idInfo)
        self.googleURL = url
        self.lastCheckoutDate = lastCheckoutDay
        self.lastCheckoutName = lastCheckoutBy
    }//init for unwrapping based on dictionary values. fails if there is no ID
}

extension Book: Equatable {
    public static func ==(lhs: Book, rhs: Book) -> Bool{
        let titles = lhs.title == rhs.title
        let authors = lhs.author == rhs.author
        let ids = lhs.id == rhs.id
        let publishers = lhs.publisher == rhs.publisher
        
        return (titles && authors && ids && publishers)
    }//books are only equatable if all required fields are the same
    
    public static func !=(lhs: Book, rhs: Book) -> Bool{
        let titles = lhs.title == rhs.title
        let authors = lhs.author == rhs.author
        let ids = lhs.id == rhs.id
        let publishers = lhs.publisher == rhs.publisher
        
        return !(titles && authors && ids && publishers)
    }//books are unequal if not all required values are the same
}

extension Book: CustomStringConvertible, Hashable{
    var hashValue: Int{
        return (title.hashValue + author.hashValue) * id.hashValue + publisher.hashValue
    }//i thought this would make a good unique hash value
    
    var description: String{
        return "\(title)- \(author), \(publisher)"
    }//nicely formatted description for ease and uniformity of display
}
