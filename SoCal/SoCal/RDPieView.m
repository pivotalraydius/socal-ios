//
//  RDPieView.m
//  SoCal
//
//  Created by Rayser on 7/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "RDPieView.h"


#define PI 3.14159265358979323846
#define DEFAULT_AM_COLOR [Helpers suriaOrangeColorWithAlpha:1.0]
#define DEFAULT_PM_COLOR [Helpers pmBlueColorWithAlpha:1.0]
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
	float sum=self->m_pmRatio + self->m_amRatio;
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
	endDeg=(self->m_pmRatio * mult);
	if(startDeg != endDeg)
	{
        UIColor *color;
        if (self->m_pmColor)
            color = m_pmColor;
        else
            color = DEFAULT_PM_COLOR;
        
        CGFloat R, G, B, A;
        [color getRed:&R green:&G blue:&B alpha:&A];
		CGContextSetRGBFillColor(ctx, R, G, B, A);
		CGContextMoveToPoint(ctx, x, y);
		CGContextAddArc(ctx, x, y, r, (startDeg)*M_PI/180.0, (endDeg)*M_PI/180.0, 0);
		CGContextClosePath(ctx);
		CGContextFillPath(ctx);
	}
	
	startDeg=endDeg;
	endDeg=endDeg + (self->m_amRatio * mult);
	if(startDeg != endDeg)
	{
        UIColor *color;
        if (self->m_amColor)
            color = m_amColor;
        else
            color = DEFAULT_AM_COLOR;
        
        CGFloat R, G, B, A;
        [color getRed:&R green:&G blue:&B alpha:&A];
		CGContextSetRGBFillColor(ctx, R, G, B, A);
		CGContextMoveToPoint(ctx, x, y);
		CGContextAddArc(ctx, x, y, r, (startDeg)*M_PI/180.0, (endDeg)*M_PI/180.0, 0);
		CGContextClosePath(ctx);
		CGContextFillPath(ctx);
		
		
	}
	
}

-(void)setAMRatio:(float)amRatio setPMRatio:(float)pmRatio {
    
	self->m_amRatio=amRatio;
	self->m_pmRatio=pmRatio;
}

-(void)setAMColor:(UIColor*)amColor setPMColor:(UIColor*)pmColor {

    self->m_amColor=amColor;
    self->m_pmColor=pmColor;
}

@end