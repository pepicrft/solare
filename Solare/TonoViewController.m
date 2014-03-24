//
//  TonoViewController.m
//  Solare
//
//  Created by Pedro Piñera Buendia on 04/06/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import "TonoViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"


@interface TonoViewController ()

@end

@implementation TonoViewController
@synthesize tabla,botoncerrar;
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
    //SELECCIONAMOS AQUELLA CELDA QUE SEA IGUAL AL TONO DE PIEL
    AppDelegate *delegado=([UIApplication sharedApplication]).delegate;
    ViewController *vistaprincipal=delegado.viewController;
    [tabla selectRowAtIndexPath:[NSIndexPath indexPathForRow:[vistaprincipal.tono intValue] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
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
        cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tonocelda.png"]];
        cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tonoceldad.png"]];
        
        
        //Añadimos el label del título
        UILabel *titulo=[[UILabel alloc] initWithFrame:CGRectMake(4, 4, 315, 15)];
        titulo.tag=5;
        titulo.backgroundColor=[UIColor clearColor];
        titulo.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        titulo.shadowOffset=CGSizeMake(0, 0.5);
        titulo.shadowColor=[UIColor colorWithWhite:1 alpha:1];
        titulo.textColor=[UIColor colorWithRed:37.0f/255 green:102.0f/255 blue:132.0f/255 alpha:1.0];
        [cell addSubview:titulo];     
        
        UILabel *descripcion=[[UILabel alloc] initWithFrame:CGRectMake(7, 11, 270, 50)];
        descripcion.tag=6;
        descripcion.backgroundColor=[UIColor clearColor];
        descripcion.font=[UIFont fontWithName:@"Helvetica" size:13];
        descripcion.lineBreakMode = UILineBreakModeWordWrap;
        descripcion.numberOfLines = 0;
        //descripcion.shadowOffset=CGSizeMake(0, 0.5);
        //descripcion.shadowColor=[UIColor colorWithWhite:1 alpha:1];
        descripcion.textColor=[UIColor colorWithRed:100.0f/255 green:100.0f/255 blue:100.0f/255 alpha:1.0];
        [cell addSubview:descripcion];   
    }
    
    UILabel *titulo=(UILabel*)([cell viewWithTag:5]);
    UILabel *descripcion= (UILabel*)([cell viewWithTag:6]);
    
    
    //Añadimos el texto de los títulos
    switch (indexPath.row) {
        case 0:titulo.text=NSLocalizedString(@"Pielmuyclara", nil); descripcion.text=NSLocalizedString(@"tono1", nil); break;
        case 1:titulo.text=NSLocalizedString(@"Pielclara", nil); descripcion.text=NSLocalizedString(@"tono2", nil); break;
        case 2:titulo.text=NSLocalizedString(@"Pielmclara", nil); descripcion.text=NSLocalizedString(@"tono3", nil); break;
        case 3:titulo.text=NSLocalizedString(@"Pielmosc", nil);descripcion.text=NSLocalizedString(@"tono4", nil); break;
        case 4:titulo.text=NSLocalizedString(@"Pielosc", nil); descripcion.text=NSLocalizedString(@"tono5", nil); break;
        case 5:titulo.text=NSLocalizedString(@"Pielmuyosc", nil);descripcion.text=NSLocalizedString(@"tono6", nil); break;
          default:           break;
    }
    
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    AppDelegate *delegado=([UIApplication sharedApplication]).delegate;
    ViewController *vistaprincipal=delegado.viewController;
    vistaprincipal.tono=[NSNumber numberWithInt:indexPath.row];
    ///Reproducimos sonido///
    [delegado playSound:@"touch1" :@"mp3"];
    //Guardamos el tono en el USERDEFAULT
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"Tonodepiel"];
    [defaults synchronize];
    
    [vistaprincipal actualizarcolortono]; //Actualizamos el tono el botón

    
    //Si se había obtenido el UV correctamente, actualizamos la interfaz, en caso contrario no
    if(vistaprincipal.UVobtenido)
    [vistaprincipal actualizarinterfaz];
    
}
-(IBAction)cerrarflotante:(id)sender{
    AppDelegate *delegado=([UIApplication sharedApplication]).delegate;
    ViewController *vistaprincipal=delegado.viewController;
    [vistaprincipal ocultartono];
}

@end
