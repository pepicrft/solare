//
//  OtrosViewController.m
//  Solare
//
//  Created by Pedro Piñera Buendia on 18/07/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import "OtrosViewController.h"
#import "Ciudad.h"
#import "AppDelegate.h"
#import "CustomAlertView.h"

@interface OtrosViewController ()

@end

@implementation OtrosViewController
@synthesize searchBar,searchDisplayController;
@synthesize resultados;
@synthesize resultadosView;
@synthesize cargando;
@synthesize temperatura,tiempomaximo,fps,indice,ciudadmdict,ciudadlabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Añadimos el icono de cargando pero oculto
    cargando=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    cargando.frame=CGRectMake(self.view.frame.size.width/2,self.view.frame.size.height/2, 0, 0);
    cargando.alpha=0.0;
    [self.view addSubview:cargando];

    

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
    if([resultados count]==0){
        return 1;
    }else
        return [resultados count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.text = nil;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        //Añadimos el Label de la ciudad
        UILabel *ciudad =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width/2-10, cell.frame.size.height)];
        ciudad.tag=1;
        ciudad.font=[UIFont fontWithName:@"Helvetica-Bold" size:19];
        ciudad.textColor=[UIColor whiteColor];
        ciudad.backgroundColor=[UIColor clearColor];
        ciudad.shadowColor=[UIColor darkGrayColor];
        ciudad.shadowOffset=CGSizeMake(0, 1);
        [cell addSubview:ciudad];
        
        //Añadimos el Label del país
        UILabel *pais =[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-cell.frame.size.width/2+10, 0, cell.frame.size.width/2-10-15, cell.frame.size.height)];
        pais.tag=2;
        pais.font=[UIFont fontWithName:@"Helvetica" size:16];
        pais.textColor=[UIColor colorWithRed:20.0f/255 green:20.0f/255 blue:20.0f/255 alpha:1.0];
        pais.backgroundColor=[UIColor clearColor];
        pais.textAlignment=UITextAlignmentRight;
        [cell addSubview:pais];
        
        
    }
    
    if (cell) {
        //customization
        UILabel *ciudad= (UILabel*)[cell viewWithTag:1] ;
        UILabel *pais= (UILabel*)[cell viewWithTag:2] ;

        if([resultados count]!=0){
        ciudad.text = [[resultados objectAtIndex:indexPath.row] objectForKey:@"name"];
        pais.text = [[[resultados objectAtIndex:indexPath.row] objectForKey:@"countryName"] capitalizedString];
        }else{
        ciudad.text=@"Sin resultados";
        pais.text=@"";
        }
    }
    
    return cell;
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
    [self.searchDisplayController setActive:NO animated:YES];
    //Iniciamos la descarga de los contenidos de esa ciudad
    ciudadsel=[[resultados objectAtIndex:indexPath.row] objectForKey:@"name"];
    [NSThread detachNewThreadSelector:@selector(descargardatosciudad:) toTarget:self withObject:[[resultados objectAtIndex:indexPath.row] objectForKey:@"key"]];
    resultados=nil;
    
    //Reproducimos cargando
    [cargando setAlpha:1.0];
    [cargando startAnimating];

    
}

-(void)buscarciudad:(NSArray*)parametros{
    AppDelegate *delegado =[[UIApplication sharedApplication] delegate];
    if([delegado connectedToNetwork]){
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
    ////////////////
    NSError *sperror;
    NSString *urlstring=[[NSString stringWithFormat:@"http://wxdata.weather.com/wxdata/ta/%@.js?max=10&key=%@",[parametros objectAtIndex:0],[preferencias objectForKey:@"Weatherapi"]] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSData *spdata=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]];
    NSDictionary *spdatadict=[NSJSONSerialization JSONObjectWithData:spdata options:kNilOptions error:&sperror];
    
    //Extraemos de todos los resultados aquellos que sean de type 1 ( ciudad )
    NSMutableArray *ciudades=[[NSMutableArray alloc] init];
    for (int i=0;i<[[spdatadict objectForKey:@"results"] count];i++){
        NSDictionary *city= [[spdatadict objectForKey:@"results"] objectAtIndex:i];
        if([[city objectForKey:@"type"] intValue]==1){
            [ciudades addObject:city];
        }
    }
    
    resultados=ciudades;
    
    NSLog(@"%@",resultados);
    //Recargamos la tabla
    [self.searchDisplayController.searchResultsTableView reloadData];
    }
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    
    NSString *busqueda=[[NSString alloc] initWithData:[self.searchDisplayController.searchBar.text
                                                        dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]
                                              encoding:NSASCIIStringEncoding];
    [NSThread detachNewThreadSelector:@selector(buscarciudad:) toTarget:[NSArray arrayWithObjects:busqueda , nil] withObject:nil];
    return NO;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    NSString *busqueda=[[NSString alloc] initWithData:[searchString
                                                        dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]
                                              encoding:NSASCIIStringEncoding];
    [NSThread detachNewThreadSelector:@selector(buscarciudad:) toTarget:self withObject:[NSArray arrayWithObjects:busqueda, nil]];
    return NO;
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //Configuramos la tabla del searchdisplaycontroller
    searchDisplayController.searchResultsTableView.backgroundColor=[UIColor clearColor];
    searchDisplayController.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    //Ocultamos la vista del resultado
    [UIView animateWithDuration:0.5 animations:^{
        resultadosView.alpha=0.0;
    }];
    
    return YES;
    
    UITableView *tableView = self.searchDisplayController.searchResultsTableView;
    for( UIView *subview in tableView.subviews ) {
        if( [subview class] == [UILabel class] ) {
            UILabel *lbl = (UILabel*)subview; // sv changed to subview.
            lbl.textColor=[UIColor whiteColor];
        }
    }
}

-(void)actualizarinterfaz{
    //Paramos cargando y ocultamos
    [cargando stopAnimating];
    [cargando setAlpha:0.0];
    
    if(ciudadmdict!=nil){
        
        fps.text=[ciudadmdict objectForKey:@"fps"];
        
        //Actualizamos el label con el índice
        indice.text=[[ciudadmdict objectForKey:@"indice"] stringValue];
    
        //Actualización del label del tiempo máximo
        if([[ciudadmdict objectForKey:@"indice"] intValue]!=0){
        tiempomaximo.text=[NSString stringWithFormat:@"%d mins",[[ciudadmdict objectForKey:@"tiempomaximo"] intValue]];
        }else{
            tiempomaximo.text=@"NL";
        }
       
   
        //Actualización del label de la ciudad
        ciudadlabel.text=ciudadsel;
    
        
        //Actualización del label de la temperatura
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *escala =[defaults objectForKey:@"Escala"];
        temperatura.text=[NSString stringWithFormat:@"%@ %@",[[ciudadmdict objectForKey:@"temperatura"] stringValue],[escala isEqualToString:@"Celsius"]?@"ºC":@"F"];
        
        
        //Animación
        [UIView animateWithDuration:0.5 animations:^{
            resultadosView.alpha=1.0;
        }];
        
        //Lectura de datos tras la actualizaciónd de la interfaz
        [self lecturadedatos];
    }
}
-(void)descargardatosciudad:(NSString*)SP{
    ciudadmdict=[[NSMutableDictionary alloc] init];
    
    //Descargamos el indice y lo guardamos en el diccionario
    id index=[Ciudad obtenerUV:SP];
    if(index!=nil)
    [ciudadmdict setObject:index forKey:@"indice"];
    
    //Descargamos la temperatura y la guardamos en el diccionario
    id temp=[Ciudad obtenerTemp:SP];
    if(temp!=nil)
    [ciudadmdict setObject:temp forKey:@"temperatura"];
    
    //Calculamos cuanto vale tmax en función del tono de piel
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSNumber* tonodefault=[defaults objectForKey:@"Tonodepiel"];
    NSNumber *tmax=[Ciudad calculotmax:[ciudadmdict objectForKey:@"indice"] :tonodefault];
    if(tmax!=nil){
    [ciudadmdict setObject:tmax forKey:@"tiempomaximo"];
    }
    
    //Calculamos el fps mínimo
    id fpsmin=[Ciudad calcularfps:[ciudadmdict objectForKey:@"indice"] :tonodefault];
    [ciudadmdict setObject:fpsmin forKey:@"fps"];
    
    
    [self actualizarinterfaz];
}
-(void)lecturadedatos{
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"%@. %@%@%@%@. %@%@. %@%@. %@%@",NSLocalizedString(@"AP10", nil),NSLocalizedString(@"AP5", nil),ciudadlabel.text,NSLocalizedString(@"AP6", nil),indice.text,NSLocalizedString(@"AP1", nil),temperatura.text,NSLocalizedString(@"AP8", nil),fps.text,NSLocalizedString(@"AP3", nil),tiempomaximo.text]);
}


@end
