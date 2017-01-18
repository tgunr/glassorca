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

    @IBOutlet var picker: WKInterfacePicker!

    @IBAction func picked(_ value: Int) {
    
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
