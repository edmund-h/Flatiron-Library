//
//  LibraryTableViewController.swift
//  Flatiron Library
//
//  Created by Edmund Holderbaum on 3/13/17.
//  Copyright © 2017 Bozo Design Labs. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {

    let library = BookRepository.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard library.numberOfBooks() == 0 else {return}
        DispatchQueue.global(qos: .background).async {
            LibraryAPIClient.getBooks(returnBooks: {(data) in
                self.library.getBooklist(bookData: data, completion:{self.tableView.reloadData()})
                
                })
            self.tableView.reloadData()
        }
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
        return cell
    }
    
    
    
    
    
    
    
    
    
    
}
    
    
    
    
    
    
    
    
    
    
    
    

    // MARK: Extra functions
 extension LibraryTableViewController {
 
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailView" else {return}
        let destination = segue.destination as! DetailViewController
        let origin = sender as! UITableViewCell
        destination.bookIndex = origin.tag
    }
 

}
