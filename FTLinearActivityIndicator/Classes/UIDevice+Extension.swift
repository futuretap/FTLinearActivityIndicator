//
//  UIDevice+Extension.swift
//  FTLinearActivityIndicator
//
//  Created by Ortwin Gentz on 15.03.21.
//

import UIKit

public enum ModelName: String {
    case iPhoneX1 = "iPhone10,3"
    case iPhoneX2 = "iPhone10,6"
    case iPhoneXs = "iPhone11,2"
    case iPhoneXsMax1 = "iPhone11,4"
    case iPhoneXsMax2 = "iPhone11,6"
    case iPhoneXR = "iPhone11,8"
    case iPhone11 = "iPhone12,1"
    case iPhone11Pro = "iPhone12,3"
    case iPhone11ProMax = "iPhone12,5"
    case iPhone12Mini = "iPhone13,1"
    case iPhone12 = "iPhone13,2"
    case iPhone12Pro = "iPhone13,3"
    case iPhone12ProMax = "iPhone13,4"
    case iPhone13Mini = "iPhone14,4"
    case iPhone13 = "iPhone14,5"
    case iPhone13Pro = "iPhone14,2"
    case iPhone13ProMax = "iPhone14,3"
    case iPhone14 = "iPhone14,7"
    case iPhone14Plus = "iPhone14,8"
    case iPhone14Pro = "iPhone15,2"
    case iPhone14ProMax = "iPhone15,3"
    case iPhone15 = "iPhone15,4"
    case iPhone15Plus = "iPhone15,5"
    case iPhone15Pro = "iPhone16,1"
    case iPhone15ProMax = "iPhone16,2"
	case iPhone16 = "iPhone17,3"
	case iPhone16Plus = "iPhone17,4"
	case iPhone16Pro = "iPhone17,1"
	case iPhone16ProMax = "iPhone17,2"
	case iPhoneSE2 = "iPhone12,8"
	case iPhoneSE3 = "iPhone14,6"
}

public extension UIDevice {
	var ftModelName: ModelName? {
		let result: String
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		let identifier = machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
		// When running in simulator, identifier will be one of "i386", "x86_64", "arm64" instead of what we want.
		switch identifier {
		case "i386", "x86_64", "arm64": result = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? identifier
		default: result = identifier
		}
        
		return .init(rawValue: result)
	}
}
