//
//  AppDelegate.h
//  Solare
//
//  Created by Pedro Piñera Buendia on 27/05/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import "Reachability.h"
#import "CustomAlertView.h"
#import "IASKAppSettingsViewController.h"


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSMutableArray *maximumTimes;
    NSArray *fpsarray;
}

-(void) playSound : (NSString *) fName : (NSString *) ext;
- (BOOL) connectedToNetwork;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property   (strong,nonatomic) NSMutableArray *maximumTimes;
@property (nonatomic,retain) NSArray *fpsarray;



@end
