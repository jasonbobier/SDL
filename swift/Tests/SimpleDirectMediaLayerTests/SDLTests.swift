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

import Testing
import Subprocess
import Foundation

@Suite(.serialized, .withPretest)
struct SDLTests {
	@Test func testver() async throws {
		try await runTest(name: "testver")
	}

	func runTest(name: String, sourceLocation: SourceLocation = #_sourceLocation) async throws {
		await #expect(throws: Never.self, sourceLocation: sourceLocation) {
			let result = try await run(.path(.init(productsDirectory)!.appending(name)), output: .discarded, error: .string(limit: 4096, encoding: UTF8.self))

			guard result.terminationStatus == .exited(0) else {
				throw SDLTestingError.error(terminationStatus: result.terminationStatus, standardError: result.standardError)
			}
		}
	}
}

private final class BundleFinder { }
private let productsDirectory = Bundle(for: BundleFinder.self).bundleURL.deletingLastPathComponent()

struct PretestTrait: SuiteTrait & TestScoping {
	func provideScope(for test: Test, testCase: Test.Case?, performing function: () async throws -> Void) async throws {
		try await pretest()
		try await function()
	}

	func pretest() async throws {
		let result = try await run(.path(.init(productsDirectory)!.appending("pretest")), output: .discarded, error: .string(limit: 4096, encoding: UTF8.self))

		guard result.terminationStatus == .exited(0) else {
			throw SDLTestingError.pretestFailed(standardError: result.standardError)
		}
	}
}

extension SuiteTrait where Self == PretestTrait {
	static var withPretest: PretestTrait {
		PretestTrait()
	}
}

enum SDLTestingError: LocalizedError {
	case pretestFailed(standardError: String)
	case error(terminationStatus: TerminationStatus, standardError: String)

	var errorDescription: String? {
		switch self {
			case .pretestFailed(let standardError):
				"pretest failed: \(standardError)"

			case .error(terminationStatus: let terminationStatus, standardError: let standardError):
				"Error: (\(terminationStatus)) \(standardError)"
		}
	}
}
