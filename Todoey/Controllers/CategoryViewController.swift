//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Chen Yi-Wei on 2019/5/24.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }

        let action = UIAlertAction(title: "Add Category", style: .default) { [weak self] (_) in
            print(textField.text!)

            guard let self = self else { return }

            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!

            self.categoryArray.append(newCategory)

            self.saveCategory()

        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            print("Cancel")
        }

        alert.addAction(action)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {

        do {

            self.categoryArray = try context.fetch(request)

        } catch {

            print(error)
        }

        tableView.reloadData()
        
    }

    func saveCategory() {

        do {
            try context.save()

        } catch {
            print("Error saving context, \(error)")
        }

        tableView.reloadData()

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categoryArray[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {

            destinationVC.selectedCategory = categoryArray[indexPath.row]

        }
    }
}
