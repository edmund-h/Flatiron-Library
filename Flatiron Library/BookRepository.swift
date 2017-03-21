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
    private var books: [Book] = []
    
    private init (){}
    
    
// MARK: Core Functions
    
    func getBooklist ( completion: @escaping ()->()) {
        var temp: [Book] = []
        LibraryAPIClient.getBooks { (bookData) in //accepting type [[String:Any]]
            bookData.forEach({ (bookInfo) in
                if let newBook = Book(bookInfo: bookInfo){
                    temp.append(newBook)
                }//append book if an ID is found in bookInfo
            })//attempts to append a book for each in bookData
            self.books = temp.sorted(by: {(first, second) in
                return self.recursiveAlphaCheck(chars1: Array(first.title.lowercased().characters),
                                                          chars2: Array(second.title.lowercased().characters))
            })//sort books alphabetically, checking value of characters recursively
            completion()
        }
    }
    
    func checkOutBook (with text: String, at index: Int, completion: @escaping ()->()) {
        LibraryAPIClient.checkoutBook(with: text, bookId: getBook(at: index).id, success:{ success in
            if let updatedBook = Book(bookInfo: success){
                self.books.remove(at: index)
                self.books.insert(updatedBook, at: index)
                completion()
            }// if a valid book is received from library, replace the old book with an updated book
        })
    }

    
// MARK: Helper/Getter/Setter Functions
    
    func numberOfBooks() -> Int{
        return books.count
    }
    
    func getBook(at index: Int) -> Book{
        return books[index]
    }
    

    
    private func recursiveAlphaCheck (chars1:[Character], chars2:[Character])-> Bool {
        
        if chars1.isEmpty && !chars2.isEmpty{ return true }
        else if chars2.isEmpty{ return false }
        //base case
        
        let val1 = self.checkVal(char: chars1[0])
        let val2 = self.checkVal(char: chars2[0])
        //check for equality of the first characters
        if val1 == val2{
            var rest1 = chars1
            var rest2 = chars2
            //set two new arrays using all but the first characters
            rest1.remove(at: 0)
            rest2.remove(at: 0)
            return recursiveAlphaCheck(chars1: rest1, chars2: rest2)
            //recursive call using the rest of the characters
        }
        return val1 < val2
        //catch case
    }
    
    private func checkVal (char: Character) -> Int{
        let alphabet:[Character:Int] = ["a":0,"b":1,"c":2,"d":3,"e":4,"f":5,"g":6,"h":7,"i":8,"j":9,"k":10,"l":11,"m":12,"n":13,"o":14,"p":15,"q":16,"r":17,"s":18,"t":19,"u":20,"v":21,"w":22,"x":23,"y":24,"z":25]
        if let myVal = alphabet[char] { return myVal }
        //if it's a letter, you get 0->25. otherwise you get 27
        else {return 27}
    }
}
