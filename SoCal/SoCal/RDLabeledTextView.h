//
//  RDLabeledTextView.h
//  SoCal
//
//  Created by Rayser on 4/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RDLabeledTextViewDelegate;

@interface RDLabeledTextView : UIView <UITextViewDelegate>
{
    UIFont *textFont;
    UIFont *titleFont;
    UIColor *textColor;
    UIColor *titleColor;
    NSString *text;
    NSString *title;
}

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIControl *controlView;
@property (nonatomic, assign) id<RDLabeledTextViewDelegate> delegate;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title;

-(NSString *)title;
-(NSString *)text;
-(UIFont *)textFont;
-(UIFont *)titleFont;
-(UIColor *)textColor;
-(UIColor *)titleColor;

-(void)setTitle:(NSString *)aTitle;
-(void)setText:(NSString *)aText;
-(void)setTextFont:(UIFont *)aTextFont;
-(void)setTitleFont:(UIFont *)aTitleFont;
-(void)setTextColor:(UIColor *)aTextColor;
-(void)setTitleColor:(UIColor *)aTitleColor;

-(void)setBorderWidth:(CGFloat)width cornerRadius:(CGFloat)radius andColor:(UIColor *)color;

-(BOOL)becomeFirstResponder;
-(BOOL)resignFirstResponder;

@end

@protocol RDLabeledTextViewDelegate <NSObject>

@optional

-(BOOL)textView:(RDLabeledTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
-(BOOL)textView:(RDLabeledTextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange;
-(BOOL)textView:(RDLabeledTextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange;
-(void)textViewDidBeginEditing:(RDLabeledTextView *)textView;
-(void)textViewDidChange:(RDLabeledTextView *)textView;
-(void)textViewDidChangeSelection:(RDLabeledTextView *)textView;
-(void)textViewDidEndEditing:(RDLabeledTextView *)textView;
-(BOOL)textViewShouldBeginEditing:(RDLabeledTextView *)textView;
-(BOOL)textViewShouldEndEditing:(RDLabeledTextView *)textView;

@end
