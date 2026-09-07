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
import System
import Foundation

@Suite(.withPretest)
struct `SDL Tests` {
	static let defaultEnvironment = Environment.inherit.updating([
		"SDL_VIDEO_DRIVER": "dummy",
		"SDL_AUDIO_DRIVER": "dummy",
		"SDL_ASSERT": "abort",
	])
	static let defaultTimeout = Duration.seconds(10)

	@Test func testatomic() async throws {
		try await Self.runTest(name: "testatomic", timeout: .seconds(20))
	}

	@Suite(.serialized)
	struct `testautomation Tests` {
		@Test func testautomation() async throws {
			try await runTest(name: "testautomation", timeout: .seconds(120))
		}

		@Test func `testautomation-no-simd`() async throws {
			try await runTest(name: "testautomation", environment: defaultEnvironment.updating(["SDL_CPU_FEATURE_MASK": "-all"]), timeout: .seconds(120))
		}
	}

	@Test func testbounds() async throws {
		try await Self.runTest(name: "testbounds")
	}

	@Test func testerror() async throws {
		try await Self.runTest(name: "testerror")
	}

	@Test func testfile() async throws {
		try await Self.runTest(name: "testfile")
	}

	@Test func testfilesystem() async throws {
		try await Self.runTest(name: "testfilesystem")
	}

	@Test func testlocale() async throws {
		try await Self.runTest(name: "testlocale")
	}

	struct `testplatform Tests` {
		@Test func testplatform() async throws {
			try await runTest(name: "testplatform")
		}

		@Test func `testplatform-no-simd`() async throws {
			try await runTest(name: "testplatform", environment: defaultEnvironment.updating(["SDL_CPU_FEATURE_MASK": "-all"]))
		}
	}

	@Test func testpower() async throws {
		try await Self.runTest(name: "testpower")
	}

	@Test func testprocess() async throws {
		try await Self.runTest(name: "testprocess", arguments: [productsDirectory.appending(path: "childprocess").path(percentEncoded: false)])
	}

	@Test func testqsort() async throws {
		try await Self.runTest(name: "testqsort")
	}

	@Test func testrwlock() async throws {
		try await Self.runTest(name: "testrwlock", timeout: .seconds(20))
	}

	@Test func testsem() async throws {
		try await Self.runTest(name: "testsem", arguments: ["10"], timeout: .seconds(30))
	}

	@Test func testsymbols() async throws {
		try await Self.runTest(name: "testsymbols", arguments: ["0", "10", "20", "40", "80", "160", "320", "640"])
	}

	@Test func testthread() async throws {
		try await Self.runTest(name: "testthread", timeout: .seconds(40))
	}

	@Test func testtimer() async throws {
		try await Self.runTest(name: "testtimer", arguments: ["--no-interactive"], timeout: .seconds(60))
	}

	@Test func testver() async throws {
		try await Self.runTest(name: "testver")
	}

	@Test func testyuv() async throws {
		try await Self.runTest(name: "testyuv", arguments: ["--automated"])
	}

	@Test func torturethread() async throws {
		try await Self.runTest(name: "torturethread", timeout: .seconds(30))
	}

	static func runTest(name: String, arguments: Arguments = [], environment: Environment = defaultEnvironment, timeout: Duration = defaultTimeout, sourceLocation: SourceLocation = #_sourceLocation) async throws {
		let productsDirectoryFilePath = FilePath(productsDirectory)!

		await #expect(throws: Never.self, sourceLocation: sourceLocation) {
			let result = try await withThrowingTaskGroup { group in
				group.addTask {
					try await run(
						.path(productsDirectoryFilePath.appending(name)),
						arguments: arguments,
						environment: environment,
						workingDirectory: productsDirectoryFilePath,
						output: .discarded,
						error: .string(limit: 4096*1024, encoding: UTF8.self)
					)
				}
				group.addTask {
					try await Task.sleep(for: timeout)
					throw SDLTestingError.timedOut
				}

				let result = try await group.next()
				group.cancelAll()

				return result!
			}

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

enum SDLTestingError: LocalizedError, CustomStringConvertible {
	case pretestFailed(standardError: String)
	case error(terminationStatus: TerminationStatus, standardError: String)
	case timedOut

	var errorDescription: String? {
		description
	}

	var description: String {
		switch self {
			case .pretestFailed(let standardError):
				"Error: pretest failed: \(standardError)"

			case .error(terminationStatus: let terminationStatus, standardError: let standardError):
				"Error: (\(terminationStatus)) \(standardError)"

			case .timedOut:
				"Error: timed out"
		}
	}
}
