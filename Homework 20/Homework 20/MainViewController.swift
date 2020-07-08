//
//  ViewController.swift
//  Homework 20
//
//  Created by Олександр Олексин on 12/24/19.
//  Copyright © 2019 Oleksandr Oleksyn. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Task1Segue" || segue.identifier == "Task2Segue" || segue.identifier == "Task3Segue" {
            let backItem = UIBarButtonItem()
            backItem.title = "Content"
            backItem.tintColor = .gray
            navigationItem.backBarButtonItem = backItem
        }
        
    }
}

