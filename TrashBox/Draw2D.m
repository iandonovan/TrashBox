//
//  Draw2D.m
//  GraphDraw
//
//  Created by Ian Donovan, Dan Raisbeck, and Michael Siegel
//  Copyright (c) 2012 Possum Kingdom. All rights reserved.
//

#import "Draw2D.h"

//Buncha constants
#define datapoints 24//16
#define granularity 100//2520
#define granularity2 15
#define totalpoints datapoints*granularity
#define averagepoints 9
#define averagepoints2 75
#define bits16 65536
#define shift16 32768

@implementation Draw2D

//Global variables? FUCK THE POLICE.
float lut[bits16];
CGPoint graph[datapoints];
CGPoint points[datapoints*granularity];
CGPoint averaged[datapoints*granularity];
CGFloat width;
CGFloat height;
int divisor;
bool setup;
bool smoothing;     //pre-splining smoothing
bool smoothing2;    //post-splining smoothing
CGContextRef context;

//Toggle dem smooves
- (void)toggleSmooth1:(bool)state
{
    smoothing = state;
}
- (void)toggleSmooth2:(bool)state
{
    smoothing2 = state;
}

//Gonna have to look in to this; empty if statement
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (float *)getLUTPointer:(id)sender
{
    return lut;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    //Set up some of those variables for drawing
    width = self.frame.size.width;
    height = self.frame.size.height;
    divisor = width / datapoints;
    context = UIGraphicsGetCurrentContext();

    //Nice naming convention
    int count = 0;
    int count2 = 0;
    
    //draw vertical bars to separate datapoints
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context,[UIColor greenColor].CGColor);
    for(int i=0; i<=datapoints; i++)
    {
        CGFloat vert = width/datapoints*i;
        CGContextMoveToPoint(context, vert,0);
        CGContextAddLineToPoint(context, vert, height);
    }
    CGContextStrokePath(context);
    CGContextBeginPath(context);
    
    //initialize the graph variable to a linear function
    if(setup == false)
    {  
        smoothing = false;
        smoothing2 = false;
        for(int i=0; i<datapoints; i++)
        {
            //special x values to allow data points to fall between vertical bars
            CGFloat vert = width/datapoints*(i+0.5);
            graph[i].x = vert;
            graph[i].y = height - (height/width * (i+1) * divisor);
        }
        setup = true;
    }
    
    //set up initial point for drawing
    CGPoint pi;
    pi.x = 0.0f;
    pi.y = height;
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context,[UIColor redColor].CGColor);
    CGContextMoveToPoint(context, pi.x, pi.y);
    points[count] = pi;
    count++;
    
    //pre-splining smoothing
    if (smoothing == true) {
        for(int i=0; i<datapoints; i++) {
            int j = i - averagepoints/2;
            averaged[i].y = 0;
            averaged[i].x = graph[i].x;
            while(j<(i+averagepoints/2)) {
                if(j<0) {
                    averaged[i].y += height;
                }
                else {
                    averaged[i].y += graph[i].y;
                }
                j++;
            }
            averaged[i].y = averaged[i].y / averagepoints;
        }
    }
    
    //This smooths out the graph my interpolating curves between points
    for(int i=0; i<datapoints-2; i++) {
        CGPoint p0, p1, p2, p3;
        
        //If first index, use mirrored point to help calculate smoothed line
        if(smoothing == true) {
            if(i==0) {
                p0.x = -1 * averaged[0].x;
                p0.y = 2*height - averaged[0].y;
            }
            else {
                p0 = averaged[i-1];
            }
            p1 = averaged[i];
            p2 = averaged[i+1];
            p3 = averaged[i+2];
        }
        else {
            if(i==0) {
                p0.x = -1 * graph[0].x;
                p0.y = 2*height - graph[0].y;
            }
            else {
                p0 = graph[i-1];
            }
            p1 = graph[i];
            p2 = graph[i+1];
            p3 = graph[i+2];
        }
        
        
        for(int j = 1; j < granularity; j++) {
            float t = (float) j * (1.0f / (float) granularity);
            float tt = t*t;
            float ttt = tt * t;
            
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            points[count].x = pi.x;
            
            //must account for boundary conditions
            if(pi.y < 0.0f) {
                points[count].y = 0.0f;
            }
            else if (pi.y > height) {
                points[count].y = height;
            }
            else {
                points[count].y = pi.y;
            }
            count++;
        }
        points[count] = p2;
        count++;
    }
    pi.x = width;
    pi.y = graph[datapoints-1].y;
    points[count] = pi;
    count++;
    //NSLog(@"Count = %d", count);
    
    //post-splining smoothing
    if(smoothing2 == true) {
        for(int i = 0; i<count; i++) {
            int j = i - averagepoints2/2;
            averaged[i].y = 0;
            averaged[i].x = points[i].x;
            while(j<(i+averagepoints2/2)) {
                if(j<0) {
                    averaged[i].y += height;
                }
                else {
                    averaged[i].y += points[i].y;
                }
                j++;
            }
            averaged[i].y = averaged[i].y / averagepoints2;
        }
        for(int i = 0; i<count; i++) {
            points[i] = averaged[i];
        }

    }
    //draw final graph
    for(int i = 0; i<count; i++)
    {
        CGContextAddLineToPoint(context, points[i].x, points[i].y);
    }
    CGContextStrokePath(context);
    
    //interpolate data. THIS IS MESSY AND I WILL FIX -dan
    lut[shift16] = 0.0f;
    for(int i = 0; i<count && count2 < shift16; i++)
    {
        CGFloat p0, p1, p2, p3, y;
        //If first index, use mirrored point to help calculate smoothed line
        if(i==0) {
            p0 = 2*height - points[0].y;
        }
        else {
            p0 = points[0].y;
        }
        p1 = points[i].y;
        p2 = points[i+1].y;
        p3 = points[i+2].y;
        
        for(int j = 1; j < granularity2 && count2 < shift16; j++) {
            float t = (float) j * (1.0f / (float) granularity);
            float tt = t*t;
            float ttt = tt * t;
            
            y = 0.5 * (2*p1+(p2-p0)*t + (2*p0-5*p1+4*p2-p3)*tt + (3*p1-p0-3*p2+p3)*ttt);
            
            //must account for boundary conditionsß
            if(y < 0.0f) {
                lut[shift16+count2] = 1.0f;
                lut[shift16-count2] = -1.0f;
            }
            else if (pi.y > height) {
                lut[shift16+count2] = 0.0f;
                lut[shift16-count2] = 0.0f;
            }
            else {
                lut[shift16+count2] = 1 - y / height;
                lut[shift16-count2] = y/height - 1;
            }
            count2++;
        }
        if(count2 < shift16)
        {
            lut[shift16+count2] = 1- p2/height;
            lut[shift16-count2] = p2/height - 1;
            count2++;
        }
    }
    //NSLog(@"Count2 = %d", count2);
}

//Start dat touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self]; 
    if(point.x >= 0 && point.x < width && point.y >=0 && point.y < height) {
        int temp = point.x / divisor;
        graph[temp].y = point.y;
    }
    [self setNeedsDisplay];
}

//Move dat touch
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(point.x >= 0 && point.x < width && point.y >=0 && point.y < height) {
        int temp = point.x / divisor;
        graph[temp].y = point.y;
    }
    [self setNeedsDisplay];
}

//End dat touch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(point.x >= 0 && point.x < width && point.y >=0 && point.y < height) {
        int temp = point.x / divisor;
        graph[temp].y = point.y;
    }
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


@end
