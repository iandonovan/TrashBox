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
#import "AudioController.h"
#import "Draw2D.h"

//@class AudioController;

@interface ViewController : UIViewController {
    
    UISlider *gainSlider;
    UISwitch *gainOnOff;
    UISegmentedControl *whichEffect;    
    AudioController *daController;
    UISwitch *smoothing1;
    UISwitch *smoothing2;
    Draw2D *graphView;
    
}

@property (nonatomic, strong) IBOutlet UISlider *gainSlider;
@property (nonatomic, strong) IBOutlet UISwitch *gainOnOff;
@property (nonatomic, strong) IBOutlet UISegmentedControl *whichEffect;
@property (nonatomic, strong) IBOutlet UISwitch *smoothing1;
@property (nonatomic, strong) IBOutlet UISwitch *smoothing2;

-(IBAction)sliderChanged:(id)sender;
-(IBAction)gainSwitchHit:(id)sender;
-(IBAction)whichEffectHit:(id)sender;
-(IBAction)smoothingSwitch1Hit:(id)sender;
-(IBAction)smoothingSwitch2Hit:(id)sender;

@end
