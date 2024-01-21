//
//  ViewController.swift
//  iOSChatApp
//
//  Created by Andrii Melnyk on 1/19/24.
//


import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.layer.cornerRadius = 10
            registerButton.layer.borderWidth = 2
            registerButton.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.layer.cornerRadius = 10
            loginButton.layer.borderWidth = 2
            loginButton.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
       let titleText = "iOSChatApp"
        var index = 0.0
        
        for letter in titleText {
            
            Timer.scheduledTimer(withTimeInterval: 0.1 * index, repeats: false) {(timer) in
                self.titleLabel.text?.append(letter)
            }
            index += 1
        }
        

       
    }

}


