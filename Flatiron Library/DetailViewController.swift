//
//  DetailViewController.swift
//  Flatiron Library
//
//  Created by Edmund Holderbaum on 3/14/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController{
    
    var bookIndex: Int?
    let library = BookRepository.sharedInstance

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pubLabel: UILabel!
    @IBOutlet weak var lastCheckedOut: UILabel!
    @IBOutlet weak var checkoutInfo: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabelsWithBookInfo()
        let allLabels = [titleLabel, authorLabel, pubLabel, lastCheckedOut, checkoutInfo]
        allLabels.forEach({
            $0!.adjustsFontSizeToFitWidth = true
            ViewFormatter.formatLabel($0!)
        })//formatting for buttons and labels is done in this area
        ViewFormatter.formatButton(checkoutButton)
        
        //create a navigation button for record deletion
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain , target: self, action: #selector (deleteEntry) )
        self.navigationItem.rightBarButtonItem = deleteButton
    }

    @IBAction func checkOut(_ sender: Any) {
        let checkoutAlert = UIAlertController(title: "Checkout", message: "Please enter your name and the date!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {cancel in})
        let ok = UIAlertAction(title: "Send", style: .default, handler: {ok in
            
            if let check = checkoutAlert.textFields?[0], let bookIndex = self.bookIndex{
                guard check.hasText else {return} // do nothing if no text
                self.library.checkOutBook(with: check.text!, at: bookIndex, completion: { //accepting type [String:Any]
                    DispatchQueue.main.sync {
                        //unhides text fields and updates them with data received from API
                        self.updateLabelsWithBookInfo()
                    }
                })// call to library API with text to update
            }
        })//when OK is pressed, sends new checkout data to API if there is text in the field
        checkoutAlert.addTextField(configurationHandler: { (textField) in })
        checkoutAlert.addAction(ok)
        checkoutAlert.addAction(cancel)
        self.present(checkoutAlert, animated: true, completion: nil)
    }//this function presents an alert controller that will send checkout data to the library API and updates labels accordingly
    
    func deleteEntry() {
        guard let bookIndex = bookIndex else {return}
        let bookID = library.getBook(at: bookIndex).id
        LibraryAPIClient.deleteBook(id: bookID)
        _ = self.navigationController?.popViewController(animated: true)
    }//this function sends a call to the api to delete the book, returning to the booklist
    
    func updateLabelsWithBookInfo(){
        guard let bookIndex = bookIndex else {return}
        let book = library.getBook(at: bookIndex)
        titleLabel.text = book.title
        authorLabel.text = book.author
        pubLabel.text = book.publisher
        let chkName = book.lastCheckoutName ?? ""
        //this will hide the label bars related to checkout if no checkout data has been received
        let hideBars = book.lastCheckoutDate == nil && book.lastCheckoutName == nil
        checkoutInfo.isHidden = hideBars
        lastCheckedOut.isHidden = hideBars
        checkoutInfo.text = chkName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
