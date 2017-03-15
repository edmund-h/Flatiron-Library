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
    let title: String
    let author: String
    let id: Int
    var lastCheckoutDate: String? = nil
    var lastCheckoutName: String? = nil
    let publisher: String
    var googleURL: URL? = nil
    
    init (title: String, author: String, publisher: String, id: Int){
        self.author = author
        self.title = title
        self.publisher = publisher
        self.id = id
    }
    
    mutating func hasBeenCheckedOut (name: String, date: String){
        self.lastCheckoutDate = date
        self.lastCheckoutName = name
    }
}

extension Book: Equatable {
    public static func ==(lhs: Book, rhs: Book) -> Bool{
        let titles = lhs.title == rhs.title
        let authors = lhs.author == rhs.author
        let ids = lhs.id == rhs.id
        let publishers = lhs.publisher == rhs.publisher
        
        return (titles && authors && ids && publishers)
    }
    public static func !=(lhs: Book, rhs: Book) -> Bool{
        let titles = lhs.title == rhs.title
        let authors = lhs.author == rhs.author
        let ids = lhs.id == rhs.id
        let publishers = lhs.publisher == rhs.publisher
        
        return !(titles && authors && ids && publishers)
    }
}

extension Book: CustomStringConvertible, Hashable{
    var hashValue: Int{
        return (title.hashValue + author.hashValue) * id.hashValue + publisher.hashValue
    }
    
    var description: String{
        return "\(title)- \(author), \(publisher)"
    }
}
