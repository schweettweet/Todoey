//
//  ViewController.swift
//  Todoey
//
//  Created by Scott Wachtler on 6/9/18.
//  Copyright © 2018 Scott Wachtler. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController, UITextViewDelegate {

    var itemArray = [Item]()
    //singleton
    //let defaults = UserDefaults.standard
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   let newItem = Item()
     //   newItem.title = "Find Mike"
     //   itemArray.append(newItem)
        
        // use this to find out where your data is being stored
        
        // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        
        // Do any additional setup after loading the view, typically from a nib.
      //  if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
      //      itemArray = items
      //  }
 
       // loadItems()
      
        
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
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(itemArray[indexPath.row])
        
        
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
            //let newItem = Item()
            
       
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
   
        do {
           try self.context.save()
            
        } catch {
            print("Error Saving Context \(error)")
        }
        
       self.tableView.reloadData()
        
    }
    
    // Item.fetchRequest is by "default" ie function is called without an parameter
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
    
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
      
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        // Line above is same as below, just used optional binding (above does that is)
        //let compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate,categoryPredicate])
        //request.predicate = compoundPredicate
        
        //   let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
           itemArray =  try context.fetch(request)
        } catch {
            print("Error RetrieveL \(error)")
        }
    
    }
    

    
    
}

//MARK: - Search Bar Method
extension TodoListViewController: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //print(searchBar.text!)
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // Long Hand for Above:
        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //request.predicate = predicate
       
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //Long Hand for Above
        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        //request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
        //Moved Below into the loadItems Function
        //do {
        //    itemArray =  try context.fetch(request)
        //} catch {
        //    print("Error RetrieveL \(error)")
        // }
       // tableView.reloadData()
        
        
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

