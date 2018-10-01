//
//  ViewController.swift
//  SqliteDatabaseSwift
//
//  Created by Nazia Afroz on 1/10/18.
//  Copyright © 2018 Nazia Afroz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        let databaseManager = DatabaseManger.shared
        switch sender.tag {
        case 1:
            databaseManager.createDictionaryTable()
        case 2:
            databaseManager.insert()
        case 3:
            databaseManager.query()
        default:
            databaseManager.query()
        }
    }
    
}

