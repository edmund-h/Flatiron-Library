//
//  DetailViewController.swift
//  Flatiron Library
//
//  Created by Edmund Holderbaum on 3/14/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var bookIndex: Int?
    let library = BookRepository.sharedInstance

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pubLabel: UILabel!
    @IBOutlet weak var lastCheckedOut: UILabel!
    @IBOutlet weak var checkoutInfo: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let bookIndex = bookIndex else {return}
        let book = library.getBook(at: bookIndex)
        titleLabel.text = book.title
        titleLabel.adjustsFontSizeToFitWidth = true
        authorLabel.text = book.author
        authorLabel.adjustsFontSizeToFitWidth = true
        pubLabel.text = book.publisher
        pubLabel.adjustsFontSizeToFitWidth = true
        
        let chkName = book.lastCheckoutName ?? ""
        let chkDate = book.lastCheckoutDate ?? ""
        let hideBars = book.lastCheckoutDate == nil && book.lastCheckoutName == nil
        checkoutInfo.isHidden = hideBars
        lastCheckedOut.isHidden = hideBars
        checkoutInfo.text = chkName + " - " + chkDate
        // Do any additional setup after loading the view.
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain , target: nil, action: #selector (deleteEntry) )
        self.navigationItem.leftBarButtonItem = deleteButton
    }

    @IBAction func checkOut(_ sender: Any) {
        var checkoutAlert = UIAlertController(title: "Checkout", message: "Please enter your name and the date!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {cancel in})
        let ok = UIAlertAction(title: "Send", style: .default, handler: {ok in
            if let check = checkoutAlert.textFields?[0]{
                guard check.hasText else {return}
                
            }
        })
        checkoutAlert.addTextField(configurationHandler: { (textField) in })
        checkoutAlert.addAction(ok)
        checkoutAlert.addAction(cancel)
    }
    
    func deleteEntry() {
        
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
