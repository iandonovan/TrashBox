//
//  AudioController.h
//  TrashBox
//
//  Created by Dan Raisbeck on 4/18/12.
//  Copyright (c) 2012 Tufts University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>

@interface AudioController : NSObject

@property bool isInit;
@property bool inputDeviceFound;


-(bool) audioInit;
-(bool) setupAudioSession;
-(id) setFilterChain;
-(id) getLineInfo;

@end
