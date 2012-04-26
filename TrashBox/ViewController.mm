//
//  ViewController.m
//  TrashBox
//
//  Created by Ian Donovan, Dan Raisbeck, and Michael Siegel
//  Copyright (c) 2012 Possum Kingdom. All rights reserved.
//

#import "ViewController.h"
#import "AudioController.h"

@implementation ViewController
@synthesize gainSlider, effectOnOff, smoothing1, smoothing2;
@synthesize whichEffect;

//Change the Audio Controller's gain value to be that of the slider
-(IBAction)sliderChanged:(id)sender
{
    [daController setGainValue:[gainSlider value]];
}

//Change the effect's on/off status to match that of the switch
-(IBAction)effectOnOffSwitchHit:(id)sender
{
    [daController setEffectOnOff:[sender isOn]];
}

//Choose which effect to use on the samples
-(IBAction)whichEffectHit:(id)sender
{
    //See which effect segment is chosen, then set it active
    int effectChoice = [sender selectedSegmentIndex];
    [daController setWhichEffect:effectChoice];
}

//Choose the first smoothing method
-(IBAction)smoothingSwitch1Hit:(id)sender
{
    [graphView toggleSmooth1:[sender isOn]];
}

//Choose the second smoothing method
-(IBAction)smoothingSwitch2Hit:(id)sender
{
    [graphView toggleSmooth2:[sender isOn]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


//Upon loading the view, we want to prepare the live audio capabilities.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    daController = [[AudioController alloc] init];
    graphView = [[Draw2D alloc] init];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
