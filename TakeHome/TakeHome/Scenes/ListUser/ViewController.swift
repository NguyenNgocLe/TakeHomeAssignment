//
//  ViewController.swift
//  TakeHome
//
//  Created by Le on 16/5/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let baseUrl: String = Environment.configuration(key: .baseUrl)
        print(baseUrl)
    }
}

