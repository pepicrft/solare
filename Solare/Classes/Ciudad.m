//
//  Ciudad.m
//  Solare
//
//  Created by Pedro Piñera Buendía on 24/07/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import "Ciudad.h"
#import "XMLReader.h"
#import "Flurry.h"
#import "AppDelegate.h"


@implementation Ciudad
+(NSNumber*)obtenerUV:(NSString*)SP{
    //Comprobamos si hay conexión
    AppDelegate *delegado= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([delegado connectedToNetwork]){

    NSLog(@"Weather URL: %@",[NSString stringWithFormat:@"http://www.weather.com/weather/right-now/%@:1",SP]);
    NSData *datosweather=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.weather.com/weather/right-now/%@:1",SP]]];

    if(datosweather!=nil){
        NSString *string = [[NSString alloc] initWithData:datosweather encoding:NSASCIIStringEncoding];

        //Extraemos el UV
        NSString *uvstring;
        NSRange startRange = [string rangeOfString:@"uv-index\">"];
        if (startRange.location != NSNotFound) {
            NSRange targetRange;
            targetRange.location = startRange.location + startRange.length;
            targetRange.length = [string length] - targetRange.location;
            NSRange endRange = [string rangeOfString:@"-" options:0 range:targetRange];
            if (endRange.location != NSNotFound) {
                targetRange.length = endRange.location - targetRange.location;
                uvstring= [string substringWithRange:targetRange];
            }
        }
        return [NSNumber numberWithFloat:[uvstring floatValue]];
    }else{
        return nil;
    }
    }
    else{
        return nil;
    }
}
+(NSNumber*)obtenerTemp:(NSString*)SP{
    //Comprobamos si hay conexión
    AppDelegate *delegado =[[UIApplication sharedApplication] delegate];
    if([delegado connectedToNetwork]){


    NSData *datostemp=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?p=%@&u=c",SP]]];
    NSString *tempxml= [[NSString alloc] initWithData:datostemp encoding:NSASCIIStringEncoding];
    NSError *parseError = nil;
    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:tempxml error:&parseError];
    float temperatura;
    if(xmlDictionary!=nil){
        temperatura=[[[[[[xmlDictionary objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"item"] objectForKey:@"yweather:condition"] objectForKey:@"temp"] floatValue];
        // Usamos la temperatura en Celsius si el idioma es español y en Farenheit si es inglés
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *escala =[defaults objectForKey:@"Escala"];
        if([escala isEqualToString:@"Celsius"]){
            temperatura=temperatura;
            return [NSNumber numberWithFloat:temperatura];
        }else {
            temperatura=temperatura*9/5+32;
            return [NSNumber numberWithFloat:temperatura];
        }
    }else {
        [Flurry logEvent:@"Error descargando temperatura de Yahoo"];
        return nil;
    }
    }else{
        return nil;
    }
}
+(NSNumber *)calculotmax:(NSNumber *)UV :(NSNumber *)frecuencia{
    AppDelegate *delegado =[[UIApplication sharedApplication] delegate];
    NSArray *tiemposmaximos= delegado.maximumTimes;
    int tmax;
    int uv=[UV intValue];
    if(uv>0){
        NSArray *uvarray= [tiemposmaximos objectAtIndex:uv-1];
        tmax = [[uvarray objectAtIndex:[frecuencia intValue]] intValue];
        return [NSNumber numberWithInt:tmax];
    }
    else
        return nil;
}
+(NSString*)calcularfps:(NSNumber *)UV :(NSNumber *)tono{
    int uviint;
    if([UV floatValue]<4) uviint=0;
    if((4<=[UV floatValue])&&([UV floatValue]<7)) uviint=1;
    if((7<=[UV floatValue])&&([UV floatValue]<10)) uviint=2;
    if(10<=[UV floatValue]) uviint=3;

    if(UV!=nil){
        if ([tono intValue]>=4) { //Con un fps mínimo es suficiente
            return NSLocalizedString(@"Calculadorasuf", nil);
        }else{ // Calculamos el fps
            AppDelegate *delegado =[[UIApplication sharedApplication] delegate];
            NSArray *fpsarray=delegado.fpsarray;
            NSString *fps =[[fpsarray objectAtIndex:uviint] objectAtIndex:[tono intValue]];
            return [NSString stringWithFormat:@"%@",fps];

    }
    }else{
        return @"";
    }
}



@end
