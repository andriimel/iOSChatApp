//
//  ChatViewController.swift
//  iOSChatApp
//
//  Created by Andrii Melnyk on 1/19/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import IQKeyboardManagerSwift
class ChatViewController:UIViewController {
    
    var messages: [MessageModel] = []
    let dataBase = Firestore.firestore()
    let imageCache = NSCache<NSString,AnyObject>()

    @IBOutlet weak var messageBubbleView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        chatTableView.dataSource = self
        chatTableView.delegate  = self
       // messageTextField.delegate = self
        
        navigationItem.hidesBackButton = true
        chatTableView.register(MessageCell.nib(), forCellReuseIdentifier: MessageCell.identifier)
        loadMessages()
        
        
    }
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        DispatchQueue.main.async {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
        
    }
    
    func loadMessages() {
        
        
        dataBase.collection("messages").order(by: "date").addSnapshotListener { querySnapshot, error in
            
            self.messages = []
            
            guard error == nil else {
                return
            }
            guard let snapshotDocuments = querySnapshot?.documents else {
                return
            }
            for doc in snapshotDocuments {
                let data = doc.data()
                if let msgSender = data["sender"] as? String,
                   let msgBody = data["message body"] as? String {
                    let newMsg = MessageModel(sender: msgSender, body: msgBody)
                    self.messages.append(newMsg)
                    
                    DispatchQueue.main.async {
                        self.chatTableView.reloadData()
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: true
                        )
                        
                    }
                }
            }
            
        }
    }
    
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        guard let messageBody = messageTextField.text,
              let msgSender = Auth.auth().currentUser?.email else {
            return
        }
        dataBase.collection("messages").addDocument(data: ["sender":msgSender,
                                                           "message body": messageBody,
                                                           "date": Date().timeIntervalSince1970]){ (error) in
            if let e = error {
                print("There was an issue saving data to firestore, \(e)")
            } else {
                print("Successfully saved data.")
                
                DispatchQueue.main.async {
                    self.messageTextField.text = ""
                }
            }
        }
        
    }
    
    func downloadProfilePicture(withPath path:String, image:UIImageView)  {
        
        if let catchedImage = imageCache.object(forKey: path as NSString) as? UIImage{
            image.image = catchedImage
            return
        }
        
        let pathReference = Storage.storage().reference(withPath: "\(path).png")
        pathReference.downloadURL { url, error in
            print("URL IS !!!!!!!!!!!!!!!! ============= ",url)
            pathReference.getData(maxSize: 1 * 2048 * 2048) { data, error in
                if let error = error {
                    print ("WTFBRO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", error)
                } else {
                    // Data for "images/island.jpg" is returned
                  
                    DispatchQueue.main.async {
                        
                        if   let uploadImage = UIImage(data: data!) {
                            self.imageCache.setObject(uploadImage, forKey: path as NSString)
                            image.image = uploadImage
                        }
                    }
                }
            }
        }
    }
}
// MARK: - UITableViewDataSource methods

@available(iOS 15.0, *)
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath)
        as! MessageCell
        
        if Auth.auth().currentUser?.email == message.sender  {
            
            self.downloadProfilePicture(withPath: message.sender, image: cell.rightImageView)
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = .systemTeal
            
        } else {
            self.downloadProfilePicture(withPath: message.sender, image: cell.leftImageView)
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor.systemMint
        }
        cell.label.text = message.body
        return cell
    }
}

//extension ChatViewController: UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        chatTableView.frame = CGRect(x: 0, y: 85, width: 393, height: 400)
//        messageBubbleView.frame = CGRect(x: 0, y: 450, width: messageBubbleView.bounds.width, height: messageBubbleView.bounds.height)
//        view.bringSubviewToFront(messageBubbleView)
//        return true
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        chatTableView.frame = CGRect(x: 0, y: 85, width: 393, height: 686)
//        messageBubbleView.frame = CGRect(x: 0, y: 769, width: messageBubbleView.bounds.width, height: messageBubbleView.bounds.height)
//        view.bringSubviewToFront(messageBubbleView)
//    }
//}
