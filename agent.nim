# =======
# Imports
# =======

import os

# ================
# External Linkage
# ================

{.passC: "-x objective-c".}
{.passC: "-F/System/Library/Frameworks/".}
{.passC: "-I/usr/include/".}
{.passC: "-include /System/Library/Frameworks/MediaPlayer.framework/Headers/MediaPlayer.h".}
{.passC: "-mmacosx-version-min=10.12".}
{.passC: "-fblocks".}
{.passL: "-framework Cocoa".}
{.passL: "-framework MediaPlayer".}
{.passL: "-framework CoreFoundation".}

# ============================
# External Types and Functions
# ============================

type
  Id {.importc: "id", header: "<objc/NSObject.h>".} = distinct int
  MPRemoteCommandEvent {.importc: "MPRemoteCommandEvent", header: "<MediaPlayer/MPRemoteCommandEvent.h>".} = Id
  MPRemoteCommandHandlerStatus {.importc: "MPRemoteCommandHandlerStatus", header: "<MediaPlayer/MPRemoteCommandCenter.h>".} = cint

# =========
# Functions
# =========

proc playEvent(event: MPRemoteCommandEvent): MPRemoteCommandHandlerStatus {.exportc.} = 
  return cint(execShellCmd("cmus-remote --play"))

proc pauseEvent(event: MPRemoteCommandEvent): MPRemoteCommandHandlerStatus {.exportc.} =
  return cint(execShellCmd("cmus-remote --pause"))

proc stopEvent(event: MPRemoteCommandEvent): MPRemoteCommandHandlerStatus {.exportc.} =
  return cint(execShellCmd("cmus-remote --stop"))

# ===========
# Entry Point
# ===========


{.emit: """
#import <Cocoa/Cocoa.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreFoundation/CoreFoundation.h>

int main() {
  MPRemoteCommandCenter *centre = [MPRemoteCommandCenter sharedCommandCenter];
  [centre.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
    return playEvent(event);
  }];
  [centre.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
    return pauseEvent(event);
  }];
  [centre.stopCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
    return stopEvent(event);
  }];
  
  CFRunLoopRun();
}

""".}
