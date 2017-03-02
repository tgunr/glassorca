//
//  TypesDetailViewController.swift
//  itHappened
//
//  Created by Dave Carlton on 3/1/17.
//  Copyright © 2017 Dave Carlton. All rights reserved.
//

import UIKit

class TypesDetailViewController: UIViewController, UITextFieldDelegate {
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var tpv: TypePickerController!
    
    var selectedTypeObject: OccuranceType?
    
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var trashButton: UIBarButtonItem!

    @IBAction func save(_ sender: UIBarButtonItem) {
        if selectedTypeObject == nil {
            let newType = OccuranceType()
            newType.initWith(name: (nameTextField?.text)!)
            appDelegate.addType(newType)
        } else {
            selectedTypeObject!.initWith(name: (nameTextField?.text)!!)
            appDelegate.saveType(selectedTypeObject!)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func trash(_ sender: Any) {
        if selectedTypeObject != nil {
            appDelegate.removeType(selectedTypeObject!)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func typePress(_ sender: Any) {
        if (sender as AnyObject).state == UIGestureRecognizerState.began
        {
            let alertController = UIAlertController(title: nil, message:
                "Long-Press Gesture Detected", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func initWith(name: String?) {
        self.nameTextField?.text = name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tpv = TypePickerController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled =  true
        }
    }
}
