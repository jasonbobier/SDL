// Copyright © 2026 Jason Bobier. All rights reserved.

import Foundation

@c(SwiftPackage_GetMainBundleResourceDirectory)
public func getMainBundleResourceDirectory(_ buffer: UnsafeMutablePointer<CChar>, _ size: CInt) -> CBool {
	getBundleResourceDirectory(bundle: .main, buffer: buffer, size: size)
}

@c(SwiftPackage_GetMainBundleResource)
public func getMainBundleResource(_ name: UnsafePointer<CChar>, _ buffer: UnsafeMutablePointer<CChar>, _ size: CInt) -> CBool {
	getBundleResource(bundle: .main, name: name, buffer: buffer, size: size)
}

public func getBundleResourceDirectory(bundle: Bundle, buffer: UnsafeMutablePointer<CChar>, size: CInt) -> CBool {
	guard let url = bundle.resourceURL else {
		return false
	}

	let path = url.path(percentEncoded: false).utf8CString

	guard path.count <= size else {
		return false
	}

	path.withUnsafeBufferPointer {
		buffer.update(from: $0.baseAddress!, count: $0.count)
	}

	return true
}

public func getBundleResource(bundle: Bundle, name: UnsafePointer<CChar>, buffer: UnsafeMutablePointer<CChar>, size: CInt) -> CBool {
	guard let url = bundle.url(forResource: String(utf8String: name), withExtension: nil) else {
		return false
	}

	let path = url.path(percentEncoded: false).utf8CString

	guard path.count <= size else {
		return false
	}

	path.withUnsafeBufferPointer {
		buffer.update(from: $0.baseAddress!, count: $0.count)
	}

	return true
}
