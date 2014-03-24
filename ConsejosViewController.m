//
//  ConsejosViewController.m
//  Solare
//
//  Created by Pedro Piñera Buendia on 03/06/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import "ConsejosViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Consejo1ViewController.h"
#import "AgradecimientosViewController.h"
#import "Flurry.h"
#import "IASKAppSettingsViewController.h"
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"

@interface ConsejosViewController ()

@end

@implementation ConsejosViewController
@synthesize tabla;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
               
        
        [Flurry logAllPageViews:self.navigationController];
           
        
        //configuramos la tabla
        [tabla setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                 
    }
    return self;
}
-(void) viewDidAppear:(BOOL)animated{
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title=NSLocalizedString(@"Consejos", nil);
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(20, 20, 49, 27);
    [backbutton addTarget:self action:@selector(volver:) forControlEvents:UIControlEventTouchUpInside];
    [backbutton setImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    [backbutton setImage:[UIImage imageNamed:@"backbuttond.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=item;
    item.isAccessibilityElement=YES;
    item.accessibilityLabel=NSLocalizedString(@"AP13", Nil);
    
    //Añadimos el botón settings
    UIButton *settingsbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    settingsbutton.frame=CGRectMake(20, 20, 49, 27);
    [settingsbutton addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
    [settingsbutton setImage:[UIImage imageNamed:@"settingsbutton.png"] forState:UIControlStateNormal];
    [settingsbutton setImage:[UIImage imageNamed:@"settingsbuttond.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem* settingsitem = [[UIBarButtonItem alloc] initWithCustomView:settingsbutton];
    self.navigationItem.rightBarButtonItem=settingsitem;
    settingsitem.isAccessibilityElement=YES;
    settingsitem.accessibilityLabel=NSLocalizedString(@"AP14", Nil);
    

    
    //Establecemos el fondo del tableview
    [self.tabla setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"consejosback.png"]]];
    [self.tabla setContentOffset:CGPointMake(0, 300)];
    [self.tabla setContentSize:CGSizeMake(self.view.bounds.size.width, 600)];
    

    
   
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        //Añadimos el fondo
        //cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"celdaconsejo.png"]];
        //cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"celdaconsejod.png"]];
        UIImage *imagencelda;
        UIImage *imagenceldad;
        switch (indexPath.row) {
            case 0:

                imagencelda=[UIImage imageNamed:@"celdaconsejofirst.png"];
                imagenceldad=[UIImage imageNamed:@"celdaconsejofirstd.png"];

                break;
            case 7:
                imagencelda=[UIImage imageNamed:@"celdaconsejolast.png"];
                imagenceldad=[UIImage imageNamed:@"celdaconsejolastd.png"];

                break;
            default:
                imagencelda=[UIImage imageNamed:@"celdaconsejo.png"];
                imagenceldad=[UIImage imageNamed:@"celdaconsejod.png"];

                break;
        }
        UIImageView *celdaview=[[UIImageView alloc] initWithImage:imagencelda];
        celdaview.frame=CGRectMake(320/2-imagencelda.size.width/2, 0, imagencelda.size.width, imagencelda.size.height    );
        UIView *celdaview2=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, celdaview.frame.size.height)];
        [celdaview2 addSubview:celdaview];           
        cell.backgroundView=celdaview2;
        
        UIImageView *celdaviewd=[[UIImageView alloc] initWithImage:imagenceldad];
        celdaviewd.frame=CGRectMake(320/2-imagenceldad.size.width/2, 0, imagenceldad.size.width, imagenceldad.size.height    );
        UIView *celdaview2d=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, celdaviewd.frame.size.height)];
        [celdaview2d addSubview:celdaviewd];           
        cell.selectedBackgroundView=celdaview2d;
        
        //Añadimos el label del título
        UILabel *titulo=[[UILabel alloc] initWithFrame:CGRectMake(35, 7, 315, 20)];
        titulo.tag=5;
        titulo.backgroundColor=[UIColor clearColor];
        titulo.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        titulo.shadowOffset=CGSizeMake(0, 0.5);
        titulo.shadowColor=[UIColor colorWithWhite:1 alpha:1];
        titulo.textColor=[UIColor colorWithRed:37.0f/255 green:102.0f/255 blue:132.0f/255 alpha:1.0];
        [cell addSubview:titulo];     
        
 
    }
   
    UILabel *titulo=(UILabel*)([cell viewWithTag:5]);
    
    
    //Añadimos el texto de los títulos
    switch (indexPath.row) {
            
        case 0:titulo.text=NSLocalizedString(@"Introduccion", nil);  break;
        case 1:titulo.text=NSLocalizedString(@"Indices", nil);  break;
        case 2:titulo.text=NSLocalizedString(@"Resistenciaagua", nil); break;
        case 3:titulo.text=NSLocalizedString(@"Elegfotoprotector", nil); break;
        case 4:titulo.text=NSLocalizedString(@"Advertencias", nil); break;
        case 5:titulo.text=NSLocalizedString(@"Infantil", nil);  break;
        case 6:titulo.text=NSLocalizedString(@"Frecuentes", nil); break;
        case 7:titulo.text=NSLocalizedString(@"Agradecimientos", nil);  break;
        default:           break;
    }
    
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        return 39;

}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch1" :@"mp3"];
    
    if(indexPath.row<7){ // Todos los consejos menos agradecimientos
            Consejo1ViewController *consejo=[[Consejo1ViewController alloc] initWithNibName:@"Consejo1ViewController" bundle:nil];
            consejo.vista=[NSNumber numberWithInt:indexPath.row];
    
            [self.navigationController pushViewController:consejo animated:YES];

        consejo.imagen.image=[UIImage imageNamed:[NSString stringWithFormat:@"foto%d.jpg",indexPath.row+1]];
        UIImage *texto =[UIImage imageNamed:[NSString stringWithFormat:@"texto%d.png",indexPath.row+1]]; 
        [consejo.scroll addSubview:[[UIImageView alloc] initWithImage:texto]];
        [consejo.scroll setContentSize:CGSizeMake(texto.size.width,
                                                  texto.size.height)];
    
        
        }else{ //Agradecimientos
            AgradecimientosViewController *agradecimientos=[[AgradecimientosViewController alloc] initWithNibName:@"AgradecimientosViewController" bundle:nil];
            [self.navigationController pushViewController:agradecimientos animated:YES];
        }
     
}
-(void)volver:(UIButton*)boton{
    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch1" :@"mp3"];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}
-(void)settings:(UIButton*)boton{
    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch1" :@"mp3"];
    IASKAppSettingsViewController *settings=[[IASKAppSettingsViewController alloc] init];
    settings.delegate=self;
    settings.showDoneButton=NO;
    [self.navigationController pushViewController:settings animated:YES];
}
#pragma mark - Settings mail
- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForSpecifier:(IASKSpecifier*)specifier {
	if ([specifier.key isEqualToString:@"nodata"]) {
		NSLog(@"Enviar mail");
        //Completamos el correo
        NSString *version=[[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
        NSString *device=[[UIDevice currentDevice] model];
        NSString *systemVersion=[[UIDevice currentDevice] systemVersion];
        NSString *locality=[[[(AppDelegate*)([[UIApplication sharedApplication] delegate]) viewController] placemark] locality];
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        //NSString *locality= self.placemark.locality;
        
        NSString *body=[NSString stringWithFormat:@"%@%@.\n\n\n%@\n\n####################\nVersión de Solare:%@\nModelo: %@\niOS: %@\nIdioma: %@\n####################",NSLocalizedString(@"Mail1", nil),locality,NSLocalizedString(@"Mail2", nil),version,device,systemVersion,language];
        
        
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
            mfViewController.mailComposeDelegate = self;
            [mfViewController setToRecipients:[NSArray arrayWithObjects:@"solare@ppinera.es", nil]];
            [mfViewController setSubject:@"Sin datos en mi zona"];
            [mfViewController setMessageBody:body isHTML:NO];
            
            [self presentModalViewController:mfViewController animated:YES];

        }
	}
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];

}

@end
