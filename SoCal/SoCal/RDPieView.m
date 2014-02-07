//
//  RDPieView.m
//  SoCal
//
//  Created by Rayser on 7/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "RDPieView.h"


#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

@implementation RDPieView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	float sum=self->m_val1 + self->m_val2;
	float mult=(360/sum);
	
	float startDeg=0;
	float endDeg=0;

    int half = (int)(rect.size.width/2);
    int x=half;
	int y=half;
	int r=half;
	
	CGContextRef ctx=UIGraphicsGetCurrentContext();
	//CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 1.0, 0.0);
	//CGContextSetLineWidth(ctx, 2.0);
	
	startDeg=0;
	endDeg=(self->m_val1 * mult);
	if(startDeg != endDeg)
	{
		CGContextSetRGBFillColor(ctx, 121.0/255.0, 150.0/255.0, 179.0/255.0, 1.0);
		CGContextMoveToPoint(ctx, x, y);
		CGContextAddArc(ctx, x, y, r, (startDeg)*M_PI/180.0, (endDeg)*M_PI/180.0, 0);
		CGContextClosePath(ctx);
		CGContextFillPath(ctx);
	}
	
	startDeg=endDeg;
	endDeg=endDeg + (self->m_val2 * mult);
	if(startDeg != endDeg)
	{
        CGContextSetRGBFillColor(ctx, 255.0/255.0, 175.0/255.0, 55.0/255.0, 1.0);
		CGContextMoveToPoint(ctx, x, y);
		CGContextAddArc(ctx, x, y, r, (startDeg)*M_PI/180.0, (endDeg)*M_PI/180.0, 0);
		CGContextClosePath(ctx);
		CGContextFillPath(ctx);
		
		
	}
	
}

-(void)setVal1:(float)val1 setVal2:(float)val2
{
	self->m_val1=val1;
	self->m_val2=val2;
}

@end