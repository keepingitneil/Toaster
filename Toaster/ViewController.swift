//
//  ViewController.swift
//  Toaster
//
//  Created by Neil Dwyer on 6/10/16.
//  Copyright © 2016 Neil Dwyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let toaster = Toaster()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showToastButtonPressed(sender: AnyObject) {
        toaster.showGeneralToast(text: "Toasted", duration: 3.0, tapHandler: nil, cancelHandler: nil)
    }


}

