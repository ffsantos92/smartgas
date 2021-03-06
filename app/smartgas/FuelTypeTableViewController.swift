//
// This file is part of SmartGas, an iOS app to find the best gas station nearby.
//
// (c) Fábio Santos <ffsantos92@gmail.com>
// (c) Mateus Silva <mateusgsilva_@hotmail.com>
// (c) Fábio Marques <fabio1956.epo@gmail.com>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import UIKit

protocol FuelTypeTableViewControllerDelegate
{
    func sendFuelId(fuelId: Int)
}

class FuelTypeTableViewController: UITableViewController {

    var vehicleFuelId: Int?
    var fuelTypes: [FuelType]!

    var delegate:CreateVehicleTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fuelTypes.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        vehicleFuelId = fuelTypes[indexPath.row].id
        tableView.reloadData();
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fuelTypeCell", forIndexPath: indexPath) as! FuelTypeTableViewCell

        let fuelType = fuelTypes[indexPath.row]
        cell.setFuel(fuelType.name)
        if vehicleFuelId == fuelTypes[indexPath.row].id {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if (self.isMovingFromParentViewController()){
            if let fuelId = vehicleFuelId {
                self.delegate?.sendFuelId(fuelId)
            }
        }
    }

}
