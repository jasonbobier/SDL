// swift-tools-version: 6.3;(experimentalCGen)
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

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

let buildDependentSettings: [CSetting] = [
	.headerSearchPath("../src"),
	.headerSearchPath("../include/build_config"),
]
let excludeList = [
	"android-project",
	"build-scripts",
	"cmake",
	"docs",
	"examples",
	"src/gpu/metal/Metal_Blit.metal",
	"src/hidapi/testgui",
	"src/render/metal/SDL_shaders_metal.metal",
	"swift",
	"test",
	"VisualC",
	"VisualC-GDK",
	"wayland-protocols",
	"Xcode"
]

let package = Package(
	name: "SimpleDirectMediaLayer",
	platforms: [
		.macOS(.v13)
	],
	products: [
		.library(name: "SimpleDirectMediaLayer", targets: ["SimpleDirectMediaLayer"]),
		.library(name: "SimpleDirectMediaLayerTest", targets: ["SimpleDirectMediaLayerTest"]),
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
				.byNameItem(name: "apple", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])),
				.byNameItem(name: "macOS", condition: .when(platforms: [.macOS])),
				.byNameItem(name: "posix", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS, .linux, .android])),
			],
			path: ".",
			exclude: excludeList,
			sources: [
				"src/SDL.c",
				"src/SDL_assert.c",
				"src/SDL_error.c",
				"src/SDL_guid.c",
				"src/SDL_hashtable.c",
				"src/SDL_hints.c",
				"src/SDL_log.c",
				"src/SDL_properties.c",
				"src/SDL_utils.c",
				"src/atomic",
				"src/audio/SDL_audio.c",
				"src/audio/SDL_audiocvt.c",
				"src/audio/SDL_audioqueue.c",
				"src/audio/SDL_audioresample.c",
				"src/audio/SDL_audiotypecvt.c",
				"src/audio/SDL_mixer.c",
				"src/audio/disk",
				"src/audio/dummy",
				"src/audio/SDL_wave.c",
				"src/camera/SDL_camera.c",
				"src/camera/dummy",
				"src/core/SDL_core_unsupported.c",
				"src/cpuinfo",
				"src/dialog/SDL_dialog.c",
				"src/dialog/SDL_dialog_utils.c",
				"src/dynapi/SDL_dynapi.c",
				"src/events/SDL_categories.c",
				"src/events/SDL_clipboardevents.c",
				"src/events/SDL_displayevents.c",
				"src/events/SDL_dropevents.c",
				"src/events/SDL_events.c",
				"src/events/SDL_eventwatch.c",
				"src/events/SDL_keyboard.c",
				"src/events/SDL_keymap.c",
				"src/events/SDL_mouse.c",
				"src/events/SDL_notificationevents.c",
				"src/events/SDL_pen.c",
				"src/events/SDL_quit.c",
				"src/events/SDL_touch.c",
				"src/events/SDL_windowevents.c",
				"src/filesystem/SDL_filesystem.c",
				"src/gpu/SDL_gpu.c",
				"src/gpu/vulkan/SDL_gpu_vulkan.c",
				"src/gpu/xr/SDL_openxrdyn.c",
				"src/haptic/SDL_haptic.c",
				"src/haptic/hidapi",
				"src/hidapi/SDL_hidapi.c",
				"src/io/SDL_asyncio.c",
				"src/io/SDL_iostream.c",
				"src/io/generic",
				"src/joystick/SDL_gamepad.c",
				"src/joystick/SDL_joystick.c",
				"src/joystick/SDL_steam_virtual_gamepad.c",
				"src/joystick/controller_type.c",
				"src/joystick/hidapi",
				"src/joystick/virtual",
				"src/loadso/dlopen",
				"src/locale/SDL_locale.c",
				"src/main/SDL_main_callbacks.c",
				"src/main/SDL_runapp.c",
				"src/main/generic",
				"src/misc/SDL_url.c",
				"src/notification/SDL_notification.c",
				"src/power/SDL_power.c",
				"src/process/SDL_process.c",
				"src/render/SDL_render.c",
				"src/render/SDL_yuv_sw.c",
				"src/render/gpu/SDL_pipeline_gpu.c",
				"src/render/gpu/SDL_render_gpu.c",
				"src/render/gpu/SDL_shaders_gpu.c",
				"src/render/opengl",
				"src/render/opengles2",
				"src/render/software",
				"src/sensor/SDL_sensor.c",
				"src/sensor/dummy",
				"src/stdlib/SDL_crc16.c",
				"src/stdlib/SDL_crc32.c",
				"src/stdlib/SDL_getenv.c",
				"src/stdlib/SDL_iconv.c",
				"src/stdlib/SDL_malloc.c",
				"src/stdlib/SDL_memcpy.c",
				"src/stdlib/SDL_memmove.c",
				"src/stdlib/SDL_memset.c",
				"src/stdlib/SDL_murmur3.c",
				"src/stdlib/SDL_qsort.c",
				"src/stdlib/SDL_random.c",
				"src/stdlib/SDL_stdlib.c",
				"src/stdlib/SDL_string.c",
				"src/stdlib/SDL_strtokr.c",
				"src/storage/SDL_storage.c",
				"src/storage/generic",
				"src/thread/SDL_thread.c",
				"src/time/SDL_time.c",
				"src/timer/SDL_timer.c",
				"src/tray/SDL_tray_utils.c",
				"src/video/SDL_RLEaccel.c",
				"src/video/SDL_blit.c",
				"src/video/SDL_blit_0.c",
				"src/video/SDL_blit_1.c",
				"src/video/SDL_blit_A.c",
				"src/video/SDL_blit_N.c",
				"src/video/SDL_blit_auto.c",
				"src/video/SDL_blit_copy.c",
				"src/video/SDL_blit_slow.c",
				"src/video/SDL_bmp.c",
				"src/video/SDL_clipboard.c",
				"src/video/SDL_egl.c",
				"src/video/SDL_fillrect.c",
				"src/video/SDL_pixels.c",
				"src/video/SDL_rect.c",
				"src/video/SDL_rotate.c",
				"src/video/SDL_stb.c",
				"src/video/SDL_stretch.c",
				"src/video/SDL_surface.c",
				"src/video/SDL_video.c",
				"src/video/SDL_video_unsupported.c",
				"src/video/SDL_vulkan_utils.c",
				"src/video/SDL_yuv.c",
				"src/video/dummy",
				"src/video/offscreen",
				"src/video/yuv2rgb/yuv_rgb_lsx.c",
				"src/video/yuv2rgb/yuv_rgb_sse.c",
				"src/video/yuv2rgb/yuv_rgb_std.c",
			],
			publicHeadersPath: "include",
			cSettings: [
				.headerSearchPath("swift/Sources/SimpleDirectMediaLayer/include"),
				.headerSearchPath("include/build_config"),
				.headerSearchPath("src"),
				.headerSearchPath("src/video/khronos"),
				.unsafeFlags(["-fno-modules"]),
				.unsafeFlags(["-include", "\(Context.packageDirectory)/swift/Sources/SimpleDirectMediaLayer/include/SDL3/SDL_revision.h"]),
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
			exclude: excludeList,
			sources: [
				"src/test"
			],
			publicHeadersPath: "swift/Sources/SimpleDirectMediaLayerTest/include",
		),


		// MARK: - Private Platform Libraries

		.target(
			name: "apple",
			path: ".",
			exclude: excludeList,
			sources: [
				"src/audio/coreaudio",
				"src/camera/coremedia",
				"src/gpu/metal/SDL_gpu_metal.m",
				"src/joystick/apple",
				"src/render/metal/SDL_render_metal.m",
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

		.target(
			name: "macOS",
			path: ".",
			exclude: excludeList,
			sources: [
				"src/dialog/cocoa",
				"src/filesystem/cocoa",
				"src/haptic/darwin",
				"src/joystick/darwin",
				"src/locale/macos",
				"src/misc/macos",
				"src/notification/cocoa",
				"src/power/macos",
				"src/tray/cocoa",
				"src/video/cocoa",
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
			exclude: excludeList,
			sources: [
				"src/filesystem/posix",
				"src/process/posix",
				"src/thread/pthread",
				"src/time/unix",
				"src/timer/unix",
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
			path: ".",
			exclude: excludeList.filter { ($0 != "swift") },
			sources: [
				"swift/Sources/BundleHelpers",
			],
		),

		.target(
			name: "testutils",
			dependencies: [
				"TestResources"
			],
			path: ".",
			exclude: excludeList.filter { $0 != "test" },
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
			exclude: excludeList.filter { ($0 != "test") && ($0 != "swift") },
			sources: [
				"swift/Sources/TestResources",
			],
			resources: {
				let testDirectory = URL(filePath: Context.packageDirectory).appending(path: "test")
				let urls = (try? FileManager.default.contentsOfDirectory(at: testDirectory, includingPropertiesForKeys: nil)) ?? []

				return urls
					.filter { ["png", "wav", "csv", "hex"].contains($0.pathExtension) || ["moose.dat", "utf8.txt"].contains($0.lastPathComponent) }
					.map { $0.lastPathComponent }
					.sorted()
					.map { .copy("test/\($0)") }
			}()
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
		.sdlTestExecutable(name: "testrendercopyex", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testrendertarget", additionalDependencies: ["testutils", "TestResources"]),
		.sdlTestExecutable(name: "testresample", additionalDependencies: ["TestResources"]),
		.sdlTestExecutable(name: "testrotate"),
		.sdlTestExecutable(name: "testrumble"),
		.sdlTestExecutable(name: "testscale", additionalDependencies: ["testutils", "TestResources"]),
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
			exclude: excludeList.filter { ($0 != "test") && ($0 != "swift") },
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

