//
//  RegisterViewController.swift
//  Stormpath Notes
//
//  Created by Edward Jiang on 3/11/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit
import Stormpath

class RegisterViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: .exit)
    }
    
    func exit() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func register(sender: AnyObject) {
        // Code for registering the user
        
        // Create the registration model
        let newUser = RegistrationModel(email: emailTextField.text!, password: passwordTextField.text!)
        newUser.givenName = firstNameTextField.text!
        newUser.surname = lastNameTextField.text!
        
        // Register the new user
        Stormpath.sharedSession.register(newUser) { (account, error) -> Void in
            if let error = error {
                self.showAlert(withTitle: "Error", message: error.localizedDescription)
            } else {
                self.exit()
            }
        }
    }

}

private extension Selector {
    static let exit = #selector(RegisterViewController.exit)
}
