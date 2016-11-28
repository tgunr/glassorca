//
//  MainViewController.swift
//  NoisyNeighbors
//
//  Created by Dave Carlton on 10/17/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import UIKit

class NeighborPickerController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let ElementCount: Int!
    
    init(pickerInterval: Int) {
        ElementCount = pickerInterval
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let n = appDelegate.neighbors.count
        return n
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let n = appDelegate.neighbors[row].label
        return n
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print("External Controller:" + String(row + 1))
    }
}

class MainViewController: UIViewController {

    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var pv: NeighborPickerController!
    
    @IBOutlet weak var neighborPickerView: UIPickerView!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var noiseButton: UIButton!
    @IBOutlet weak var incidentsButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func noise(_ sender: Any) {
        if appDelegate.stagedIncident == nil {
            activityIndicator.startAnimating()
            let newIncident = Incident()
            let pickerRow = neighborPickerView.selectedRow(inComponent: 0)
            let incidentNeighbor = appDelegate.neighbors[pickerRow]
            let typeIndex = typeSegmentedControl.selectedSegmentIndex
            newIncident.initWith(neighbor: incidentNeighbor, type: typeIndex)
            appDelegate.stageIncident(newIncident)
        } else {
            appDelegate.unstageIncident()
            activityIndicator.stopAnimating()
        }
    }

    @IBAction func incidents(_ sender: Any) {
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pv = NeighborPickerController.init(pickerInterval: 10)
        neighborPickerView.dataSource = pv as UIPickerViewDataSource?
        neighborPickerView.delegate = pv as UIPickerViewDelegate?
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.neighborPickerView.reloadAllComponents()
    }
}

class MainDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

