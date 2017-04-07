//
//  FirstViewController.swift
//  Test
//
//  Created by Thomas Yuan on 4/7/17.
//  Copyright © 2017 Thomas Yuan. All rights reserved.
//

import UIKit
import CoreBluetooth
//let serviceUUID = CBUUID(string: "0000FE95-0000-1000-8000-00805F9B34FB") //short
let serviceUUID = CBUUID(string: "322AB0F0-713C-4EC5-A619-EC8E8D1763E2")

class FirstViewController: UIViewController {

    var ad: Advertiser?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ad = Advertiser()
        ad?.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


class Advertiser: NSObject {
    var peripheralManager: CBPeripheralManager?
    
    func start() {
        print("start")
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    func onPowerOn() {
        let service = CBMutableService(type: serviceUUID, primary: true)
        peripheralManager?.add(service)
    }
    
}

extension Advertiser: CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState \(peripheral.state.rawValue)")
        
        switch (peripheral.state) {
        case .unknown,
             .unsupported,
             .unauthorized:
            print("Ignored CBPeripheralManagerState")
            break
            
        case .resetting,
             .poweredOff:
            print("CBPeripheralManagerState.PoweredOff")
            break
            
        case .poweredOn:
            print("CBPeripheralManagerState.PoweredOn")
            onPowerOn()
            break
        }
    }
    
    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let e = error {
            print("peripheralManagerDidStartAdvertising error: \(e)")
        } else {
            print("peripheralManagerDidStartAdvertising done.")
        }
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        assert(peripheralManager == peripheral)
        
        if let e = error {
            print("peripheralManager add service error: \(e)")
        } else {
            print("peripheralManager add service done.")
            
        }
        
        let dataToBeAdvertised: [String: Any] = [
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
            CBAdvertisementDataLocalNameKey: "123456789012345678901234567890"
        ]
        
        peripheral.startAdvertising(dataToBeAdvertised)
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("didReceiveRead Request")
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("didReceiveWrite Request")
        
    }
    
    public func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
    }
    
}




