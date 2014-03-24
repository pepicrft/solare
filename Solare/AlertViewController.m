//
//  AlertViewController.m
//  Solare
//
//  Created by Pedro Piñera Buendia on 30/05/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()


@end

@implementation AlertViewController
@synthesize  boton;
@synthesize alertitle,buttontitle;
@synthesize  mensaje;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
