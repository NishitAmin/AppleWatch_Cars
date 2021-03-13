//
//  CarObject.swift
//  WatchApp_Cars
//
//  Created by Xcode on 2020-11-29.
//  Copyright © 2020 Nishit Amin. All rights reserved.
//

import UIKit

class CarObject: NSObject, NSCoding {
    var Model : String?
    var Make : String?
    var Year : String?
    var Color : String?
    var Status : String?
    var Price : String?
    
    func initWithData(
        Make:String,
        Model:String,
        Year:String,
        Color:String,
        Status:String,
        Price:String)
    {
        self.Make = Make
        self.Model = Model
        self.Year = Year
        self.Color = Color
        self.Status = Status
        self.Price = Price
    }
    
    required convenience init?(coder decoder: NSCoder) {
        
        guard let Make = decoder.decodeObject(forKey: "Make") as? String,
            let Model = decoder.decodeObject(forKey: "Model") as? String,
            let Year = decoder.decodeObject(forKey: "Year") as? String,
            let Color = decoder.decodeObject(forKey: "Color") as? String,
            let Status = decoder.decodeObject(forKey: "Status") as? String,
            let Price = decoder.decodeObject(forKey: "Price") as? String
            else {
                return nil
        }
        self.init()
        self.initWithData(Make:Make, Model: Model, Year:Year, Color:Color, Status:Status, Price:Price)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.Make, forKey: "Make")
        coder.encode(self.Model, forKey: "Model")
        coder.encode(self.Year, forKey: "Year")
        coder.encode(self.Color, forKey: "Color")
        coder.encode(self.Status, forKey: "Status")
        coder.encode(self.Price, forKey: "Price")
    }
}
