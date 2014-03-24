//
//  TonoViewController.h
//  Solare
//
//  Created by Pedro Piñera Buendia on 04/06/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TonoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tabla;
    IBOutlet UIButton *botoncerrar;
    
}
-(IBAction)cerrarflotante:(id)sender;

@property (nonatomic,retain) IBOutlet UITableView *tabla;
@property (nonatomic,retain) IBOutlet UIButton *botoncerrar;


@end
