//
//  ViewController.swift
//  Todoey
//
//  Created by Scott Wachtler on 6/9/18.
//  Copyright © 2018 Scott Wachtler. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class TodoListViewController: UITableViewController, UITextViewDelegate {

   // Core Data Declaration var itemArray = [Item]()
    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //code
        return  toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items"
        }
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row]{
            do {
            try realm.write{
                //realm.delete(item)
                item.done = !item.done
                }} catch {
                    print("Error updating done: \(error)")
            }
        }
        tableView.reloadData()
       tableView.deselectRow(at: indexPath , animated: true)
  
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            print ("comparing Current Category and Selected Cat: \(self.selectedCategory)")
            if let currentCategory = self.selectedCategory{
                print("it did equal")
                do{
                    print("I am Doing")
                    try self.realm.write {
                        print("I'm trying")
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
    
                }
                } catch {
                    print("Error Writing: \(error)")
                }
                
            }
            self.tableView.reloadData()
        }  //Not sure this closing bracket is in the right place, but I know it needs to be near here as the function
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
           // print(alertTextField)
            textField = alertTextField
        }
            
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
//    func saveItems() {
//
//        do {
//           try self.context.save()
//
//        } catch {
//            print("Error Saving Context \(error)")
//        }
//
//       self.tableView.reloadData()
//
//    }

    
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    
    
}

//MARK: - Search Bar Method
extension TodoListViewController: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()  

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

