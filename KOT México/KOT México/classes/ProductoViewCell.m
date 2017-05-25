//
//  ProductoViewCell.m
//  Kot México
//
//  Created by Gilberto Julián de la Orta Hernández on 04/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "ProductoViewCell.h"

@implementation ProductoViewCell

@synthesize myTableViewController;
@synthesize img;
@synthesize commentTextLabel;
@synthesize producto;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

#pragma mark Memory Cleanup

- (void)viewDidUnload {

}

- (void)dealloc {
    [super dealloc];
}

@end
