//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare constants
    let KEYBOARD_HEIGHT = 258.0
    let TEXTFIELD_HEIGHT = 50.0

    // Declare instance variables here

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set ChatViewController as the delegate and datasource
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //Set ChatViewController as the delegate of the text field
        messageTextfield.delegate = self

        
        //Set the tapGesture, used to drop text field when editing is completed
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        

        //Register custom cell MessageCell.xib file
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //Declare cellForRowAtIndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        let messageArray = ["First Message", "Second Message", "Third Message"]
        cell.messageBody.text = messageArray[indexPath.row]
        return cell

    }
    
    //Declare numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3

    }
    
    
    
    //Declare tableViewTapped
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0

    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods

    //Declare textFieldDidBeginEditing, automatically triggered
    func textFieldDidBeginEditing(_ textField: UITextField) {

        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = CGFloat(self.KEYBOARD_HEIGHT + self.TEXTFIELD_HEIGHT)
            self.view.layoutIfNeeded() // refresh
        }
    }
    
    
    //Declare textFieldDidEndEditing, triggered when user tab above text field
    func textFieldDidEndEditing(_ textField: UITextField) {

        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = CGFloat(self.TEXTFIELD_HEIGHT)
            self.view.layoutIfNeeded() // refresh
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    

    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        
        //TODO: Send the message to Firebase and save it in our database
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        //Create a child database just for messages
        let messagesDB = Database.database().reference().child("Messages")
        
        let senderMessagePair = ["Sender": Auth.auth().currentUser?.email,
                                 "MessageBody": messageTextfield.text!]
        
        messagesDB.childByAutoId().setValue(senderMessagePair) {
            (error, reference) in
            
            if (error != nil) {
                print(error!)
            } else {
                print("Message saved.")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
            }
        }
    }
    
    //TODO: Create the retrieveMessages method here:
    

    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Logout error!")
        }

    }

}
