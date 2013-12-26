//
//  Restaurant.m
//  Kot México
//
//  Created by Gilberto Julián de la Orta Hernández on 13/12/11.
//  Copyright (c) 2011 Naranya. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

@synthesize type, name, idRestaurant;

+ (id)restaurantWithType:(NSString *)type name:(NSString *)name idrestaurant:(NSString *)idRestaurant
{
	Restaurant *newProduct = [[self alloc] init];
	newProduct.type = type;
	newProduct.name = name;
    newProduct.idRestaurant = idRestaurant;
	return newProduct;
}

@end
