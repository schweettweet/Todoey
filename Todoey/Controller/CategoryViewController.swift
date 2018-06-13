//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Scott Wachtler on 6/11/18.
//  Copyright © 2018 Scott Wachtler. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var catArray: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of Rows \(catArray?.count)")
        return  catArray?.count ?? 1
    }

      //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = catArray?[indexPath.row].name ?? "No Categories Added"
        //cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    

    
        //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    //seque: UIStoryBoardSeque?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        print("Row: \(tableView.indexPathForSelectedRow?.row)")
        
        if let indexPath = tableView.indexPathForSelectedRow {
            print("Cat Array: \(catArray?[indexPath.row])")
            destinationVC.selectedCategory = catArray?[indexPath.row]
        }
   
    }
    
     //MARK: - Data Manipulation Methods
   
    func save(category: Category) {
        do {
            // for Core Data use: try self.context.save()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Context \(error)")
        }
        self.tableView.reloadData()
    }
    

    
    func loadCategories(){
        catArray = realm.objects(Category.self)
        tableView.reloadData()
    }

   
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
        
            let newCategoryItem = Category()
            newCategoryItem.name = textField.text!

            self.save(category: newCategoryItem)
         //   self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create New Category"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    

    
   
    
}
