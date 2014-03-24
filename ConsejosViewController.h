//
//  ConsejosViewController.h
//  Solare
//
//  Created by Pedro Piñera Buendia on 03/06/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewController.h"
#import "TonoViewController.h"
#import "IASKAppSettingsViewController.h"
#import <MessageUI/MessageUI.h>


@interface ConsejosViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,IASKSettingsDelegate,MFMailComposeViewControllerDelegate>{
    IBOutlet UITableView *tabla;
    
    
}
//Funciones



@property(nonatomic,retain) IBOutlet UITableView *tabla;

@end
