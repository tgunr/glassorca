//
//  NeighborsViewController.swift
//  NoisyNeighbors
//
//  Created by Dave Carlton on 10/17/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import UIKit

class NeighborsViewController: UIViewController {

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

class IncidentsTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var incidentLabel: UILabel!
    
}

class NeighborsDetailViewController: UIViewController {

    private var appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var neighborUUID: UITextField!
    @IBOutlet weak var labelTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var incidentsTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func save(_ sender: UIBarButtonItem) {
        let newNeighbor = Neighbor()
        newNeighbor.label = labelTextField.text!
        newNeighbor.name = nameTextField.text!
        newNeighbor.address = addressTextField.text!
        newNeighbor.uuid = NSUUID().uuidString
        appDelegate.saveNeighbor(newNeighbor)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelButton(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    func initWith(uuid: String, label: String?, name: String?, address: String?) {
        self.neighborUUID.text = uuid
        self.labelTextField.text = label
        self.nameTextField.text = name
        self.addressTextField.text = address
    }
}
