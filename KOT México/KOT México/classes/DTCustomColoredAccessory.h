//
//  DTCustomColoredAccessory.h
//  TestTableView
//
//  Created by Gilberto Julián de la Orta Hernández on 05/12/11.
//  Copyright (c) 2011 Naranya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{
    DTCustomColoredAccessoryTypeRight = 0,
    DTCustomColoredAccessoryTypeUp,
    DTCustomColoredAccessoryTypeDown
} DTCustomColoredAccessoryType;

@interface DTCustomColoredAccessory : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
    
    DTCustomColoredAccessoryType _type;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

@property (nonatomic, assign)  DTCustomColoredAccessoryType type;

+ (DTCustomColoredAccessory *)accessoryWithColor:(UIColor *)color type:(DTCustomColoredAccessoryType)type;

@end