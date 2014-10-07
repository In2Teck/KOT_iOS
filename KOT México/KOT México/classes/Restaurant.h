//
//  Restaurant.h
//  Kot México
//
//  Created by Gilberto Julián de la Orta Hernández on 13/12/11.
//  Copyright (c) 2011 Naranya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject{
    NSString *type;
    NSString *name;
    NSString *idRestaurant;
}

@property (nonatomic, copy) NSString *type, *name, *idRestaurant;

+ (id)restaurantWithType:(NSString *)type name:(NSString *)name idrestaurant:(NSString *)idRestaurant;

@end