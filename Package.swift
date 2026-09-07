// swift-tools-version: 6.3;(experimentalCGen)
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target {
	static func sdlTestExecutable(name: String, dependencies: [Dependency] = [], sources: [String] = [], cSettings: [CSetting] = []) -> Target {
		.executableTarget(
			name: name,
			dependencies: [
				"SimpleDirectMediaLayer",
				"SimpleDirectMediaLayerTest",
			] + dependencies,
			path: "test",
			sources: [
				name + ".c"
			] + sources,
			cSettings: [
				.unsafeFlags(["-include", "\(Context.packageDirectory)/swift/Sources/SimpleDirectMediaLayer/include/SDL3/SDL_revision.h"]),
			] + cSettings,
		)
	}
}

let excludeList = [
	"android-project",
	"build-scripts",
	"cmake",
	"docs",
	"examples",
	"src/hidapi/testgui",
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
	],
	targets: [


		// MARK: - Public Libraries

		.target(
			name: "SimpleDirectMediaLayer",
			dependencies: [
				.byNameItem(name: "SDL_Internal_apple", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])),
				.byNameItem(name: "SDL_Internal_macOS", condition: .when(platforms: [.macOS])),
				.byNameItem(name: "SDL_Internal_posix", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS, .linux, .android])),
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
				.unsafeFlags(["-fno-modules", "-include", "\(Context.packageDirectory)/swift/Sources/SimpleDirectMediaLayer/include/SDL3/SDL_revision.h"]),
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
			name: "SDL_Internal_apple",
			path: ".",
			exclude: excludeList,
			sources: [
				"src/audio/coreaudio",
				"src/camera/coremedia",
				"src/gpu/metal/SDL_gpu_metal.m",
				"src/joystick/apple",
				"src/render/metal/SDL_render_metal.m",
			],
			publicHeadersPath: "swift/Sources/SDL_Internal_apple/include",
			cSettings: [
				.headerSearchPath("include"),
				.headerSearchPath("include/build_config"),
				.headerSearchPath("src"),
				.headerSearchPath("src/video/khronos"),
				.unsafeFlags(["-fno-modules"])
			],
		),

		.target(
			name: "SDL_Internal_macOS",
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
			publicHeadersPath: "swift/Sources/SDL_Internal_macOS/include",
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
			name: "SDL_Internal_posix",
			path: ".",
			exclude: excludeList,
			sources: [
				"src/filesystem/posix",
				"src/process/posix",
				"src/thread/pthread",
				"src/time/unix",
				"src/timer/unix",
			],
			publicHeadersPath: "swift/Sources/SDL_Internal_posix/include",
			cSettings: [
				.headerSearchPath("include"),
				.headerSearchPath("include/build_config"),
				.headerSearchPath("src"),
				.unsafeFlags(["-fno-modules"])
			],
		),


		// MARK: - SDL Test Executables

		.sdlTestExecutable(name: "checkkeys"),
		.sdlTestExecutable(name: "childprocess"),
		.sdlTestExecutable(name: "pretest"),
		.sdlTestExecutable(name: "testatomic"),
		.sdlTestExecutable(name: "testautomation", sources: [
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
		]),
		.sdlTestExecutable(name: "testbounds"),
		.sdlTestExecutable(name: "testerror"),
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
		.sdlTestExecutable(name: "torturethread"),


		// MARK: - SDL Test

		.testTarget(
			name: "SimpleDirectMediaLayerTests",
			dependencies: [
				"SimpleDirectMediaLayer",
				.product(name: "Subprocess", package: "swift-subprocess"),
			],
			path: "swift/Tests/SimpleDirectMediaLayerTests",
		),


		// MARK: - SDL Example Executables

		// examples/demo/01-snake
		.executableTarget(
			name: "examples_demo_01-snake",
			dependencies: [
				"SimpleDirectMediaLayer"
			],
			path: "examples/demo/01-snake",
		),

		// examples/demo/02-woodeneye-008
		.executableTarget(
			name: "examples_demo_02-woodeneye-008",
			dependencies: [
				"SimpleDirectMediaLayer"
			],
			path: "examples/demo/02-woodeneye-008",
		),

		// examples/demo/03-infinite-monkeys
		.executableTarget(
			name: "examples_demo_03-infinite-monkeys",
			dependencies: [
				"SimpleDirectMediaLayer"
			],
			path: "examples/demo/03-infinite-monkeys",
		),

		// examples/demo/04-bytepusher
		.executableTarget(
			name: "examples_demo_04-bytepusher",
			dependencies: [
				"SimpleDirectMediaLayer"
			],
			path: "examples/demo/04-bytepusher",
		),


		// MARK: - Build Plugins

		.plugin(
			name: "BuildSDLRevisionHeaderPlugin",
			capability: .buildTool(),
			path: "swift/Sources/BuildSDLRevisionHeaderPlugin"
		),
	]
)

