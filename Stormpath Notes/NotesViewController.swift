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
    
    let notesEndpoint = NSURL(string: "https://stormpathnotes.herokuapp.com/notes")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Watch for keyboard open / close
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .keyboardWasShown, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .keyboardWillBeHidden, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Place code to load data here
        
        let request = NSMutableURLRequest(URL: notesEndpoint)
        request.setValue("Bearer \(Stormpath.sharedSession.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard let data = data, json = try? NSJSONSerialization.JSONObjectWithData(data, options: []), notes = json["notes"] as? String else {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.notesTextView.text = notes
            })
        }
        task.resume()
        
        Stormpath.sharedSession.me { (account, error) -> Void in
            if let account = account {
                self.helloLabel.text = "Hello \(account.fullName)!"
            }
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        // Code when someone presses the logout button
        
        Stormpath.sharedSession.logout()
        
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    // Push the text view up when the keyboard appears.
    func keyboardWasShown(notification: NSNotification) {
        if let keyboardRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
            notesTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0)
            notesTextView.scrollIndicatorInsets = notesTextView.contentInset
        }
    }
    
    // Push the text view back down when the keyboard reappears.
    func keyboardWillBeHidden(notification: NSNotification) {
        notesTextView.contentInset = UIEdgeInsetsZero
        notesTextView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
}

extension NotesViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        // Add a "Save" button to the navigation bar when we start editing the 
        // text field.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: .stopEditing)
    }
    
    func stopEditing() {
        // Remove the "Save" button, and close the keyboard.
        navigationItem.rightBarButtonItem = nil
        notesTextView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        // Code when someone exits out of the text field
        
        let postBody = ["notes": notesTextView.text]
        
        let request = NSMutableURLRequest(URL: notesEndpoint)
        request.HTTPMethod = "POST"
        request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(postBody, options: [])
        request.setValue("application/json" ?? "", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Stormpath.sharedSession.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        task.resume()
    }
}

private extension Selector {
    static let keyboardWasShown = #selector(NotesViewController.keyboardWasShown(_:))
    static let keyboardWillBeHidden = #selector(NotesViewController.keyboardWillBeHidden(_:))
    static let stopEditing = #selector(NotesViewController.stopEditing)
}