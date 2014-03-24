//
//  AgradecimientosViewController.m
//  Solare
//
//  Created by Pedro Piñera Buendia on 05/06/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import "AgradecimientosViewController.h"
#import "AppDelegate.h"

@interface AgradecimientosViewController ()

@end

@implementation AgradecimientosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"Agradecimientos", nil);
        //OCULTAMOS EL BOTÓN BACK
        [self.navigationItem setHidesBackButton:YES];
        UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        backbutton.frame=CGRectMake(20, 20, 49, 27);
        [backbutton addTarget:self action:@selector(volver:) forControlEvents:UIControlEventTouchUpInside];
        
        [backbutton setImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
        [backbutton setImage:[UIImage imageNamed:@"backbuttond.png"] forState:UIControlStateHighlighted];
        
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
        self.navigationItem.leftBarButtonItem=item;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void) viewDidAppear:(BOOL)animated{
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
-(void)volver:(UIButton*)boton{
    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch1" :@"mp3"];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
