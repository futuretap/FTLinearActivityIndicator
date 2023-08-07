//
//  ViewController.swift
//  FTLinearActivityIndicator
//
//  Created by Ortwin Gentz on 03.01.18.
//  Copyright © 2018 FutureTap GmbH. All rights reserved.
//

import UIKit
import FTLinearActivityIndicator

@available(iOSApplicationExtension, unavailable)
class ViewController: UIViewController {
	@IBOutlet var standAloneIndicator: FTLinearActivityIndicator?
	@IBOutlet var imagePickerContainer: UIView!
	
	var statusBarHidden = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func toggle(_ sender: Any) {
#if (swift(<5.9) || !os(visionOS))
		UIApplication.shared.isNetworkActivityIndicatorVisible = !UIApplication.shared.isNetworkActivityIndicatorVisible
#endif
	}

	@IBAction func toggleStandAlone(_ sender: Any) {
		guard let standAloneIndicator = standAloneIndicator else {return}
		
		if standAloneIndicator.isAnimating {
			standAloneIndicator.stopAnimating()
		} else {
			standAloneIndicator.startAnimating()
		}
	}
	
	@IBAction func toggleStatusBar(_sender: Any) {
		statusBarHidden = !statusBarHidden
#if (swift(<5.9) || !os(visionOS))
		setNeedsStatusBarAppearanceUpdate()
#endif
	}
	
	@IBAction func showCamera() {
		let cameraPickerController = UIImagePickerController()
		cameraPickerController.sourceType = .camera
		
		imagePickerContainer.addSubview(cameraPickerController.view)
		addChild(cameraPickerController)
	}
	
	override var prefersStatusBarHidden: Bool {
		get {
			return statusBarHidden
		}
	}
}

