//
//  PeopleAnnotation.swift
//  MoneyPot
//
//  Created by Akshat Shah on 4/18/22.
//

import Foundation

class PeopleAnnotation{
    var person: String
    var group: String
    var balance : Int
    
    init(person: String, group: String, balance: Int) {
        self.person = person
        self.group = group
        self.balance = balance
    }
}
