//
//  AudioController.h
//  TrashBox
//
//  Created by Ian Donovan, Dan Raisbeck, and Michael Siegel
//  Copyright (c) 2012 Possum Kingdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>

@interface AudioController : NSObject

@property bool isInit;
@property bool inputDeviceFound;

-(id)init;
//-(bool)setupAudioSession;

AudioStreamBasicDescription makeASBD(Float64 sampleRate);
AudioUnitConnection makeConnection(AudioUnit remoteUnit, AudioUnitElement input, AudioUnitElement output);

//-(id) setFilterChain;
//-(id) getLineInfo;

@end
