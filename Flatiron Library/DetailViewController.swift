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
        guard let bookIndex = bookIndex else {return}
        let book = library.getBook(at: bookIndex)
        let allLabels = [titleLabel, authorLabel, pubLabel, lastCheckedOut, checkoutInfo]
        titleLabel.text = book.title
        authorLabel.text = book.author
        pubLabel.text = book.publisher
        let chkName = book.lastCheckoutName ?? ""
        let hideBars = book.lastCheckoutDate == nil && book.lastCheckoutName == nil
        checkoutInfo.isHidden = hideBars
        lastCheckedOut.isHidden = hideBars
        checkoutInfo.text = chkName
        
        allLabels.forEach({
            $0!.adjustsFontSizeToFitWidth = true
            ViewFormatter.formatLabel($0!)
        })
        ViewFormatter.formatButton(checkoutButton)
        
        // Do any additional setup after loading the view.
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain , target: self, action: #selector (deleteEntry) )
        self.navigationItem.rightBarButtonItem = deleteButton
    }

    @IBAction func checkOut(_ sender: Any) {
        let checkoutAlert = UIAlertController(title: "Checkout", message: "Please enter your name and the date!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {cancel in})
        let ok = UIAlertAction(title: "Send", style: .default, handler: {ok in
            if let check = checkoutAlert.textFields?[0]{
                guard check.hasText else {return}
                DispatchQueue.global(qos: .background).async {
                    LibraryAPIClient.checkoutBook(checkout: check.text!, id: self.library.getBook(at: self.bookIndex!).id, success: {success in
                        print ("success called")
                        guard let text = success["lastcheckedoutby"] as? String else {return}
                        DispatchQueue.main.async {
                            self.lastCheckedOut.isHidden = false
                            self.checkoutInfo.isHidden = false
                            self.checkoutInfo.text = text
                        }
                    })
                }
            }
        })
        checkoutAlert.addTextField(configurationHandler: { (textField) in })
        checkoutAlert.addAction(ok)
        checkoutAlert.addAction(cancel)
        self.present(checkoutAlert, animated: true, completion: nil)
    }
    
    func deleteEntry() {
        guard let bookIndex = bookIndex else {return}
        let bookID = library.getBook(at: bookIndex).id
        LibraryAPIClient.deleteBook(toDelete: bookIndex, id: bookID)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
