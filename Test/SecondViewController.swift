//
//  SecondViewController.swift
//  Test
//
//  Created by Thomas Yuan on 4/7/17.
//  Copyright © 2017 Thomas Yuan. All rights reserved.
//

import UIKit
import CoreBluetooth

class SecondViewController: UIViewController {

    var d: Discovery?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        d = Discovery()
        d?.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class Discovery: NSObject {
    var centralManager: CBCentralManager?

    func start() {
        centralManager = CBCentralManager(delegate: self, queue: nil)

    }
    
    func onPowerOn() {
        centralManager!.scanForPeripherals(withServices: [serviceUUID], options: nil)

    }
}

extension Discovery: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("central manager state change: \(central.state.rawValue)")
        
        switch (central.state) {
        case .unknown,
             .unsupported,
             .unauthorized:
            print("ignored status.")
            
            break;
            
        case .resetting,
             .poweredOff:
            break
            
        case .poweredOn:
            onPowerOn()
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("didDiscover, RSSI \(RSSI), \(peripheral), \n\(advertisementData)")
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect \(peripheral)")
        
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    }
}

