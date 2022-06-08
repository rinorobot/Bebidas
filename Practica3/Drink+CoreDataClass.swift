//
//  Drink+CoreDataClass.swift
//  Practica3
//
//  Created by Salvador Gómez Moya on 05/04/22.
//
//

import Foundation
import CoreData

@objc(Drink)
public class Drink: NSManagedObject {
    
    func initializeWith(_ drink: [String:Any]) {
      let name = (drink["name"]) as? String ?? ""
      let ingredients = (drink["ingredients"]) as? String ?? ""
      let directions = (drink["directions"]) as? String ?? ""
      let image = (drink["image"]) as? String ?? ""
        self.name = name
        self.directions = directions
        self.ingredients = ingredients
        self.image = image
    }
    

}
