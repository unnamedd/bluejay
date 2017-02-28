//
//  PeripheralsViewController.swift
//  Bluejay
//
//  Created by Jeremy Chiang on 2017-02-27.
//  Copyright © 2017 Steamclock Software. All rights reserved.
//

import Foundation
import UIKit
import Bluejay

class PeripheralsViewController: UITableViewController {
    
    private let bluejay = Bluejay.shared
    private var peripherals = [ScanDiscovery]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bluejay.start()
        
        scan()
    }
    
    @IBAction func scan() {
        bluejay.scan(
            allowDuplicates: true,
            serviceIdentifiers: nil,
            discovery: { [weak self] (discovery, discoveries) -> (ScanAction) in
                guard let weakSelf = self else {
                    return .stop
                }
                
                weakSelf.peripherals = discoveries
                weakSelf.tableView.reloadData()
                
                if discovery == nil {
                    return .stop
                }
                
                return .continue
        }) { (discoveries, error) in
            if let error = error {
                debugPrint("Scan stopped with error: \(error.localizedDescription)")
            }
            else {
                debugPrint("Scan stopped without error.")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peripheralCell", for: indexPath)
        
        cell.textLabel?.text = peripherals[indexPath.row].peripheral.name ?? "Unknown"
        cell.detailTextLabel?.text = "RSSI: \(peripherals[indexPath.row].rssi)"
        
        return cell
    }
    
}
