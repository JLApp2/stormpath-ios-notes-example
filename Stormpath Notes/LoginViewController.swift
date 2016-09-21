//
//  LoginViewController.swift
//  Stormpath Notes
//
//  Created by Edward Jiang on 3/11/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit
import Stormpath

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func login(_ sender: AnyObject) {
        // Code when someone presses the login button
        
        Stormpath.sharedSession.login(emailTextField.text!, password: passwordTextField.text!, completionHandler: openNotes)
    }
    
    @IBAction func loginWithFacebook(_ sender: AnyObject) {
        // Code when someone presses the login with Facebook button
        
        Stormpath.sharedSession.login(socialProvider: .facebook, completionHandler: openNotes)
    }
    
    @IBAction func loginWithGoogle(_ sender: AnyObject) {
        // Code when someone presses the login with Google button
        
        Stormpath.sharedSession.login(socialProvider: .google, completionHandler: openNotes)
    }

    @IBAction func resetPassword(_ sender: AnyObject) {
        // Code when someone presses the reset password button
        
        Stormpath.sharedSession.resetPassword(emailTextField.text!) { (success, error) -> Void in
            if let error = error {
                self.showAlert(withTitle: "Error", message: error.localizedDescription)
            } else {
                self.showAlert(withTitle: "Success", message: "Password reset email sent!")
            }
        }
    }
    
    func openNotes(_ success: Bool, error: NSError?) {
        if let error = error {
            showAlert(withTitle: "Error", message: error.localizedDescription)
        }
        else {
            performSegue(withIdentifier: "login", sender: self)
        }
    }
}

// Helper extension to display alerts easily.
extension UIViewController {
    func showAlert(withTitle title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
