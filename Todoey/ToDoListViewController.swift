//
//  ViewController.swift
//  Todoey
//
//  Created by Ram Wadher on 09/02/2019.
//  Copyright © 2019 Ram Wadher. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Ram"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find Car"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Food"
        itemArray.append(newItem3)
        

        
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
//        }
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //above sets the dcell to the opposite of what its at once called upon. ! at the beggining reverses.
        
        tableView.reloadData()

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
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData() //takes into account the new item
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //a placeholder is the grey writing that dissapears
            textField = alertTextField
        }
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
    

}
