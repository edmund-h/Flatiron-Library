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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allFields = [titleField, authorField, pubField]
        allFields.forEach({
            ViewFormatter.formatTextField($0)
            $0.delegate = self
        })
        ViewFormatter.formatButton(submitButton)
        ViewFormatter.formatButton(random)
    }//format buttons and fields

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func attemptSubmit(_ sender: UIButton) {
        guard checkFields() else {return} //will not procede if check for all fields to contain text fails
        let dataToSubmit = [
            "title" : titleField.text!,
            "author": authorField.text!,
            "publisher": pubField.text!,
            "url":""
        ]
        LibraryAPIClient.submitBook(bookData: dataToSubmit, success: {_ in })
        DispatchQueue.main.async {  _ = self.navigationController?.popViewController(animated: true)  }
    }
    
    @IBAction func random(_ sender: Any) {
        GoogleBooksAPIClient.getRandomBook(returnBookData: {data in //co
            DispatchQueue.main.async {
                self.titleField.text = data["title"]
                self.authorField.text = data["author"]
                self.pubField.text = data["publisher"]
            }
        })
    }//sends a check to the
    
    func checkFields()-> Bool {
        var mayProcede = true
        allFields.forEach { (thisField) in
            if !thisField.hasText{
                UIView.animate(withDuration: 0.3, animations: {
                    thisField.backgroundColor = UIColor.red
                }, completion: {complete in })
                mayProcede = false
            }//turn the background red for each field that has no text
        }//if even one field has no text this will return false without
        return mayProcede
    }//checks each field to make sure there is text in the text fields
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }//this will make sure background color is white while editing for legibility purposes
}
