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

//@class AudioController;

@interface ViewController : UIViewController {

UISlider *gainSlider;
    AudioController *daController;

}

@property (nonatomic, strong) IBOutlet UISlider *gainSlider;

-(IBAction)sliderChanged:(id)sender;


@end
