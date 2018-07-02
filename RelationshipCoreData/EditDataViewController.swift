//
//  EditDataViewController.swift
//  RelationshipCoreData
//
//  Created by Sumit Ghosh on 27/06/18.
//  Copyright © 2018 Sumit Ghosh. All rights reserved.
//

import UIKit
import CoreData
import Photos

class EditDataViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var deviceCodeTextField: UITextField!
    @IBOutlet weak var deviceTypeTextField: UITextField!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var purchaseDateTextField: UITextField!
    @IBOutlet weak var osversionTextField: UITextField!
    @IBOutlet weak var deviceImage: UIImageView!
    
    var selectedDevice: Device?
    var deviceCode:String?
    var deviceType:String?
    var user:User?
    let imagePicker = UIImagePickerController()

    
    struct StoryBoardIDS {
       static let OWNERLIST = "ownerLink"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        
        if selectedDevice != nil {
           // deviceType = selectedDevice?.deviceType
            deviceCode = selectedDevice?.name
            self.deviceCodeTextField.text = deviceCode
            self.deviceTypeTextField.text = deviceType
            if selectedDevice?.owner == nil {
                self.ownerLabel.text = "Tap to Select"
            }else{
                self.ownerLabel.text = selectedDevice?.owner?.name ?? ""
            }
            self.osversionTextField.text = selectedDevice?.osVersion
            
            if selectedDevice?.purchaseDate == nil {
                self.purchaseDateTextField.placeholder = "Please enter Date"
            }else{
                self.purchaseDateTextField.text = selectedDevice?.purchaseDate
            }
            if selectedDevice?.image == nil {
                
            }else{
                self.deviceImage.image = UIImage.init(data: selectedDevice?.image! as! Data)
            }
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            appDelegate.coreDataStack.managedObjectContext.refresh(selectedDevice!, mergeChanges: true)
            if let birthdayBuddies = selectedDevice?.value(forKey: "purchaseOnSameDate") as? [Device] {
                for birthdayBuddy in birthdayBuddies {
                    print("Birthday buddy! - \(birthdayBuddy.name)")
                }
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryBoardIDS.OWNERLIST {
            let OwnerScreen = segue.destination as! OwnerViewController
            OwnerScreen.pickOwner = true
            OwnerScreen.delegate = self
        }
    }
    

    @IBAction func saveButtonAction(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        if selectedDevice == nil {
            self.insertOperation()
        }else{
            self.updateFunction()
        }
        
        appDelegate.coreDataStack.saveMainContext()
        self.shwoingSccessAlertMessage()
    }
    
    func shwoingSccessAlertMessage() -> Void {
        let alert = UIAlertController(title: "Success", message: "Adding/Updating data in  Local DB ", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Update Operation in coredata using NSManagedObjectContext
    func updateFunction() -> Void {
        self.selectedDevice?.name = self.deviceCodeTextField.text ?? ""
        //self.selectedDevice?.deviceType = self.deviceTypeTextField.text ?? ""
        self.selectedDevice?.owner = self.user
        self.selectedDevice?.osVersion = self.osversionTextField.text ?? ""
        self.selectedDevice?.purchaseDate = self.purchaseDateTextField.text ?? ""
        self.selectedDevice?.image = UIImageJPEGRepresentation(self.deviceImage.image!, 0.7)! as NSData; // 0.7 is JPG quality
    }
    
    //MARK: Insert Operation in coredata using NSManagedObjectContext
    func insertOperation() -> Void {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "Device", in: appDelegate.coreDataStack.managedObjectContext) else {
            fatalError("Could not find entiyu description")
        }
            let device = Device.init(entity: entity, insertInto: appDelegate.coreDataStack.managedObjectContext)
            let deviceName = deviceCodeTextField.text ?? ""
            device.name = "Some Device #\(deviceName)"
            //device.deviceType = deviceTypeTextField.text ?? ""
            device.owner = self.user
            device.purchaseDate = self.purchaseDateTextField.text ?? ""
            device.osVersion = self.osversionTextField.text ?? ""
            device.image = UIImageJPEGRepresentation(self.deviceImage.image!, 0.7)! as NSData;
    }
    
    @IBAction func SelectImageButtonAction(_ sender: Any) {
        let status = PHPhotoLibrary.authorizationStatus()
        print("\(status)")
        
        if (status == PHAuthorizationStatus.authorized) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            print("Not approved image")
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
                else {
                    print("Not approved image")
                }
            })
        }
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])  {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            deviceImage.contentMode = .scaleAspectFit
            deviceImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Owner selection delegate
extension EditDataViewController:OwnerSelectionDelegate {
    func selectedOwner(selectedUser: User, Controller: UIViewController) {
        self.user = selectedUser
        self.ownerLabel.text = selectedUser.name
        Controller.navigationController?.popViewController(animated: true)
    }
}

