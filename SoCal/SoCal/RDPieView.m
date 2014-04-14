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

@implementation RDPieView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        
        [Helpers setBorderToView:self borderColor:[UIColor clearColor] borderThickness:0.0 borderRadius:frame.size.height/2];
        [self setClipsToBounds:YES];
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
    
    [self drawPartitions];
}

-(void)drawPartitions {
    
    if (self->m_amRatio == 0 || self->m_amRatio == 1) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // Draw them with a 1.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1);
    
    float diameter = self.frame.size.width;
    float radius = self.frame.size.width/2;
    float x = radius;
    float y = radius;
    
    if (m_amRatio == 0.5) {
        
        CGContextMoveToPoint(context, 0, radius); //start at this point
        CGContextAddLineToPoint(context, diameter, radius); //draw to this point
    }
    else if (m_amRatio == 0.25 || m_amRatio == 0.75) {
    
        CGContextMoveToPoint(context, 0, radius);
        CGContextAddLineToPoint(context, diameter, radius);
        
        CGContextMoveToPoint(context, radius, 0);
        CGContextAddLineToPoint(context, radius, diameter);
    }
    else {
        
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context, diameter, radius);
        
        float dx = x + ( radius * cos(120 * PI / 180.0) );
        float dy = y + ( radius * sin(120 * PI / 180.0) );
        
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context, dx, dy);
        
        dx = x + ( radius * cos(240 * PI / 180.0) );
        dy = y + ( radius * sin(240 * PI / 180.0) );
        
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context, dx, dy);
    }
    
    // and now draw the Path!
    CGContextStrokePath(context);
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