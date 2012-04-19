//
//  AudioController.m
//  TrashBox
//
//  Created by Dan Raisbeck on 4/18/12.
//  Copyright (c) 2012 Tufts University. All rights reserved.
//

#import "AudioController.h"

@implementation AudioController

-(bool) audioInit {
    if([self setupAudioSession] == false)
    {
        return false;
    }
    return true;
}

-(bool) setupAudioSession {
    
    AVAudioSession *mySession = [AVAudioSession sharedInstance];
    [mySession setDelegate: self];
    
    
    // tz change to play and record
	// Assign the Playback category to the audio session.
    NSError *audioSessionError = nil;
    [mySession setCategory: AVAudioSessionCategoryPlayAndRecord
                     error: &audioSessionError];
    
    if (audioSessionError != nil) {
        NSLog (@"Error setting audio session category.");
        return false;
        
    }   
    return true;
}

@end
