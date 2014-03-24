//
//  ViewController.h
//  Solare
//
//  Created by Pedro Piñera Buendia on 27/05/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "YLProgressBar.h"
#import "AlertViewController.h"
#import "TonoViewController.h"
#import <iAd/iAd.h>
#import "OtrosViewController.h"
#import "Ciudad.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate,ADBannerViewDelegate,UIScrollViewDelegate>{
   //Core Location
    CLLocationManager *locationmanager;
    CLLocation *currentLocation;
    IBOutlet MKMapView *mapa;
    CLPlacemark *placemark;

    //Forecast
    float UV;
    float tmax;
    float tmin;
    float temperatura;
    NSNumber *UVI;

    //Interfaz
    IBOutlet UIView *barra;
    IBOutlet UIView *guiaBarra;
    IBOutlet UIView *uvView;
    IBOutlet UILabel *uvLabel;
    IBOutlet UILabel *uvindexLabel;
    IBOutlet UILabel *localizacionLabel;
    IBOutlet UILabel *tmaxLabel;
    IBOutlet UILabel *temperaturaLabel;
    IBOutlet UILabel *escalalabel;
    IBOutlet UIButton *clock;
    IBOutlet UIActivityIndicatorView *progreso;


    //Alarma
    IBOutlet UIButton *alarmaButton;
    IBOutlet UIView *alarmaView;
    IBOutlet YLProgressBar *progressBar;
    NSDate *endOfAlarm;
    NSDate *startOfAlarm;
    BOOL isAlarmActive;
    NSTimer *counter;
    IBOutlet UILabel *contadorlabel;
    BOOL UVobtenido;
    BOOL esdenoche;
    UIView *alarmahiddenview;

    //Tono de piel
    NSNumber *tono;
    TonoViewController *tonoView;
    IBOutlet UIImageView *tonocolor;

    //Calcular el FPS
    IBOutlet UILabel *fpslabel;
    IBOutlet UILabel *fpslabeltit;

    //Publicidad
    ADBannerView *iAdBannerView;

    //Scrollview
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIView *mainscrollview;
    OtrosViewController *otros;

    //Buscador
    IBOutlet UIView* buscadorlabelview;

    //Alerta
    BOOL alertamostrada;


}

-(void) parsearjson;
-(void)actualizarinterfaz;
-(IBAction)mostraralarma:(id)sender;
-(IBAction)activaralarma:(id)sender;
-(void)startCounter;
-(void)showAlert:(NSArray*)mensajes;


//Acciones botones
-(IBAction)mostrarconsejos:(id)sender;
-(IBAction)mostrarinformacion:(id)sender;
-(IBAction)seleccionartono:(id)sender;

//Mostrar/ocultar Tono
-(void)mostrartono;
-(void)ocultartono;
-(void)actualizarcolortono;


//Accesibilidad
-(void)confaccesibilidad;
-(void)lectura;






//Core Location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic,retain)IBOutlet MKMapView *mapa;
@property (nonatomic,retain)    IBOutlet UIView *barra;
@property (nonatomic,retain)    IBOutlet UIView *guiaBarra;
@property (nonatomic,retain)    IBOutlet UIView *uvView;
@property (nonatomic,retain)    IBOutlet UILabel *uvLabel;
@property (nonatomic,retain)    IBOutlet UILabel *uvindexLabel;
@property (nonatomic,retain)    IBOutlet UILabel *localizacionLabel;
@property (nonatomic,retain)    IBOutlet UILabel *temperaturaLabel;
@property (nonatomic,retain)    IBOutlet UILabel *tmaxLabel;
@property (nonatomic,retain) IBOutlet UILabel *escalalabel;
@property (nonatomic,retain)     IBOutlet UIView *alarmaView;
@property (nonatomic,retain)     IBOutlet YLProgressBar *progressBar;
@property (nonatomic,retain)     NSDate *endOfAlarm;
@property (nonatomic,retain)     NSDate *startOfAlarm;
@property (nonatomic,retain)     NSTimer *counter;
@property (nonatomic,retain)     IBOutlet UIButton *alarmaButton;
@property (nonatomic)     BOOL isAlarmActive;
@property (nonatomic)     BOOL esdenoche;
@property (nonatomic,retain)    IBOutlet UILabel *contadorlabel;
@property (nonatomic,retain)     CLPlacemark *placemark;
@property (nonatomic,retain) IBOutlet UIButton *clock;
@property (strong,nonatomic) TonoViewController *tonoView;
@property (strong,nonatomic)     NSNumber *tono;
@property (strong,nonatomic) NSNumber *UVI;
@property (nonatomic) BOOL UVobtenido;
@property (nonatomic,strong)     IBOutlet UIImageView *tonocolor;
@property (nonatomic,retain)     IBOutlet UIActivityIndicatorView *progreso;
@property (nonatomic,retain)     IBOutlet UILabel *fpslabel;
@property (nonatomic,retain)     IBOutlet UILabel *fpslabeltit;
@property (nonatomic,retain) IBOutlet     UIView *alarmahiddenview;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic,retain) IBOutlet UIView *mainscrollview;
@property (nonatomic,retain)     OtrosViewController *otros;
@property (nonatomic,retain) IBOutlet UIView *buscadorlabelview;
@property (nonatomic) BOOL alertamostrada;



@end
