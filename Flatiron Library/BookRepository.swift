//
//  BookRepository.swift
//  Flatiron Library
//
//  Created by Edmund Holderbaum on 3/14/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import Foundation

class BookRepository{
    static let sharedInstance = BookRepository()
    fileprivate var books: [Book] = []
    
    private init (){}
    
    
// MARK: Core Functions
    
    func getBooklist (bookData: [[String:Any]], completion: ()->()) {
        print ("updating library booklist")
        var temp: [Book] = []
        //LibraryAPIClient.getBooks { (bookData) in
            bookData.forEach({ (bookInfo) in
                let authorInfo = bookInfo["author"] as? String ?? "nil"
                let titleInfo = bookInfo["title"] as? String ?? "nil"
                let publisherInfo = bookInfo["publisher"] as? String ?? "nil"
                let idInfo = bookInfo["id"] as? Int ?? -1
                //standard stuff. i feel like this should be aborted if id is nil but eh
                
                var url: URL? = nil
                if let urlStr = bookInfo ["url"] as? String{
                    url = URL(string: urlStr)
                }//determine if there is a url and if it is a proper url
                let lastCheckoutDay = bookInfo["lastcheckedout"] as? String? ?? nil
                let lastCheckoutBy = bookInfo["lastcheckedoutby"] as? String? ?? nil
                
                var book = Book(title: titleInfo, author: authorInfo, publisher: publisherInfo, id: idInfo)
                //actually put the struct together here, optionals go in below
                book.googleURL = url
                book.lastCheckoutDate = lastCheckoutDay
                book.lastCheckoutName = lastCheckoutBy
                
                //now append to temp for alphabetization
                temp.append(book)
            })
        //}
        self.books = temp.sorted(by: {(first, second) in
            return BookRepository.recursiveAlphaCheck(chars1: Array(first.title.lowercased().characters),
                                       chars2: Array(second.title.lowercased().characters))
            
        })
        print ("finishing up...\(self.books)")
        completion()
        
    }

    
// MARK: Helper/Getter/Setter Functions
    
    func numberOfBooks() -> Int{
        return books.count
    }
    
    func getBook(at index: Int) -> Book{
        return books[index]
    }
    
    static fileprivate func recursiveAlphaCheck (chars1:[Character], chars2:[Character])-> Bool {
        
        if chars1.isEmpty && !chars2.isEmpty{ return true }
        else if chars2.isEmpty{ return false }
        //base case
        
        let val1 = Alphabet.checkVal(char: chars1[0])
        let val2 = Alphabet.checkVal(char: chars2[0])
        if val1 == val2{
            var rest1 = chars1
            var rest2 = chars2
            rest1.remove(at: 0)
            rest2.remove(at: 0)
            return recursiveAlphaCheck(chars1: rest1, chars2: rest2)
            //recursive call using the rest of the characters
        }
        return val1 < val2
        //catch case
    }
    
}

enum Alphabet: Int{
    case a=0,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
    
    static func checkVal (char: Character) -> Int{
        let dict:[Character:Alphabet] = ["a":.a, "b":.b,"c":.c,"d":.d,"e":.e,"f":.f,"g":.g,"h":.h,"i":.i,"j":.j,
                                         "k":.k,"l":.l,"m":.m,"n":.n,"o":.o,"p":.p,"q":.q,"r":.r,"s":.s,"t":.t,
                                         "u":.u,"v":.v,"w":.w,"x":.x,"y":.y,"z":.z]//yeah i know
        if let myVal = dict[char]?.rawValue{ return myVal }
        //if it's a letter, you get 0->26. otherwise you get 27
        else {return 27}
    }
}
