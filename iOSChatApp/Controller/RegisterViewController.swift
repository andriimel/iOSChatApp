//
//  RegisterViewController.swift
//  iOSChatApp
//
//  Created by Andrii Melnyk on 1/19/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import MobileCoreServices


class RegisterViewController: UIViewController {
    
    
    var uploadImageURL = URL(string: "")
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
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.layer.cornerRadius = 10
            passwordTextField.layer.borderWidth = 1
            passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
            passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
            passwordTextField.leftViewMode = .always
            passwordTextField.backgroundColor = .secondarySystemBackground
        }
    }
    @IBOutlet weak var registerButton: UIButton! {
        didSet{
            registerButton.layer.cornerRadius = 10
            registerButton.layer.borderWidth = 1
            registerButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var userPhotoImageView: UIImageView! {
        didSet {
            userPhotoImageView.isUserInteractionEnabled = true
            userPhotoImageView.image = UIImage(systemName: "person")
            userPhotoImageView.layer.masksToBounds = true
            userPhotoImageView.layer.cornerRadius = userPhotoImageView.bounds.height/2
            userPhotoImageView.layer.borderWidth = 2
            userPhotoImageView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    // Get a reference to the storage service using the default Firebase App
    
    
    override func viewDidLoad() {
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        

        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeUserPhotoTapped(_:)))
        userPhotoImageView.addGestureRecognizer(gesture)
        super.viewDidLoad()
    }
    
    @objc func changeUserPhotoTapped(_ sender:UITapGestureRecognizer) {
        
        print ("Change photo !!!!  ")
        presentPhotoActionSheet()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        print("Register button pressed !!!! ")
        guard let email = emailTextField.text,
              let password = passwordTextField.text
             // uploadImageURL != nil
        else{
            ErrorMessage()
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        
            if let er = error {
                self.ErrorMessage()
            } else {
//                self.uploadFile(fileUrl: (self.uploadImageURL)!)
                //let fileExtension = 
                let storageRef = Storage.storage().reference().child("\(email).png")
                if  let uploadData = self.userPhotoImageView.image!.pngData() {
                    storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil {
                            print(error)
                            return
                        }
                        storageRef.downloadURL { (url, error) in
                                      guard let downloadURL = url else {
                                          return
                                      }
                                      print("DOWNLOAD URL IS :",downloadURL)
                            
                                  }
                        print(metadata)
                    }
                }
                                self.performSegue(withIdentifier: "GoToLogin", sender: self)

            }
        }
    }
    

    
    func uploadFile(fileUrl: URL){
        
        //        let fileExtension = fileUrl.pathExtension
        //        let fileName = "profilePicture_\(emailTextField.text ?? "")\(fileExtension)"
        //
        //        print("File extension is  ================= ",fileExtension)
        //        let metadata = StorageMetadata()
        //        let riversRef = Storage.storage().reference().child(fileName)
        //        metadata.contentType = "image/jpeg"
        //        let uploadTask = riversRef.putFile(from: fileUrl, metadata: metadata) { metadata, error in
        //            guard let metadata = metadata else {
        //                return
        //            }
        //
        //            let size = metadata.size
        //            riversRef.downloadURL { (url, error) in
        //                guard let downloadURL = url else {
        //                    return
        //                }
        //                print("DOWNLOAD URL IS :",downloadURL)
        //            }
        //        }
        
        let storageRef = Storage.storage().reference()
        if  let uploadData = userPhotoImageView.image!.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error)
                    return
                }
                print(metadata)
            }
        }
    }
    
    func ErrorMessage(){
        let action = UIAlertController(title: "Oops", message:"Something wrong with inputs data. Please check all again.", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(action, animated: true)
    }
}


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let action = UIAlertController(title: "Profile picture", message: "How would you like to select picture", preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        action.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self]_ in
            self?.presentCamera()
        }))
        action.addAction(UIAlertAction(title: "Chose Photo", style: .default, handler:{ [weak self]_ in
            self?.presentPhotoPicker()
        } ))
        
        present(action, animated: true)
    }
    
    func presentCamera(){
        let vc  = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker() {
        let vc  = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
//            return
//        }
//        self.userPhotoImageView.image = selectedImage
//        print(info[UIImagePickerController.InfoKey.imageURL] as? URL)
//        uploadImageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
//        print("uploadURL IS :::::::::::",uploadImageURL)
        
        var selectedImageFromUIPicker : UIImage?
        if  let editedImg = info[.editedImage] as? UIImage  {
            
            selectedImageFromUIPicker = editedImg
        } else if let originalImg = info[.originalImage] as? UIImage {
            selectedImageFromUIPicker = originalImg
        }
        
        if let selectedImage = selectedImageFromUIPicker {
            userPhotoImageView.image = selectedImage
        }
//        let imageName = UUID().uuidString
//        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
//
//        if let jpegData = image.jpegData(compressionQuality: 0.8) {
//            try? jpegData.write(to: imagePath)
//        }
//            print("Image path is =================",imagePath)
//        uploadImageURL = imagePath
//        print("imageURL IS ",uploadImageURL)

        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension RegisterViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        print("return button pressed !!!!")
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.endEditing(true)
        }
        
        return true
    }
}
