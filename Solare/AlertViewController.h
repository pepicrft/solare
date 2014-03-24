//
//  AlertViewController.h
//  Solare
//
//  Created by Pedro Piñera Buendia on 30/05/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewController : UIViewController{
    IBOutlet UITextView *mensaje;
    IBOutlet UIButton *boton;
    IBOutlet UILabel *alertitle;
    IBOutlet UILabel *buttontitle;
}
@property (strong,nonatomic) UITextView *mensaje;
@property (nonatomic,retain) IBOutlet UIButton *boton;
@property (nonatomic,retain) IBOutlet UILabel *alertitle;
@property (nonatomic,retain) IBOutlet UILabel *buttontitle;

@end
