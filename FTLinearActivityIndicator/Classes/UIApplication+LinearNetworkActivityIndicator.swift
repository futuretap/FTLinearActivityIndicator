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

#if !targetEnvironment(macCatalyst) && (swift(<5.9) || !os(visionOS))
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
                let modelName: FTModelName? = UIDevice.current.ftModelName
                let config: FTConfig = FTConfig.config(for: modelName) ?? FTConfig.defaultConfig

				let x = (indicatorWindow?.frame.width ?? 0) - config.x
				
                let indicator = FTLinearActivityIndicator(
                    frame: CGRect(
                        x: x,
                        y: config.y,
                        width: config.width,
                        height: config.height
                    )
                )
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

#if !targetEnvironment(macCatalyst) && (swift(<5.9) || !os(visionOS))
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

private struct FTConfig {
    let x: Double
    let y: Double
    let width: Double
    let height: Double
    
    static func config(for model: FTModelName?) -> FTConfig? {
        guard let model else { return nil }
        let x: Double
        let width: Double
        switch model {
        case .iPhoneX1, .iPhoneX2, .iPhoneXs, .iPhoneXsMax1, .iPhoneXsMax2, .iPhone11ProMax:
            x = 74
            width = 44
        case .iPhoneXR, .iPhone11:
            x = 70
            width = 40
        case .iPhone11Pro:
            x = 60
            width = 34
        case .iPhone12Mini, .iPhone13Mini:
            x = 60
            width = 30
        case .iPhone12, .iPhone12Pro, .iPhone13, .iPhone13Pro, .iPhone14:
            x = 72
            width = 34
        case .iPhone12ProMax, .iPhone13ProMax, .iPhone14ProMax:
            x = 80
            width = 42
        case .iPhone14Plus, .iPhone14Pro, .iPhone15Plus, .iPhone15ProMax:
            x = 88
            width = 48
        case .iPhone15, .iPhone15Pro:
            x = 84
            width = 48
        }
        return FTConfig(
            x: x,
            y: model.hasDynamicIsland ? FTConstants.defaultY : FTConstants.dynamicIslandY,
            width: width,
            height: FTConstants.defaultHeight
        )
    }
    
    static let defaultConfig: FTConfig = {
        print("⚠️ Hey! This model is not supported by FTLinearActivityIndicator.\n💡Please consider making a PR to the repository: https://github.com/futuretap/FTLinearActivityIndicator")
        return FTConfig(
            x: FTConstants.defaultX,
            y: FTConstants.defaultY,
            width: FTConstants.defaultWidth,
            height: FTConstants.defaultHeight
        )
    }()
}

private struct FTConstants {
    static let defaultX: Double = 74
    static let defaultY: Double = 7
    static let defaultWidth: Double = 44
    static let defaultHeight: Double = 4.5

    static let dynamicIslandY: Double = 9
}
