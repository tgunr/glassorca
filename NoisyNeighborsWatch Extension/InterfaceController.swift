//
//  InterfaceController.swift
//  NoisyNeighborsWatch Extension
//
//  Created by Dave Carlton on 12/3/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    let neighborItems: [ (String, String) ] = [
    ("1", "Loud Dog"),
    ("2", "5 Dog Lady"),
    ("3", "Dragon Lady"),
    ("4", "Stupid Guy")
    ]
    
    let neighbors: [WKPickerItem] = []
    let defaults = UserDefaults.init(suiteName: "NoisyNeighbors")
    
    @IBOutlet var picker: WKInterfacePicker!

    @IBAction func picked(_ value: Int) {
    
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        let pickerItems: [WKPickerItem] = neighborItems.map {
            let pickerItem = WKPickerItem()
            pickerItem.caption = $0.0
            pickerItem.title = $0.1
            return pickerItem
        }
        
        // Configure interface objects here.
        picker.setItems(pickerItems)
        picker.focus()    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
//        let n = defaults?.array(forKey: "Neighbors") as? [String]
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    

}
