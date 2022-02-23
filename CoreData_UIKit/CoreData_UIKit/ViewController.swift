//
//  ViewController.swift
//  CoreData_UIKit
//
//  Created by Nicholas Sseguya on 23/02/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        return table
    }()
    
    private var models: [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TO DO LIST"
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        getAllToDoItems()
        
        setupNavMenu()
        
    }
    
    func setupNavMenu() {
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItems = [addBtn]
    }
    
    @objc private func didTapAdd() {
        
        let alert = UIAlertController(title: "New To Do", message: "Enter new to do title", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.createToDoItem(title: text)
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = model.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ _ in
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit to do title", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.title
            alert.addAction(UIAlertAction(title: "Update", style: .cancel, handler: { [weak self] _ in
                
                guard let field = alert.textFields?.first, let newTitle = field.text, !newTitle.isEmpty else {
                    return
                }
                
                self?.updateToDoItem(toDoItem: item, newTitle: newTitle)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ [weak self] _ in
            self?.deleteToDoItem(toDoItem: item)
        }))
        
        sheet.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        
        // iPad Support
        sheet.popoverPresentationController?.sourceView = self.view
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    
    // MARK :- Core Data
    
    func getAllToDoItems() {
        
        do {
            models = try context.fetch(ToDoItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func createToDoItem(title: String) {
        
        let newToDoItem = ToDoItem(context: context)
        
        newToDoItem.title = title
        newToDoItem.createdAt = Date()
        
        do {
            try context.save()
            getAllToDoItems()
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    
    func deleteToDoItem(toDoItem: ToDoItem) {
        context.delete(toDoItem)
        
        do {
            try context.save()
            getAllToDoItems()
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    
    func updateToDoItem(toDoItem: ToDoItem, newTitle: String) {
        
        toDoItem.title = newTitle
        
        do {
            try context.save()
            getAllToDoItems()
        } catch  {
            print(error.localizedDescription)
        }
        
    }
}

