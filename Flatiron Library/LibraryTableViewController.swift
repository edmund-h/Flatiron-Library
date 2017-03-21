//
//  LibraryTableViewController.swift
//  Flatiron Library
//
//  Created by Edmund Holderbaum on 3/13/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//


//TODO : Fix excessive dispatch queue calls. remove and rename parameters in a more swifty way. remove print statements

import UIKit

class LibraryTableViewController: UITableViewController {

    let library = BookRepository.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            self.library.getBooklist( completion:{
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            })//pass an order to the library to get books asynchronously. then in the completion closure reload table cells back on the main queue.
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return library.numberOfBooks()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.tag = indexPath.row
        cell.textLabel!.text = library.getBook(at: indexPath.row).title
        cell.detailTextLabel!.text = library.getBook(at: indexPath.row).author
        ViewFormatter.formatTableCell(cell)
        return cell
    }//fill cell with text, format, and pass to tableView
}

    // MARK: Extra functions
 extension LibraryTableViewController {


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailView" else {return}
        guard let selectedRow = tableView.indexPathForSelectedRow?.row else {return}
        let destination = segue.destination as! DetailViewController
        destination.bookIndex = selectedRow
    }
}
