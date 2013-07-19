//
//  CustomTableViewCell.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-15.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

@synthesize colOne, colTwo, colThree, colFour;
@synthesize deleteBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //[roomPrice setText:@"blah blah"];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*-(void) dealloc {
    
    [self.roomName release];
    [self.roomArea release];
    [self.roomPrice release];
    [self.roomSize release];
    [super dealloc];
}*/


@end
