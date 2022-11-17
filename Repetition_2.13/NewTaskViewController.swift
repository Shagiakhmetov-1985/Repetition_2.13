//
//  NewTaskViewController.swift
//  Repetition_2.13
//
//  Created by Marat Shagiakhmetov on 16.11.2022.
//

import UIKit
import CoreData
// MARK: - Setup second view NewTaskViewController
class NewTaskViewController: UIViewController {
    
    var delegate: TaskListViewControllerDelegate?
    
    private let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // MARK: - Set text field
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        return textField
    }()
    // MARK: - Set buttons
    private lazy var saveButton: UIButton = {
        let button = setButton(
            color: UIColor(
                red: 22/255,
                green: 155/255,
                blue: 75/255,
                alpha: 1
            ),
            title: "Save Task"
        )
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = setButton(
            color: UIColor(
                red: 195/255,
                green: 65/255,
                blue: 65/255,
                alpha: 1
            ),
            title: "Cancel"
        )
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(subviews: taskTextField, saveButton, cancelButton)
        setConstraints()
    }
    // MARK: - Add subviews on the screen
    private func setupSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    // MARK: - Set constraints
    private func setConstraints() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.topAnchor, constant: 50),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.topAnchor, constant: 50),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    // MARK: - Button actions
    @objc private func save() {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: content) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: content) as? Task else { return }
        task.title = taskTextField.text
        
        if content.hasChanges {
            do {
                try content.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        delegate?.reloadData()
        dismiss(animated: true)
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
}
// MARK: - Custom class for button
extension NewTaskViewController {
    private func setButton(color: UIColor, title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }
}
