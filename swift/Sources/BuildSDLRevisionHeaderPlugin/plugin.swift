/*
  Simple DirectMedia Layer
  Copyright (C) 1997-2026 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/

import PackagePlugin
import Foundation

@main
struct BuildSDLRevisionHeaderPlugin: BuildToolPlugin {
	func createBuildCommands(context: PackagePlugin.PluginContext, target: any PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
		let emptyURL = context.pluginWorkDirectoryURL.appending(path: "empty")
		let headerURL = context.pluginWorkDirectoryURL.appending(path: "include/SDL_revision_swiftpm.h")
		let passThrough = ["PATH", "DEVELOPER_DIR"]
		let arguments = [
			context.package.directoryURL.appending(path: "swift/Scripts/BuildSDLRevisionHeader.swift").path(percentEncoded: false),
			context.package.directoryURL.path(percentEncoded: false),
			headerURL.path(percentEncoded: false)
		]
		let environment = ProcessInfo.processInfo.environment.filter { passThrough.contains($0.key) }

		try FileManager.default.createDirectory(
			at: emptyURL,
			withIntermediateDirectories: true)

		return [
			.prebuildCommand(
				displayName: "BuildSDLRevisionHeader",
				executable: try context.tool(named: "swift").url,
				arguments: arguments,
				environment: environment,
				outputFilesDirectory: emptyURL
			),

			// We have to add a build command here so that the include directory is picked up by a -I.
			// This is all part of the experimentalCGen.
			.buildCommand(
				displayName: "Add Include for BuildSDLRevisionHeader",
				executable: try context.tool(named: "swift").url,
				arguments: arguments,
				environment: environment,
				outputFiles: [
					headerURL,
				]
			)
		]
	}
}
