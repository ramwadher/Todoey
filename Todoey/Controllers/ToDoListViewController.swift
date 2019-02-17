//
//  ViewController.swift
//  Todoey
//
//  Created by Ram Wadher on 09/02/2019.
//  Copyright © 2019 Ram Wadher. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()

    //below passes the AppDelegate class as an object in our view controller
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }

    
    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        //above references to textlabel that is in every cell.
        
        //Ternery Operator ==>
        //value = condiition ? valueIfTrue : valueIfFalse
        //for the below the line says.  set the cell.accessoryType to checkmark (if item.done is true) or none (if false)
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        
        return cell
    }
    
    
    //MARK -TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //above sets the cell to the opposite of what its at once called upon. ! at the beggining reverses.
        
        saveItems()
    
        //below removes the grey highlight after selecting the row.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        //var textField is within scope for the enitre function. This can then be used within closures to extract data
        
        let alert = UIAlertController(title: "Add new Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once user clicks the add item button on our ui alert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //a placeholder is the grey writing that dissapears
            textField = alertTextField
        }
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
    
    
    //MARK - Model manipulation methods
    
    func saveItems () {
        
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
        
        self.tableView.reloadData() //takes into account the new item
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Failed to retrieve data \(error)")
        }
    }
}

//MARK search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        }
    }
}
