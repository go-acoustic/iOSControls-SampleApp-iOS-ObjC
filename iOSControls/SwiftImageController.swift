//
//  SwiftImageController.swift
//  iOSAutomationTestApp
//
//  Created by Chanikya Mandapathi on 9/4/16.
//  Copyright © 2016 CanNMobile. All rights reserved.
//

import UIKit
import Tealeaf

class SwiftImageController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.imageView.image = UIImage(imageLiteral: "tealeaf")
    }
    
    @IBAction func getPhoto(_ sender: AnyObject) {
        
        self.imageView.image = UIImage(named:"tealeaf")
        
//        let picker = UIImagePickerController()
//        picker.sourceType = .PhotoLibrary
//        picker.delegate = self
//        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        self.imageView.image = image
       // dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postPhoto(_ sender: AnyObject) {
        
        let stat:Bool = TLFCustomEvent.sharedInstance().logImage(self.imageView.image)
        print("Status of log image \(stat)")
        
        AppManager.sharedInstance().isImageUploaded = stat
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
