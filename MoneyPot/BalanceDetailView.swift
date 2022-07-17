//
//  BalanceDetailView.swift
//  MoneyPot
//
//  Created by Akshat Shah on 4/21/22.
//

import Foundation
import UIKit
import Firebase

class BalanceDetailView : UIViewController {
    var total : Int = 0
    var ref : DatabaseReference!
    var userData : PeopleAnnotation?

    
    @IBOutlet weak var amount: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        configureView()
    }
    
    func configureView(){
        self.view.layer.cornerRadius = 6
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
    }
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBalance(_ sender: Any) {
        let amountValue = Int(amount.text!)
        let newTotal = amountValue! + total
        
        self.ref.child("Groups").child(userData!.group).updateChildValues(["Amount": newTotal])
        self.ref.child("Groups").child(userData!.group).child("People").child("0").updateChildValues([userData!.person: (userData!.balance + amountValue!)])
        dismiss(animated: true, completion: nil)
        //update total balance
        //update the username balance
    }
}
