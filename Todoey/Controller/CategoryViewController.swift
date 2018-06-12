//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Scott Wachtler on 6/11/18.
//  Copyright © 2018 Scott Wachtler. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var catArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

      //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let catitem = catArray[indexPath.row]
        cell.textLabel?.text = catitem.name
        
        //cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //code
        return  catArray.count
    }
    
        //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray[indexPath.row]
        }
    }
    
     //MARK: - Data Manipulation Methods
   
    func saveCategories() {
        do {
            try self.context.save()
        } catch {
            print("Error Saving Context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        //   let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            catArray =  try context.fetch(request)
        } catch {
            print("Error RetrieveL \(error)")
        }
    }
      //MARK: - Add New Categories 
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
        
            let newCategoryItem = Category(context: self.context)
            newCategoryItem.name = textField.text!
            self.catArray.append(newCategoryItem)
            // Use defaults only for small items/configurations, etc
            // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveCategories()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            // print(alertTextField)
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    

    
   
    
}
