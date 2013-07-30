//
//  invoicer.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-19.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "InvoiceManager.h"

@implementation InvoiceManager

@synthesize secondVC, invoiceVC;
@synthesize currActiveVCName;
@synthesize listOfServices;
@synthesize estimateDate, ratePerSquareFeet, customerAddressOne, customerAddressTwo, customerFirstName, customerLastName, customerEmail, customerReferredBy,
typeOfBuilding, buildingState, poNo, invoiceNo, technicianName, orderDate, customerPhoneNoTwo, customerPhoneNo, usingProductType;


static InvoiceManager *shared = NULL;

- (id)init
{
    if ( self = [super init] )
    {
        // initialize your singleton variable here (i.e. set to initial value that you require)
        //listOfServices = [NSMutableArray arrayWithCapacity:1];
        listOfServices = [[NSMutableArray alloc] initWithCapacity:2];
        [self setCustomerAddressOne:@"(Empty)"];
        [self setCustomerAddressTwo:@"(Empty)"];
        [self setCustomerEmail:@"(Empty)"];
        [self setCustomerFirstName:@"(Empty)"];
        [self setCustomerLastName:@"(Empty)"];
        [self setCustomerPhoneNo:@"(Empty)"];
        [self setCustomerPhoneNoTwo:@"(Empty)"];
        [self setCustomerReferredBy:@"(Empty)"];
        
        [self setBuildingState:@"Vacant State"];          // 'Furnished State', 'Vacant State' or 'Mobile State'
        [self setUsingProductType:@"Normal Products"];       // 'Normal Products' or 'Green Products' products
        [self setTypeOfBuilding:@"Residential Building"];    // 'Residential Building', 'Commercial Building' or other
        [self setInvoiceNo:@"(Empty)"];
        [self setPoNo:@"(Empty)"];
        [self setTechnicianName:@"(Empty)"];
        [self setOrderDate:@"(Empty)"];
    }
    return self;
    
}

+ (InvoiceManager *)sharedInvoiceManager{
    @synchronized(shared)
    {
        if ( !shared || shared == NULL )
        {
            // allocate the shared instance, because it hasn't been done yet
            shared = [[InvoiceManager alloc] init];
        }
        
        return shared;
    }
}

-(ServiceItem *) createServiceItem:(NSString*) serviceTypeName withOrderVal:(NSInteger) orderArg {
    // create object and push it on the listOfServices array
    ServiceItem *item = [[ServiceItem alloc] init];
    item.name = serviceTypeName;
    item.order = orderArg;
    
    [listOfServices addObject:item];
    NSLog(@"ALLOC SERVICE VC");
    // create a UIViewController instance and save it
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    
    if ([serviceTypeName isEqualToString:@"autoSpa"] || [serviceTypeName isEqualToString:@"ductCleaning"]){
        ServiceTypeTwoVC *serviceVC = (ServiceTypeTwoVC*) [storyboard instantiateViewControllerWithIdentifier:@"ServiceTypeTwoVC"];
        serviceVC.VCServiceNameType = serviceTypeName;
        [serviceVC retain];
        item.serviceVC = serviceVC;
    } else {
        ServiceTypeViewController *serviceVC = (ServiceTypeViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ServiceTypeViewController"];
        
        serviceVC.serviceDataCellArray = [[NSMutableArray alloc] initWithCapacity:1];
        serviceVC.dataTableNoOfRows = 0;
        
        //serviceVC.examp.text = serviceTypeName;
        //NSLog(@"label text is %@", serviceVC.examp.text);
        serviceVC.VCServiceNameType = serviceTypeName;   // currentVCServiceName = 'name of the type of service'
        [serviceVC retain];                              // retain VC's; they will be used globally to navigate.. globally
        item.serviceVC = serviceVC;                      // save to invoice manager..
    }
    // sort the array in ascending order, in terms of their 'order' variable
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES] autorelease];
    [listOfServices sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return item;
}

// remove service item with name 'serviceTypeName' from the 'listOfServices' array
-(void) removeServiceItemWithName:(NSString*) serviceTypeName {
    for (NSInteger i = 0; i < [listOfServices count]; i++){
        if ([[[listOfServices objectAtIndex:i] name] isEqualToString:serviceTypeName]){
            [[[listOfServices objectAtIndex:i] serviceVC] release];
            [listOfServices removeObjectAtIndex:i];
        }
    }
}

// check what VC is currently being presented. then, find out the next VC ( if any )
-(UIViewController *) getNextVC {
    //NSLog(@"current active service is %@", currActiveVCName);
    for (NSInteger i = 0; i < [listOfServices count]; i++){
        if ( [[[listOfServices objectAtIndex:i] name] isEqualToString:currActiveVCName] ){
            //NSLog(@"next object index: %u", i+1);
            //NSLog(@"count:%u", [listOfServices count]);
            if ([listOfServices count] > (i+1)){
                return [[listOfServices objectAtIndex:(i+1)] serviceVC];
            } else {
                return NULL;
            }
        }
    }
    return NULL;
}

//-----------------------------------
// Create PDF from UIView

-(NSMutableData *)createPDFDatafromUIView:(UIView*)aView {
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    return pdfData;
}

-(NSString*)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [self createPDFDatafromUIView:aView];
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:@"Users/Oprescu/heyhey.pdf" atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    return documentDirectoryFilename;
}

// END OF pdf funcs
//-----------------------------------

-(void) printOut {
    NSLog(@"list of services count: %u", [listOfServices count]);
}

- (void)dealloc
{
    //NSLog(@"Deallocating singleton...");
    //NSLog(@"IF I GET CALLED OMG OMG");
    // Deallocating all ServiceItem objects
    for (int i = 0; i < [listOfServices count]; i++){
        //NSLog(@"deallocating.. %@", [[listOfServices objectAtIndex:i] name]);
        [[listOfServices objectAtIndex:i] release];
        
    }
    
    // dealloc all strings holding customer info and other
    [customerReferredBy release];
    [customerPhoneNoTwo release];
    [customerPhoneNo release];
    [customerLastName release];
    [customerFirstName release];
    [customerEmail release];
    [customerAddressTwo release];
    [customerAddressOne release];
    [poNo release];
    [invoiceNo release];
    [orderDate release];
    [technicianName release];
    
    [listOfServices release];
    [secondVC release];
    [invoiceVC release];
    [shared release];   // release the shared singleton
    [super dealloc];
}

@end
