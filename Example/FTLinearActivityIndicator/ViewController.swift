//
//  ViewController.swift
//  FTLinearActivityIndicator
//
//  Created by Ortwin Gentz on 03.01.18.
//  Copyright © 2018 FutureTap GmbH. All rights reserved.
//

import UIKit
import FTLinearActivityIndicator

class ViewController: UIViewController {
	@IBOutlet var standAloneIndicator: FTLinearActivityIndicator?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func toggle(_ sender: Any) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = !UIApplication.shared.isNetworkActivityIndicatorVisible
	}

	@IBAction func toggleStandAlone(_ sender: Any) {
		guard let standAloneIndicator = standAloneIndicator else {return}
		
		if standAloneIndicator.isAnimating {
			standAloneIndicator.stopAnimating()
		} else {
			standAloneIndicator.startAnimating()
		}
	}
}

