//
//  LogInViewController.swift
//  iOSChatApp
//
//  Created by Andrii Melnyk on 1/19/24.
//
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

// ...
      
class LoginViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton! {
        didSet{
            logInButton.layer.cornerRadius = 10
            logInButton.layer.borderWidth = 1
            logInButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.layer.cornerRadius = 10
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.borderColor = UIColor.lightGray.cgColor
            emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
            emailTextField.leftViewMode = .always
            emailTextField.backgroundColor = .secondarySystemBackground
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet{
            passwordTextField.layer.cornerRadius = 10
            passwordTextField.layer.borderWidth = 1
            passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
            passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
            passwordTextField.leftViewMode = .always
            passwordTextField.backgroundColor = .secondarySystemBackground
        }
    }
    @IBOutlet weak var userPhotoImageView: UIImageView! {
        
        didSet{
            userPhotoImageView.isUserInteractionEnabled = true
            userPhotoImageView.image = UIImage(systemName: "person")
            userPhotoImageView.layer.masksToBounds = true
            userPhotoImageView.layer.cornerRadius = userPhotoImageView.bounds.height/2
            userPhotoImageView.layer.borderWidth = 2
            userPhotoImageView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        userPhotoImageView.image = UIImage(systemName: "person")

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(registerButtonPressed))
    }

    
    @IBAction func logInButtonPressed (_ sender: UIButton)  {
        
        logInUserMethod()
    }
    
    func logInUserMethod() {
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty,!password.isEmpty, password.count >= 6 else {
            alertLoginError()
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            guard error == nil else {
                self!.unCorrectInputsDataError()
                return
            }
                self!.performSegue(withIdentifier: "LoginToChat", sender: self)
            
        }
    }
    
    @objc func registerButtonPressed() {
        performSegue(withIdentifier: "GoToRegister", sender: self)
    }
    // MARK: - Login error methods
    func alertLoginError(){
        let alert = UIAlertController(title: "Oops...", message: "Please enter all information to log in ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    func unCorrectInputsDataError(){
        let alert = UIAlertController(title: "Error...", message: "Wrong password or mail, please try again !!! ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            logInUserMethod()
        }
        
        return true
    }
}
