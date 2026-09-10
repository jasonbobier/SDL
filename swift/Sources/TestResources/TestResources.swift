// Copyright © 2026 Jason Bobier. All rights reserved.

@_exported import BundleHelpers

@c(SwiftPackege_GetLibraryBundleResourceDirectory)
public func getLibraryBundleResourceDirectory(_ buffer: UnsafeMutablePointer<CChar>, _ size: CInt) -> CBool {
	getBundleResourceDirectory(bundle: .module, buffer: buffer, size: size)
}

@c(SwiftPackage_GetLibraryBundleResource)
public func getLibraryBundleResource(_ name: UnsafePointer<CChar>, _ buffer: UnsafeMutablePointer<CChar>, _ size: CInt) -> CBool {
	getBundleResource(bundle: .module, name: name, buffer: buffer, size: size)
}
