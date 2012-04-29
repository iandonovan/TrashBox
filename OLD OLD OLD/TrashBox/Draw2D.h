//
//  Draw2D.h
//  GraphDraw
//
//  Created by Ian Donovan, Dan Raisbeck, and Michael Siegel
//  Copyright (c) 2012 Possum Kingdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Draw2D : UIView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)toggleSmooth1:(bool)state;
- (void)toggleSmooth2:(bool)state;

- (float *)getLUTPointer:(id)sender;

@end
