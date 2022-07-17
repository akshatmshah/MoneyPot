//
//  TableViewController.swift
//  MoneyPot
//
//  Created by Akshat Shah on 4/17/22.
//

import Foundation
import UIKit
import Firebase

class TableViewController : UITableViewController{
    
    var username : String? = ""
    var ref : DatabaseReference!
    var refHandle : DatabaseHandle!
    var userGroups : [String?]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        refHandle = ref.child("People").observe(DataEventType.value, with: {
            (snapchat) in
            if let people = snapchat.value as? NSDictionary{
                //                let people = data["People"]
                for person in people{
                    let personName : String = person.key as! String
                    if(personName == self.username){
                        self.userGroups = person.value as! [String?]
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        })
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")!
        if let title = cell.viewWithTag(2) as? UILabel{
            title.text = userGroups[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let group : String? = userGroups[indexPath.row]
            userGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.ref.child("People").child(username!).setValue(userGroups)
            //set to nil to remove from firebase database
            self.ref.child("Groups").child(group!).child("People").child("0").updateChildValues([username: nil])
//            var count : UInt = 0;
            self.ref.child("Groups").child(group!).observe(DataEventType.value, with: { (snapshot) in
                if(snapshot.childrenCount == 1){
                    self.ref.child("Groups").updateChildValues([group!: ["Amount" : 0]])
                }
              })
            }
//            var count = 0;
//            ref.child("Groups").child(group!).observeEventType(.Value, withBlock: { (snapshot: FDataSnapshot!) in
//                    count += snapshot.childrenCount
//                }
//            print(count)
//            if(count == 1){
//
//            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableViewtoDetailViewSegue"{
            guard let s = segue.destination as? DetailViewController,
                  let index = tableView.indexPathForSelectedRow?.row
            else {
                return
            }
            s.group = userGroups[index]
            s.username = username!
        }
        if segue.identifier == "tableViewtoJoinGroup"{
            if let s = segue.destination as? JoinGroupViewController{
                s.currUser = self.username!
                s.userGroups = self.userGroups
            }
        }
    }
}
