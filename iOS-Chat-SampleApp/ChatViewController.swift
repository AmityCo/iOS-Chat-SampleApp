//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import AmitySDK

class ChatViewController: UIViewController, UITableViewDataSource {
    @IBAction func exit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var channelName: UINavigationItem!
    var channelID:String?
    var token : AmityNotificationToken?
    var messageToken : AmityNotificationToken?
    var messageRepository:AmityMessageRepository?
    var messagesCollection: AmityCollection<AmityMessage>?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let message = messages[indexPath.row]
        
                let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
                cell.label.text = message.body
        
                //This is a message from the current user.
        if message.sender == AmityManager.shared.client?.currentUserId {
                    cell.leftImageView.isHidden = true
                    cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor.systemBlue
            cell.label.textColor = UIColor.white
                }
                //This is a message from another sender.
                else {
                    cell.leftImageView.isHidden = false
                    
                    cell.rightImageView.isHidden = true
                    cell.messageBubble.backgroundColor = UIColor.systemRed
                    cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
                }
        
        return cell
    }
    

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBAction func sendMessage(_ sender: Any) {
        print( self.channelID!)
       messageRepository?.createTextMessage(withChannelId: self.channelID!,
                                                             text: textfield.text ?? "",
                                                                     tags: nil,
                                                                     parentId: nil) { message, error in
            
        
            if let error = error {
           
                print(error)
            }
            else{
              
                print("success")
            }
        }
        textfield.text = ""
     

       
    }
    
 
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = channelID
        navigationItem.hidesBackButton = true
        messageRepository = AmityMessageRepository(client: AmityManager.shared.client!)
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        
    }
    
    func loadMessages() {
      
        print(channelID)
     
         messagesCollection = messageRepository?.getMessages(channelId: channelID!,
                                                               includingTags: [],
                                                               excludingTags: [],
                                                               filterByParentId: false,
                                                               parentId: nil,
                                                               reverse: true)
            
        token = messagesCollection?.observe { collection, change, error in
            
            if let error = error{
                print("Error!!!")
                print(error.localizedDescription)
            }
            else{
                self.messages = []
//                if collection.hasNext {
//                    collection.nextPage()
//                }
                
                    for index in 0..<collection.count() {
                     
                        if let message = collection.object(at: index),
                           let messageBody =  message.data?["text"] as?  String {
                        
                            let newMessage = Message(sender: (message.user?.userId)!, body: messageBody)
                            self.messages.insert(newMessage, at: 0)
                          
                                                      DispatchQueue.main.async {
                                                             self.tableView.reloadData()
                                                          let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                                          self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                                      }
                            

                        }

                    }
                    self.tableView.reloadData()
                
}

        }

    }

}
