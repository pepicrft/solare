//
//  Ciudad.h
//  Solare
//
//  Created by Pedro Piñera Buendía on 24/07/12.
//  Copyright (c) 2012 Pedro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ciudad : NSObject{
    
}
+(NSNumber*)obtenerUV:(NSString*)SP;
+(NSNumber*)obtenerTemp:(NSString*)SP;
+(NSNumber*)calculotmax:(NSNumber*)UV:(NSNumber*)frecuencia;
+(NSString*)calcularfps:(NSNumber*)UV:(NSNumber*)tono;
@end
