//
//  RDPieView.h
//  SoCal
//
//  Created by Rayser on 7/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface RDPieView : UIView {

    float m_amRatio;
	float m_pmRatio;
    
    UIColor *m_amColor;
    UIColor *m_pmColor;
    UIColor *m_expiredColor;
}

-(void)setAMRatio:(float)amRatio setPMRatio:(float)pmRatio;
-(void)setAMColor:(UIColor*)amColor setPMColor:(UIColor*)pmColor;
//-(void)setVal1:(float)val1 setVal2:(float)val2;

@end
