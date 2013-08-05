//
//  invoicer.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-19.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "ServiceItem.h"
#import <QuartzCore/QuartzCore.h>

/*
 #ifndef invoiceManager_asdasd_h
 #define invoiceManager_asdasd_h
 
 
 
 #endif
 
 */

@interface InvoiceManager : NSObject {
    // FUNCTIONALITY VARS:
    NSString *currActiveVCName;
    
    // DATA VARIABLES:
    // order info:
    NSString *invoiceNo;
    NSString *poNo;
    NSString *orderDate;
    NSString *technicianName;
    // customer info:
    NSString *customerFirstName;
    NSString *customerLastName;
    NSString *customerAddressOne, *customerAddressTwo;
    NSString *customerPhoneNo;
    NSString *customerPhoneNoTwo;
    NSString *customerEmail;
    NSString *customerReferredBy;
    
    // Each service has a tag assigned to it, based on which an order is made
    // 'carpet' tag = 1, 'upholstery' tag = 2, 'mattress' tag = 3, 'miscellaneous' tag = 4, 'areaRugs' tag = 5, 'floodCleanup' tag = 6, 'autoSpa' tag = 7, 'ductFurnaceCleaning' tag = 8
    
    // auto spa:
    
    // carpet care:
    NSString *typeOfBuilding;       // 'Residential Building', 'Commercial Building' or other
    NSString *buildingState;        // 'Furnished State', 'Vacant State' or 'Portable State'
    NSString *usingProductType;     // 'Normal Products' or 'Green Products' products
    
    NSString *estimateDate;
    float ratePerSquareFeet;
    
    // array that holds all the carpet care services
    NSMutableArray *listOfServices;
    
    // View Controllers
    UIViewController *firstVC;
    UIViewController *ccSecondVC;   // carpet care second view controller
    UIViewController *invoiceVC;
    
    // current company
    NSString *currCompanyName;  // can be one of the three: 'carpetCare', 'autoSpa' or 'ductFurnaceCleaning'
    
}

@property (assign, readwrite) NSString *currCompanyName;
@property (assign, readwrite) UIViewController *ccSecondVC, *invoiceVC, *firstVC;

@property (assign, readwrite) NSString *currActiveVCName;
@property (assign, readwrite) NSString *orderDate, *invoiceNo, *poNo, *technicianName, *customerFirstName, *customerLastName,
*customerAddressOne, *customerAddressTwo, *customerPhoneNo, *customerPhoneNoTwo, *customerEmail, *customerReferredBy, *typeOfBuilding, *buildingState, *usingProductType;
@property (assign, readwrite) NSString *estimateDate;
@property (assign, readwrite) NSMutableArray *listOfServices;
@property (assign, readwrite) float ratePerSquareFeet;
@property (assign, readwrite) NSInteger services;

+(InvoiceManager *) sharedInvoiceManager;
-(ServiceItem *) createServiceItem:(NSString*) serviceTypeName withOrderVal:(NSInteger) orderArg;
-(void) removeServiceItemWithName:(NSString*) serviceTypeName;
-(bool) existsServiceName: (NSString*) serviceTypeName;
-(UIViewController *) getNextVC;            // returns the VC that is following the currently presented VC (this func is only called when a service VC is being presented)

-(void) printOut;
-(NSMutableData *)createPDFDatafromUIView:(UIView*)aView;
-(NSString*)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;

@end
