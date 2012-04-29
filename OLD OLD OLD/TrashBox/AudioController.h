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
@property bool onOrOff;
@property (nonatomic) int whichEffect;

-(id)init; //initialize
-(void)setGainValue:(float)val; //Set the gain value
-(void)setEffectOnOff:(bool)val; //set effects on or off
-(void)setWhichEffect:(int)whichEffect; //which effect to use for filter

//Make the ASBD in the AudioController
AudioStreamBasicDescription makeASBD(Float64 sampleRate);
//Set up the connection; deprecated now with the render callback
AudioUnitConnection makeConnection(AudioUnit remoteUnit, AudioUnitElement input, AudioUnitElement output);

//The effect struct for the callback function
typedef struct {
    AudioUnit rioUnit;
    float gainSliderValue;
    bool effectOnOff;
    int whichEffect;
} EffectState;

//The callback function to render audio
OSStatus MyAURenderCallback (
                             void * inRefCon,
                             AudioUnitRenderActionFlags * ioActionFlags,
                             const AudioTimeStamp *  inTimeStamp,
                             UInt32                  inBusNumber,
                             UInt32                  inNumberFrames,
                             AudioBufferList *       ioData
                             );


typedef OSStatus (*AURenderCallback) (
                                      void                        *inRefCon,
                                      AudioUnitRenderActionFlags  *ioActionFlags,
                                      const AudioTimeStamp        *inTimeStamp,
                                      UInt32                      inBusNumber,
                                      UInt32                      inNumberFrames,
                                      AudioBufferList             *ioData
                                      );


//-(id) setFilterChain;
//-(id) getLineInfo;

@end
