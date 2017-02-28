//
//  NeighborsTableViewController.swift
//  itHappened
//
//  Created by Dave Carlton on 10/26/16.
//  Copyright © 2016 Dave Carlton. All rights reserved.
//

import UIKit

class NeighborTableViewCell: UITableViewCell {
    @IBOutlet weak var neighborLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
}

class NeighborsTableViewController: UITableViewController {
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedIndexPath: IndexPath?

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var neigborsTableView: UITableView!
    @IBAction func add(_ sender: Any) {
        selectedIndexPath = nil
        _ = NeighborsDetailViewController()
        performSegue(withIdentifier: "neighborDetail", sender: sender)
    }
   
    @IBAction func info(_ sender: UIButton, forEvent: UIEvent) {
        let view = sender.superview!
        let cell = view.superview as! NeighborTableViewCell
        selectedIndexPath = neigborsTableView.indexPath(for: cell)
        _ = NeighborsDetailViewController()
        performSegue(withIdentifier: "neighborDetail", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.rightBarButtonItem=addButton
//        if gNeighbors.count == 0 {
//            loadNeighbors()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (gNeighbors.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "neighborCell", for: indexPath) as! NeighborTableViewCell
//        let thisNeighbor = gNeighbors.subscript(indexPath as Index)
        let neighbor = gNeighbors[indexPath.row]
        // Configure the cell...
        cell.neighborLabel.text = neighbor.label
        cell.addressLabel.text = neighbor.address
        return cell
    }

    override func viewDidAppear(_ animated: Bool) {
//        let count = self.neigborsTableView.numberOfRows(inSection: 0)
        self.neigborsTableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let thatNeighbor = gNeighbors[indexPath.row]
            appDelegate.removeNeighbor(thatNeighbor)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
//        neigborsTableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let dest = segue.destination as! NeighborsDetailViewController
        if selectedIndexPath != nil {
            let neighbor = gNeighbors[(selectedIndexPath?.row)!]
            dest.selectedNeighborObject = neighbor
        } else {
            dest.selectedNeighborObject = nil
        }
    }

    func loadNeighbors () {
        let n1 = "N1"
        let a1 = "Address 1"
        
        let n2 = "N2"
        let a2 = "Address 2"
        
        let N1 = Neighbor()
        N1.initWith(label: n1, name: n1, address: a1)
        let N2 = Neighbor()
        N2.initWith(label: n2, name: n2, address: a2)
        
        gNeighbors = [N1, N2]
        //        self.gNeighbors = gNeighbors
        appDelegate.saveNeighbor(N1)
        appDelegate.saveNeighbor(N2)
        
    }

}
