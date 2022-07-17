//
//  JoinGroupViewController.swift
//  MoneyPot
//
//  Created by Akshat Shah on 4/21/22.
//

import Foundation
import UIKit
import Firebase


class JoinGroupViewController : UIViewController{
    var ref : DatabaseReference!
    var refHandle : DatabaseHandle!
    var currUser : String = ""
    var currGroups : [String] = []
    var userGroups : [String?] = []

    
    @IBOutlet var groupName : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        refHandle = ref.child("Groups").observe(DataEventType.value, with: {
            (snapchat) in
            if let groups = snapchat.value as? NSDictionary{
                for group in groups{
                    self.currGroups.append(group.key as! String);
                }
            }
        })
    }
    
    @IBAction func addPersonToGroup(_ sender: Any) {
        let group = groupName?.text
        if(currGroups.contains(group!)){
            userGroups.append(group)
            self.ref.child("People").child(currUser).setValue(userGroups)
            self.ref.child("Groups").child(group!).child("People").child("0").updateChildValues([currUser: 0])
            dismiss(animated: true, completion: nil)
        }
        if(!currGroups.contains(group!)){
            userGroups.append(group)
            self.ref.child("People").child(currUser).setValue(userGroups)
//            self.ref.child("Groups").updateChildValues([group : "0"])
            self.ref.child("Groups").updateChildValues([group!: ["Amount" : 0]])
//            self.ref.child("Groups").child(group!).updateChildValues(["Amount" : 0]);
            self.ref.child("Groups").child(group!).updateChildValues(["People" : ["0" : [currUser : 0]]]);
//            self.ref.child("Groups").child(group!).updateChildValues(["People" : 0]);
//            self.ref.child("Groups").child(group!).child("People").child("0").updateChildValues([currUser : 0]);
            dismiss(animated: true, completion: nil)
        }
    }
}
