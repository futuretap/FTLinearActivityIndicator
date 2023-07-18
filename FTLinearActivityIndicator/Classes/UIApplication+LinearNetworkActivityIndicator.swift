//
//  UIApplication+LinearNetworkActivityIndicator.swift
//  FTLinearActivityIndicator
//
//  Created by Ortwin Gentz on 03.01.18.
//  Copyright © 2018 FutureTap GmbH. All rights reserved.
//

import UIKit

@available(iOSApplicationExtension, unavailable)
extension UIApplication {
	@objc final public class func configureLinearNetworkActivityIndicatorIfNeeded() {
		#if !targetEnvironment(macCatalyst)
		if #available(iOS 11.0, *) {
			// detect notch
			if let window = shared.windows.first, window.safeAreaInsets.bottom > 0.0 {
				if UIDevice.current.userInterfaceIdiom != .pad {
					configureLinearNetworkActivityIndicator()
				}
			}
		}
		#endif
	}

	#if !targetEnvironment(macCatalyst)
	class func configureLinearNetworkActivityIndicator() {
		DispatchQueue.once {
			let originalSelector = #selector(setter: UIApplication.isNetworkActivityIndicatorVisible)
			let swizzledSelector = #selector(ft_setNetworkActivityIndicatorVisible(visible:))
			let originalMethod = class_getInstanceMethod(self, originalSelector)
			let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
			method_exchangeImplementations(originalMethod!, swizzledMethod!)
		}
		UIViewController.configureLinearNetworkActivityIndicator()
	}

	private struct AssociatedKeys {
		static var indicatorWindowKey: UInt8 = 0
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
				let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 12)
				indicatorWindow = UIWindow(frame: frame)
				indicatorWindow?.windowLevel = UIWindow.Level.statusBar + 1
				indicatorWindow?.isUserInteractionEnabled = false

				// notched iPhones differ in corner radius and right notch width
				// => lookup margin from right window edge, and width
				let layout: [ModelName: (CGFloat, CGFloat)] = [
					.iPhoneX1: (74, 44),
					.iPhoneX2: (74, 44),
					.iPhoneXs: (74, 44),
					.iPhoneXsMax1: (74, 44),
					.iPhoneXsMax2: (74, 44),
					.iPhoneXR: (70, 40),
					.iPhone11: (70, 40),
					.iPhone11Pro: (60, 34),
					.iPhone11ProMax: (74, 44),
					.iPhone12Mini: (60, 30),
					.iPhone12: (72, 34),
					.iPhone12Pro: (72, 34),
					.iPhone12ProMax: (80, 42),
					.iPhone13Mini: (60, 30),
					.iPhone13: (72, 34),
					.iPhone13Pro: (72, 34),
					.iPhone13ProMax: (80, 42),
					.iPhone14: (72, 34),
					.iPhone14Plus: (80, 42),
					.iPhone14Pro: (72, 34),
					.iPhone14ProMax: (80, 42),
				]
				let modelName = UIDevice.current.ftModelName
				let config = modelName.flatMap { layout[$0] } ?? (74, 44)
				
				let x = indicatorWindow!.frame.width - config.0
				let width = config.1
				
				let indicator = FTLinearActivityIndicator(frame: CGRect(x: x, y: 7, width: width, height: 4.5))
				indicator.isUserInteractionEnabled = false
				indicator.hidesWhenStopped = false
				indicator.startAnimating()
				indicatorWindow?.addSubview(indicator)
			}
		}
		guard let indicator = indicatorWindow?.subviews.first as? FTLinearActivityIndicator else {return}
        if #available(iOS 13.0, *) {
            indicator.tintColor = indicatorWindow?.windowScene?.statusBarManager?.statusBarStyle == .lightContent ? .white : .black
        } else {
            indicator.tintColor = statusBarStyle == .default ? UIColor.black : UIColor.white
        }
		if visible {
			indicatorWindow?.isHidden = self.isStatusBarHidden
			indicator.isHidden = false
			indicator.alpha = 1
		} else {
			UIView.animate(withDuration: 0.5, animations: {
				indicator.alpha = 0
			}) { (finished) in
				if (finished) {
					indicator.isHidden = !self.isNetworkActivityIndicatorVisible  // might have changed in the meantime
					self.indicatorWindow?.isHidden = !self.isNetworkActivityIndicatorVisible || self.isStatusBarHidden
				}
			}
		}
	}

	func ftUpdateNetworkActivityIndicatorAppearance() {
		self.indicatorWindow?.isHidden = !self.isNetworkActivityIndicatorVisible || self.isStatusBarHidden
	}
	#endif
}

#if !targetEnvironment(macCatalyst)
@available(iOSApplicationExtension, unavailable)
extension UIViewController {
	@objc final public class func configureLinearNetworkActivityIndicator() {
		DispatchQueue.once {
			let originalSelector = #selector(setNeedsStatusBarAppearanceUpdate)
			let swizzledSelector = #selector(ftSetNeedsStatusBarAppearanceUpdate)
			let originalMethod = class_getInstanceMethod(self, originalSelector)
			let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
			method_exchangeImplementations(originalMethod!, swizzledMethod!)
		}
	}

	@objc func ftSetNeedsStatusBarAppearanceUpdate() {
		self.ftSetNeedsStatusBarAppearanceUpdate()
		UIApplication.shared.ftUpdateNetworkActivityIndicatorAppearance()
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
#endif
