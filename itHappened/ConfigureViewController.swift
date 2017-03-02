//
//  ConfigureViewController.swift
//  itHappened
//
//  Created by Dave Carlton on 10/17/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import UIKit

class ConfigureViewController: UIViewController {

    private var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

class TypePickerController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let n = gOccuranceTypes.count
        return n
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let n = gOccuranceTypes[row].name
        return n
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print("External Controller:" + String(row + 1))
    }
}





