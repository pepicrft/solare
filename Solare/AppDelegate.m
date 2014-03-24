//
//  AppDelegate.m
//  Solare
//
//  Created by Pedro Piñera Buendia on 27/05/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "UAirship.h"
#import "Appirater.h"
#import "Flurry.h"
#import "UAConfig.h"
#import "UAirship+Internal.h"


@implementation AppDelegate
@synthesize maximumTimes;
@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize fpsarray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    [self initializeMaximumTimes];
    [self initializeFPSArray];
    [self initializeAppiRater];
    [self initializeFlurry];
    [self downloadRequiredInformation];
    [self initializeUrbanAirship];
    [self checkAndSetupFirstTimeOpened];
    [self checkIfOpenedByNotification:launchOptions];

    return YES;
}


- (void)initializeAppiRater
{
    [Appirater appLaunched:YES];
}


- (void)initializeFPSArray
{
//Initialize fps array
    //Got from http://www.portalfarma.com/Profesionales/campanaspf/categorias/Documents/20_guia_solar.pdf
    NSArray *uvi1=[NSArray arrayWithObjects:@"15-20",@"15-20",@"15-20",@"15-20", nil];
    NSArray *uvi2=[NSArray arrayWithObjects:@"30-50",@"30-50",@"15-20",@"15-20", nil];
    NSArray *uvi3=[NSArray arrayWithObjects:@"50+",@"30-50",@"15-25",@"15-20", nil];
    NSArray *uvi4=[NSArray arrayWithObjects:@"50+",@"50+",@"30-50",@"15-20", nil];

    fpsarray = [NSArray arrayWithObjects:uvi1,uvi2,uvi3,uvi4, nil];
}


- (void)initializeMaximumTimes
{
    NSArray *uv1 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:112.0],[NSNumber numberWithFloat:140.0],[NSNumber numberWithFloat:175.0],[NSNumber numberWithFloat:218.7],
                    [NSNumber numberWithFloat:273.5],[NSNumber numberWithFloat:341.8],nil];
    NSArray *uv2 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:56.0],[NSNumber numberWithFloat:70.0],[NSNumber numberWithFloat:87.5],[NSNumber numberWithFloat:109.4],
                    [NSNumber numberWithFloat:136.7],[NSNumber numberWithFloat:170.9],nil];
    NSArray *uv3 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:37.3],[NSNumber numberWithFloat:46.7],[NSNumber numberWithFloat:58.3],[NSNumber numberWithFloat:72.9],
                    [NSNumber numberWithFloat:91.2],[NSNumber numberWithFloat:113.9],nil];
    NSArray *uv4 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:28.0],[NSNumber numberWithFloat:35.0],[NSNumber numberWithFloat:43.8],[NSNumber numberWithFloat:54.7],
                    [NSNumber numberWithFloat:68.4],[NSNumber numberWithFloat:85.5],nil];
    NSArray *uv5 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:22.4],[NSNumber numberWithFloat:28],[NSNumber numberWithFloat:35],[NSNumber numberWithFloat:43.7],
                    [NSNumber numberWithFloat:54.7],[NSNumber numberWithFloat:68.4],nil];
    NSArray *uv6 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:18.7],[NSNumber numberWithFloat:23.3],[NSNumber numberWithFloat:29.2],[NSNumber numberWithFloat:36.5],
                    [NSNumber numberWithFloat:45.6],[NSNumber numberWithFloat:57.0],nil];
    NSArray *uv7 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:16],[NSNumber numberWithFloat:20],[NSNumber numberWithFloat:25],[NSNumber numberWithFloat:31.2],
                    [NSNumber numberWithFloat:39.1],[NSNumber numberWithFloat:48.8],nil];
    NSArray *uv8 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:14],[NSNumber numberWithFloat:17.5],[NSNumber numberWithFloat:21.9],[NSNumber numberWithFloat:27.3],
                    [NSNumber numberWithFloat:34.2],[NSNumber numberWithFloat:42.7],nil];
    NSArray *uv9 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:12.4],[NSNumber numberWithFloat:15.6],[NSNumber numberWithFloat:19.4],[NSNumber numberWithFloat:24.3],
                    [NSNumber numberWithFloat:30.4],[NSNumber numberWithFloat:38],nil];
    NSArray *uv10 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:11.2],[NSNumber numberWithFloat:14],[NSNumber numberWithFloat:17.5],[NSNumber numberWithFloat:21.9],
                    [NSNumber numberWithFloat:27.3],[NSNumber numberWithFloat:34.2],nil];
    NSArray *uv11 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:10.2],[NSNumber numberWithFloat:12.7],[NSNumber numberWithFloat:15.9],[NSNumber numberWithFloat:19.9],
                    [NSNumber numberWithFloat:24.9],[NSNumber numberWithFloat:31.1],nil];
    NSArray *uv12 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:9.3],[NSNumber numberWithFloat:11.7],[NSNumber numberWithFloat:14.6],[NSNumber numberWithFloat:18.2],
                    [NSNumber numberWithFloat:22.8],[NSNumber numberWithFloat:28.5],nil];
    NSArray *uv13 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:8.6],[NSNumber numberWithFloat:10.8],[NSNumber numberWithFloat:13.5],[NSNumber numberWithFloat:16.8],
                    [NSNumber numberWithFloat:21.0],[NSNumber numberWithFloat:26.3],nil];
    NSArray *uv14 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:8],[NSNumber numberWithFloat:10],[NSNumber numberWithFloat:12.5],[NSNumber numberWithFloat:15.6],
                    [NSNumber numberWithFloat:19.5],[NSNumber numberWithFloat:24.4],nil];
    NSArray *uv15 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:7.5],[NSNumber numberWithFloat:9.3],[NSNumber numberWithFloat:11.7],[NSNumber numberWithFloat:14.6],
                    [NSNumber numberWithFloat:18.2],[NSNumber numberWithFloat:22.8],nil];
    maximumTimes =[[NSMutableArray alloc] initWithObjects:uv1,uv2,uv3,uv4,uv5,uv6,uv7,uv8,uv9,uv10,uv11,uv12,uv13,uv14,uv15, nil];
}


- (void)checkIfOpenedByNotification:(NSDictionary *)launchOptions
{
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(notification){
        [self.viewController showAlert:[NSArray arrayWithObjects:notification.alertBody, NSLocalizedString(@"OK", nil) , NSLocalizedString(@"Notificacion", nil), nil]];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    NSDictionary *remotenotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remotenotification) {
        NSLog(@"La aplicación ha sido abierta debido a una notificación");
        [self.viewController showAlert:[NSArray arrayWithObjects:[[remotenotification objectForKey:@"aps"] objectForKey:@"alert"], NSLocalizedString(@"OK", nil) , NSLocalizedString(@"Notificacion", nil), nil]];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}


- (void)initializeFlurry
{
    [Flurry startSession:@"CJV4JGICTYS789VDIZFI"];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}


- (void)downloadRequiredInformation
{
    if ([self connectedToNetwork]){
        [self downloadRegionsPlist];
        [self downloadSettingsPlist];
    }
}


- (void)checkAndSetupFirstTimeOpened
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL firstTime =[defaults boolForKey:@"firstTime"];
    if(!firstTime){
        NSLog(@"Es la primera vez que abre la app");
        [defaults setObject:@"Celsius" forKey:@"Escala"];
        [defaults setBool:YES forKey:@"firstTime"];
        [defaults setBool:YES forKey:@"push"];
        [defaults synchronize];
    }
}


- (void)initializeUrbanAirship
{
    [UAPush setDefaultPushEnabledValue:NO];
    [UAirship setLogLevel:UALogLevelTrace];
    UAConfig *config = [UAConfig defaultConfig];
    [UAirship takeOff:config];
    UA_LDEBUG(@"Config:\n%@", [config description]);
    [[UAPush shared] resetBadge];
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
            UIRemoteNotificationTypeSound |
            UIRemoteNotificationTypeAlert);
}

-(void)downloadRegionsPlist{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * filePath = [documentsDirectory stringByAppendingString:@"/Regiones.plist"];
    NSData *regionesplist=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.ppinera.es/iOSData/Solare/Regiones.plist"]];
    [regionesplist writeToFile:filePath atomically:YES];
}

-(void)downloadSettingsPlist{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Preferencias.plist"];
    NSData *dataplist=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.ppinera.es/iOSData/Solare/Preferencias.plist"]];
    [dataplist writeToFile:filePath atomically:YES];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:self.viewController.isAlarmActive forKey:@"alarmActive"];
    [defaults synchronize];

    if(self.viewController.isAlarmActive){
        [defaults setObject:self.viewController.endOfAlarm forKey:@"endOfAlarm"];
        [defaults setObject:self.viewController.startOfAlarm forKey:@"startOfAlarm"];

    }

    [self.viewController.locationManager stopUpdatingLocation];

    if([self.viewController.counter isValid]){
        [self.viewController.counter invalidate];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;


    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.viewController.isAlarmActive =[defaults boolForKey:@"alarmActive"];
    self.viewController.endOfAlarm =[defaults objectForKey:@"endOfAlarm"];
    self.viewController.startOfAlarm =[defaults objectForKey:@"endOfAlarm"];

    if (self.viewController.isAlarmActive){
        [self.viewController startCounter];
    }
    else{
        self.viewController.progressBar.progress=0.0;
        self.viewController.isAlarmActive =NO;
    }

    [self.viewController.locationManager startUpdatingLocation];


    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                                                   fromDate:[NSDate date]];
    NSLog(@"Hora : %d",components.hour);
    if(components.hour>7 && components.hour<22 )
    {
        self.viewController.esdenoche=FALSE;
    }else {
        self.viewController.esdenoche=TRUE;
    }

    [self updateNotificationsStatus];
}


- (void)updateNotificationsStatus
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"push"]){
        NSLog(@"Las notificaciones están activas");
        [[UAPush shared]
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)];
    }else{
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];

    }
    [[UAPush shared] setAutobadgeEnabled:YES];
    [[UAPush shared] resetBadge];//zero badge
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [UAirship land];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber=0;
    NSLog(@"Cargando notificación");
    [self.viewController showAlert:[NSArray arrayWithObjects:notification.alertBody, NSLocalizedString(@"OK", nil), NSLocalizedString(@"Notificacion", nil), nil]];
}

-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"Notification received");
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    [self.viewController showAlert:[NSArray arrayWithObjects:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"], NSLocalizedString(@"OK", nil), NSLocalizedString(@"Notificacion", nil), nil]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA
    [[UAPush shared] registerDeviceToken:deviceToken];
}

void uncaughtExceptionHandler(NSException *exception) {
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

#pragma mark - Sound playing
-(void) playSound : (NSString *) fName : (NSString *) ext
{
SystemSoundID soundID;
NSString *path  = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
if ([[NSFileManager defaultManager] fileExistsAtPath : path])
{
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pathURL,&soundID);
    AudioServicesPlaySystemSound (soundID);
}
else
{
    NSLog(@"error, file not found: %@", path);
}
}

#pragma mark - Reachability
- (BOOL) connectedToNetwork
{
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}



@end
