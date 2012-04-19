//
//  ViewController.h
//  TrashBox
//
//  Created by Ian Donovan, Dan Raisbeck, and Michael Siegel
//  Copyright (c) 2012 Possum Kingdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>

@interface ViewController : UIViewController

AudioStreamBasicDescription makeASBD(Float64 sampleRate);
AudioUnitConnection makeConnection(AudioUnit remoteUnit, AudioUnitElement input, AudioUnitElement output);

@end
