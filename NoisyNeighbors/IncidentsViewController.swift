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
    private var localIncidents: [Incident] = IncidentList.allIncidents()
//    lazy var incidentArray: [[String: Incident]] = [[String: Incident]]()
    var selectedCells: [IndexPath]?

    @IBOutlet weak var incidentsTableView: UITableView!
    @IBOutlet weak var mergeButton: UIBarButtonItem!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    @IBAction func merge(_ sender: Any) {
        selectedCells = incidentsTableView.indexPathsForSelectedRows
        // Save any staged incident
        IncidentList.commitIncident()
        var all = IncidentList.allIncidents()
        let newIncident = Incident()
        // As we iterate, the selected incident occurred date will always be earlier thab
        // the newIncident.occured on first pass.
        var earlist: Date = newIncident.occured
        // We set latest to beginning of time so first pass will cause conditional to 
        // latest to first incident encountered
        var latest: Date = Date.init(timeIntervalSince1970: 0)
        for thisIncident in selectedCells! {
            let thatIncident = all[thisIncident.row]
            if thatIncident.occured < earlist {
                earlist = thatIncident.occured
            }
            if thatIncident.stopped > latest {
                latest = thatIncident.stopped
            }
            newIncident.neighbor = thatIncident.neighbor
            newIncident.type = thatIncident.type
            all.remove(at: thisIncident.row)
            IncidentList.remove(thatIncident)
        }
        IncidentList.setIncidents(all)
        IncidentList.stageIncident(newIncident)
        viewDidAppear(true)
    }

    @IBAction func trash(_ sender: Any) {
        selectedCells = incidentsTableView.indexPathsForSelectedRows
        for theIncident in selectedCells! {
            deleteIncident(indexPath: theIncident)
        }
    }
    
    func dateFormatted(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.isLenient = true
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let result = dateFormatter.string(from: date)
        return result
    }

    func filterIncidents() {
        let theFilter = self.title!
        localIncidents = IncidentList.incidents(filter: theFilter)
    }
    
    func deleteIncident(indexPath: IndexPath) {
        let thatIncident = IncidentList.incident(indexPath: indexPath)
        IncidentList.remove(thatIncident)
        filterIncidents()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (localIncidents.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incidentCell", for: indexPath) as! IncidentsTableViewCell
        let incident = localIncidents[indexPath.row]
        // Configure the cell...
        let aDate = incident.occured
        let dateFormat = dateFormatted(aDate)
        cell.dateLabel.text = dateFormat
        cell.incidentLabel.text = incident.type.rawValue

        let interval = incident.interval()
        cell.durationLabel.text = incident.stringFromTimeInterval(interval: interval)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteIncident(indexPath: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
        selectedCells = incidentsTableView.indexPathsForSelectedRows
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.accessoryType = .none
        selectedCells = incidentsTableView.indexPathsForSelectedRows
    }

    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
        selectedCells = incidentsTableView.indexPathsForSelectedRows
        self.incidentsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem=mergeButton
//        self.navigationItem.rightBarButtonItem=trashButton
        filterIncidents()
    }
}
