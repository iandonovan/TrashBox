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
@property (nonatomic, strong) IBOutlet UISlider *gainSlider;

-(IBAction)sliderChanged:(id)sender;

@end
