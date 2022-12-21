//
//  CategoryViewController.swift
//  ToDo-App
//
//  Created by TTGMOTSF on 06/11/2022.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Changing status bar color
        statusBarColorChange(colour: HexColor("E8C413")!)
        loadCategories()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //statis bar color goes back to yellow when view appears again
        statusBarColorChange(colour: HexColor("E8C413")!)
        guard let navBar = navigationController?.navigationBar else {fatalError("Found nil while asigning naviationController")}
        
        navBar.backgroundColor = UIColor(hexString: "E8C413")

    }
    
    //Mark: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
       
        if let category = categories?[indexPath.row]{
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
                    cell.backgroundColor = categoryColour
                    cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    //Saving Categories into realm Database
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    //Loading saved Categories from database
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //Mark: - Delete Data from Swipe
    override func deleteModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //Mark: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a New Cateogry", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {[self](action) in
            let newCategory = Category()
            //Checking if textfield is empty or not
            guard !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! else {return}
                
            //If it's not empty, we trigger the following code
                newCategory.name = textField.text!
                newCategory.colour = UIColor.randomFlat().hexValue()
                save(category: newCategory)
            }
        
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //Mark: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDoViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
   //MARK: - Customazing status bar
    
    func statusBarColorChange(colour: UIColor){

        if #available(iOS 13.0, *) {

                let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
                statusBar.backgroundColor = colour
                statusBar.tag = 100
                UIApplication.shared.keyWindow?.addSubview(statusBar)

        } else {
                let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                statusBar?.backgroundColor = colour
        }
    }
}

