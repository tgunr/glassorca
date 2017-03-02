//
//  ConfigureDetailViewController.swift
//  itHappened
//
//  Created by Dave Carlton on 3/1/17.
//  Copyright © 2017 Dave Carlton. All rights reserved.
//

import UIKit

class ConfigureDetailViewController: UIViewController, UITextFieldDelegate {
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var tpv: TypePickerController!
    
    var selectedOccuranceObject: Occurance?
    
    @IBOutlet weak var occuranceUUID: UITextField?
    @IBOutlet weak var labelTextField: UITextField?
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var addressTextField: UITextField?
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var recordStopButton: UISwitch!
    @IBOutlet weak var typesButton: UIButton!
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if selectedOccuranceObject == nil {
            let newOccurance = Occurance()
            newOccurance.initWith(label: (labelTextField?.text)!, name: (nameTextField?.text)!, address: (addressTextField?.text)!)
            appDelegate.addOccurance(newOccurance)
        } else {
            selectedOccuranceObject!.initWith(label: (labelTextField?.text)!, name: (nameTextField?.text)!, address: (addressTextField?.text)!)
            appDelegate.saveOccurance(selectedOccuranceObject!)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func trash(_ sender: Any) {
        if selectedOccuranceObject != nil {
            appDelegate.removeOccurance(selectedOccuranceObject!)
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
    
    func initWith(uuid: String, label: String?, name: String?, address: String?) {
        self.occuranceUUID?.text = uuid
        self.labelTextField?.text = label
        self.nameTextField?.text = name
        self.addressTextField?.text = address
    }
    
    func initWithNeighbor(_ occurance: Occurance) {
        initWith(uuid: occurance.uuid, label: occurance.label, name: occurance.name, address: occurance.address)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tpv = TypePickerController()
        typePickerView.dataSource = tpv as UIPickerViewDataSource?
        typePickerView.delegate = tpv as UIPickerViewDelegate?
        
        self.labelTextField?.delegate = self;
        
        // Do any additional setup after loading the view, typically from a nib.
        if selectedOccuranceObject != nil {
            initWithNeighbor(selectedOccuranceObject!)
            trashButton.isEnabled =  true
            saveButton.isEnabled =  true
        } else {
            trashButton.isEnabled = false
            saveButton.isEnabled = false
        }
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
