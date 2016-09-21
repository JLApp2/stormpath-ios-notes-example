//
//  NotesViewController.swift
//  Stormpath Notes
//
//  Created by Edward Jiang on 3/11/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit
import Stormpath

class NotesViewController: UIViewController {
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    let notesEndpoint = URL(string: "https://stormpathnotes.herokuapp.com/notes")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Watch for keyboard open / close
        NotificationCenter.default.addObserver(self, selector: .keyboardWasShown, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: .keyboardWillBeHidden, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Place code to load data here
        
        var request = URLRequest(url: notesEndpoint)
        request.setValue("Bearer \(Stormpath.sharedSession.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let data = data, let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any], let notes = json["notes"] as? String else {
                return
            }
            DispatchQueue.main.async(execute: {
                self.notesTextView.text = notes
            })
        }) 
        task.resume()
        
        Stormpath.sharedSession.me { (account, error) -> Void in
            if let account = account {
                self.helloLabel.text = "Hello \(account.fullName ?? "")!"
            }
        }
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        // Code when someone presses the logout button
        
        Stormpath.sharedSession.logout()
        
        dismiss(animated: false, completion: nil)
    }
    
    // Push the text view up when the keyboard appears.
    func keyboardWasShown(_ notification: Notification) {
        if let keyboardRect = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            notesTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0)
            notesTextView.scrollIndicatorInsets = notesTextView.contentInset
        }
    }
    
    // Push the text view back down when the keyboard reappears.
    func keyboardWillBeHidden(_ notification: Notification) {
        notesTextView.contentInset = UIEdgeInsets.zero
        notesTextView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}

extension NotesViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Add a "Save" button to the navigation bar when we start editing the 
        // text field.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: .stopEditing)
    }
    
    func stopEditing() {
        // Remove the "Save" button, and close the keyboard.
        navigationItem.rightBarButtonItem = nil
        notesTextView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // Code when someone exits out of the text field
        
        let postBody = ["notes": notesTextView.text]
        
        var request = URLRequest(url: notesEndpoint)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: postBody, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Stormpath.sharedSession.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
}

private extension Selector {
    static let keyboardWasShown = #selector(NotesViewController.keyboardWasShown(_:))
    static let keyboardWillBeHidden = #selector(NotesViewController.keyboardWillBeHidden(_:))
    static let stopEditing = #selector(NotesViewController.stopEditing)
}
