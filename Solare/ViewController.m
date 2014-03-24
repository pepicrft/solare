//
//  ViewController.m
//  Solare
//
//  Created by Pedro Piñera Buendia on 27/05/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AlertViewController.h"
#import "InformacionViewController.h"
#import "ConsejosViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Flurry.h"
#import "XMLReader.h"
#import "CustomAlertView.h"
#import "OtrosViewController.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize locationManager, currentLocation,mapa;
@synthesize barra,guiaBarra,uvView,uvLabel,uvindexLabel,localizacionLabel,tmaxLabel,temperaturaLabel,escalalabel,placemark,clock;
@synthesize  alarmaView, progressBar, endOfAlarm, counter,alarmaButton, isAlarmActive,contadorlabel, startOfAlarm;
@synthesize tonoView,tono,UVI,UVobtenido;
@synthesize esdenoche;
@synthesize  tonocolor;
@synthesize  progreso,fpslabel,fpslabeltit;
@synthesize  alarmahiddenview;
@synthesize  scrollview,mainscrollview,otros;
@synthesize buscadorlabelview;
@synthesize alertamostrada;


-(void) viewDidAppear:(BOOL)animated{


}
-(void)viewWillAppear:(BOOL)animated{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Iniciamos los banners
    [self initiAdBanner];


    // Inicializamos el core Location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //Conriguramos mapa
    [mapa setShowsUserLocation:YES];



    //Tono de piel. Restauramos tono de piel desde userdefaults que ya había seleccionado el usuario previamente
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSNumber* tonodefault=[defaults objectForKey:@"Tonodepiel"];
    //Cargamos el tono de piel desde el USERDEFAULTS
    if(tonodefault==nil){
        tono=[NSNumber numberWithInt:0];
        [defaults setObject:tono forKey:@"Tonodepiel"];
        [defaults synchronize];
    }else {
        tono=tonodefault;
    }
    [self actualizarcolortono]; //Actualizamos el tono el botón


    //Configuramos la barra de progreso
    progressBar.progress=0.0;

    //Inicializamos la vista para seleccionar el tono de piel solo que la dejamos oculta por debajo de la vista principal
    tonoView=[[TonoViewController alloc] initWithNibName:@"TonoViewController" bundle:nil];
    tonoView.view.frame=CGRectMake(-3, self.view.frame.size.height, 325, 280);
    [self.view addSubview:tonoView.view];

    //Ocultamos el ActivityProgressIndicator
    progreso.hidden=YES;

    // Configuramos el scroll
        scrollview.contentSize=CGSizeMake(scrollview.frame.size.width*2, scrollview.frame.size.height);
        scrollview.delegate=self;
        otros=[[OtrosViewController alloc] initWithNibName:@"OtrosViewController" bundle:nil];
        otros.view.tag=1;
        //Añadimos la vista de otros mostrándola por detrás de la principal ( por las sombras ).
        [scrollview addSubview:otros.view];
        [scrollview bringSubviewToFront:mainscrollview];



    //////// ACCESIBILIDAD /////////////
    fpslabel.accessibilityLabel=[NSString stringWithFormat:@"El factor mínimo es %@",[Ciudad calcularfps:UVI :tono]];
    alarmahiddenview.isAccessibilityElement=NO;
    contadorlabel.isAccessibilityElement=NO;
    alarmaButton.isAccessibilityElement=NO;



}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;}


#pragma mark -
#pragma mark - Core Location

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%@",@"Posicion Actualizada");

    //Mostramos el ActivityProgressIndicator
    progreso.hidden=NO;
    [progreso startAnimating];

    //Detectamos si la precisión está por debajo de 70, en ese caso centraremos el mapa.

    if (newLocation.horizontalAccuracy < 70.0)
    {
        //- FLURRY -//
        [Flurry logEvent:@"Localizado correctamente"];
        [Flurry setLatitude:newLocation.coordinate.latitude
                           longitude:newLocation.coordinate.longitude
                  horizontalAccuracy:newLocation.horizontalAccuracy
                    verticalAccuracy:newLocation.verticalAccuracy];


        self.currentLocation = newLocation;
        //Centramos el mapa en la región de la localización
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = .025;
        span.longitudeDelta = .025;
        region.center = newLocation.coordinate;
        region.span = span;
        [mapa setRegion:region animated:YES];

        //Inicializamos el geocoder
        CLGeocoder *geocoder = [[CLGeocoder alloc] init]; //Inicializamos el geocoder para obtener datos de la localización ( Ciudad, País, Calle...)
        CLLocation *testlocation=[[CLLocation alloc] initWithLatitude:38.694567 longitude:1.464369];
        [geocoder reverseGeocodeLocation:newLocation
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           if (placemarks && placemarks.count > 0) {
                               placemark = [placemarks objectAtIndex:0];
                               NSLog(@"%@",placemark.country);
                               NSLog(@"%@",placemark.subAdministrativeArea);
                               //[self parsearjson]; //Si hemos localizado correctamente inicializamos el parseo
                               [NSThread detachNewThreadSelector:@selector(parsearjson) toTarget:self withObject:nil];

                               localizacionLabel.text=placemark.locality; //Actualizamos el label que muestra la ciudad, con la ciudad obtenida

                           }else{
                               //OCULTAMOS el ActivityProgressIndicator
                               [progreso stopAnimating];
                               progreso.hidden=YES;
                           }
                       }];
        [manager stopUpdatingLocation]; //Detenemos la localización ya que hemos obtenido la posición y no interesa seguir actualizando
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    //En el caso de que no hayamos podido obtener la posición por GPS, se detiene la localización, y además se avisa con un mensaje de error en una alerta
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        [self showAlert:[NSArray arrayWithObjects:@"Error obteniendo su posición", @"OK", @"Error", nil]];
    }
}

-(void) parsearjson{
        //Comprobaremos si ha pasado más de media hora desde la última captura, y si se ha desplazado más de x kilómetros
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

        //////////////////////////////////////////////////////////
        // LECTURA DEL FICHERO REGIONES.PLIST///
        NSString *filePathbundlereg = [[NSBundle mainBundle] pathForResource:@"Regiones" ofType:@"plist"];
        NSString *filePathDocumentreg=[NSString stringWithFormat:@"%@/Regiones.plist",documentpath];

        //Si se ha descargado correctamente el último usamos el último, en caso contrario, usaremos el local
        NSData *documentdatareg=[NSData dataWithContentsOfFile:filePathDocumentreg];
        NSMutableDictionary *regiones;
        if(documentdatareg){
            regiones=[NSMutableDictionary dictionaryWithContentsOfFile:filePathDocumentreg];
        } else{
            regiones=[NSMutableDictionary dictionaryWithContentsOfFile:filePathbundlereg];
        }

        //////////////////////////////////////////////////////////



        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDate *ultimafecha= [defaults objectForKey:@"Ultimafecha"];
        NSData *data = [defaults objectForKey:@"Ultimaposicion"];
        CLLocation *ultimaposicion= [NSKeyedUnarchiver unarchiveObjectWithData:data];
        BOOL ultimoUVobt=[defaults boolForKey:@"UltimoUVobt"];
        NSNumber *Tiempoentre=[preferencias objectForKey:@"Tiempoentre"];
        NSNumber *Distanciaentre=[preferencias objectForKey:@"Distanciaentre"];
        BOOL iteraUVerror=[[preferencias objectForKey:@"IteraUVerror"] boolValue];
        BOOL hayquedescargar; //Indica si tenemos que realizar la descarga


        /// COMPROBACIONES ////////
        if(iteraUVerror&&!ultimoUVobt){ // Si hubo un error al descargar UV se intentará de nuevo siempre que tengamos en el servidor marcadas las iteraciones
            //Lo que determina las iteraciones activadas, es que si hubo un error al obtener UV, cada vez que se abra la app se intentará descargar los datos de nuevo
            //aumentando el número de peticiones al servidor. Podemos configurarlo a no, ya que se entiende que si dió error, puede que pase un tiempo hasta que vuelva
            // a estar activo
            hayquedescargar=YES;
        }else{
            //En caso de que la última fecha almacenada, o de que la última posición almacenada sean distintos de nil. Comprobaremos si los intervalos son menores a los establecidos en Preferencias.
            if ((ultimafecha!=nil) || (ultimaposicion!=nil)){
                NSTimeInterval tiempotranscurrido = [ultimafecha timeIntervalSinceNow];
                double distanciatotal = [placemark.location distanceFromLocation:ultimaposicion];
                int tiempoenminutos=abs((int)(tiempotranscurrido/60)); //Calculamos el tiempo que ha pasado en minutos
                int distanciaenkm=abs((int)(distanciatotal/1000)); //Calculamos la distancia que se ha desplazado en kilómetros


                //Para que descarguemos datos, se tienen que cumplir que ambos sean mayores que el tiempo (o) la distancia establecidos
                if((tiempoenminutos>[Tiempoentre intValue])||(distanciaenkm>[Distanciaentre intValue])){
                    hayquedescargar=YES; //Se ha desplazado mucho o ha pasado mucho tiempo
                }
                else {
                    hayquedescargar=NO; //Se ha desplazado poco o ha pasado poco tiempo
                }

                //No tenemos datos últimos almacenados, luego hay que descargar
            }else{
                hayquedescargar = YES;
        }
        }


        //Ya sabemos si hay que descargar o no, en función de los datos que tenemos y de lo que nos indican los datos del servidor.
        //Si hay que descargar: Se descargan los datos, se actualizan las variables, y se guarda en el USERDefault
        //Si no hay que descargar: Se cargan los datos del user defaults



    //Buscamos la key correspondiente
    //Esto puede presentar algún problema ya que el nombre de la región ofrecido por el placemark, y el que tenemos en el .plist puede que no coincidan
    NSString *SP;
    for (NSString *key in [regiones allKeys]){
        if ([key caseInsensitiveCompare:placemark.subAdministrativeArea] == NSOrderedSame){
            SP=[regiones objectForKey:key];
        }
    }

    ///////////////////////////////////////////
    //Pasamos a descargar lo necesario ////////
    ///////////////////////////////////////////

        if(hayquedescargar){ // En este caso tenemos que descargar los datos


            //// Si SP fuera nil quiere decir que no ha encontrado la subAdministrativeArea en las keys, luego notificamos a Flurry para añadir lo necesario en Regiones.plist
            //- FLURRY -//
            if(SP==nil){
                UVobtenido=NO;
                NSDictionary *flurrydict=[[NSDictionary alloc] initWithObjectsAndKeys:placemark.subAdministrativeArea,@"Provincia", nil];
                [Flurry logEvent:@"No se ha encontrado la key en Regiones.plist" withParameters:flurrydict];
            } else //(SP!=nil)
            {
                //Descargamos la URL con el tiempo para obtener UV
                UVI=[Ciudad obtenerUV:SP];
                NSLog(@"SP: %@",SP);
                if(UVI==nil){
                    UVobtenido=NO;
                }else{
                    UVobtenido=YES;
                    UV=[UVI floatValue];
                }
                }


            //Guardamos UV y temp en el NSUserDefaults//
            //Guardamos :
            // El último UV obtenido
            // La última temperatura obtenida
            // Si se obtuvo UV la última vez
            // Última fecha de obtención del UV
            // Última posición de obtención de dicho UV
            [defaults setObject:[NSNumber numberWithFloat:UV] forKey:@"UltimoUV"];
            [defaults setObject:[NSNumber numberWithFloat:temperatura] forKey:@"Ultimatmp"];
            [defaults setBool:UVobtenido forKey:@"UltimoUVobt"];
            [defaults setObject:[NSDate date] forKey:@"Ultimafecha"];
            NSData *location = [NSKeyedArchiver archivedDataWithRootObject:placemark.location];
            [defaults setObject:location forKey:@"Ultimaposicion"];

        }else{ //// En este caso no hay que descargarlos si no que tenemos que recuperarlos

            UVobtenido=[defaults boolForKey:@"UltimoUVobt"];
            temperatura=[[defaults objectForKey:@"Ultimatmp"] floatValue];
            UV=[[defaults objectForKey:@"UltimoUV"] floatValue];

            }

    ///////////////////////////////////////////
    ///// DESCARGAMOS DATOS DE TEMPERATURA ////
    ///////////////////////////////////////////



    if(SP!=nil){
        //Descargamos el xml de yahoo para obtener la temperatura
        temperatura=[[Ciudad obtenerTemp:SP] floatValue];
   }

    //Mostramos las alertas oportunas si es de noche, o si no hay datos UV
    if (UVobtenido==NO){
        [self performSelector:@selector(showAlert:) onThread:[NSThread mainThread] withObject:[NSArray arrayWithObjects:NSLocalizedString(@"NoUVInfo", nil) , NSLocalizedString(@"Entendido", nil   ) , NSLocalizedString(@"Informacion", nil), nil] waitUntilDone:NO];
    }
    if(esdenoche==YES){
        [self performSelector:@selector(showAlert:) onThread:[NSThread mainThread] withObject:[NSArray arrayWithObjects:NSLocalizedString(@"Esdenoche", nil) , NSLocalizedString(@"Entendido", nil   ) , NSLocalizedString(@"Informacion", nil), nil] waitUntilDone:NO];

    }

    //Guardamos fecha y posición
    [defaults synchronize];

    //Guardamos el índice ultravioleta en un NSNumber
    UVI=[NSNumber numberWithFloat:UV];

    //Actualizamos la interfaz
    [self performSelectorOnMainThread:@selector(actualizarinterfaz) withObject:nil waitUntilDone:NO];
}

#pragma Actualizar Interfaz
-(void)actualizarinterfaz{


    //Actualizamos el fps
    fpslabel.text=[NSString stringWithFormat:@"%@",[Ciudad calcularfps:UVI :tono]];

    //OCULTAMOS el ActivityProgressIndicator
    [progreso stopAnimating];
    progreso.hidden=YES;

    //Actualizamos el label de la escala
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *escala =[defaults objectForKey:@"Escala"];
    if([escala isEqualToString:@"Celsius"]){
        escalalabel.text=@"ºC";
    }else {
        escalalabel.text=@"F";
    }

    ////////Si hemos obtenido los datos UV//////
    if (UVobtenido){
        //Actualizamos posiciones de la barra y de la guía
        CGRect barraFrame = [self.barra frame];
        barraFrame.origin.y = 192-UV*8.4;

        CGRect guiaBarraFrame = [self.guiaBarra frame];
        guiaBarraFrame.origin.y=barraFrame.origin.y;

        CGRect uvViewFrame = [self.uvView frame];
        uvViewFrame.origin.y=barraFrame.origin.y-59;


        //Color en función del índice siguiendo la tabla de la siguiente página
        UIColor *colorbarra;
        NSString *indiceuv;
        if (UV<3){
            colorbarra=[UIColor colorWithRed:119.0/255 green:200.0/255 blue:203.0/255 alpha:1.0];
            indiceuv=NSLocalizedString(@"UVMuybajo", nil);
        }
        if (UV>=3&&UV<5){
            colorbarra=[UIColor colorWithRed:862.0/255 green:142.0/255 blue:32.0/255 alpha:1.0];
            indiceuv=NSLocalizedString(@"UVBajo", nil) ;
        }
        if (UV>=5&&UV<7){
            colorbarra=[UIColor colorWithRed:179.0/255 green:87.0/255 blue:21.0/255 alpha:1.0];
            indiceuv=NSLocalizedString(@"UVModerado", nil);
        }
        if (UV>=7&&UV<10){
            colorbarra=[UIColor colorWithRed:178.0/255 green:36.0/255 blue:7.0/255 alpha:1.0];
            indiceuv=NSLocalizedString(@"UVAlto", nil);
        }
        if (UV>=10){
            colorbarra=[UIColor colorWithRed:177.0/255 green:44.0/255 blue:143.0/255 alpha:1.0];
            indiceuv=NSLocalizedString(@"UVMuyalto", nil);
        }

        //Animaciones

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        self.barra.frame=barraFrame;
        self.guiaBarra.frame=guiaBarraFrame;
        self.uvView.frame=uvViewFrame;
        self.barra.backgroundColor=colorbarra;

        //Actualizamos el label de UV
        uvindexLabel.text=indiceuv;
        uvLabel.text=[NSString stringWithFormat:@"%g",UV];


        //Calculamos tmax que puede permanecer al sol
        tmax=[[Ciudad calculotmax:UVI :tono] intValue];
        if((int)UV==0) //No hay límite de tiempo (UV=0)
            tmaxLabel.text=[NSString stringWithFormat:@"NL"];
        else
            tmaxLabel.text=[NSString stringWithFormat:@"%d",(int)tmax];




    }else{ ////////// NO TENEMOS DATOS DE UV (UVobtenido=no)

        //[self showAlert:[NSArray arrayWithObjects:NSLocalizedString(@"NoUVInfo", nil) ,NSLocalizedString(@"Entendido", nil   ) ,NSLocalizedString(@"Informacion", nil), nil]];
        tmaxLabel.text=[NSString stringWithFormat:@"Err"];
        uvindexLabel.text=NSLocalizedString(@"Sindatos", nil);
        uvLabel.text=@"";
    }

    //Si es de noche mostramos una alerta indicándolo
    if (esdenoche){
        //[self performSelector:@selector(showAlert:) withObject:[NSArray arrayWithObjects:NSLocalizedString(@"Esdenoche", nil) ,NSLocalizedString(@"Entendido", nil   ) ,NSLocalizedString(@"Informacion", nil), nil] afterDelay:0.5];
    }


    //En un caso o en el otro actualizaremos el label de la temperatura
    temperaturaLabel.text=[NSString stringWithFormat:@"%g",temperatura];

    [UIView commitAnimations];

    //Configuramos accesibilidad
    [self confaccesibilidad];
    [self lectura]; //Lee información de los datos obtenidos

}

-(void)calculotmax:(NSNumber*)frecuencia{
    //Lo calcularemos a partir del array que creamos en el arranque de programa

    AppDelegate *delegado =[[UIApplication sharedApplication] delegate];
    NSArray *tiemposmaximos= delegado.maximumTimes;
    if((int)UV>0){
        NSArray *uvarray= [tiemposmaximos objectAtIndex:(int)UV-1];
        tmax = [[uvarray objectAtIndex:[frecuencia intValue]] floatValue];

    }
}

#pragma mark - Acciones botones
-(IBAction)mostraralarma:(id)sender{

    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch2" :@"mp3"];
    /////////////

    [UIView animateWithDuration:0.5 animations:^{
        CGRect alarmaframe= alarmaView.frame;
        if(alarmaframe.origin.y<0)//Mostramos alarma
        {
            //ACCESIBILIDAD
            contadorlabel.isAccessibilityElement=YES;
            alarmaButton.isAccessibilityElement=YES;

            clock.accessibilityHint=NSLocalizedString(@"APAlarm2", nil);

            if (isAlarmActive) {
                [clock setImage:[UIImage imageNamed:@"dclock2.png"] forState:UIControlStateNormal];

            }else{
            [clock setImage:[UIImage imageNamed:@"dclock.png"] forState:UIControlStateNormal];
            }
            alarmaframe.origin.y=alarmaframe.origin.y+55;
            alarmaView.frame=alarmaframe;

        }
        else
        {       //Ocultamos alarma

            //ACCESIBILIDAD
            contadorlabel.isAccessibilityElement=NO;
            alarmaButton.isAccessibilityElement=NO;

            clock.accessibilityHint=NSLocalizedString(@"APAlarm1", nil);


            if (isAlarmActive) {
                [clock setImage:[UIImage imageNamed:@"clock2.png"] forState:UIControlStateNormal];

            }else{
                [clock setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];
            }
            alarmaframe.origin.y=alarmaframe.origin.y-55;
            alarmaView.frame=alarmaframe;

        }
    }];
}
-(IBAction)activaralarma:(id)sender{ //Activación de la alarma


    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch1" :@"mp3"];
    /////////////

    if(!esdenoche){

    if(!UVobtenido){

        [self showAlert:[NSArray arrayWithObjects:NSLocalizedString(@"Nohaydatos", nil) , NSLocalizedString(@"OK", nil) , @"Error", nil]];
    }
    else if((int)UV==0){ //No hay límite de exposición al sol
        [self showAlert:[NSArray arrayWithObjects:NSLocalizedString(@"Nohayriesgo", nil) , NSLocalizedString(@"Entendido", nil), NSLocalizedString(@"Informacion", nil), nil]];
    }
    else{ //Si hay limite, luego podemos activar la alarma

    if(isAlarmActive ==NO)
    {
        NSLog(@"Activamos la alarma");
        alarmaButton.accessibilityHint=NSLocalizedString(@"APAlarm4", nil);

        //Mostramos una alerta
        [self showAlert:[NSArray arrayWithObjects:NSLocalizedString(@"Advertencia", nil) , NSLocalizedString(@"Entendido", nil) , NSLocalizedString(@"Importante", nil), nil]];
        //Actualizamos las imágenes del botón
        [self.clock setImage:[UIImage imageNamed:@"clock2.png"] forState:UIControlStateNormal];
        [self.clock setImage:[UIImage imageNamed:@"dclock2.png"] forState:UIControlStateHighlighted];


    startOfAlarm = [[NSDate alloc] init];
    endOfAlarm =[startOfAlarm dateByAddingTimeInterval:60 * tmax];
        [self startCounter];
    isAlarmActive =YES;

    ///// Iniciamos la notificación local //////
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        [localNotification setFireDate:endOfAlarm];
        [localNotification setAlertAction:@"Launch"];
        [localNotification setAlertBody:[NSString stringWithFormat:@"%@ %d %@",NSLocalizedString(@"tmax1", nil),(int)(tmax),NSLocalizedString(@"tmax2", nil)]];
        localNotification.soundName=@"sirena.caf";
        [localNotification setHasAction: YES];
        [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    ///////////////////

    }else { //La alarma ya estaba activa la deshabilitamos

        NSLog(@"Desactivamos la alarma");
        alarmaButton.accessibilityHint=NSLocalizedString(@"APAlarm3", nil);


        //Actualizamos las imágenes del botón
        [self.clock setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];
        [self.clock setImage:[UIImage imageNamed:@"dclock.png"] forState:UIControlStateHighlighted];
        [alarmaButton setImage:[UIImage imageNamed:@"Comenzar.png"] forState:UIControlStateNormal];
        [alarmaButton setImage:[UIImage imageNamed:@"dComenzar.png"] forState:UIControlStateHighlighted];

        [[UIApplication sharedApplication] cancelAllLocalNotifications];

        [counter invalidate];
        [contadorlabel setText:@""];
        progressBar.progress=0.0;
        isAlarmActive =NO;

    }
    }
    }else{ //Es de noche

        [self showAlert:[NSArray arrayWithObjects:NSLocalizedString(@"Alarmadenoche", nil), NSLocalizedString(@"OK", nil), NSLocalizedString(@"Informacion", nil), nil]];
    }
}
-(void)startCounter
{
    counter =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(actualizarcontador:) userInfo:nil repeats:YES];
}
-(void)actualizarcontador:(NSTimer*)timer{
    NSTimeInterval tiempototal= [endOfAlarm timeIntervalSinceDate:startOfAlarm];
    NSTimeInterval cuenta=[endOfAlarm timeIntervalSinceDate:[[NSDate alloc] init]];

    //Actualizamos el porcentaje de la barra de progreso
    [progressBar setProgress:(tiempototal - cuenta) / tiempototal animated:YES];


    if(cuenta>0){ //Hay que actualizar porque todavía no ha llegado a cero la cuenta
        //Actualizamos las imágenes del botón
        alarmaButton.accessibilityHint=NSLocalizedString(@"APAlarm4", nil);

        [self.clock setImage:[UIImage imageNamed:@"clock2.png"] forState:UIControlStateNormal];
        [self.clock setImage:[UIImage imageNamed:@"dclock2.png"] forState:UIControlStateHighlighted];
        [alarmaButton setImage:[UIImage imageNamed:@"Reiniciar.png"] forState:UIControlStateNormal];
        [alarmaButton setImage:[UIImage imageNamed:@"dReiniciar.png"] forState:UIControlStateHighlighted];


        int horas= (int)(cuenta/3600);
        int minutos= (int)((cuenta-horas*3600)/60);
        int segundos= (int)(cuenta-horas*3600-minutos*60);
        NSString *cuentastring;
        if(horas==0){
            cuentastring=[NSString stringWithFormat:@"%d min, %d seg",minutos,segundos];
        contadorlabel.accessibilityLabel=[NSString stringWithFormat:@"%@%d %@, %d %@",NSLocalizedString(@"APCount1", nil),minutos,NSLocalizedString(@"APCount3", nil),segundos,NSLocalizedString(@"APCount4", nil)];
        }
        else {
            cuentastring=[NSString stringWithFormat:@"%d h, %d min, %d seg",horas,minutos,segundos];
            contadorlabel.accessibilityLabel=[NSString stringWithFormat:@"%@%d %@,%d %@, %d %@",NSLocalizedString(@"APCount1", nil),horas,NSLocalizedString(@"APCount1", nil),minutos,NSLocalizedString(@"APCount3", nil),segundos,NSLocalizedString(@"APCount4", nil)];
        }
        contadorlabel.text=cuentastring;

    }else{
        alarmaButton.accessibilityHint=NSLocalizedString(@"APAlarm3", nil);


        //La cuenta es menor que cero luego invalidamos el counter y borramos el label
        //Actualizamos las imágenes del botón
        [self.clock setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];
        [self.clock setImage:[UIImage imageNamed:@"dclock.png"] forState:UIControlStateHighlighted];

        [counter invalidate];
        contadorlabel.text=@"";
        progressBar.progress=0.0;
        [alarmaButton setImage:[UIImage imageNamed:@"Comenzar.png"] forState:UIControlStateNormal];
        [alarmaButton setImage:[UIImage imageNamed:@"dComenzar.png"] forState:UIControlStateHighlighted];

        [[UIApplication sharedApplication] cancelAllLocalNotifications];

        isAlarmActive =NO;
        }
}


#pragma mark - Mostrar alerta
-(void)showAlert:(NSArray*)mensajes{

    if(!alertamostrada){
        CustomAlertView *alertaa=[[CustomAlertView alloc] initWithTitle:[mensajes objectAtIndex:2] message:[mensajes objectAtIndex:0] delegate:self cancelButtonTitle:[mensajes objectAtIndex:1] otherButtonTitles:nil];
            [alertaa show];

    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView{
    alertamostrada=YES;
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    alertamostrada=NO;
}




#pragma  BOTONES INFERIORES
-(IBAction)mostrarconsejos:(id)sender{
    //- FLURRY -//
    [Flurry logEvent:@"Accede a consejos"];

    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch1" :@"mp3"];
    /////////////
    ConsejosViewController *consejos=[[ConsejosViewController alloc] initWithNibName:@"ConsejosViewController" bundle:nil];
    UINavigationController *navigation =[[UINavigationController alloc] initWithRootViewController:consejos];
    [navigation.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:navigation animated:YES completion:nil];
}
-(IBAction)mostrarinformacion:(id)sender{
    //- FLURRY -//
    [Flurry logEvent:@"Accede a información"];

    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch1" :@"mp3"];
    /////////////
    InformacionViewController *informacion=[[InformacionViewController alloc] init];
    [informacion setModalPresentationStyle:UIModalPresentationFullScreen];
    [informacion setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentModalViewController:informacion animated:YES];


}


#pragma mark TONO Acciones
-(IBAction)seleccionartono:(id)sender{
    //- FLURRY -//
    [Flurry logEvent:@"El usuario quiere seleccionar tono de piel"];

    //Mostramos la ventana para seleccionar el tono de piel
    if(tonoView.view.frame.origin.y>=self.view.frame.size.height)
        [self mostrartono];
    else {
        [self ocultartono];
    }
}
-(void)mostrartono{
    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch2" :@"mp3"];
    //Añadimos una vista transaparete que cubra todo
    UIView *transparente=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 480)];
    transparente.backgroundColor=[UIColor colorWithWhite:0.0f alpha:1];
    transparente.alpha=0.0f;
    transparente.tag=100;
    [self.view addSubview:transparente];


    [UIView animateWithDuration:0.5 animations:^{
    [self.view bringSubviewToFront:tonoView.view];
    tonoView.view.frame=CGRectMake(-3, self.view.frame.size.height-255, 325, 280);

    transparente.alpha=0.2;
    }];


    //Accesibilidad
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Seleccione tono de piel");
}
-(void)ocultartono{
    ///Reproducimos sonido///
    AppDelegate *delegado=[[UIApplication sharedApplication] delegate];
    [delegado playSound:@"touch2" :@"mp3"];
    [UIView animateWithDuration:0.5 animations:^{
    [[self.view viewWithTag:100] setAlpha:0.0f];
    tonoView.view.frame=CGRectMake(-3, self.view.frame.size.height, 325, 280);

    } completion:^(BOOL finished) {
        [[self.view viewWithTag:100] removeFromSuperview];

    }];
}

-(void)actualizarcolortono{
    switch ([tono intValue]) {
        case 0:
            [tonocolor setBackgroundColor:[UIColor colorWithRed:249.0f/255 green:239.0f/255 blue:229.0f/255 alpha:1.0]];
            break;
        case 1:
            [tonocolor setBackgroundColor:[UIColor colorWithRed:249.0f/255 green:224.0f/255 blue:177.0f/255 alpha:1.0]];
            break;
        case 2:
            [tonocolor setBackgroundColor:[UIColor colorWithRed:238.0f/255 green:195.0f/255 blue:130.0f/255 alpha:1.0]];
            break;
        case 3:
            [tonocolor setBackgroundColor:[UIColor colorWithRed:208.0f/255 green:130.0f/255 blue:106.0f/255 alpha:1.0]];
            break;
        case 4:
            [tonocolor setBackgroundColor:[UIColor colorWithRed:200.0f/255 green:104.0f/255 blue:56.0f/255 alpha:1.0]];
            break;
        case 5:
            [tonocolor setBackgroundColor:[UIColor colorWithRed:158.0f/255 green:94.0f/255 blue:6.0f/255 alpha:1.0]];
            break;

        default:
            [tonocolor setBackgroundColor:[UIColor colorWithRed:249.0f/255 green:224.0f/255 blue:177.0f/255 alpha:1.0]];
            break;
    }

}


//Accesibilidad
-(void)confaccesibilidad{
    temperaturaLabel.isAccessibilityElement=YES;
    tmaxLabel.isAccessibilityElement=YES;
    uvView.isAccessibilityElement=YES;
    fpslabel.isAccessibilityElement=YES;


    temperaturaLabel.accessibilityLabel=[NSString stringWithFormat:@"%@%@ %@",NSLocalizedString(@"AP1", nil),temperaturaLabel.text,escalalabel.text];
    if(![tmaxLabel.text isEqualToString:@"NL"]){
    tmaxLabel.accessibilityLabel=[NSString stringWithFormat:@"%@%@ %@",NSLocalizedString(@"AP3", nil),tmaxLabel.text,NSLocalizedString(@"AP4", nil)];
    }else{
        tmaxLabel.accessibilityLabel=NSLocalizedString(@"AP7", nil);
    }
    uvView.accessibilityLabel=[NSString stringWithFormat:@"%@%@ %@%@",NSLocalizedString(@"AP5", nil),placemark.subLocality,NSLocalizedString(@"AP6", nil),uvLabel.text];
    fpslabel.accessibilityLabel=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"AP8", nil),fpslabel.text];
}
-(void)lectura{
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"%@%@. %@. %@.",NSLocalizedString(@"AP10", nil),uvView.accessibilityLabel,temperaturaLabel.accessibilityLabel,tmaxLabel.accessibilityLabel]);
}

#pragma mark - Banner views
-(void)initiAdBanner
{
    if (!iAdBannerView)
    {
        // Get the size of the banner in portrait mode
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        // Create a new bottom banner, will be slided into view
        iAdBannerView = [[ADBannerView alloc]initWithFrame:CGRectMake(0.0,
                                                                      -bannerSize.height,
                                                                      bannerSize.width,
                                                                      bannerSize.height)];
        iAdBannerView.delegate = self;
        iAdBannerView.hidden = TRUE;
        iAdBannerView.accessibilityHint=NSLocalizedString(@"AP9", nil);
        [self.view addSubview:iAdBannerView];
    }
}
-(void)hideBanner:(UIView*)banner
{
    if (banner &&
        ![banner isHidden])
    {
        [UIView beginAnimations:@"animatedBannerOff" context:nil];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = TRUE;
    }
}

-(void)showBanner:(UIView*)banner
{
    if (banner &&
        [banner isHidden])
    {
        [UIView beginAnimations:@"animatedBannerOn" context:nil];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = FALSE;
    }
}
///Delegado de iAd

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self showBanner:iAdBannerView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    // Only request adMob when iAd did fail
    [self hideBanner:iAdBannerView];
}



#pragma mark - Scroll View Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    otros.view.frame=CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height);

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int pagina;
    pagina=scrollView.contentOffset.x/scrollView.frame.size.width;
    if(pagina==0){
        [UIView animateWithDuration:0.5 animations:^{
            alarmaView.frame=CGRectMake(0, -34, alarmaView.frame.size.width, alarmaView.frame.size.height);
            fpslabel.alpha=1.0;
            fpslabeltit.alpha=1.0;
            buscadorlabelview.alpha=0.0;
            otros.cargando.alpha=0.0;

        }];
           }
    else if (pagina==1){
        [UIView animateWithDuration:0.5 animations:^{
            alarmaView.frame=CGRectMake(0,-alarmaView.frame.size.height,alarmaView.frame.size.width, alarmaView.frame.size.height);
            fpslabel.alpha=0.0;
            fpslabeltit.alpha=0.0;
            buscadorlabelview.alpha=1.0;
            if(!isAlarmActive){
                [clock setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];
            }
     }];
    }
}






@end


