//
//  Consejo1ViewController.m
//  Solare
//
//  Created by Pedro Piñera Buendia on 04/06/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import "Consejo1ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"


@interface Consejo1ViewController ()

@end

@implementation Consejo1ViewController
@synthesize imagen,scroll,vista;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
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
-(void)viewDidAppear:(BOOL)animated{
    //Registramos que se ha mostrado la vista Consejo Detalle 0,1,....
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    ///Añadimos borde a la imagen
    CALayer* layer = [self.imagen layer];
    [layer setBorderWidth:1];
    //[self.imagen setContentMode:UIViewContentModeCenter];
    [layer setBorderColor:[UIColor whiteColor].CGColor];
    [layer setShadowOffset:CGSizeMake(-3.0, 3.0)];
    [layer setShadowRadius:3.0];
    [layer setShadowOpacity:0.5];
    
    //Ponemso el título al navigation
    NSLog(@"Número de vista: %d",[vista  intValue]);
    switch ([vista intValue]) {
           
        case 0:
            self.title=NSLocalizedString(@"Introduccion", nil);
            break;
        case 1:
            self.title=NSLocalizedString(@"Indices", nil);
            break;
        case 2:
            self.title=NSLocalizedString(@"Resistenciaagua", nil);
            break;
        case 3:
            self.title=NSLocalizedString(@"Elegfotoprotector", nil);
            break;
        case 4:
            self.title=NSLocalizedString(@"Advertencias", nil);
            break;
        case 5:
            self.title=NSLocalizedString(@"Infantil", nil);
            break;
        case 6:
            self.title=NSLocalizedString(@"Frecuentes", nil);
            break;
        case 7:
            self.title=NSLocalizedString(@"Agradecimientos", nil);
            break;
        default:
            break;
    }
    
    //Inicializamos
    imagenoculta=NO;
    anteriory=0;
    
   
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float diferencia = scrollView.contentOffset.y-anteriory;
    anteriory=scrollView.contentOffset.y;


    if(diferencia>0){ 
        if(imagen.frame.origin.y>-186){
           
            CGRect imagenframe=imagen.frame;
            imagenframe.origin.y=imagenframe.origin.y-diferencia;
            imagen.frame=imagenframe;
            
            CGRect scrollframe=scrollView.frame;
            CGRect newscroll=CGRectMake(scrollframe.origin.x, scrollframe.origin.y-diferencia, scrollframe.size.width, scrollframe.size.height+diferencia);
            scrollView.frame=newscroll;
       
        }
      
    }
    if(diferencia<0){
        if(imagen.frame.origin.y<=0){
            CGRect scrollframe=scrollView.frame;
            CGRect imagenframe=imagen.frame;
            CGRect newscroll;
            
            if(imagenframe.origin.y-diferencia<0){
            imagenframe.origin.y=imagenframe.origin.y-diferencia;
            newscroll=CGRectMake(scrollframe.origin.x, imagenframe.size.height+imagenframe.origin.y, scrollframe.size.width, scrollframe.size.height+diferencia);

            }else {
                imagenframe.origin.y=0;
                newscroll=CGRectMake(scrollframe.origin.x, imagenframe.size.height+imagenframe.origin.y, scrollframe.size.width, self.view.frame.size.height-imagenframe.size.height);

            }
            imagen.frame=imagenframe;
            
            scrollView.frame=newscroll;
            
        }
    } 
}
    
@end
