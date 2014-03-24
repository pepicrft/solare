//
//  InformacionViewController.h
//  Solare
//
//  Created by Pedro Piñera Buendia on 02/06/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import "AlertViewController.h"
#import <MessageUI/MessageUI.h>
#import "CustomAlertView.h"


@interface InformacionViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate> {
    IBOutlet UIScrollView *scrollView;
      AlertViewController *alerta;
        UIImage *shareimage;
    
}

-(IBAction)volver:(id)sender;
-(void) animarcelda:(NSNumber*)celda;
-(IBAction)compartir:(id)sender;
-(IBAction)contactar:(id)sender;
-(IBAction)valorar:(id)sender;
-(void)mostraralerta:(NSString*)texto;
-(void)compartirtwitter:(UIImage*)image;

@property (nonatomic, strong) NSMutableArray *accessibleElements;
@property (nonatomic,retain) AlertViewController *alerta;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) UIImage *shareimage;
@end
