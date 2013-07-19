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
    
    NSString *typeOfBuilding;   // 'residential', 'commercial' or other
    NSString *buildingState;    // 'furnished', 'vacant' or 'mobile'
    
    NSString *estimateDate;
    float ratePerSquareFeet;
    
    UIViewController *secondVC;
    UIViewController *invoiceVC;
    // array that holds all the services
    NSMutableArray *listOfServices;	
    
}

@property (assign, readwrite) UIViewController *secondVC, *invoiceVC;

@property (assign, readwrite) NSString *currActiveVCName;
@property (assign, readwrite) NSString *orderDate, *invoiceNo, *poNo, *technicianName, *customerFirstName, *customerLastName,
                                *customerAddressOne, *customerAddressTwo, *customerPhoneNo, *customerPhoneNoTwo, *customerEmail, *customerReferredBy, *typeOfBuilding, *buildingState;
@property (assign, readwrite) NSString *estimateDate;
@property (assign, readwrite) NSMutableArray *listOfServices;
@property (assign, readwrite) float ratePerSquareFeet;
@property (assign, readwrite) NSInteger services;

+(InvoiceManager *) sharedInvoiceManager;
-(ServiceItem *) createServiceItem:(NSString*) serviceTypeName withOrderVal:(NSInteger) orderArg;
-(void) removeServiceItemWithName:(NSString*) serviceTypeName;
-(UIViewController *) getNextVC;            // returns the VC that is following the currently presented VC (this func is only called when a service VC is being presented)

-(void) printOut;
-(NSMutableData *)createPDFDatafromUIView:(UIView*)aView;
-(NSString*)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;

@end
