//
//  MainVCViewController.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "MainVC.h"

@implementation MainVC

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
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)setupUI {
    
    [Helpers setBorderToView:self.btnCreateEvent borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRadius:0.0];
    [Helpers setBorderToView:self.btnUseInvite borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRadius:0.0];
}

-(IBAction)btnCreateEventAction {
    
    self.composeVC = [[ComposeVC alloc] init];
    [self.navigationController pushViewController:self.composeVC animated:YES];
}

-(IBAction)btnUseInviteAction {
    
    self.eventVC = [[EventVC alloc] init];
    [self.navigationController pushViewController:self.eventVC animated:YES];
}

@end
