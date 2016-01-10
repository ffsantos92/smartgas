//
//  MainFuelStationViewController.swift
//  smartgas
//
//  Created by Mateus Silva on 22/12/15.
//  Copyright © 2015 Mateus Silva. All rights reserved.
//

import UIKit
import CoreLocation

class MainFuelStationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var brands:[Brand]!
    var fuelStations:[FuelStation]!
    var districts:[District]!
    var municipalities:[Municipality]!
    var fuelTypes:[FuelType]!
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    
    let showFuelStationSegueIdentifier = "showFuelStation"
    let editVehicleSegueIdentifier = "editVehicle"
    
    @IBOutlet weak var fuelStationTableView: UITableView!
    
    override func viewDidLoad() {						
        super.viewDidLoad()
        
        fuelStationTableView.delegate = self
        fuelStationTableView.dataSource = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fuelStationLoad:", name:"fuelStationsReady", object: nil)
        
        locationInit()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func fuelStationLoad(notification: NSNotification){
        self.fuelStations = FuelStation.loadAll()
        self.brands = Brand.loadAll()
        self.districts = District.loadAll()
        self.municipalities = Municipality.loadAll()
        self.fuelTypes = FuelType.loadAll()
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            self.fuelStationTableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fuelStations?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fuelStationCell", forIndexPath: indexPath) as! FuelStationTableViewCell
        
        let fuelStation = fuelStations![indexPath.row]

        cell.setFuelStation(fuelStation, brands: brands)
        
        return cell
    }
    
    func locationInit() {
        locationManager.delegate = self
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "batteryStateDidChange:", name: UIDeviceBatteryStateDidChangeNotification, object: nil)
        if UIDevice.currentDevice().batteryState == UIDeviceBatteryState.Charging || UIDevice.currentDevice().batteryState == UIDeviceBatteryState.Full {
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func batteryStateDidChange(notification: NSNotification) {
        print("BATTERY STATE CHANGE")
    }
    
    
    /*func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("NEW LOCATION")
        let locationObj = locations.last
        let coord = locationObj?.coordinate
        if let c = coord {
            currentLocation = c
            print("lat: \(c.latitude) long:\(c.longitude)")
            
            if let fuelStations = self.fuelStations {
                //for station in fuelStations {
                let stationLocation = CLLocation(latitude: fuelStations[0].latitude!, longitude: fuelStations[0].longitude!)
                print("DISTANCE: \(getDistance(locationObj!, destination: stationLocation))")
                let distance = String(format:"%.1f", getDistance(locationObj!, destination: stationLocation)/1000)
                print("DISTANCE IN KM: " + distance)
                
                let cell = self.fuelStationTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                if let cc = cell as? FuelStationTableViewCell {
                    cc.setDistance(distance)
                }
                //}
            }
            
            
            //defaults.setDouble(currentLocation.latitude, forKey: "latitude")
            //defaults.setDouble(currentLocation.longitude, forKey: "longitude")
        }
        
    }*/
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinates = locations.last?.coordinate {
            currentLocation = coordinates
            
            for fuelStation in fuelStations {
                let stationLocation = CLLocation(latitude: fuelStation.latitude!, longitude: fuelStation.longitude!)
                let distance = String(format:"%.1f", getDistance(locations.last!, destination: stationLocation)/1000)
                fuelStationTableView.
            }
            
            if let fuelStations = self.fuelStations {
                //for station in fuelStations {
                let stationLocation = CLLocation(latitude: fuelStations[0].latitude!, longitude: fuelStations[0].longitude!)
                print("DISTANCE: \(getDistance(locationObj!, destination: stationLocation))")
                let distance = String(format:"%.1f", getDistance(locationObj!, destination: stationLocation)/1000)
                print("DISTANCE IN KM: " + distance)
                
                let cell = self.fuelStationTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                if let cc = cell as? FuelStationTableViewCell {
                    cc.setDistance(distance)
                }
                //}
            }
            
            
            //defaults.setDouble(currentLocation.latitude, forKey: "latitude")
            //defaults.setDouble(currentLocation.longitude, forKey: "longitude")
        }
        
    }
    
    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        locationManager.startUpdatingLocation()
    }
    
    /*
    *Criar evento para trocar tipo de localizaçao consoante a mudança do estado de bateria
    */
    func getDistance(myLocation: CLLocation, destination: CLLocation) -> CLLocationDistance {
        return myLocation.distanceFromLocation(destination)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let fuelStation = fuelStations![indexPath.row]
        print(fuelStation.title)
        performSegueWithIdentifier(showFuelStationSegueIdentifier, sender: fuelStation)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        guard let identifier = segue.identifier else {
            return;
        }
        
        if identifier == showFuelStationSegueIdentifier {
            if let nextController = segue.destinationViewController.childViewControllers[0] as? ShowFuelStationTableViewController {
                if let fuelStation = sender as? FuelStation {
                    nextController.fuelStation = fuelStation
                    for brand in brands {
                        if brand.id == fuelStation.brandId {
                            nextController.brand = brand
                        }
                    }
                    
                    for district in districts {
                        if district.id == fuelStation.districtId {
                            nextController.district = district
                        }
                    }
                    
                    for municipality in municipalities {
                        if municipality.id == fuelStation.municipalityId {
                            nextController.municipality = municipality
                        }
                    }
                    
                    for fuelType in fuelTypes {
                        if fuelStation.prices[fuelType.id] != nil {
                            nextController.fuelTypes.append(fuelType)
                        }
                    }
                }
            }
        }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
