//
//  ViewController.swift
//  CoreTable
//
//  Created by Lukas Muller on 18/09/16.
//  Copyright © 2016 Lukas Muller. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  var items = [NSManagedObject]()
  let haha = ["World", "Tea", "Human"]
  
  let cellId = "cell"
  
  let tableView: UITableView = {
    let tv = UITableView()
    return tv
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.frame = view.frame
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    tableView.dataSource = self
    tableView.delegate = self
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
    
    do {
      let results = try managedContext.fetch(fetchRequest)
      items = results as! [NSManagedObject]
      
    }
    catch let error as NSError {
      print("Could not fetch \(error.userInfo)")
    }
  }
  
  func addAction(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Name your thing", message: nil, preferredStyle: .alert)
    
    alert.addTextField { textfield in
      textfield.placeholder = "Name your task..."
    }
    
    let action1 = UIAlertAction(title: "Add", style: .default) { action in
      print("Do stuff with \(alert.textFields![0].text!)")
      self.saveItem(taskName: alert.textFields![0].text!)
    }
    
    alert.addAction(action1)
    
    let action2 = UIAlertAction(title: "Cancel", style: .destructive) { action in
      print("cancel")
    }
    
    alert.addAction(action2)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  func saveItem(taskName: String) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)
    let item = NSManagedObject(entity: entity!, insertInto: managedContext)
    item.setValue(taskName, forKey: "task")
    item.setValue(false, forKey: "done")
    do {
      try managedContext.save()
      items.append(item)
      tableView.reloadData()
      // Append ?
    } catch {
      print("error")
    }
  }
}

extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
    let item = items[indexPath.row]
    cell?.textLabel?.text = item.value(forKey: "task") as? String
    return cell!
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    managedContext.delete(items[indexPath.row])
    items.remove(at: indexPath.row)
    tableView.reloadData()
  }
  
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    managedContext.delete(items[indexPath.row])
    items.remove(at: indexPath.row)
    tableView.reloadData()
  }
}
