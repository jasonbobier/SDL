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

#ifndef SimpleDirectMediaLayer_build_config_h
#define SimpleDirectMediaLayer_build_config_h

#include_next "SDL_build_config.h"

// Audio subsystem
#undef SDL_AUDIO_DISABLED
#undef SDL_AUDIO_DRIVER_COREAUDIO
#undef SDL_AUDIO_DRIVER_DISK
#undef SDL_AUDIO_DRIVER_DUMMY

#ifndef SDL_SWIFTPM_AUDIO_ENABLED
#define SDL_AUDIO_DISABLED 1
#endif

#ifdef SDL_SWIFTPM_AUDIO_DRIVER_COREAUDIO_ENABLED
#define SDL_AUDIO_DRIVER_COREAUDIO 1
#endif

#ifdef SDL_SWIFTPM_AUDIO_DRIVER_DISK_ENABLED
#define SDL_AUDIO_DRIVER_DISK 1
#endif

#ifdef SDL_SWIFTPM_AUDIO_DRIVER_DUMMY_ENABLED
#define SDL_AUDIO_DRIVER_DUMMY 1
#endif


// Camera subsystem
#undef SDL_CAMERA_DISABLED
#undef SDL_CAMERA_DRIVER_COREMEDIA
#undef SDL_CAMERA_DRIVER_DUMMY

#ifndef SDL_SWIFTPM_CAMERA_ENABLED
#define SDL_CAMERA_DISABLED 1
#endif

#ifdef SDL_SWIFTPM_CAMERA_DRIVER_COREMEDIA_ENABLED
#define SDL_CAMERA_DRIVER_COREMEDIA 1
#endif

#ifdef SDL_SWIFTPM_CAMERA_DRIVER_DUMMY_ENABLED
#define SDL_CAMERA_DRIVER_DUMMY 1
#endif

// Dialog subsystem
#undef SDL_DIALOG_DISABLED
#undef SDL_DIALOG_DUMMY

#ifndef SDL_SWIFTPM_DIALOG_ENABLED
#define SDL_DIALOG_DISABLED 1
#endif

#endif /* SimpleDirectMediaLayer_build_config_h */
