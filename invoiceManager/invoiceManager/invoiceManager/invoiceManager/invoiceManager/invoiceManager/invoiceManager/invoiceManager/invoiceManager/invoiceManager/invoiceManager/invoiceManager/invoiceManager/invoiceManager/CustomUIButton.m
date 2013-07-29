//
//  customUIButton.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-21.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "customUIButton.h"

@implementation CustomUIButton

@synthesize activeBtn, cellIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        activeBtn = 0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
