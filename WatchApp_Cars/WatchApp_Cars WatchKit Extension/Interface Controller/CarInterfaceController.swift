//
//  CarInterfaceController.swift
//  WatchApp_Cars WatchKit Extension
//
//  Created by Xcode on 2020-11-29.
//  Copyright © 2020 Nishit Amin. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class CarInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var carTable : WKInterfaceTable!
    var cars : [CarObject] = []
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replyValues = Dictionary<String, AnyObject>()
        let loadedData = message["carData"]
        let lodadedCar = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [CarObject]
        cars = lodadedCar!
        replyValues["status"] = "Cars Received" as AnyObject?;
        replyHandler(replyValues)
    }
    
  
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(WCSession.default.isReachable){
            let message = ["getCarData" : [:]]
            WCSession.default.sendMessage(message, replyHandler: {
                (result) -> Void in
                if result["carData"] != nil
                {
                    let loadedData = result["carData"]
                    
                    NSKeyedUnarchiver.setClass(CarObject.self, forClassName: "CarObject")
                    
                    let loadedCar = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [CarObject]
                    
                    self.cars = loadedCar!
                    self.carTable.setNumberOfRows(3, withRowType: "CarRowController")
//                    print(self.carTable.numberOfRows)
                    
                    for(index, car) in self.cars.enumerated() {
                        let row = self.carTable.rowController(at: index) as! CarRowController
                        
                        row.lblMake.setText(car.Make)
                        row.lblModel.setText(car.Model)
                        row.lblYear.setText(car.Year)
                        row.lblColor.setText(car.Color)
                        row.lblStatus.setText(car.Status)
                        row.lblPrice.setText(car.Price)
                        
                    }
                }
            }, errorHandler: {(error) -> Void in
                print(error)
            })
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
