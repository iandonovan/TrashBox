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

//Things in the interface so we can operate on them
@interface ViewController : UIViewController {
    
    UISlider *gainSlider;               //Slider for gain/"volume"
    UISwitch *effectOnOff;              //Switch to turn effects on/off
    UISegmentedControl *whichEffect;    //Segmented controller for choosing effect
    AudioController *daController;      //The audio controller that does the work
    UISwitch *smoothing1;               //Smooths the drawing in one way
    UISwitch *smoothing2;               //Smooths it out in another way
    Draw2D *graphView;                  //The actual graph view on the controller
    
}

//Set the above as properties
@property (nonatomic, strong) IBOutlet UISlider *gainSlider;
@property (nonatomic, strong) IBOutlet UISwitch *effectOnOff;
@property (nonatomic, strong) IBOutlet UISegmentedControl *whichEffect;
@property (nonatomic, strong) IBOutlet UISwitch *smoothing1;
@property (nonatomic, strong) IBOutlet UISwitch *smoothing2;

//Methods to act on the properties
-(IBAction)sliderChanged:(id)sender;
-(IBAction)effectOnOffSwitchHit:(id)sender;
-(IBAction)whichEffectHit:(id)sender;
-(IBAction)smoothingSwitch1Hit:(id)sender;
-(IBAction)smoothingSwitch2Hit:(id)sender;

@end
