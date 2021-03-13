//
//  TableViewController.swift
//  WatchApp_Cars
//
//  Created by Xcode on 2020-11-29.
//  Copyright © 2020 Nishit Amin. All rights reserved.
//

import UIKit
import WatchConnectivity

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WCSessionDelegate{
    
    let getData = GetData()
    var timer : Timer!
    @IBOutlet var myTable : UITableView!
    var lastMessage: CFAbsoluteTime = 0
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("gtugty")
        var replyValues  = Dictionary<String,AnyObject>()
        print(message)
        if(message["getCarData"] != nil){
            NSKeyedArchiver.setClassName("CarObject",for:CarObject.self)
            let carDta = NSKeyedArchiver.archivedData(withRootObject: self.myCars)
            print(getData.dbData)
            print(carDta)
            replyValues["carData"] = carDta as AnyObject?
            replyHandler(replyValues)
        }
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.refreshTable), userInfo: nil, repeats: true);
        
        getData.jsonParser()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
    
    var myCars : [CarObject] = []
    @objc func refreshTable(){
        if(getData.dbData != nil)
        {
            if (getData.dbData?.count)! > 0
            {
                
                for car in getData.dbData!{
                    var model = car.value(forKey: "Model") as! String
                    var make = car.value(forKey: "Make") as! String
                    var year = car.value(forKey: "Year") as! String
                    var color = car.value(forKey: "Color") as! String
                    var status = car.value(forKey: "Status") as! String
                    var price = car.value(forKey: "Price") as! String
                    var nc = CarObject()
                    nc.initWithData(Make: make, Model: model, Year: year, Color: color, Status: status, Price: price)
                    self.myCars.append(nc)
            
                }
                let carD = NSKeyedArchiver.archivedData(withRootObject: self.myCars)
                sendWatchMessage(carD)
                self.myTable.reloadData()
                self.timer.invalidate()
            }
        }
    }
    
    func sendWatchMessage(_ msgData:Data) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        // if less than half a second has passed, bail out
        if lastMessage + 0.5 > currentTime {
            return
        }
        
        // send a message to the watch if it's reachable
        if (WCSession.default.isReachable) {
            
            let message = ["carData": msgData]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
        
        // update our rate limiting property
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            if session.isPaired != true {
                print("Watch not paired")
            }
            if session.isWatchAppInstalled != true{
                print("Watch App is not installed")
            }
        }else{
            print("Watch not supported.")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if getData.dbData != nil
        {
            return (getData.dbData?.count)!
        }
        else
        {
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? MyDataTableViewCell ?? MyDataTableViewCell(style: .default, reuseIdentifier: "myCell")
        
        let row = indexPath.row
        let rowData = (getData.dbData?[row])! as NSDictionary
        
        cell.make.text = rowData["Make"] as? String
        cell.model.text = rowData["Model"] as? String
        cell.year.text = rowData["Year"] as? String
        cell.color.text = rowData["Color"] as? String
        cell.status.text = rowData["Status"] as? String
        cell.price.text = rowData["Price"] as? String
        
        return cell
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
