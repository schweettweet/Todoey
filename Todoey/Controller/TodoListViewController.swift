//
//  ViewController.swift
//  Todoey
//
//  Created by Scott Wachtler on 6/9/18.
//  Copyright © 2018 Scott Wachtler. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController, UITextViewDelegate {

    var itemArray = [Item]()
    //singleton
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   let newItem = Item()
     //   newItem.title = "Find Mike"
     //   itemArray.append(newItem)
        
        
        // Do any additional setup after loading the view, typically from a nib.
      //  if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
      //      itemArray = items
      //  }
        loadItems()
        
    }

    //MARK - Tableview Datasource Methods
    
    //Cell Display, and how many rows.
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        //above replaces the if then below
        //if item.done == true{
        //   cell.accessoryType = .checkmark
        //} else {
        //    cell.accessoryType = .none
       //}
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //code
       return  itemArray.count
    }

    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
       // itemArray[indexPath.row].done
       // if itemArray[indexPath.row].done == true {
       //     itemArray[indexPath.row].done = false
       // } else {
       //     itemArray[indexPath.row].done = true
       // }
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.reloadData()
      //  if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
    //     tableView.cellForRow(at: indexPath)?.accessoryType = .none
     //   } else {
     //   tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
     //   }
     //   tableView.deselectRow(at: indexPath , animated: true)
       // tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when the user click on the add button on the alert
           // print(textField.text)
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
           // Use defaults only for small items/configurations, etc
           // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
           // print(alertTextField)
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error Encoding:  \(error)")
        }
        
        
    }
    
    func loadItems(){
        if let data =  try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error Decode: \(error)")
                
            }
        }
        
        
    }
    
}

