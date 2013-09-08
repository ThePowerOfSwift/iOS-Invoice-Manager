//
//  CustomTableCellData.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-22.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTableViewCell.h"

/*
 serviceType = { carpet | upholstery | mattress | repair | reservice | flood }
 
 ------------------------------------------- OptionsPopoverVC:
 carpet service:
 name (Entrance | Master Bedroom | Living Room | ... | Stairs / Landings)
 itemAttribute (Room | Stairs)       {any type of room name => itemAttribute = Room type. If name = Stairs / Landings, itemAttribute = Stairs}
 notes
 rlength
 rwidth
 price
 priceRate
 quantity = # of stairs
 quantity2 = # of landings
 
 ------------------------------------------- OptionsMatressPopoverVC
 matress service:
 name - item name (King size, queen size, double)
 vacOrFull - (power-vac only | full clean)
 quantity - ..
 notes - ..
 addonBiocide, addonDeodorizer, addonFabricProtector - booleans
 
 ------------------------------------------- OptionsUpholsteryPopoverVC:
 upholstery service:
 name = upholstery item name
 materialType = leather, synthetic, natural, specialty
 vacOrFull = (power-vac only | full clean)
 quantity = ..
 price = full price ( quantity * price per item, which is hardcoded )
 notes - ..
 
 ------------------------------------------- OptionsFloodPopoverVC:
 flood service:
 name = item name (blowers, dehumidifiers, Water Extraction, etc)
 
 if item name is 'blowers':
 ratePerHr = price rate per day
 quantity = # of days
 quantity2 = # of blowers
 if item name is 'dehumifiers':
 ratePerHr = price rate per day
 quantity = # of days
 quantity2 = # of dehumidifiers
 if item name is 'biocide application':
 ratePerHr = price rate per sq feet ($/sq feet)
 quantity = square feet
 if item name is 'demolition':
 ratePerHr = price rate per hour ($/hr)
 quantity = # of hours
 if item name is 'water extraction':
 ratePerHr = price rate per hour ($/hr)
 quantity = # of hours
 
 price = full price ( quantity * price per item, which is hardcoded )
 notes - ..
 
 -------------------------------------------OptionsMiscellaneousPopoverVC:
 
 miscellaneous:
 name, price per item ( = priceRate ), quantity;
 
 ------------------------------------------- OptionsAreaRugsPopoverVC:
 area rugs:
 
 name = 2x3, 3x6, 9x12..etc
 materialType = (synthetic | wool)
 quantity = ..
 price = ..
 notes = ..
 addons..
 
 ------------------------------------------- OptionsAutoSpaPVC:
 auto spa - auto package:
 name = package name ( Bronze, Silver, Gold, Platinum )
 itemAttribute = car type ( SUV, Compact, Midsize )
 
 vacOrFull = 'Auto Package'
 quantity = # of cars
 price = price
 priceRate = price per one car
 notes = ..
 
 ------------------------------------------- OptionsSemiSpaPVC:
 auto spa - semi package:
 name = package name ( 'Complete Exterior Wash', 'Complete Exterior Detail', etc )
 itemAttribute = car type ( SUV, Compact, Midsize )
 
 vacOrFull = 'Semi Package'
 quantity = # of cars
 price = price
 priceRate = price per one car
 notes = ..
 
 ------------------------------------------- OptionsAutoDetailPVC:
 auto spa - auto detailing services:
 name = package name ( 'Interior Vacuum' or 'Fabric Guard' or etc.. )
 itemAttribute = car type ( Car, SUV )
 materialType = service type restoration id (serviceTypeRestorationID) ('Interior Vacuum' or 'Fabric Guard' or etc..)
 
 vacOrFull = 'Auto Detail'
 quantity = # of cars
 price = price
 priceRate = price per one car
 notes = ..
 
 ------------------------------------------- OptionsSemiDetailPVC:
 auto spa - semi detailing services:
 name = package name ( 'Exterior Wash (Day Cab)' or 'Engine Shampoo (Sleeper Unit)' or etc.. )
 itemAttribute = car type ( 'Day Cab' or 'Sleeper Unit' )
 materialType = service type restoration id (serviceTypeRestorationID)
 
 vacOrFull = 'Semi Detail'
 quantity = # of cars
 price = price
 priceRate = price per one car
 notes = ..
 
 ------------------------------------------- OptionsAluminumMetalPVC:
 auto spa - aluminum and metal polishing services:
 name = package name ( 'Exterior Wash (Day Cab)' or 'Engine Shampoo (Sleeper Unit)' or etc.. )
 materialType = service type restoration id (serviceTypeRestorationID)
 
 vacOrFull = 'Aluminum Metal'
 quantity = # of cars
 price = price
 priceRate = price per one car
 notes = ..
 
 ------------------------------------------- OptionsWindshieldCrackPVC:
 auto spa - Windshield & Rock Chip Repair:
 name = package name ('1st Rock Chip', '2nd Rock Chip', 'Additional Rock Chip', etc..)
 materialType = service type restoration id (serviceTypeRestorationID)
 
 vacOrFull = 'Windshield Crack'
 quantity = # of cars
 price = price
 priceRate = price per one car
 notes = ..
 
 ------------------------------------------- OptionsDuctFurnaceCleanPVC:
 auto spa - Windshield & Rock Chip Repair:
 name = package name ('1st Rock Chip', '2nd Rock Chip', 'Additional Rock Chip', etc..)
 materialType = service type restoration id (serviceTypeRestorationID)
 
 vacOrFull = 'Windshield Crack'
 quantity = # of cars
 price = price
 priceRate = price per one car
 notes = ..
 */

@interface ServiceDataCell : NSObject {
    NSString *serviceType;
    
    NSString *name;
    NSString *itemAttribute;
    bool addonDeodorizer;
    bool addonFabricProtector;
    bool addonBiocide;
    // [0] == deodorizer, [1] == fabric protector, [2] == biocide
    
    NSString *notes;
    float rlength, rwidth;
    float price;
    float priceRate;
    
    NSString *vacOrFull;
    
    NSInteger quantity, quantity2;
    
    NSString *materialType;
    
    NSInteger noOfHours;
    float ratePerHr;
    
    NSMutableArray* attributesList, *attributesListTwo, *attributesListThree;
    
    UIViewController* popoverVC;    // keep track of each UIViewController so it can be displayed for 'editing' purposes
}

@property (assign, readwrite) bool addonBiocide, addonDeodorizer, addonFabricProtector;
@property (assign, readwrite) NSString *serviceType;
@property (assign, readwrite) NSInteger quantity, quantity2;
@property (assign, readwrite) NSInteger cellNumber;
@property (copy, readwrite) NSString *name, *materialType, *itemAttribute;
@property (copy, readwrite) NSString *notes;
@property (assign, readwrite) float rlength, rwidth, price, ratePerHr, priceRate;
@property (assign, readwrite) NSMutableArray *attributesList, *attributesListTwo, *attributesListThree;

@property (assign, readwrite) UIViewController* popoverVC;
@property (copy) NSString *vacOrFull;
@end
