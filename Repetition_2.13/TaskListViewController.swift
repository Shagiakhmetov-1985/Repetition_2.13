//
//  ViewController.swift
//  Repetition_2.13
//
//  Created by Marat Shagiakhmetov on 16.11.2022.
//

import UIKit
import CoreData

// MARK: - Setup main view TaskListViewConrtoller
class TaskListViewController: UITableViewController {
    
    private let cellID = "cell"
    private var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        getData()
    }
    // MARK: - Setup view
    private func setupView() {
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    // MARK: - Setup navigation bar
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearance.backgroundColor = UIColor(
            red: 22/255,
            green: 155/255,
            blue: 75/255,
            alpha: 1
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    // MARK: - Setup bar button
    @objc private func addNewTask() {
        showAlert()
    }
    // MARK: - Work with save button on the alert controller
    private func save(taskName: String) {
        StorageManager.shared.save(taskName: taskName) { task in
            taskList.append(task)
            tableView.insertRows(
                at: [IndexPath(row: taskList.count - 1, section: 0)],
                with: .automatic
            )
        }
    }
    // MARK: - Get data
    private func getData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let tasks):
                taskList = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension TaskListViewController {
    // Task list
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    // Edit task
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Delete task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        
        if editingStyle == .delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(task: task)
        }
    }
}
// MARK: - Alert controller
extension TaskListViewController {
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Update Task" : "New Task"
        
        let alert = AlertController(
            title: title,
            message: "What do you want to do?",
            preferredStyle: .alert
        )
        
        alert.action(task: task) { taskName in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task: task, newName: taskName)
                completion()
            } else {
                self.save(taskName: taskName)
            }
        }
        
        present(alert, animated: true)
    }
}
