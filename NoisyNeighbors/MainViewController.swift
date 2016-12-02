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
        let n = gNeighbors.count
        return n
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let n = gNeighbors[row].label
        return n
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print("External Controller:" + String(row + 1))
    }
}

class MainViewController: UIViewController {

    static let sharedInstance = MainViewController()

    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var pv: NeighborPickerController!

    @IBOutlet weak var neighborPickerView: UIPickerView!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var noiseButton: UIButton!
    @IBOutlet weak var incidentsButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var configureButton: UIBarButtonItem!

    /// Used to share information between this controller and its parent.
//    var shortcutItem: UIApplicationShortcutItem?

    func startNoise() {
        let newIncident = Incident()
        let incidentNeighbor = pickerNeighbor()
        let typeIndex = typeSegmentedControl.selectedSegmentIndex
        newIncident.initWith(neighbor: incidentNeighbor, type: typeIndex)
        IncidentList.stageIncident(newIncident)
    }

    func stopNoise() {
        IncidentList.commitIncident()
    }
    
    @IBAction func noise(_ sender: Any) {
        if IncidentList.staged() {
            activityIndicator.startAnimating()
            startNoise()
        } else {
            activityIndicator.stopAnimating()
            stopNoise()
        }
    }

    @IBAction func incidents(_ sender: Any) {
        let incidentNeighbor = pickerNeighbor()
        let ivc = IncidentsTableViewController()
        ivc.title = incidentNeighbor.label
    }

    @IBAction func longPress(_ sender: Any) {
        if (sender as AnyObject).state == UIGestureRecognizerState.began
        {
            let alertController = UIAlertController(title: nil, message:
                "Long-Press Gesture Detected", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))

            self.present(alertController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pv = NeighborPickerController.init(pickerInterval: 10)
        neighborPickerView.dataSource = pv as UIPickerViewDataSource?
        neighborPickerView.delegate = pv as UIPickerViewDelegate?
        if IncidentList.staged() {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        self.navigationItem.rightBarButtonItem = configureButton
 
        self.neighborPickerView.reloadAllComponents()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longPressRecognizer)

        addNotifier(selector: #selector(applicationDidEnterForeground))

    }

    func addNotifier(selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector,
                name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func applicationDidEnterForeground(notifier: NSNotification) {
        let shortCutItem = appDelegate.shortcutItem
        if shortCutItem != nil {
            handleShortCutItem(shortCutItem!)
        }
    }

    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) {
        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return  }

        guard let shortCutType = shortcutItem.type as String? else { return  }

        switch (shortCutType) {
        case ShortcutIdentifier.Start.type:
            if IncidentList.staged() {
                startNoise()
            } else {
                stopNoise()
                startNoise()
            }
            activityIndicator.startAnimating()
            break
        case ShortcutIdentifier.Stop.type:
            stopNoise()
            activityIndicator.stopAnimating()
            break
        case ShortcutIdentifier.Share.type:
            let text = "Share NoisyNeighbors"
            let url: URL = URL(string: "http://polymicro.net/noisyneighbors")!
            let objectsToShare = [text, url] as [Any]
            let activityViewController = UIActivityViewController(activityItems: objectsToShare,
                    applicationActivities: nil)
            self.present(activityViewController, animated: true)
            break
        default:
            break
        }

        // Construct an alert using the details of the shortcut used to open the application.
//        let alertController = UIAlertController(title: "Shortcut Handled", message: "\"\(shortcutItem.localizedTitle)\"", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
        // Display an alert indicating the shortcut selected from the home screen.
//        window!.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.neighborPickerView.reloadAllComponents()
    }

    private func pickerNeighbor() -> Neighbor {
        let pickerRow = neighborPickerView.selectedRow(inComponent: 0)
        let incidentNeighbor = gNeighbors[pickerRow]
        return incidentNeighbor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let dest = segue.destination // as! IncidentsTableViewController
        if segue.identifier == "incidents" {
            let incidentNeighbor = pickerNeighbor()
            dest.title = incidentNeighbor.label
        }
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

