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
#if !targetEnvironment(macCatalyst) && (swift(<5.9) || !os(visionOS))
		if UIDevice.current.userInterfaceIdiom != .pad {
			if #available(iOS 18.0, *) {
				configureLinearNetworkActivityIndicator()
			}
			// detect notch
			if let window = shared.windows.first, window.safeAreaInsets.bottom > 0.0 {
				configureLinearNetworkActivityIndicator()
			}
		}
		#endif
	}

#if !targetEnvironment(macCatalyst) && (swift(<5.9) || !os(visionOS))
	class func configureLinearNetworkActivityIndicator() {
		DispatchQueue.once {
			swizzle(original: #selector(setter: UIApplication.isNetworkActivityIndicatorVisible),
					swizzled:  #selector(setter: ft_networkActivityIndicatorVisible))
			swizzle(original: #selector(getter: UIApplication.isNetworkActivityIndicatorVisible),
					swizzled:  #selector(getter: ft_networkActivityIndicatorVisible))
		}
		UIViewController.configureLinearNetworkActivityIndicator()
	}

	private struct AssociatedKeys {
		static var indicatorWindowKey: UInt8 = 0
		static var indicatorVisibleKey: UInt8 = 0
	}

	var indicatorWindow: UIWindow? {
		get {
			objc_getAssociatedObject(self, &AssociatedKeys.indicatorWindowKey) as? UIWindow
		}

		set {
			if let newValue {
				objc_setAssociatedObject(
					self,
					&AssociatedKeys.indicatorWindowKey,
					newValue as UIWindow?,
					.OBJC_ASSOCIATION_RETAIN_NONATOMIC
				)
			}
		}
	}


	@objc var ft_networkActivityIndicatorVisible: Bool {
		get {
			objc_getAssociatedObject(self, &AssociatedKeys.indicatorVisibleKey) as? Bool ?? false
		}
		set {
			self.ft_networkActivityIndicatorVisible = newValue // original implementation
			objc_setAssociatedObject(self, &AssociatedKeys.indicatorVisibleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
			
			if newValue {
				if indicatorWindow == nil {
					let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 12)
					indicatorWindow = UIWindow(frame: frame)
					indicatorWindow?.windowLevel = UIWindow.Level.statusBar + 1
					indicatorWindow?.isUserInteractionEnabled = false
					if #available(iOS 17.0, *) {
						indicatorWindow?.registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (newTC: UITraitEnvironment, previousTraitCollection: UITraitCollection) in
							self.ftUpdateNetworkActivityIndicatorAppearance()
						})
					}
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
						.iPhone15: (72, 34),
						.iPhone15Plus: (80, 42),
						.iPhone15Pro: (72, 34),
						.iPhone15ProMax: (80, 42),
						.iPhone16: (84, 36),
						.iPhone16Plus: (96, 42),
						.iPhone16Pro: (86, 38),
						.iPhone16ProMax: (96, 42),
						.iPhoneSE2: (177, 40),
						.iPhoneSE3: (177, 40),
					]
					let modelName = UIDevice.current.ftModelName
					let config = modelName.flatMap { layout[$0] } ?? (74, 44)
					
					let x = indicatorWindow!.frame.width - config.0
					let width = config.1
					
					let indicator = FTLinearActivityIndicator(frame: CGRect(x: x, y: 7, width: width, height: 4.5))
					if [.iPhoneSE2, .iPhoneSE3].contains(modelName) {
						indicator.frame = CGRect(x: 172, y: 1.5, width: 31, height: 3)
					}
					indicator.isUserInteractionEnabled = false
					indicator.hidesWhenStopped = false
					indicator.startAnimating()
					indicatorWindow?.addSubview(indicator)
				}
			}
			guard let indicator = indicatorWindow?.subviews.first as? FTLinearActivityIndicator else {return}
			if #available(iOS 13.0, *) {
				let style = indicatorWindow?.windowScene?.statusBarManager?.statusBarStyle ?? .default
				indicator.tintColor = switch style {
				case .lightContent: .white
				case .darkContent: .black
				default: indicatorWindow?.traitCollection.userInterfaceStyle == .dark ? .white : .black
				}
			} else {
				indicator.tintColor = statusBarStyle == .default ? UIColor.black : UIColor.white
			}
			if newValue {
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
	}

	func ftUpdateNetworkActivityIndicatorAppearance() {
		self.indicatorWindow?.isHidden = !self.isNetworkActivityIndicatorVisible || self.isStatusBarHidden
		isNetworkActivityIndicatorVisible = isNetworkActivityIndicatorVisible
	}
	#endif
}

#if !targetEnvironment(macCatalyst) && (swift(<5.9) || !os(visionOS))
@available(iOSApplicationExtension, unavailable)
extension UIViewController {
	@objc final public class func configureLinearNetworkActivityIndicator() {
		DispatchQueue.once {
			swizzle(original: #selector(setNeedsStatusBarAppearanceUpdate),
					swizzled: #selector(ftSetNeedsStatusBarAppearanceUpdate))
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

@available(iOSApplicationExtension, unavailable)
extension NSObject {
	fileprivate class func swizzle(original: Selector, swizzled: Selector) {
		let originalMethod = class_getInstanceMethod(self as AnyClass, original)
		let swizzledMethod = class_getInstanceMethod(self as AnyClass, swizzled)
		method_exchangeImplementations(originalMethod!, swizzledMethod!)
	}
}
#endif
