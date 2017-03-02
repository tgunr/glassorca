//
//  TypesTableViewController
//  itHappened
//
//  Created by Dave Carlton on 3/1/17.
//  Copyright © 2017 Dave Carlton. All rights reserved.
//

import UIKit

class TypeTableViewCell: UITableViewCell {
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var detail: UIButton!
}

class TypesTableViewController: UITableViewController {
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var typesTableView: UITableView!

    @IBAction func add(_ sender: Any) {
        selectedIndexPath = nil
        _ = ConfigureDetailViewController()
        performSegue(withIdentifier: "typeDetail", sender: sender)
    }
    
    @IBAction func info(_ sender: UIButton, forEvent: UIEvent) {
        let view = sender.superview!
        let cell = view.superview as! ConfigureTableViewCell
        selectedIndexPath = typesTableView.indexPath(for: cell)
        _ = ConfigureDetailViewController()
        performSegue(withIdentifier: "typeDetail", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.rightBarButtonItem=addButton
                if gOccuranceTypes.count == 0 {
                    loadTypes()
        }
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
        return (gOccurances.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thisCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TypeTableViewCell
        //        let thisNeighbor = gOccurances.subscript(indexPath as Index)
        let type = gOccuranceTypes[indexPath.row]
        // Configure the cell...
        thisCell.typeLabel.text = type.name
        return thisCell
    }

    override func viewDidAppear(_ animated: Bool) {
        //        let count = self.neigborsTableView.numberOfRows(inSection: 0)
        self.typesTableView.reloadData()
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
            let thatType = gOccuranceTypes[indexPath.row]
            appDelegate.removeType(thatType)
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
        let dest = segue.destination as! TypesDetailViewController
        if selectedIndexPath != nil {
            let type = gOccuranceTypes[(selectedIndexPath?.row)!]
            dest.selectedTypeObject = type
        } else {
            dest.selectedTypeObject = nil
        }
    }
    
    func loadTypes () {
        let n1 = "Barking Dog"
        let n2 = "Loud Music"
        
        let N1 = OccuranceType()
        N1.initWith(name: n1)
        let N2 = OccuranceType()
        N2.initWith(name: n2)
        
        gOccuranceTypes = [N1, N2]
        //        self.gOccurances = gOccurances
        appDelegate.saveType(N1)
        appDelegate.saveType(N2)
        
    }

}
