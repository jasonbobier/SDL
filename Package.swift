// swift-tools-version: 6.3;(experimentalCGen)
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

// Returns paths from basePath
func contentsOfDirectory(path: String, relativeTo basePath: String = Context.packageDirectory, files: Bool = false, withExtensions extensions: [String]? = nil, directories: Bool = false, exclude: [String] = []) -> [String] {
	let baseURL = URL(filePath: basePath, directoryHint: .isDirectory).standardizedFileURL
	let basePath = baseURL.path(percentEncoded: false)
	let directoryURL = URL(string: path, relativeTo: baseURL)!
	let urls = (try? FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles)) ?? []

	return urls
		.filter { !exclude.contains($0.lastPathComponent) }
		.filter {
			if try! $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory! {
				directories
			} else {
				files && (extensions?.contains($0.pathExtension) ?? true)
			}
		}
		.map {
			String($0.standardizedFileURL.path(percentEncoded: false).trimmingPrefix(basePath))
		}
}

extension Target {
	static func sdlTestExecutable(name: String, sources: [String]? = nil, additionalDependencies: [Dependency] = [], additionalSources: [String] = [], additionalCSettings: [CSetting] = [], additionalLinkerSettings: [LinkerSetting] = []) -> Target {
		.executableTarget(
			name: name,
			dependencies: [
				"SimpleDirectMediaLayer",
				"SimpleDirectMediaLayerTest",
			] + additionalDependencies,
			path: "test",
			sources: (sources ?? [name + ".c"]) + additionalSources,
			cSettings: [
				.unsafeFlags(["-include", "\(Context.packageDirectory)/swift/Sources/SimpleDirectMediaLayer/include/SDL3/SDL_revision.h"]),
				.define("HAVE_BUILD_CONFIG"),
				.define("HAVE_OPENGL"),
				.headerSearchPath("../src/video/khronos"),
			] + additionalCSettings,
			linkerSettings: additionalLinkerSettings,
		)
	}

	static func sdlExampleExecutable(name: String, sources: [String], additionalDependencies: [Dependency] = []) -> Target {
		.executableTarget(
			name: name,
			dependencies: [
				"SimpleDirectMediaLayer"
			] + additionalDependencies,
			path: "examples",
			sources: sources,
		)
	}
}

// Matches CMake's BUILD_DEPENDENT for tests
let buildDependentSettings: [CSetting] = [
	.headerSearchPath("../src"),
	.headerSearchPath("../include/build_config"),
]

let package = Package(
	name: "SimpleDirectMediaLayer",
	platforms: [
		.macOS(.v13)
	],
	products: [
		.library(name: "SimpleDirectMediaLayer", targets: ["SimpleDirectMediaLayer"]),
		.library(name: "SimpleDirectMediaLayerStatic", type: .static, targets: ["SimpleDirectMediaLayer"]),
		.library(name: "SimpleDirectMediaLayerDynamic", type: .dynamic, targets: ["SimpleDirectMediaLayer"]),
		.library(name: "SimpleDirectMediaLayerTest", type: .static, targets: ["SimpleDirectMediaLayerTest"]),	// SDL3_test
	],
	traits: [
		.trait(
			name: "SteamStorage",
			description: "Enable the Steam user storage backend (CMake's SDL_STORAGE_STEAM)."
		),
	],
	dependencies: [
		.package(url: "https://github.com/swiftlang/swift-subprocess", from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-system", from: "1.8.1"),
	],
	targets: [


		// MARK: - Public Libraries

		.target(
			name: "SimpleDirectMediaLayer",
			dependencies: [
//				.byNameItem(name: "apple", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])),
				.byNameItem(name: "macOS", condition: .when(platforms: [.macOS])),
				.byNameItem(name: "posix", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS, .linux, .android])),
			],
			path: ".",
			exclude:
				contentsOfDirectory(path: ".", files: true, directories: true, exclude: ["src"])
				+ contentsOfDirectory(path: "src/atomic", directories: true)
				+ contentsOfDirectory(path: "src/audio", directories: true, exclude: ["disk", "dummy"])
				+ contentsOfDirectory(path: "src/camera", directories: true, exclude: ["dummy"])
				+ contentsOfDirectory(path: "src/core", directories: true)
				+ contentsOfDirectory(path: "src/cpuinfo", directories: true)
				+ contentsOfDirectory(path: "src/dialog", directories: true)
				+ contentsOfDirectory(path: "src/dynapi", files: true, withExtensions: ["exports", "sym", "py"], directories: true)
				+ contentsOfDirectory(path: "src/events", directories: true)
				+ contentsOfDirectory(path: "src/filesystem", directories: true)
				+ contentsOfDirectory(path: "src/gpu", directories: true, exclude: ["vulkan", "xr"])
				+ contentsOfDirectory(path: "src/haptic", directories: true, exclude: ["hidapi"])
				+ contentsOfDirectory(path: "src/hidapi", files: true, withExtensions: ["txt", "md", "am", "ac", "build", ""], directories: true)
				+ contentsOfDirectory(path: "src/io", directories: true, exclude: ["generic"])
				+ contentsOfDirectory(path: "src/joystick", files: true, withExtensions: ["sh", "py"], directories: true, exclude: ["hidapi", "virtual"])
				+ contentsOfDirectory(path: "src/libm", directories: true)
				+ contentsOfDirectory(path: "src/loadso", directories: true)
				+ contentsOfDirectory(path: "src/locale", directories: true)
				+ contentsOfDirectory(path: "src/main", directories: true, exclude: ["generic"])
				+ contentsOfDirectory(path: "src/misc", directories: true)
				+ contentsOfDirectory(path: "src/notification", directories: true)
				+ contentsOfDirectory(path: "src/power", directories: true)
				+ contentsOfDirectory(path: "src/process", directories: true)
				+ contentsOfDirectory(path: "src/render/direct3d", files: true, withExtensions: ["bat", "hlsl", "hlsli"], directories: true)
				+ contentsOfDirectory(path: "src/render/direct3d11", files: true, withExtensions: ["bat", "hlsl", "hlsli"], directories: true)
				+ contentsOfDirectory(path: "src/render/direct3d12", files: true, withExtensions: ["bat", "hlsl", "hlsli", "cpp"], directories: true)
				+ contentsOfDirectory(path: "src/render/gpu", directories: true)
				+ contentsOfDirectory(path: "src/render/metal", files: true, withExtensions: ["sh", "metal", "m"], directories: true)
				+ contentsOfDirectory(path: "src/render/ngage", files: true, withExtensions: ["cpp", "hpp"], directories: true)
				+ contentsOfDirectory(path: "src/render/opengl", directories: true)
				+ contentsOfDirectory(path: "src/render/opengles", directories: true)
				+ contentsOfDirectory(path: "src/render/opengles2", directories: true)
				+ contentsOfDirectory(path: "src/render/ps2", directories: true)
				+ contentsOfDirectory(path: "src/render/psp", directories: true)
				+ contentsOfDirectory(path: "src/render/software", directories: true)
				+ contentsOfDirectory(path: "src/render/vitagxm", directories: true)
				+ contentsOfDirectory(path: "src/render/vulkan", files: true, withExtensions: ["bat", "hlsl", "hlsli"], directories: true)
				+ contentsOfDirectory(path: "src/sensor", directories: true, exclude: ["dummy"])
				+ contentsOfDirectory(path: "src/stdlib", files: true, withExtensions: ["masm"], directories: true)
				+ contentsOfDirectory(path: "src/storage", directories: true, exclude: ["generic", "steam"])
				+ contentsOfDirectory(path: "src/thread", directories: true)
				+ contentsOfDirectory(path: "src/time", directories: true)
				+ contentsOfDirectory(path: "src/timer", directories: true)
				+ contentsOfDirectory(path: "src/tray", directories: true)
				+ contentsOfDirectory(path: "src/video", files: true, withExtensions: ["pl"], directories: true, exclude: ["dummy", "offscreen", "yuv2rgb"])
				+ contentsOfDirectory(path: "src/video/yuv2rgb", files: true, withExtensions: ["md", ""])
				+ [
					"src/test",
				],
			sources: [
				"src"
			],
			publicHeadersPath: "include",
			cSettings: [
				.headerSearchPath("swift/Sources/SimpleDirectMediaLayer/include"),
				.headerSearchPath("include/build_config"),
				.headerSearchPath("src"),
				.unsafeFlags(["-fno-modules"]),
				.unsafeFlags(["-include", "\(Context.packageDirectory)/swift/Sources/SimpleDirectMediaLayer/include/SDL3/SDL_revision.h"]),
				.unsafeFlags(["-idirafter", "\(Context.packageDirectory)/src/video/khronos"]),
				.define("SDL_STORAGE_STEAM", .when(traits: ["SteamStorage"])),
			],
			plugins: [
				"BuildSDLRevisionHeaderPlugin",
			]
		),

		.target(
			name: "SimpleDirectMediaLayerTest",
			dependencies: [
				"SimpleDirectMediaLayer"
			],
			path: ".",
			exclude:
				contentsOfDirectory(path: ".", files: true, directories: true, exclude: ["src"])
				+ contentsOfDirectory(path: "src", files: true, directories: true, exclude:["test"]),
			sources: [
				"src/test"
			],
			publicHeadersPath: "swift/Sources/SimpleDirectMediaLayerTest/include",
		),


		// MARK: - Private Platform Libraries
/*
		.target(
			name: "apple",
			path: ".",
			exclude: excludeList,
			sources: [
			],
			publicHeadersPath: "swift/Sources/apple/include",
			cSettings: [
				.headerSearchPath("include"),
				.headerSearchPath("include/build_config"),
				.headerSearchPath("src"),
				.headerSearchPath("src/video/khronos"),
				.unsafeFlags(["-fno-modules"])
			],
		),
*/
		.target(
			name: "macOS",
			path: ".",
			exclude:
				contentsOfDirectory(path: ".", files: true, directories: true, exclude: ["src"])
				+ contentsOfDirectory(path: "src", files: true, directories: true, exclude: [
					"audio", "camera", "dialog", "filesystem", "gpu", "haptic", "joystick", "locale", "misc", "notification", "power", "render", "tray", "video"
				])
				+ contentsOfDirectory(path: "src/audio", files: true, directories: true, exclude: ["coreaudio"])
				+ contentsOfDirectory(path: "src/camera", files: true, directories: true, exclude: ["coremedia"])
				+ contentsOfDirectory(path: "src/dialog", files: true, directories: true, exclude: ["cocoa"])
				+ contentsOfDirectory(path: "src/filesystem", files: true, directories: true, exclude: ["cocoa"])
				+ contentsOfDirectory(path: "src/gpu", files: true, directories: true, exclude: ["metal"])
				+ contentsOfDirectory(path: "src/gpu/metal", files: true, withExtensions: ["sh", "metal"])
				+ contentsOfDirectory(path: "src/haptic", files: true, directories: true, exclude: ["darwin"])
				+ contentsOfDirectory(path: "src/joystick", files: true, directories: true, exclude: ["apple", "darwin"])
				+ contentsOfDirectory(path: "src/locale", files: true, directories: true, exclude: ["macos"])
				+ contentsOfDirectory(path: "src/misc", files: true, directories: true, exclude: ["macos"])
				+ contentsOfDirectory(path: "src/notification", files: true, directories: true, exclude: ["cocoa"])
				+ contentsOfDirectory(path: "src/power", files: true, directories: true, exclude: ["macos"])
				+ contentsOfDirectory(path: "src/render", files: true, directories: true, exclude: ["metal"])
				+ contentsOfDirectory(path: "src/render/metal", files: true, withExtensions: ["sh", "metal"])
				+ contentsOfDirectory(path: "src/tray", files: true, directories: true, exclude: ["cocoa"])
				+ contentsOfDirectory(path: "src/video", files: true, directories: true, exclude: ["cocoa"]),
			sources: [
				"src/audio",
				"src/camera",
				"src/dialog",
				"src/filesystem",
				"src/gpu",
				"src/haptic",
				"src/joystick",
				"src/locale",
				"src/misc",
				"src/notification",
				"src/power",
				"src/render",
				"src/tray",
				"src/video",
			],
			publicHeadersPath: "swift/Sources/macOS/include",
			cSettings: [
				.headerSearchPath("include"),
				.headerSearchPath("include/build_config"),
				.headerSearchPath("src"),
				.headerSearchPath("src/video/khronos"),
				.unsafeFlags(["-fno-modules"])
			],
			linkerSettings: [
				.linkedFramework("AVFoundation"),
				.linkedFramework("AppKit"),
				.linkedFramework("AudioToolbox"),
				.linkedFramework("Carbon"),
				.linkedFramework("CoreAudio"),
				.linkedFramework("CoreFoundation"),
				.linkedFramework("CoreGraphics"),
				.linkedFramework("CoreHaptics"),
				.linkedFramework("CoreMedia"),
				.linkedFramework("CoreVideo"),
				.linkedFramework("ForceFeedback"),
				.linkedFramework("GameController"),
				.linkedFramework("IOKit"),
				.linkedFramework("Metal"),
				.linkedFramework("QuartzCore"),
				.linkedFramework("Security"),
				.linkedFramework("UniformTypeIdentifiers"),
				.linkedFramework("UserNotifications"),
			],
		),

		.target(
			name: "posix",
			path: ".",
			exclude:
				contentsOfDirectory(path: ".", files: true, directories: true, exclude: ["src"])
				+ contentsOfDirectory(path: "src", files: true, directories: true, exclude: ["filesystem", "loadso", "process", "thread", "time", "timer"])
				+ contentsOfDirectory(path: "src/filesystem", files: true, directories: true, exclude: ["posix"])
				+ contentsOfDirectory(path: "src/loadso", files: true, directories: true, exclude: ["dlopen"])
				+ contentsOfDirectory(path: "src/process", files: true, directories: true, exclude: ["posix"])
				+ contentsOfDirectory(path: "src/thread", files: true, directories: true, exclude: ["pthread"])
				+ contentsOfDirectory(path: "src/time", files: true, directories: true, exclude: ["unix"])
				+ contentsOfDirectory(path: "src/timer", files: true, directories: true, exclude: ["unix"]),
			sources: [
				"src/filesystem",
				"src/loadso",
				"src/process",
				"src/thread",
				"src/time",
				"src/timer",
			],
			publicHeadersPath: "swift/Sources/posix/include",
			cSettings: [
				.headerSearchPath("include"),
				.headerSearchPath("include/build_config"),
				.headerSearchPath("src"),
				.unsafeFlags(["-fno-modules"])
			],
		),


		// MARK: - Helper Libraries

		.target(
			name: "BundleHelpers",
			path: "swift/Sources/BundleHelpers",
		),

		.target(
			name: "testutils",
			dependencies: [
				"TestResources"
			],
			path: ".",
			exclude:
				contentsOfDirectory(path: ".", files: true, directories: true, exclude: ["test"])
				+ contentsOfDirectory(path: "test", files: true, directories: true, exclude: ["testutils.c"]),
			sources: [
				"test/testutils.c",
			],
			publicHeadersPath: "swift/Sources/testutils/include",
			cSettings: [
				.headerSearchPath("include"),
			],
		),


		// MARK: - SDL Tests Executables

		.sdlTestExecutable(name: "childprocess"),
		.sdlTestExecutable(name: "pretest"),
		.sdlTestExecutable(name: "testatomic"),
		.sdlTestExecutable(name: "testautomation", additionalSources: [
			"testautomation_audio.c",
			"testautomation_blit.c",
			"testautomation_clipboard.c",
			"testautomation_events.c",
			"testautomation_guid.c",
			"testautomation_hints.c",
			"testautomation_images.c",
			"testautomation_intrinsics.c",
			"testautomation_iostream.c",
			"testautomation_joystick.c",
			"testautomation_keyboard.c",
			"testautomation_log.c",
			"testautomation_main.c",
			"testautomation_math.c",
			"testautomation_mouse.c",
			"testautomation_pixels.c",
			"testautomation_platform.c",
			"testautomation_properties.c",
			"testautomation_rect.c",
			"testautomation_render.c",
			"testautomation_sdltest.c",
			"testautomation_stdlib.c",
			"testautomation_subsystems.c",
			"testautomation_surface.c",
			"testautomation_time.c",
			"testautomation_timer.c",
			"testautomation_video.c",
		], additionalCSettings: buildDependentSettings),
		.sdlTestExecutable(name: "testbounds"),
		.sdlTestExecutable(name: "testerror"),
		.sdlTestExecutable(name: "testevdev", additionalCSettings: buildDependentSettings),
		.sdlTestExecutable(name: "testfile"),
		.sdlTestExecutable(name: "testfilesystem"),
		.sdlTestExecutable(name: "testlocale"),
		.sdlTestExecutable(name: "testplatform"),
		.sdlTestExecutable(name: "testpower"),
		.sdlTestExecutable(name: "testprocess"),
		.sdlTestExecutable(name: "testqsort"),
		.sdlTestExecutable(name: "testrwlock"),
		.sdlTestExecutable(name: "testsem"),
		.sdlTestExecutable(name: "testsymbols"),
		.sdlTestExecutable(name: "testthread"),
		.sdlTestExecutable(name: "testtimer"),
		.sdlTestExecutable(name: "testver"),
		.sdlTestExecutable(name: "testyuv", additionalDependencies: ["testutils"], additionalSources: ["testyuv_cvt.c"]),
		.sdlTestExecutable(name: "torturethread"),


		// MARK: - Other SDL Test Executables

		// Provides the files used by the test executables
		.target(
			name: "TestResources",
			dependencies: [
				"BundleHelpers",
			],
			path: ".",
			exclude:
				contentsOfDirectory(path: ".", files: true, directories: true, exclude: ["swift", "test"])
				+ contentsOfDirectory(path: "swift", files: true, directories: true, exclude: ["Sources"])
				+ contentsOfDirectory(path: "swift/Sources", files: true, directories: true, exclude: ["TestResources"])
				+ contentsOfDirectory(path: "test", files: true, withExtensions: ["c", "cpp", "dat", "h", "hlsl", "in", "m", "markdown", "sh", "txt", "xbm", ""], directories: true, exclude: ["moose.dat", "utf8.txt"]),
			sources: [
				"swift/Sources/TestResources",
			],
			resources: (contentsOfDirectory(path: "test", files: true, withExtensions: ["png", "wav", "csv", "hex"]) + ["test/moose.dat", "test/utf8.txt"]).map { .copy($0) }
		),

		.sdlTestExecutable(name: "checkkeys"),
		.sdlTestExecutable(name: "loopwave", additionalDependencies: ["testutils"]),
		.sdlTestExecutable(name: "testasyncio", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testaudio", additionalDependencies: ["testutils"]),
		.sdlTestExecutable(name: "testaudiohotplug", additionalDependencies: ["testutils"]),
		.sdlTestExecutable(name: "testaudioinfo"),
		.sdlTestExecutable(name: "testaudiorecording"),
		.sdlTestExecutable(name: "testaudiostreamdynamicresample", additionalDependencies: ["testutils"]),
		.sdlTestExecutable(name: "testcamera"),
		.sdlTestExecutable(name: "testclipboard"),
		.sdlTestExecutable(name: "testcolorspace"),
		.sdlTestExecutable(name: "testcontroller", additionalDependencies: ["testutils"], additionalSources: ["gamepadutils.c"]),
		.sdlTestExecutable(name: "testcustomcursor"),
		.sdlTestExecutable(name: "testdescriptor", additionalCSettings: buildDependentSettings),
		.sdlTestExecutable(name: "testdialog"),
		.sdlTestExecutable(name: "testdisplayinfo"),
		.sdlTestExecutable(name: "testdlopennote", additionalDependencies: ["testutils"]),
		.sdlTestExecutable(name: "testdraw"),
		.sdlTestExecutable(name: "testdrawchessboard"),
		.sdlTestExecutable(name: "testdropfile"),
//		.sdlTestExecutable(name: "testffmpeg", additionalSources: ["testffmpeg_vulkan.c"]),	// Requires FFmpeg > 5.1.3, can we #define around it?
		.sdlTestExecutable(name: "testgeometry", additionalDependencies: ["testutils"]),
		.sdlTestExecutable(name: "testgl", additionalLinkerSettings: [.linkedFramework("OpenGL")]),
		.sdlTestExecutable(name: "testgles"),
		.sdlTestExecutable(name: "testgles2"),
		.sdlTestExecutable(name: "testgpu_simple_clear"),
		.sdlTestExecutable(name: "testgpu_spinning_cube"),
		.sdlTestExecutable(name: "testgpu_spinning_cube_xr"),
		.sdlTestExecutable(name: "testgpurender_effects", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testgpurender_msdf", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testhaptic"),
		.sdlTestExecutable(name: "testhittesting"),
		.sdlTestExecutable(name: "testhotplug"),
		.sdlTestExecutable(name: "testiconv", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testime", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testintersections"),
		.sdlTestExecutable(name: "testkeys"),
		.sdlTestExecutable(name: "testloadso"),
		.sdlTestExecutable(name: "testlock"),
		.sdlTestExecutable(name: "testmanymouse"),
		.sdlTestExecutable(name: "testmessage"),
		.sdlTestExecutable(name: "testmodal"),
		.sdlTestExecutable(name: "testmouse"),
		.sdlTestExecutable(name: "testmultiaudio", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(
			name: "testnative",
			additionalDependencies: ["testutils", "TestResources"],
			additionalSources: ["testnativecocoa.m", "testnativex11.c"],
			additionalCSettings: buildDependentSettings + [.unsafeFlags(["-fno-objc-arc"])],
		),
		.sdlTestExecutable(name: "testnotification", additionalDependencies: ["TestResources"]),
		.sdlTestExecutable(name: "testoffscreen"),
		.sdlTestExecutable(name: "testoverlay", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testpalette"),
		.sdlTestExecutable(name: "testpen"),
		.sdlTestExecutable(name: "testpopup"),		// Has a main thread issue!!!!
		.sdlTestExecutable(name: "testrelative"),
		.sdlTestExecutable(name: "testrendercopyex", additionalDependencies: ["testutils", "TestResources"], additionalCSettings: [.unsafeFlags(["-fno-modules"])]),
		.sdlTestExecutable(name: "testrendertarget", additionalDependencies: ["testutils", "TestResources"], additionalCSettings: [.unsafeFlags(["-fno-modules"])]),
		.sdlTestExecutable(name: "testresample", additionalDependencies: ["TestResources"]),
		.sdlTestExecutable(name: "testrotate"),
		.sdlTestExecutable(name: "testrumble"),
		.sdlTestExecutable(name: "testscale", additionalDependencies: ["testutils", "TestResources"], additionalCSettings: [.unsafeFlags(["-fno-modules"])]),
		.sdlTestExecutable(name: "testsensor"),
		.sdlTestExecutable(name: "testshader", additionalDependencies: ["testutils", "TestResources"], additionalLinkerSettings: [.linkedFramework("OpenGL")]),
		.sdlTestExecutable(name: "testshape", additionalDependencies: ["TestResources"]),
		.sdlTestExecutable(name: "testsoftwaretransparent"),
		.sdlTestExecutable(name: "testsprite", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testspritecxx", sources: ["testsprite.cpp"], additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testspriteminimal"),
		.sdlTestExecutable(name: "testspritesurface"),
		.sdlTestExecutable(name: "testsurround"),
		.sdlTestExecutable(name: "testtime"),
		.sdlTestExecutable(name: "testtray", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testurl"),
		.sdlTestExecutable(name: "testviewport", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testvulkan"),
//		.sdlTestExecutable(name: "testwaylandcustom"),	// Wayland only, generated source, needs pkg-config wayland-client, I think needed for Linux, can we #define around it?
		.sdlTestExecutable(name: "testwm"),


		// MARK: - SimpleDirectMediaLayerTests

		.testTarget(
			name: "SimpleDirectMediaLayerTests",
			dependencies: [
				"SimpleDirectMediaLayer",
				.product(name: "Subprocess", package: "swift-subprocess"),
				.product(name: "SystemPackage", package: "swift-system"),
			],
			path: "swift/Tests/SimpleDirectMediaLayerTests",
		),


		// MARK: - SDL Example Executables

		// Provides the files used by the example executables
		.target(
			name: "ExampleResources",
			dependencies: [
				"BundleHelpers",
			],
			path: ".",
			exclude:
				contentsOfDirectory(path: ".", files: true, directories: true, exclude: ["swift", "test"])
				+ contentsOfDirectory(path: "swift", files: true, directories: true, exclude: ["Sources"])
				+ contentsOfDirectory(path: "swift/Sources", files: true, directories: true, exclude: ["ExampleResources"])
				+ contentsOfDirectory(path: "test", files: true, directories: true, exclude: ["sample.png", "speaker.png", "icon2x.png", "sample.wav","sword.wav"]),
			sources: [
				"swift/Sources/ExampleResources",
			],
			resources: [
				.copy("test/sample.png"),
				.copy("test/gamepad_front.png"),
				.copy("test/speaker.png"),
				.copy("test/icon2x.png"),
				.copy("test/sample.wav"),
				.copy("test/sword.wav"),
			]
		),

		.sdlExampleExecutable(name: "asyncio-load-bitmaps", sources: ["asyncio/01-load-bitmaps/load-bitmaps.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "audio-load-wav", sources: ["audio/03-load-wav/load-wav.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "audio-multiple-streams", sources: ["audio/04-multiple-streams/multiple-streams.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "audio-planar-data", sources: ["audio/05-planar-data/planar-data.c"]),
		.sdlExampleExecutable(name: "audio-simple-playback", sources: ["audio/01-simple-playback/simple-playback.c"]),
		.sdlExampleExecutable(name: "audio-simple-playback-callback", sources: ["audio/02-simple-playback-callback/simple-playback-callback.c"]),
		.sdlExampleExecutable(name: "camera-read-and-draw", sources: ["camera/01-read-and-draw/read-and-draw.c"]),
		.sdlExampleExecutable(name: "demo-snake", sources: ["demo/01-snake/snake.c"]),
		.sdlExampleExecutable(name: "demo-woodeneye-008", sources: ["demo/02-woodeneye-008/woodeneye-008.c"]),
		.sdlExampleExecutable(name: "demo-infinite-monkeys", sources: ["demo/03-infinite-monkeys/infinite-monkeys.c"]),
		.sdlExampleExecutable(name: "demo-bytepusher", sources: ["demo/04-bytepusher/bytepusher.c"]),
		.sdlExampleExecutable(name: "input-gamepad-events", sources: ["input/04-gamepad-events/gamepad-events.c"]),
		.sdlExampleExecutable(name: "input-gamepad-polling", sources: ["input/03-gamepad-polling/gamepad-polling.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "input-gamepad-rumble", sources: ["input/05-gamepad-rumble/gamepad-rumble.c"]),
		.sdlExampleExecutable(name: "input-joystick-events", sources: ["input/02-joystick-events/joystick-events.c"]),
		.sdlExampleExecutable(name: "input-joystick-polling", sources: ["input/01-joystick-polling/joystick-polling.c"]),
		.sdlExampleExecutable(name: "misc-clipboard", sources: ["misc/02-clipboard/clipboard.c"]),
		.sdlExampleExecutable(name: "misc-locale", sources: ["misc/03-locale/locale.c"]),
		.sdlExampleExecutable(name: "misc-power", sources: ["misc/01-power/power.c"]),
		.sdlExampleExecutable(name: "pen-drawing-lines", sources: ["pen/01-drawing-lines/drawing-lines.c"]),
		.sdlExampleExecutable(name: "renderer-affine-textures", sources: ["renderer/19-affine-textures/affine-textures.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "renderer-blending", sources: ["renderer/20-blending/blending.c"]),
		.sdlExampleExecutable(name: "renderer-clear", sources: ["renderer/01-clear/clear.c"]),
		.sdlExampleExecutable(name: "renderer-cliprect", sources: ["renderer/15-cliprect/cliprect.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "renderer-color-mods", sources: ["renderer/11-color-mods/color-mods.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "renderer-debug-text", sources: ["renderer/18-debug-text/debug-text.c"]),
		.sdlExampleExecutable(name: "renderer-geometry", sources: ["renderer/10-geometry/geometry.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "renderer-lines", sources: ["renderer/03-lines/lines.c"]),
		.sdlExampleExecutable(name: "renderer-points", sources: ["renderer/04-points/points.c"]),
		.sdlExampleExecutable(name: "renderer-primitives", sources: ["renderer/02-primitives/primitives.c"]),
		.sdlExampleExecutable(name: "renderer-read-pixels", sources: ["renderer/17-read-pixels/read-pixels.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "renderer-rectangles", sources: ["renderer/05-rectangles/rectangles.c"]),
		.sdlExampleExecutable(name: "renderer-rotating-textures", sources: ["renderer/08-rotating-textures/rotating-textures.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "renderer-scaling-textures", sources: ["renderer/09-scaling-textures/scaling-textures.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "renderer-streaming-textures", sources: ["renderer/07-streaming-textures/streaming-textures.c"]),
		.sdlExampleExecutable(name: "renderer-textures", sources: ["renderer/06-textures/textures.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "renderer-viewport", sources: ["renderer/14-viewport/viewport.c"], additionalDependencies: ["ExampleResources"]),
		.sdlExampleExecutable(name: "storage-user", sources: ["storage/01-user/user.c"]),


		// MARK: - Build Plugins

		.plugin(
			name: "BuildSDLRevisionHeaderPlugin",
			capability: .buildTool(),
			path: "swift/Sources/BuildSDLRevisionHeaderPlugin"
		),

	]
)

