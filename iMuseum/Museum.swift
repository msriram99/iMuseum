//
//  Museum.swift
//  iMuseum
//
//  Created by Himaja Motheram on 4/10/17.
//  Copyright © 2017 Sriram Motheram. All rights reserved.
//

import UIKit

import UIKit

class Museum: NSObject {
    
   
    var name          :String!
    var street  :String!
    var city          :String!
    var state    :String!
    
    
    init(name: String, street: String, city: String, state: String) {
        
        self.name = "\(name)"
        self.street = street
        self.city = city
        self.state = state
        
    }
    
}
