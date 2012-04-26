//
//  Draw2D.h
//  GraphDraw
//
//  Created by Dan Raisbeck on 4/21/12.
//  Copyright (c) 2012 Mercury Computer Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Draw2D : UIView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
