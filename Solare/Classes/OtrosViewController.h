//
//  OtrosViewController.h
//  Solare
//
//  Created by Pedro Piñera Buendia on 18/07/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtrosViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    UISearchDisplayController *searchDisplayController;
    UISearchBar *searchBar;
    NSArray *resultados;
    IBOutlet UIView *resultadosView;
    UIActivityIndicatorView *cargando;
    
    //Labels
    IBOutlet UILabel *indice;
    IBOutlet UILabel *temperatura;
    IBOutlet UILabel *tiempomaximo;
    IBOutlet UILabel *fps;
    IBOutlet UILabel *ciudadlabel;
    NSMutableDictionary *ciudadmdict;
    
    //Variables de instancia
    NSString *ciudadsel;
}
@property(nonatomic,retain) IBOutlet UILabel *indice;
@property(nonatomic,retain) IBOutlet UILabel *temperatura;
@property(nonatomic,retain) IBOutlet UILabel *tiempomaximo;
@property(nonatomic,retain) IBOutlet UILabel *fps;
@property(nonatomic,retain) IBOutlet UILabel *ciudadlabel;
@property(nonatomic,retain) NSMutableDictionary *ciudadmdict;
@property (nonatomic,retain) UIActivityIndicatorView *cargando;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic,retain) NSArray *resultados;
@property (nonatomic,retain)IBOutlet UIView *resultadosView;


-(void)buscarciudad:(NSArray*)parametros;
-(void)actualizarinterfaz;
-(void)descargardatosciudad:(NSString*)SP;
-(void)lecturadedatos;
@end
