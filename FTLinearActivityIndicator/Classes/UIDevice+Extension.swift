//
//  UIDevice+Extension.swift
//  FTLinearActivityIndicator
//
//  Created by Ortwin Gentz on 15.03.21.
//

import UIKit

public extension UIDevice {
	var ftModelName: String {
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		let identifier = machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
		return identifier
	}
}
