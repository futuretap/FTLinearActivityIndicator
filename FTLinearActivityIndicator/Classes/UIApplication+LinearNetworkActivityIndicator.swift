//
//  UIApplication+LinearNetworkActivityIndicator.swift
//  FTLinearActivityIndicator
//
//  Created by Ortwin Gentz on 03.01.18.
//  Copyright © 2018 FutureTap GmbH. All rights reserved.
//

import UIKit

extension UIApplication {
	@objc final public class func configureLinearNetworkActivityIndicatorIfNeeded() {
		if #available(iOS 11.0, *) {
			// detect iPhone X
			if let window = shared.windows.first, window.safeAreaInsets.top > 0.0 {
				configureLinearNetworkActivityIndicator()
			}
		}
	}
	
	class func configureLinearNetworkActivityIndicator() {
		DispatchQueue.once {
			let originalSelector = #selector(setter: UIApplication.isNetworkActivityIndicatorVisible)
			let swizzledSelector = #selector(ft_setNetworkActivityIndicatorVisible(visible:))
			
			let originalMethod = class_getInstanceMethod(self, originalSelector)
			let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
			method_exchangeImplementations(originalMethod!, swizzledMethod!)
		}
	}
	
	private struct AssociatedKeys {
		static var indicatorWindowKey = "FTLinearActivityIndicatorWindowKey"
	}
	
	var indicatorWindow: UIWindow? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.indicatorWindowKey) as? UIWindow
		}
		
		set {
			if let newValue = newValue {
				objc_setAssociatedObject(
					self,
					&AssociatedKeys.indicatorWindowKey,
					newValue as UIWindow?,
					.OBJC_ASSOCIATION_RETAIN_NONATOMIC
				)
			}
		}
	}


	@objc func ft_setNetworkActivityIndicatorVisible(visible: Bool) {
		self.ft_setNetworkActivityIndicatorVisible(visible: visible) // original implementation
		
		if visible {
			if indicatorWindow == nil {
				indicatorWindow = UIWindow(frame: statusBarFrame)
				indicatorWindow?.windowLevel = UIWindowLevelStatusBar + 1
				
				let indicator = FTLinearActivityIndicator(frame: CGRect(x: indicatorWindow!.frame.width - 74, y: 5, width: 44, height: 6))
				indicator.tintColor = statusBarStyle == .default ? UIColor.black : UIColor.white
				indicatorWindow?.addSubview(indicator)
			}
		}
		indicatorWindow?.isHidden = !visible
		guard let indicator = indicatorWindow?.subviews.first as? FTLinearActivityIndicator else {return}
		if visible {
			indicator.startAnimating()
		} else {
			indicator.stopAnimating()
		}
	}
}

// https://stackoverflow.com/a/39983813/235297
extension DispatchQueue {
	private static var _onceTracker = [String]()
	
	public class func once(file: String = #file, function: String = #function, line: Int = #line, block:()->Void) {
		let token = file + ":" + function + ":" + String(line)
		once(token: token, block: block)
	}
	
	/**
	Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
	only execute the code once even in the presence of multithreaded calls.
	
	- parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
	- parameter block: Block to execute once
	*/
	public class func once(token: String, block:()->Void) {
		objc_sync_enter(self)
		defer { objc_sync_exit(self) }
		
		
		if _onceTracker.contains(token) {
			return
		}
		
		_onceTracker.append(token)
		block()
	}
}
