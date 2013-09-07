//
//  CustomTableCellData.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-22.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "ServiceDataCell.h"

@implementation ServiceDataCell

@synthesize name, rlength, rwidth, notes, price, materialType, itemAttribute;
@synthesize quantity, quantity2;
@synthesize serviceType;
@synthesize ratePerHr;
@synthesize priceRate;
@synthesize vacOrFull;
@synthesize addonFabricProtector, addonDeodorizer, addonBiocide;
@synthesize popoverVC;
@synthesize attributesList, attributesListTwo, attributesListThree;

-(id) init {
    if (self = [super init]){
        // popoverVC = [[UIViewController alloc] init];
    }
    return self;
}

-(void) dealloc {
    [popoverVC release];
    [name release];
    [notes release];
    [vacOrFull release];
    [super dealloc];
}

@end
