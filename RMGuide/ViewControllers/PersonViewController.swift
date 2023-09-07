//
//  PersonViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 07.09.2023.
//

import UIKit

final class PersonViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    private let storageManager = StorageManager.shared
    private var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        person = storageManager.fetchPerson()
        firstNameTextField.text = person?.name
        lastNameTextField.text = person?.surname
        
        let action = UIAction { [weak self] _ in
            guard let firstName = self?.firstNameTextField.text else { return }
            self?.doneButton.isEnabled = !firstName.isEmpty
        }
        firstNameTextField.addAction(action, for: .editingChanged)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        save()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private func save() {
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        let person = Person(name: firstName, surname: lastName)
        storageManager.save(personType: person)
        dismiss(animated: true)
    }
}
