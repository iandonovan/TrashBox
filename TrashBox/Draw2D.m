//
//  Draw2D.m
//  GraphDraw
//
//  Created by Ian Donovan, Dan Raisbeck, and Michael Siegel
//  Copyright (c) 2012 Possum Kingdom. All rights reserved.
//

#import "Draw2D.h"

#define datapoints 128//16
#define granularity 10//2520
#define totalpoints datapoints*granularity
#define averagepoints 8

@implementation Draw2D

//extern bool moveaverage;

CGFloat graph[datapoints];
CGFloat pointfloat[datapoints*granularity];
CGPoint points[datapoints*granularity];
CGPoint averaged[datapoints*granularity];
CGFloat width;
CGFloat height;
int divisor;
bool setup;
CGContextRef context;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */

- (void)drawRect:(CGRect)rect
{
    width = self.frame.size.width;
    height = self.frame.size.height;
    divisor = width / datapoints;
    NSLog(@"Width: %f", width);
    NSLog(@"Height: %f", height);
    context = UIGraphicsGetCurrentContext();
    int count = 0;
    
    //moveaverage = true;
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context,[UIColor greenColor].CGColor);
    for(int i=0; i<datapoints; i++)
    {
        CGContextMoveToPoint(context, width/datapoints *(i+1),0);
        CGContextAddLineToPoint(context, width/datapoints*(i+1), height);
    }
    CGContextStrokePath(context);
    CGContextBeginPath(context);
    
    if(setup == false)
    {  
        graph[0] = height;
        for(int i=1; i<datapoints; i++)
        {
            graph[i] = height - (height/width * (i+1) * divisor);
        }
        pointfloat[0] = height;
        setup = true;
    }
    
    CGPoint pi;
    pi.x = 0.0f;
    pi.y = height;
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context,[UIColor redColor].CGColor);
    CGContextMoveToPoint(context, pi.x, pi.y);
    points[count] = pi;
    pointfloat[count] = pi.y;
    count++;

    for(int i=1; i<datapoints-2; i++)
    {
        CGPoint p0, p1, p2, p3;
        p0.x = (i-1) * divisor;
        p0.y = graph[i-1];
        p1.x = i * divisor;
        p1.y = graph[i];
        p2.x = (i+1)*divisor;
        p2.y = graph[i+1];
        p3.x = (i+2) * divisor;
        p3.y = graph[i+2];
        
        for(int j = 1; j < granularity; j++)
        {
            float t = (float) j * (1.0f / (float) granularity);
            float tt = t*t;
            float ttt = tt * t;
            
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            pointfloat[count] = pi.y;
            points[count] = pi;
            count++;
        }
        pointfloat[count] = p2.y;
        points[count] = p2;
        count++;
    }
    pi.x = width;
    pi.y = graph[datapoints-1];
    pointfloat[count] = pi.y;
    points[count] = pi;
    count++;
    NSLog(@"Count = %d", count);
    /*
     averaged[0] = points[0];
     for(int i = 0; i< count-1; i++)
     {
     averaged[i+1].y = (pointfloat[i] + pointfloat[i+1] + pointfloat[i+2])/3;
     averaged[i+1].x = points[i+1].x;
     }
     averaged[count-1].x = width;
     averaged[count-1].y = (2*graph[count-1] + graph[count-2])/3;
     */
    for(int i = 0; i<count; i++)
    {
        CGContextAddLineToPoint(context, points[i].x, points[i].y);
    }
    CGContextStrokePath(context);
}

//Touch starts; mark the location of the touch and begin drawing
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self]; 
    if(point.x >= 0 && point.x < width && point.y >=0 && point.y < height) {
        int temp = point.x / divisor;
        graph[temp] = point.y;
    }
    NSLog(@"Touch Start - x: %f - y: %f", point.x, point.y);
    [self setNeedsDisplay];
}

//Touch is moving -- most of the drawing happens here
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(point.x >= 0 && point.x < width && point.y >=0 && point.y < height) {
        int temp = point.x / divisor;
        graph[temp] = point.y;
    }
    NSLog(@"Touch Moving - x: %f - y: %f", point.x, point.y);
    [self setNeedsDisplay];
}

//Touch over; wrap it up
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(point.x >= 0 && point.x < width && point.y >=0 && point.y < height) {
        int temp = point.x / divisor;
        graph[temp] = point.y;
    }
    NSLog(@"Touch End - x: %f - y: %f", point.x, point.y);
    [self setNeedsDisplay];
}

//Somehow cancel the touch; what does that gensture entail?
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch Cancelled");
    
}


@end
