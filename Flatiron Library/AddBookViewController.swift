//
//  AddBookViewController.swift
//  Flatiron Library
//
//  Created by Edmund Holderbaum on 3/14/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var pubField: UITextField!
    var allFields: [UITextField] = []
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var random: UIButton!
    var tries = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allFields = [titleField, authorField, pubField]
        // Do any additional setup after loading the view.
        allFields.forEach({
            ViewFormatter.formatTextField($0)
            $0.delegate = self
        })
        ViewFormatter.formatButton(submitButton)
        ViewFormatter.formatButton(random)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func attemptSubmit(_ sender: UIButton) {
        guard checkFields() else {return}
        let dataToSubmit = [
            "title" : titleField.text!,
            "author": authorField.text!,
            "publisher": pubField.text!,
            "url":""
        ]
        print ("about to call submission with data: \(dataToSubmit)")
        LibraryAPIClient.submitBook(bookData: dataToSubmit, success: {_ in })
        DispatchQueue.main.async {  self.navigationController?.popViewController(animated: true)  }
    }
    
    @IBAction func random(_ sender: Any) {
        GoogleBooksAPIClient.getRandomBook(returnBookData: {data in
            DispatchQueue.main.async {
                self.titleField.text = data["title"]
                self.authorField.text = data["author"]
                self.pubField.text = data["publisher"]
            }
        })
    }
    
    func checkFields()-> Bool { //checks if there is text in the text fields
        var mayProcede = true
        allFields.forEach { (thisField) in
            if !thisField.hasText{
                UIView.animate(withDuration: 0.3, animations: {
                    thisField.backgroundColor = UIColor.red
                }, completion: {complete in })
                mayProcede = false
                tries += 1
            }
        }
        return mayProcede
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
}
