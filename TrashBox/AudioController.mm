//
//  AudioController.m
//  TrashBox
//
//  Created by Ian Donovan, Dan Raisbeck, and Michael Siegel
//  Copyright (c) 2012 Possum Kingdom. All rights reserved.
//

#import "AudioController.h"

@implementation AudioController
@synthesize isInit, inputDeviceFound;
@synthesize onOrOff, whichEffect;

//Declare our remote unit and effect right off
AudioUnit remoteIOUnit;
EffectState effectState; 

-(id)init
{
    if(self == [super init])
    {
        isInit = NO;
        
        //Set up the audio session
        OSStatus setupAudioSessionError =
        AudioSessionInitialize(
                               NULL,    //default run loop
                               NULL,    //default run loop mode
                               NULL,    //interrupt callback
                               NULL     //client callback data
                               );
        NSAssert(setupAudioSessionError == noErr, @"Couldn't initialize audio session");
        
        //Enable recording
        UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
        setupAudioSessionError = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
        NSAssert (setupAudioSessionError == noErr, @"Couldn't set audio session property");
        
        //Get the iPad's sample rate
        UInt32 f64PropertySize = sizeof(Float64);
        Float64 hardwareSampleRate = kAudioSessionProperty_CurrentHardwareSampleRate;
        
        setupAudioSessionError = AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate, &f64PropertySize, &hardwareSampleRate);
        NSAssert(setupAudioSessionError == noErr, @"Couldn't get the iPad's sample rate");
        NSLog(@"The iPad's sample rate is %f", hardwareSampleRate);
        
        //Describe the audio unit
        AudioComponentDescription compDesc;
        compDesc.componentType = kAudioUnitType_Output;
        compDesc.componentSubType = kAudioUnitSubType_RemoteIO;
        compDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
        compDesc.componentFlags = 0;
        compDesc.componentFlagsMask = 0;
        
        //Find the unit we're going to use
        AudioComponent remoteIOComponent = AudioComponentFindNext(NULL, &compDesc);
        OSErr setupError = AudioComponentInstanceNew(remoteIOComponent, &remoteIOUnit);
        NSAssert(setupError == noErr, @"Couldn't get Remote IO unit instance");
        
        //Enable output on the remote IO unit
        UInt32 oneFlag = 1;
        AudioUnitElement bus0 = 0;
        setupError = AudioUnitSetProperty(remoteIOUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, bus0, &oneFlag, sizeof(oneFlag));
        NSAssert(setupError == noErr, @"Could not enable remote IO output");
        
        //Enable input on the remote IO unit
        AudioUnitElement bus1 = 1;
        setupError = AudioUnitSetProperty(remoteIOUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, bus1, &oneFlag, sizeof(oneFlag));
        
        //Make the AudioStreamBasicDesription
        AudioStreamBasicDescription datASBD = makeASBD(hardwareSampleRate);
        
        //Check output scope streaming
        setupError = AudioUnitSetProperty(remoteIOUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, bus1, &datASBD, sizeof(datASBD));
        NSAssert(setupError == noErr, @"Could not set ASBD for remote IO output scope -- bus 1");
        
        //Check input scope streaming
        setupError = AudioUnitSetProperty(remoteIOUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, bus0, &datASBD, sizeof(datASBD));
        NSAssert(setupError == noErr, @"Could not set ASBD for remote IO input scope -- bus 0");
        
        //New Changes by Mike 4/24!!!!!!
        effectState.rioUnit = remoteIOUnit;    
        effectState.gainSliderValue = .5;  //initial value
        effectState.effectOnOff = YES;       //initial value
        effectState.whichEffect = 0;       //initially have "grit" on
        
        //Set up the callback struct
        AURenderCallbackStruct callbackStruct;
        callbackStruct.inputProc = MyAURenderCallback; //issues
        callbackStruct.inputProcRefCon = &effectState;
        
        setupError = 
        AudioUnitSetProperty(remoteIOUnit, 
                             kAudioUnitProperty_SetRenderCallback, 
                             kAudioUnitScope_Global, 
                             bus0, 
                             &callbackStruct, 
                             sizeof(callbackStruct));
        NSAssert(setupError == noErr,
                 @"Couldn't set RIO render callback on bus 0");
        

        //Disable connection for AU Callback. Otherwise, short circuits RemoteIO
        
//        //Make the audio unit connection property
//        AudioUnitConnection connex = makeConnection(remoteIOUnit, bus0, bus1);
//        setupError = AudioUnitSetProperty(remoteIOUnit, kAudioUnitProperty_MakeConnection, kAudioUnitScope_Input, bus0, &connex, sizeof(connex));
//        NSAssert(setupError == noErr, @"Could not establish audio unit connection property");
//        
        
        //GOGOGOGOGOGOGO
        setupError = AudioUnitInitialize(remoteIOUnit);
        NSAssert(setupError == noErr, @"Could not initialize the remote IO unit");
        
        OSStatus startErr = AudioOutputUnitStart(remoteIOUnit);
        NSAssert(startErr == noErr, @"Could not start the remote IO unit");
    }
    
    isInit = YES;
    inputDeviceFound = YES;
    onOrOff = YES;
    return self;
}

//A helper function to make the AudioStreamBasicDescription
//Compartmentalizing code
AudioStreamBasicDescription makeASBD (Float64 sampleRate)
{
    AudioStreamBasicDescription tempASBD;
    memset(&tempASBD, 0, sizeof(tempASBD));
    
    tempASBD.mSampleRate = sampleRate;
    tempASBD.mFormatID = kAudioFormatLinearPCM;
    tempASBD.mFormatFlags = kAudioFormatFlagsCanonical;
    tempASBD.mBytesPerPacket = 4;
    tempASBD.mFramesPerPacket = 1;
    tempASBD.mBytesPerFrame = tempASBD.mBytesPerPacket * tempASBD.mFramesPerPacket;
    tempASBD.mChannelsPerFrame = 2;
    tempASBD.mBitsPerChannel = 16;
    
    return tempASBD;
}

//A helper function to make the connection between audio units
//Compartmentalizing code
AudioUnitConnection makeConnection(AudioUnit remoteUnit, AudioUnitElement input, AudioUnitElement output)
{
    AudioUnitConnection connection;
    connection.sourceAudioUnit = remoteUnit;
    connection.sourceOutputNumber = output;
    connection.destInputNumber = input;
    
    return connection;
}

//New functions
//Callback, dayum
OSStatus MyAURenderCallback (
                             void * inRefCon,
                             AudioUnitRenderActionFlags * ioActionFlags,
                             const AudioTimeStamp *  inTimeStamp,
                             UInt32                  inBusNumber,
                             UInt32                  inNumberFrames,
                             AudioBufferList *       ioData
                             ) 
{
    //Grab the effect state and the remote IO unit
    EffectState* effectState = (EffectState*) inRefCon;
    AudioUnit rioUnit = effectState->rioUnit;
    
    OSStatus renderErr = noErr;     //call Render!!!!
    
    UInt32 bus1 = 1;
    renderErr = AudioUnitRender(rioUnit, ioActionFlags, inTimeStamp, bus1, inNumberFrames, ioData);
        
    float* fBuffer = new float[1024]; //BAD, HARD CODED
    
    for (int bufCount=0; bufCount<ioData->mNumberBuffers; bufCount++) //for all buffers
    {
        AudioBuffer buf = ioData->mBuffers[bufCount]; //copy buffer

        SInt16* bufData = (SInt16*)buf.mData;
        
        for (int i=0; i<buf.mDataByteSize/sizeof(SInt16); i++) //1024 sample buffer, unless changed through initialization
        { 
            //STILL INTERLEAVED SAMPLES AT THIS POINT
            //This is where the gain happens for each sample
            //We always have the gain, even if other effects are off -- act as a volume knob
            bufData[i] = bufData[i]*effectState->gainSliderValue; //adjusting indv sample value
            
            fBuffer[i] = bufData[i];
            
            //If we have effects on AND it chooses the "grit" effect
            if (effectState->effectOnOff && effectState->whichEffect==0)
            {
                //Simple nonlinear transformation -- sounds RAWK
                fBuffer[i] = atanf(.015*fBuffer[i]);
                bufData[i] = fBuffer[i]*9000;

            }
            
            /* So the other one would go like
             if (effectState->gainOnOff && effectState->whichEffect==1)
             {
                do things with the drawing
             }
            */
            
            //NSLog(@"%f",fBuffer[i]);
                        
            
           // NSLog(@"%f",effectState->gainSliderValue); THIS WILL STOP AUDIO OUTPUT
            
            //Messing with random (white noise)
                    //NSLog(@"%f", ((float)rand()/pow(2, 32)*2-1));
                    //bufData[i] = (SInt16)(random()*effectState->gainSliderValue);
        }
                
    }
      
}

//Obj.C method to change audioEffect->gainSliderValue
//Call this method from ViewController
-(void)setGainValue:(float)val {
    effectState.gainSliderValue = val;
}

//Set the effect's on/off state from the switch
-(void)setEffectOnOff:(bool)val
{
    self.OnOrOff = val;
    effectState.effectOnOff = val;
}
//Set which effect to apply from the segmented controller
-(void)setWhichEffect:(int)effectChoice
{
    effectState.whichEffect = effectChoice;
}



//DAN CODE STARTS HERE
//AudioSessions are used for interrupts, so we'll add them at the end
/*
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
 */

@end
