//
//  ViewController.swift
//  MoneyPot
//
//  Created by Akshat Shah on 4/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var username : UILabel? 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTableViewController"{
            if let s = segue.destination as? TableViewController{
                s.username = username?.text;
            }
        }
    }
}

