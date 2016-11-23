//
//  NeighborsTableViewController.swift
//  NoisyNeighbors
//
//  Created by Dave Carlton on 10/26/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import UIKit

class NeighborTableViewCell: UITableViewCell {
    @IBOutlet weak var neighborLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
}

class NeighborsTableViewController: UITableViewController {
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var neigborsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.rightBarButtonItem=addButton
        if appDelegate.neighbors.count == 0 {
            loadNeighbors()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (appDelegate.neighbors.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "neighborCell", for: indexPath) as! NeighborTableViewCell
//        let thisNeighbor = appDelegate.neighbors?.subscript(indexPath as Index)
        let neighbor = appDelegate.neighbors[indexPath.row]
        // Configure the cell...
        cell.neighborLabel.text = neighbor.label
        cell.addressLabel.text = neighbor.address
        return cell
    }

    override func viewDidAppear(_ animated: Bool) {
        self.neigborsTableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func loadNeighbors () {
        let n1 = "N1"
        let a1 = "Address 1"
        
        let n2 = "N2"
        let a2 = "Address 2"
        
        let N1 = Neighbor()
        N1.initWith(label: n1, name: n1, address: a1)
        let N2 = Neighbor()
        N2.initWith(label: n2, name: n2, address: a2)
        
        appDelegate.neighbors = [N1, N2]
//        self.neighbors = appDelegate.neighbors
        appDelegate.saveNeighbor(N1)
        appDelegate.saveNeighbor(N2)
        
    }
}
