//
//  InformacionViewController.m
//  Solare
//
//  Created by Pedro Piñera Buendia on 02/06/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import "InformacionViewController.h"
#import "AlertViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "CustomAlertView.h"


@interface InformacionViewController ()

@end

#define celdas 5
#define offset 100

@implementation InformacionViewController
@synthesize  scrollView,alerta;
@synthesize accessibleElements=_accessibleElements;
@synthesize shareimage;

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
    scrollView.contentSize=CGSizeMake(320, 81*celdas+offset);
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.contentOffset=CGPointMake(0, 0);
    scrollView.scrollEnabled=YES;
    scrollView.isAccessibilityElement=NO;
    for (int i=0;i<celdas;i++){
        UIImageView *celda=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Celda%d.png",i+1]]];
        celda.frame=CGRectMake(320, i*(81-2), 320, 81);
        celda.isAccessibilityElement=YES;
        celda.accessibilityTraits=UIAccessibilityTraitStaticText;
        [scrollView addSubview:celda];
        //Añadimos accesibilidad
        NSString *localizedlab=[NSString stringWithFormat:@"AI%d",i+1];
        NSString *localizedlabdet=[NSString stringWithFormat:@"AID%d",i+1];
        celda.accessibilityLabel=NSLocalizedString(localizedlab, nil);
        celda.accessibilityHint=NSLocalizedString(localizedlabdet, nil);
        
        
    }
         
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
-(void)viewDidAppear:(BOOL)animated{
    [self animarcelda:[NSNumber numberWithInt:0]];
    

    }


-(void) animarcelda:(NSNumber*)celda{
    if([celda intValue]<5){
    UIView *celdaView=[[scrollView subviews] objectAtIndex:[celda intValue]];
        [UIView animateWithDuration:0.3 animations:^{
        celdaView.frame=CGRectMake(0, [celda intValue]*(81-2), 320, 81);
        } completion:^(BOOL finished) {
            [self animarcelda:[NSNumber numberWithInt:[celda intValue]+1]];
        }];
        
    }
}
-(IBAction)volver:(id)sender{
    ///Reproducimos sonido///
    AppDelegate *delegado=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch1" :@"mp3"];
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)contactar:(id)sender{
    
    ///Reproducimos sonido///
    AppDelegate *delegado=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch1" :@"mp3"];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [mfViewController setSubject:NSLocalizedString(@"mailsubject", nil)];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"solare@ppinera.es", nil];
        [mfViewController setToRecipients:toRecipients];
        NSString *emailBody = NSLocalizedString(@"mailbody", nil);
        [mfViewController setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:mfViewController animated:YES];
    }else {
        [self mostraralerta:[NSString stringWithFormat:NSLocalizedString(@"Mailnoconf", nil)]];
    }
}
-(IBAction)valorar:(id)sender{
    
    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch1" :@"mp3"];
    // LECTURA DEL FICHERO PREFERENCIAS.PLIST///
    NSString *filePathbundle = [[NSBundle mainBundle] pathForResource:@"Preferencias" ofType:@"plist"];  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *documentpath=[paths objectAtIndex:0];
    NSString *filePathDocument=[NSString stringWithFormat:@"%@/Preferencias.plist",documentpath];
    
    //Si se ha descargado correctamente el último usamos el último, en caso contrario, usaremos el local
    NSData *documentdata=[NSData dataWithContentsOfFile:filePathDocument];
    NSMutableDictionary *preferencias;
    if(documentdata){
        preferencias=[NSMutableDictionary dictionaryWithContentsOfFile:filePathDocument];
    } else{
        preferencias=[NSMutableDictionary dictionaryWithContentsOfFile:filePathbundle];
    }
    ////////////
    
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str]; 
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    
    // Here is the app id from itunesconnect
    NSString *appkey=[preferencias objectForKey:@"Appdireccion"];
    if(![appkey isEqualToString:@""] ){
        
    str = [NSString stringWithFormat:@"%@%@", str,appkey]; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
-(IBAction)compartir:(id)sender{
    
    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch1" :@"mp3"];
    NSLog(@"Compartiendo");
    
    CustomAlertView *alertview=[[CustomAlertView alloc] initWithTitle:NSLocalizedString(@"twitter3", nil) message:NSLocalizedString(@"twitter4", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"twitter5", nil),NSLocalizedString(@"twitter6", nil), nil];
    [alertview show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0){ //Desea incluir foto
        NSLog(@"Desea incluir foto");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else
        {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        [imagePicker setDelegate:self];
        [self presentModalViewController:imagePicker animated:YES];
    }else{
        [self performSelector:@selector(compartirtwitter:) withObject:[UIImage imageNamed:@"Icon@2x.png"] afterDelay:0.5];
    }


}

#pragma mark - Mostrar alerta
-(void)mostraralerta:(NSString*)texto{
        CustomAlertView *alertaa=[[CustomAlertView alloc] initWithTitle:NSLocalizedString(@"Informacion", nil) message:texto    delegate:self cancelButtonTitle: NSLocalizedString(@"Entendido", nil) otherButtonTitles:nil];
        [alertaa show];
    
}

#pragma mark - Mail delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            [self mostraralerta:[NSString stringWithFormat:NSLocalizedString(@"Mailenborradores", nil)]];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            [self mostraralerta:[NSString stringWithFormat:NSLocalizedString(@"Mailenviado", nil)]];
            break;
        case MFMailComposeResultFailed:
            [self mostraralerta:[NSString stringWithFormat:NSLocalizedString(@"Mailfallido", nil)]];
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Foto seleccionada");
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissModalViewControllerAnimated:YES];
    [self performSelector:@selector(compartirtwitter:) withObject:image afterDelay:0.5];
  
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
    [self performSelector:@selector(compartirtwitter:) withObject:[UIImage imageNamed:@"Icon@2x.png"] afterDelay:0.5];

}

-(void)compartirtwitter:(UIImage*)image{
    NSLog(@"Compartiendo en twitter");
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    ViewController *vista=delegado.viewController;
     NSString *localidad=vista.placemark.locality;
    NSNumber *UV = vista.UVI;
     
     TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    if(localidad!=nil){ //Se ha obtenido la localidad, luego se muestra
    [twitter setInitialText:[NSString stringWithFormat:@"%@ %@ %@ %@",NSLocalizedString(@"twitter1", nil),UV,NSLocalizedString(@"twitter2", nil),localidad]];
    }else {
        [twitter setInitialText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"twitter7", nil),NSLocalizedString(@"twitter2", nil)]];

    }

    [twitter addImage:image];
     [twitter addURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id533472988"]];
     
     if([TWTweetComposeViewController canSendTweet]){
     [self presentViewController:twitter animated:YES completion:nil];
     } else {
     [self mostraralerta:[NSString stringWithFormat:NSLocalizedString(@"Imposibletweet", nil)]];
     return;
     }
     
     twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
     if (TWTweetComposeViewControllerResultDone) {
     
     } else if (TWTweetComposeViewControllerResultCancelled) {
     [self mostraralerta:[NSString stringWithFormat:NSLocalizedString(@"Oopstweet", nil)]];
     }
     [self dismissModalViewControllerAnimated:YES];
     };
    
}

@end
