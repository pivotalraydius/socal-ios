//
//  LocationVC.m
//  SoCal
//
//  Created by Rayser on 4/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "LocationVC.h"

@interface LocationVC ()

@end

@implementation LocationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)closeButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
