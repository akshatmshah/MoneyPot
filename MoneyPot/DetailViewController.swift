//
//  DetailViewController.swift
//  MoneyPot
//
//  Created by Akshat Shah on 4/17/22.
//

import Foundation
import UIKit
import Firebase


class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var group : String? = ""
    var ref : DatabaseReference!
    var refHandle : DatabaseHandle!
    var peopleData : [PeopleAnnotation] = []
    var amount : Int = 0
    var username : String = ""
    
    @IBOutlet var total : UILabel?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        refHandle = ref.child("Groups").observe(DataEventType.value, with: {
            (snapchat) in
            self.peopleData.removeAll()
            if let groups = snapchat.value as? NSDictionary{
                for group in groups{
                    let groupName : String = group.key as! String
                    if(groupName == self.group){
                        if let data = group.value as? NSDictionary{
                            self.amount = data["Amount"] as! Int
                            self.total!.text = "$\(self.amount)"
                            if let people = data["People"] as? [NSDictionary]{
                                for person in people[0] {
                                    let personData = PeopleAnnotation(person: person.key as! String, group: groupName, balance: person.value as! Int)
                                    self.peopleData.append(personData)
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peopleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell")!
        
        let peopleDat = self.peopleData[indexPath.row]
        
        if let title = cell.viewWithTag(1) as? UILabel{
            title.text = peopleDat.person
        }
        
        if let balance = cell.viewWithTag(2) as? UILabel{
            balance.text = "$\(peopleDat.balance)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func resetBalance(_ sender: Any) {
        print("restedBalnace")
        for dat in peopleData{
            self.ref.child("Groups").child(group!).child("People").child("0").updateChildValues([dat.person: 0])
        }
        self.ref.child("Groups").child(group!).updateChildValues(["Amount": 0])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewtoBalanceView"{
            if let s = segue.destination as? BalanceDetailView{
                s.total = amount
                
                for dat in peopleData{
                    if(dat.person == username){
                        s.userData = dat
                    }
                }
            }
        }
    }
}
