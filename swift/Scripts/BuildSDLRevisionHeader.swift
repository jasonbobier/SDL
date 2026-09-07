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

// Generates SDL_revision_swiftpm.h, mirroring what CMake's configure_file()
// produces from include/build_config/SDL_revision.h.cmake.
//
// Run as a script (no package dependencies are available in script mode):
//     swift swift/Scripts/BuildSDLRevisionHeader.swift <package-dir> <output-header>

import Foundation

enum ScriptError: LocalizedError {
	case missingArguments
	case badArguments(String)
	case notDirectory(String)
	case gitExitError(Int32)
	case gitSignalError(Int32)
	case versionParseError(String)

	var errorDescription: String? {
		switch self {
			case .missingArguments:
				"Missing arguments"

			case .badArguments(let arguments):
				"Bad arguments: \(arguments)"

			case .notDirectory(let path):
				"Bad arguments: \(path) is not a directory!"

			case .gitExitError(let code):
				"Git error (exit: \(code))"

			case .gitSignalError(let code):
				"Git error (signal: \(code))"

			case .versionParseError(let path):
				"Unable to parse version header at \"\(path)\""
		}
	}
}

struct StandardError: TextOutputStream {
	func write(_ string: String) {
		guard string.isEmpty == false else {
			return
		}

		FileHandle.standardError.write(Data(string.utf8))
	}
}

var standardError = StandardError()

func gitDescribe(packageDirectory: URL) throws -> String {
	let process = Process()
	let pipe = Pipe()

	process.executableURL = URL(filePath: "/usr/bin/env")
	process.arguments = [
		"git",
		"-C",
		packageDirectory.path(percentEncoded: false),
		"describe",
		"--tags",
		"--always",
	]
	process.standardOutput = pipe

	try process.run()

	let data = try pipe.fileHandleForReading.readToEnd() ?? Data()

	process.waitUntilExit()

	guard process.terminationStatus == 0 else {
		switch process.terminationReason {
			case .uncaughtSignal:
				throw ScriptError.gitSignalError(process.terminationStatus)

			default:
				throw ScriptError.gitExitError(process.terminationStatus)
		}
	}

	return String(decoding: data, as: UTF8.self)
		.trimmingCharacters(in: .whitespacesAndNewlines)
}

do {
	guard CommandLine.arguments.count > 2 else {
		throw ScriptError.missingArguments
	}
	guard CommandLine.arguments.count == 3 else {
		throw ScriptError.badArguments(CommandLine.arguments.dropFirst().joined(separator: " "))
	}

	let packageDirectoryURL = URL(filePath: CommandLine.arguments[1])
	let values = try packageDirectoryURL.resourceValues(forKeys: [.isDirectoryKey])

	guard values.isDirectory == true else {
		throw ScriptError.notDirectory(CommandLine.arguments[1])
	}

	let gitDescription = try gitDescribe(packageDirectory: packageDirectoryURL)
	let versionHeaderURL = packageDirectoryURL.appending(path: "include/SDL3/SDL_version.h")
	let versionHeader = try String(contentsOf: versionHeaderURL, encoding: .utf8)
	let versionRegex = #/#define\s+SDL_MAJOR_VERSION\s+(?<major>\d+)[\s\S]*?#define\s+SDL_MINOR_VERSION\s+(?<minor>\d+)[\s\S]*?#define\s+SDL_MICRO_VERSION\s+(?<micro>\d+)/#

	guard let match = versionHeader.firstMatch(of: versionRegex) else {
		throw ScriptError.versionParseError(versionHeaderURL.path(percentEncoded: false))
	}

	let sdlRevision = "SDL-\(match.major).\(match.minor).\(match.micro)-\(gitDescription)"
	let newSDLRevisionHeader = """
	  #ifndef SDL_revision_swiftpm_h_
	  #define SDL_revision_swiftpm_h_

	  #ifdef SDL_VENDOR_INFO
	  #define SDL_REVISION "\(sdlRevision) (" SDL_VENDOR_INFO ")"
	  #else
	  #define SDL_REVISION "\(sdlRevision)"
	  #endif

	  #endif /* SDL_revision_swiftpm_h_ */

	  """

	let sdlRevisionHeaderURL = URL(filePath: CommandLine.arguments[2])
	let oldSDLRevisionHeader = try? String(contentsOf: sdlRevisionHeaderURL, encoding: .utf8)

	// Only write when the content changes: a prebuild command runs on every
	// build, and touching the header would recompile every file that includes it.
	if oldSDLRevisionHeader != newSDLRevisionHeader {
		try FileManager.default.createDirectory(
			at: sdlRevisionHeaderURL.deletingLastPathComponent(),
			withIntermediateDirectories: true)
		try newSDLRevisionHeader.write(to: sdlRevisionHeaderURL, atomically: true, encoding: .utf8)
	}
} catch {
	print("error: BuildSDLRevisionHeader: \(error.localizedDescription)", to: &standardError)
	exit(1)
}
