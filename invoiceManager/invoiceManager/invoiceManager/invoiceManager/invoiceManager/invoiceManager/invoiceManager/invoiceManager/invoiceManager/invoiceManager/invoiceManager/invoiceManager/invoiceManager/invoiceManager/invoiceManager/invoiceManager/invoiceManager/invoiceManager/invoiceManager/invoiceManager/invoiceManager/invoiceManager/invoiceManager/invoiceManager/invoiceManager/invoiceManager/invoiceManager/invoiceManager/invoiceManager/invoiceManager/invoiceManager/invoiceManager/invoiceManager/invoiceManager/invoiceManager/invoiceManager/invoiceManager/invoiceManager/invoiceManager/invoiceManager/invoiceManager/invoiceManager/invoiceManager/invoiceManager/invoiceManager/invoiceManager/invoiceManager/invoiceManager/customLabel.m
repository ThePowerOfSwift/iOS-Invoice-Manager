//
//  customLabel.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-29.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "customLabel.h"

@implementation customLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    NSLog(@"DOOES IT EVER GET HERE???");
    BOOL isPDF = !CGRectIsEmpty(UIGraphicsGetPDFContextBounds());
    if (!layer.shouldRasterize && isPDF){
        [self drawRect: self.bounds];
        /*
        CGSize fitSize = [self sizeThatFits:self.bounds.size];
        float x = self.bounds.origin.x;
        float y = self.bounds.origin.y;
        if (self.textAlignment == NSTextAlignmentCenter){
            x += (self.bounds.size.width - fitSize.width) / 2.0f;
            y += (self.bounds.size.height - fitSize.height) / 2.0f;
        } else if (self.textAlignment == NSTextAlignmentRight){
            x += self.bounds.size.width - fitSize.width;
            y += self.bounds.size.height - fitSize.height;
        }
        [self.textColor set];
        [self.text drawInRect:CGRectMake(x,y,fitSize.width, fitSize.height) withFont:self.font lineBreakMode:NSLineBreakByWordWrapping alignment:self.textAlignment];
         */
    } else {
        [super drawLayer:layer inContext:ctx];
    }
}

@end
