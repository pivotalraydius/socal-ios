//
//  RDLabeledTextView.m
//  SoCal
//
//  Created by Rayser on 4/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "RDLabeledTextView.h"

@implementation RDLabeledTextView

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initializeWithFrame:self.frame];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)aTitle {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initializeWithFrame:frame];
        title = aTitle;
    }
    
    return self;
}

-(void)initializeWithFrame:(CGRect)frame {
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.controlView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    [self addSubview:self.textView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.controlView];
    
    textFont = [UIFont systemFontOfSize:12.0];
    titleFont = [UIFont systemFontOfSize:16.0];
    textColor = [UIColor blackColor];
    titleColor = [UIColor blackColor];
    text = @"";
    
    [self.textView setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.controlView setBackgroundColor:[UIColor clearColor]];
    
    [self.textView setText:text];
    [self.titleLabel setText:title];
    
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.textView setDelegate:self];
    
    [self.controlView addTarget:self action:@selector(becomeFirstResponder) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setFrame:(CGRect)frame {
    
    [self.textView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.titleLabel setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.controlView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    [super setFrame:frame];
}

-(NSString *)title {
    
    return title;
}

-(void)setTitle:(NSString *)aTitle {
    
    title = aTitle;
    [self.titleLabel setText:title];
}

-(NSString *)text {
    
    return text;
}

-(void)setText:(NSString *)aText {
    
    text = aText;
    [self.textView setText:text];
}

-(UIFont *)textFont {
    
    return textFont;
}

-(void)setTextFont:(UIFont *)aTextFont {
    
    textFont = aTextFont;
    [self.textView setFont:textFont];
}

-(UIFont *)titleFont {
    
    return titleFont;
}

-(void)setTitleFont:(UIFont *)aTitleFont {
    
    titleFont = aTitleFont;
    [self.titleLabel setFont:titleFont];
}

-(UIColor *)textColor {
    
    return textColor;
}

-(void)setTextColor:(UIColor *)aTextColor {
    
    textColor = aTextColor;
    [self.textView setTextColor:textColor];
}

-(UIColor *)titleColor {
    
    return titleColor;
}

-(void)setTitleColor:(UIColor *)aTitleColor {
    
    titleColor = aTitleColor;
    [self.titleLabel setTextColor:titleColor];
}

-(void)setBorderWidth:(CGFloat)width cornerRadius:(CGFloat)radius andColor:(UIColor *)color {
    
    [self.layer setBorderWidth:width];
    [self.layer setCornerRadius:radius];
    [self.layer setBorderColor:color.CGColor];
}

-(BOOL)becomeFirstResponder {
    
    [self.controlView setHidden:YES];
    [self.titleLabel setHidden:YES];
    
    return [self.textView becomeFirstResponder];
}

-(BOOL)resignFirstResponder {
    
    [self.controlView setHidden:NO];
    
    NSString *aText = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    text = aText;
    
    if ([text isEqualToString:@""]) {
        [self.titleLabel setHidden:NO];
    }
    else {
        [self.titleLabel setHidden:YES];
    }
    
    return [self.textView resignFirstResponder];
}

#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(RDLabeledTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)aText {
    
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        
        return [self.delegate textView:textView shouldChangeTextInRange:range replacementText:aText];
    }
    else {
        
        return YES;
    }
}

-(BOOL)textView:(RDLabeledTextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    
    if ([self.delegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
        
        return [self.delegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    else {
        
        return YES;
    }
}

-(BOOL)textView:(RDLabeledTextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if ([self.delegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
        
        return [self.delegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    }
    else {
        
        return YES;
    }
}

-(void)textViewDidBeginEditing:(RDLabeledTextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        
        [self.delegate textViewDidBeginEditing:textView];
    }
}

-(void)textViewDidChange:(RDLabeledTextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        
        [self.delegate textViewDidChange:textView];
    }
}

-(void)textViewDidChangeSelection:(RDLabeledTextView *)textView {
 
    if ([self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        
        [self.delegate textViewDidChangeSelection:textView];
    }
}

-(void)textViewDidEndEditing:(RDLabeledTextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        
        [self.delegate textViewDidEndEditing:textView];
    }
}

-(BOOL)textViewShouldBeginEditing:(RDLabeledTextView *)textView {
 
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        
        return [self.delegate textViewShouldBeginEditing:textView];
    }
    else {
        
        return YES;
    }
}

-(BOOL)textViewShouldEndEditing:(RDLabeledTextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        
        return [self.delegate textViewShouldEndEditing:textView];
    }
    else {
        
        return YES;
    }
}

@end
