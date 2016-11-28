//
//  IncidentsViewController.swift
//  NoisyNeighbors
//
//  Created by Dave Carlton on 11/27/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import UIKit

class IncidentsTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var incidentLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
}

class IncidentsTableViewController: UITableViewController {
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var localIncidents: [Incident]?
    
    @IBOutlet weak var incidentsTableView: UITableView!

    func dateFormatted(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.isLenient = true
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let result = dateFormatter.string(from: date) // returns "2015-09-16T13:51:53.316000+00:00"
        return result
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (localIncidents!.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incidentCell", for: indexPath) as! IncidentsTableViewCell
        //        let thisNeighbor = gNeighbors.subscript(indexPath as Index)
        let incident = localIncidents![indexPath.row]
        // Configure the cell...
        let aDate = incident.occured
        let dateFormat = dateFormatted(aDate)
        cell.dateLabel.text = dateFormat
        cell.incidentLabel.text = incident.type.rawValue

        let interval = incident.interval()
        cell.durationLabel.text = incident.stringFromTimeInterval(interval: interval)
        return cell
    }

    override func viewDidAppear(_ animated: Bool) {
        let allIncidents = gIncidents
        let theFilter = self.title
        localIncidents = allIncidents.filter {
            $0.neighbor?.label == theFilter
        }
        self.incidentsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        let allIncidents = gIncidents
        let theFilter = self.title
        localIncidents = allIncidents.filter {
            $0.neighbor?.label == theFilter
        }
        if localIncidents == nil {
            localIncidents = allIncidents
        }
    }
}
