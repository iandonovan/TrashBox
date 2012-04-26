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
@synthesize gainSlider, gainOnOff;
@synthesize whichEffect;

//Change the Audio Controller's gain value to be that of the slider
-(IBAction)sliderChanged:(id)sender
{
    [daController setGainValue:[gainSlider value]];
}

-(IBAction)gainSwitchHit:(id)sender
{
    [daController setGainOnOff:[sender isOn]];
}

-(IBAction)whichEffectHit:(id)sender
{
    int effectChoice = [sender selectedSegmentIndex];
    [daController setWhichEffect:effectChoice];
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
    daController = [[AudioController alloc] init];
    
}

//Set up the AudioStreamBasicDescription


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
