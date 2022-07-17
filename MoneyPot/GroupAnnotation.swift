//
//  GroupAnnotation.swift
//  MoneyPot
//
//  Created by Akshat Shah on 4/18/22.
//

import Foundation



class GroupAnnotation {
    var groupName: String
    var balance: Int
    var people : [PeopleAnnotation]
    
    init(name: String, balance: Int, people: [PeopleAnnotation]) {
        self.groupName = name
        self.balance = balance
        self.people = people
    }
}
