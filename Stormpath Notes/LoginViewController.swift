//
//  LoginViewController.swift
//  Stormpath Notes
//
//  Created by Edward Jiang on 3/11/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func login(_ sender: AnyObject) {
        // Code when someone presses the login button
        openNotes()
        
    }
    
    @IBAction func loginWithFacebook(_ sender: AnyObject) {
        // Code when someone presses the login with Facebook button
        
    }
    
    @IBAction func loginWithGoogle(_ sender: AnyObject) {
        // Code when someone presses the login with Google button
        
    }

    @IBAction func resetPassword(_ sender: AnyObject) {
        // Code when someone presses the reset password button
        
    }
    
    func openNotes() {
        performSegue(withIdentifier: "login", sender: self)
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
