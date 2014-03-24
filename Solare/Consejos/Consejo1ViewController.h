//
//  Consejo1ViewController.h
//  Solare
//
//  Created by Pedro Piñera Buendia on 04/06/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Consejo1ViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIImageView* imagen;
    IBOutlet UIScrollView *scroll;
    NSNumber *vista;
    float anteriory;
    BOOL imagenoculta;
    
}
-(void)volver:(UIButton*)boton;


@property (nonatomic,retain) IBOutlet UIImageView *imagen;
@property(nonatomic,retain) IBOutlet UIScrollView*scroll;
@property(strong,nonatomic) NSNumber *vista;


@end
