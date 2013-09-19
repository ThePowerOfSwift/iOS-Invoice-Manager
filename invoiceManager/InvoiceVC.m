//
//  InvoiceVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-28.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "InvoiceVC.h"

@interface InvoiceVC ()

@end

@implementation InvoiceVC

@synthesize pdfData;
@synthesize mainView, test;
@synthesize signatureView;

@synthesize popoverController;
@synthesize signatureImageView;
@synthesize scrollViewer;
@synthesize backbtn, signaturebtn;
@synthesize invoiceSubviews;
@synthesize writePDF;
@synthesize carpetDiscount, upholsteryDiscount, mattressDiscount, areaRugsDiscount, miscellaneousDiscount, floodDiscount, ductFurnaceDiscount;
@synthesize discountedAreaRugsPrice, discountedCarpetPrice, discountedFloodPrice, discountedMattressPrice, discountedMiscePrice, discountedUpholsteryPrice, discountedDuctFurnace;
@synthesize subtotalCarpetPrice, subtotalUpholsteryPrice, subtotalMattressPrice, subtotalMiscePrice, subtotalAreaRugsPrice, subtotalFloodPrice, subtotalDuctFurnace;
@synthesize subtotalAutospaPrice, discountedAutospaPrice, autospaDiscount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //NSLog(@"setting scrollviewer");
    [scrollViewer setScrollEnabled:YES];
    [scrollViewer setContentSize:CGSizeMake(768, 1024)];
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    
    if (!invoiceSubviews){
        invoiceSubviews = [[NSMutableArray alloc] initWithCapacity:2];
        //NSLog(@"initiating mutable array..");
    }
    writePDF = false;
    
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // for signature capture BELOW
    /*drawImage = [[UIImageView alloc] initWithImage:nil];
     drawImage.frame = signatureView.frame;
     [signatureView addSubview:drawImage];
     signatureView.backgroundColor = [UIColor lightGrayColor];
     mouseMoved = 0;*/
    // for signature capture ABOVE
}

-(void) viewDidDisappear:(BOOL)animated {
    [self clearView];
}

-(void) clearView {
    for (UIView *v in invoiceSubviews){
        [v removeFromSuperview];
        [v release];
        
    }
    [invoiceSubviews removeAllObjects];
}

-(void) viewDidAppear:(BOOL)animated {
    // set all initial discounts to 0;
    carpetDiscount = 0;
    upholsteryDiscount = 0;
    mattressDiscount = 0;
    areaRugsDiscount = 0;
    miscellaneousDiscount = 0;
    floodDiscount = 0;
    autospaDiscount = 0;
    ductFurnaceDiscount = 0;
    
    discountedCarpetPrice = 0;
    discountedUpholsteryPrice = 0;
    discountedMattressPrice = 0;
    discountedAreaRugsPrice = 0;
    discountedMiscePrice = 0;
    discountedFloodPrice = 0;
    discountedAutospaPrice = 0;
    discountedDuctFurnace = 0;
    
    [self createInvoice];
    
    //[self saveInvoiceToDatabase];
}

-(IBAction) saveInvoiceToDatabase {
    
    // check if the device is connected to internet before sending !
    if ([self connectedToInternet]){
        InvoiceManager *invMngr = [InvoiceManager sharedInvoiceManager];
        NSURL *url = [NSURL URLWithString:@"http://pokemonpacific.com/"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [invMngr customerFirstName], @"custFirstName",
                                [invMngr customerLastName], @"custLastName",
                                [invMngr orderDate], @"orderDate",
                                nil];
        [httpClient postPath:@"/funcsPHP/test.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Request Successful, response '%@'", responseStr);
            [responseStr release];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        }];
        
        //[httpClient release];
        
        
        //httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.mysite.com"]];
        
        NSURLRequest *request =
        [httpClient multipartFormRequestWithMethod:@"POST"
                                          path:@"/funcsPHP/test.php"
                                    parameters:params
                     constructingBodyWithBlock: ^(id<AFMultipartFormData> formData) {
                         [formData appendPartWithFileData:pdfData name:@"pdfData" fileName:@"someInvoice.pdf" mimeType:@"application/pdf"];
                         [formData appendPartWithFormData:[[NSNumber numberWithInt:pdfData.length].stringValue dataUsingEncoding:NSUTF8StringEncoding] name:@"filelength"];
                     }];
        
        AFHTTPRequestOperation *operation =
        [httpClient HTTPRequestOperationWithRequest:request
                                        success:^(AFHTTPRequestOperation *operation, id json) {
                                            NSString *responseStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
                                            NSLog(@"All OK, %@", responseStr);
                                        }
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            NSLog(@"All failed, %@", error);
                                        }];
        
        [httpClient enqueueHTTPRequestOperation:operation];
    } else {
        NSLog(@"No Internet Connection.. invoice has not been sent !");
    }
}

- (BOOL) connectedToInternet {
    NSURL *url=[NSURL URLWithString:@"http://www.google.com"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode]==200)?YES:NO;
}

-(IBAction) createInvoice {
    
    //float subtotal = 0;
    InvoiceManager *invMngr = [InvoiceManager sharedInvoiceManager];
    
    CGFloat posX = 53.0;
    CGFloat posY = 382.0;
    
    CGFloat pdfX = 53.0;
    CGFloat pdfY = 382.0;
    
    bool saveToFile = false; // if true, saves to a local file; if false, saves as nsdata, to be emailed
    
    ///pdfData = [NSMutableData dataWithCapacit
    
    if (saveToFile){
        // start drawing in pdf context
        UIGraphicsBeginPDFContextToFile(@"Users/Oprescu/MightyCleanInvoice.pdf", CGRectZero, nil);
    } else {
        if (pdfData){
            UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
        } else {
            pdfData = [NSMutableData data];
            UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
        }
        [pdfData retain];
    }
    
    //UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1753, 1240), nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0.0, 0.0, 768.0, 1024.0), nil);
    
    // draw the mighty clean logo
    //[self drawImage:@"invoice_image" withRect:CGRectMake(40.0, 40.0, 174.0f, 35.0f)];
    [self drawText:[NSString stringWithFormat:@"Invoice "] inFrame:CGRectMake(39.0, 132.0, 300.0f, 100.0f) withFontSize:60.0];
    
    // Draw Invoice Text:
    [self drawText:[NSString stringWithFormat:@"From: Mighty Clean \nEdmonton, Alberta\n1.780.488.8282\ninfo@mightyclean.ca\nwww.mightyclean.ca "] inFrame:CGRectMake(40.0, 200.0, 300.0f, 100.0f) withFontSize:16.0];
    
    // Draw Customer Invoice Address:
    [self drawText:[NSString stringWithFormat:@"To: %@ %@ \n%@,%@\nemail: %@\n", [invMngr customerFirstName], [invMngr customerLastName], [invMngr customerAddressOne], [invMngr customerAddressTwo], [invMngr customerEmail]] inFrame:CGRectMake(40.0, 300.0, 300.0f, 100.0f) withFontSize:16.0];
    
    // Draw the Mighty Clean logo
    [self drawImage:@"mightyCleanCarpetCareLogo.png" withRect:CGRectMake(425.0, 35.0, 313.0f, 186.0f)];
    
    // set the subtotal of each service to 0
    [self setSubtotalAreaRugsPrice:0];
    [self setSubtotalCarpetPrice:0];
    [self setSubtotalFloodPrice:0];
    [self setSubtotalMattressPrice:0];
    [self setSubtotalMiscePrice:0];
    [self setSubtotalUpholsteryPrice:0];
    [self setSubtotalAutospaPrice:0];
    [self setSubtotalDuctFurnace:0];
    
    /* iterate through each service */
    for (int i = 0; i < [[invMngr listOfServices] count]; i++){
        ServiceItem *item = [[invMngr listOfServices] objectAtIndex:i];
        ServiceTypeViewController *vc = (ServiceTypeViewController*)[[[invMngr listOfServices] objectAtIndex:i] serviceVC];
        
        /* Print the service name on screen and in pdf context */
        [self printServiceNameAtX:posX AtY:posY AtPdfX:pdfX AtPdfY:pdfY withServiceName:[item name]];
        
        /* Draw Add Discount Button to the screen ( NOT TO PDF )*/
        [self printDiscountButtonAtX:(posX+400.0) AtY:posY withServiceName:[item name]];
        
        // increase current y position
        posY = posY + 45.0;
        pdfY = pdfY + 5.0;
        
        // Draw horizontal line 
        [self printHorizLineBelowX:posX Y:posY pdfX:(pdfX - 8.0) pdfY:(pdfY - 23.0)];
        // substracted some pixels cause drawing the image doesn't render at proper coordinates ( should not affect flow as pdfY is not affected )
        
        // adjust the scroll view / extend if necessary
        [self adjustScreenSize_CurrentY:posY];
        // adjust the pdf pages, if necessary
        [self adjustPdfPages_currentPdfY:&pdfY];
        
        /* get the array of all data cells of service 'i', iterate through it and go through all subservices */
        NSMutableArray *dataCellArray = [vc serviceDataCellArray];
        
        posY += 15.0;
        pdfY += 55.0;
        
        // for each data cell of service 'i'
        for (int j = 0; j < [dataCellArray count]; j++){
            ServiceDataCell *data_cell = [dataCellArray objectAtIndex:j];
            [self printSubservice:data_cell PosX:&posX PosY:&posY PdfX:&pdfX PdfY:&pdfY];
            /*if ([[data_cell serviceType] isEqualToString:@"ductFurnaceCleaning"]){
                posY += 600.0;
                pdfY += 600.0;
            }
            posY += 135.0;
            pdfY += 130.0;*/
            
            [self printSubserviceNotes:data_cell PosX:posX PosY:&posY PdfX:pdfX PdfY:&pdfY];
            
            pdfY += 20.0;
            
            /*[label sizeToFit];
            int numLines = (int)(label.frame.size.height/label.font.leading);
            
            posY += 75.0;
            pdfY += 50.0;*/
            
            // adjust the scroll view / extend if necessary
            [self adjustScreenSize_CurrentY:posY];
            // adjust the pdf pages, if necessary
            [self adjustPdfPages_currentPdfY:&pdfY];
            
            // if j is the second last item in the dataCellArray array, then print the discount, if any
            if (([dataCellArray count] - 1) == j){
                [self printSubserviceDiscountService:[data_cell serviceType] PosX:posX PosY:posY PdfX:pdfX PdfY:pdfY];
                
                posY += 50.0;
                pdfY += 20.0;
            }
            
            // adjust the scroll view / extend if necessary
            [self adjustScreenSize_CurrentY:posY];
            // adjust the pdf pages, if necessary
            [self adjustPdfPages_currentPdfY:&pdfY];           
            
        }
        
        // if there are any subservices, print their subtotal and increase y
        if ([dataCellArray count]){
            [self printServiceTotal_PosX:posX PosY:posY PdfX:pdfX PdfY:pdfY ServiceName:[item name]];
            posY += 50.0;
            pdfY += 50.0;
            
            // adjust the scroll view / extend if necessary
            [self adjustScreenSize_CurrentY:posY];
            // adjust the pdf pages, if necessary
            [self adjustPdfPages_currentPdfY:&pdfY];
            
        }
        // increase y for the next service
        posY += 20.0;
        //pdfY += 20.0;
    }
    
    posY += 30.0;
    pdfY += 30.0;
    // print subtotal, tax and total..
    [self printTotal_PosX:posX PosY:&posY PdfX:pdfX PdfY:&pdfY];
    
    // adjust the scroll view / extend if necessary
    [self adjustScreenSize_CurrentY:posY];
    // adjust the pdf pages, if necessary
    [self adjustPdfPages_currentPdfY:&pdfY];
    
    // extend screen/pdf
    posY += 70.0;
    pdfY += 70.0;
    
    // adjust the scroll view / extend if necessary
    [self adjustScreenSize_CurrentY:posY];
    // adjust the pdf pages, if necessary
    // create a new pdf page on which to write the order information
    [self adjustNewPdfPage:&pdfY];
    
    // print other general order info
    [self printOrderInfo_ScreenPos:CGPointMake(posX, posY) PDFPos:CGPointMake(pdfX, pdfY)];
    
    posY += 800.0;
    pdfY += 800.0;
    
    // adjust the scroll view / extend if necessary
    [self adjustScreenSize_CurrentY:posY]; 
    // adjust the pdf pages, if necessary
    //[self adjustPdfPages_currentPdfY:&pdfY];
    
    // end drawing in pdf context
    UIGraphicsEndPDFContext();
}

-(void) printOrderInfo_ScreenPos: (CGPoint) pos PDFPos: (CGPoint) pdfpos {
    //CGFloat pdfFontSize = 15.0f;
    //CGFloat screenFontSize = 21.0f;
    UILabel* customerTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(pos.x, pos.y, 250.0f, 38.0f)];
    
    // add to an array of subviews
    [invoiceSubviews addObject:customerTitleLabel];
    
    // create label for the service subtotal
    [customerTitleLabel setText:[NSString stringWithFormat:@"Order Information "]];
    [customerTitleLabel setFont:[UIFont systemFontOfSize:21.0f]];
    
    pos.y += 40.0;
    
    UILabel* customerInfoLabel = [[UILabel alloc] initWithFrame: CGRectMake(pos.x, pos.y, 650.0f, 900.0f)];
    //UILabel* customerInfoDetailsLabel = [[UILabel alloc] initWithFrame: CGRectMake(pos.x + 200, pos.y, 300.0f, 400.0f)];
    // set as multiline
    [customerInfoLabel setNumberOfLines:0];
    //[customerInfoDetailsLabel setNumberOfLines:0];
    
    // add to invoiceSubviews ( so it can be deallocated later )
    [invoiceSubviews addObject:customerInfoLabel];
    //[invoiceSubviews addObject:customerInfoDetailsLabel];
    
    InvoiceManager *invMngr = [InvoiceManager sharedInvoiceManager];
    
    NSString* customerInfo = [NSString stringWithFormat:@"Name:\n%@ %@\n\nAddress:\n%@\n%@\n\nE-mail:\n%@\n\nPhone:\n%@ \n%@\n\nReferred By:\n%@\n\nBuilding Type:\n%@\n\nBuilding State:\n%@\n\nType of Products:\n%@\n\nInvoice No:\n%@\n\nPO No:\n%@\n\nOrder Date:\n%@\n\nTech Name:\n%@", [invMngr customerFirstName], [invMngr customerLastName], [invMngr customerAddressOne], [invMngr customerAddressTwo], [invMngr customerEmail], [invMngr customerPhoneNo], [invMngr customerPhoneNoTwo], [invMngr customerReferredBy], [invMngr typeOfBuilding], [invMngr buildingState], [invMngr usingProductType], [invMngr invoiceNo], [invMngr poNo], [invMngr orderDate], [invMngr technicianName]];
    
    // add properties
    [customerInfoLabel setText:customerInfo];
    [customerInfoLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    // print to screen
    [mainView addSubview:customerTitleLabel];
    [mainView addSubview:customerInfoLabel];
    //[mainView addSubview:customerInfoDetailsLabel];
    
    // printing to pdf (context)
    [self drawText:[NSString stringWithFormat: @"Order Information "] inFrame:CGRectMake(pdfpos.x, pdfpos.y,250.0, 40.0) withFontSize:15.0];
    
    pdfpos.y += 800.0;
    [self drawText:customerInfo inFrame:CGRectMake(pdfpos.x, pdfpos.y,200.0, 800.0) withFontSize:15.0];
    //[self drawText:detailsOnly inFrame:CGRectMake(pdfpos.x + 200, pdfpos.y,300.0, 300.0) withFontSize:15.0];
    
    // text above customer's signature
    [self drawText:@"Customer Signature " inFrame:CGRectMake(590.0, 915.0, 160.0, 40.0) withFontSize:13.0];
    // draw the customer's signature
    [[signatureImageView image] drawInRect:CGRectMake(600.0, 900.0, 100.0, 100.0)];
}

-(void) printServiceTotal_PosX: (CGFloat) posx PosY: (CGFloat) posy PdfX: (CGFloat) pdfx PdfY: (CGFloat) pdfy ServiceName: (NSString *) service_name {
    CGFloat subserviceFontSize = 13.0f;
    NSString *discountToDisplay = @"";
    if ([service_name isEqualToString:@"carpet"]){
        discountToDisplay = [NSString stringWithFormat:@"$%.02f ", [self discountedCarpetPrice]];
    } else if ([service_name isEqualToString:@"upholstery"]){
        discountToDisplay = [NSString stringWithFormat:@"$%.02f ", [self discountedUpholsteryPrice]];
    } else if ([service_name isEqualToString:@"mattress"]){
        discountToDisplay = [NSString stringWithFormat:@"$%.02f ", [self discountedMattressPrice]];
    } else if ([service_name isEqualToString:@"miscellaneous"]){
        discountToDisplay = [NSString stringWithFormat:@"$%.02f ", [self discountedMiscePrice]];
    } else if ([service_name isEqualToString:@"areaRugs"]){
        discountToDisplay = [NSString stringWithFormat:@"$%.02f ", [self discountedAreaRugsPrice]];
    } else if ([service_name isEqualToString:@"floodcleanup"]){
        discountToDisplay = [NSString stringWithFormat:@"$%.02f ", [self discountedFloodPrice]];
    } else if ([service_name isEqualToString:@"autoSpa"]){
        discountToDisplay = [NSString stringWithFormat:@"$%.02f ", [self discountedAutospaPrice]];
    } else if ([service_name isEqualToString:@"ductFurnaceCleaning"]){
        discountToDisplay = [NSString stringWithFormat:@"$%.02f ", [self discountedAutospaPrice]];
    }
    
    /* Print Service Subtotal */
    UILabel *serviceSubtotalLabel = [[UILabel alloc] initWithFrame: CGRectMake(posx, posy, 250.0f, 38.0f)];
    
    // add to an array of subviews
    [invoiceSubviews addObject:serviceSubtotalLabel];
    
    
    // create label for the service subtotal
    [serviceSubtotalLabel setText:[NSString stringWithFormat:@"Subtotal "]];
    [serviceSubtotalLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    posx += 600.0;
    
    UILabel *serviceSubtotalPriceLabel = [[UILabel alloc] initWithFrame: CGRectMake(posx, posy, 250.0f, 38.0f)];
    [serviceSubtotalPriceLabel setText:[NSString stringWithFormat:@"%@ ", discountToDisplay]];
    [serviceSubtotalPriceLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    // add to an array of subviews
    [invoiceSubviews addObject:serviceSubtotalPriceLabel];
    
    // print to screen
    [mainView addSubview:serviceSubtotalLabel];
    [mainView addSubview:serviceSubtotalPriceLabel];
    
    // print to pdf
    [self drawText:[NSString stringWithFormat:@"Subtotal "] inFrame:CGRectMake(pdfx, pdfy, 250.0f, 38.0f) withFontSize:subserviceFontSize];
    
    pdfx += 625.0;
    
    [self drawText:[NSString stringWithFormat:@"%@ ", discountToDisplay] inFrame:CGRectMake(pdfx, pdfy, 250.0f, 38.0f) withFontSize:subserviceFontSize];
}

-(void) printTotal_PosX: (CGFloat) posx PosY: (CGFloat*) posy PdfX: (CGFloat) pdfx PdfY: (CGFloat*) pdfy {
    
    // CGFloat totalPrice = subtotalCarpetPrice + subtotalUpholsteryPrice + subtotalMattressPrice + subtotalMiscePrice + subtotalAreaRugsPrice + subtotalFloodPrice;
    CGFloat totalPrice = discountedCarpetPrice + discountedUpholsteryPrice + discountedMattressPrice + discountedMiscePrice + discountedAreaRugsPrice + discountedFloodPrice + discountedAutospaPrice + discountedDuctFurnace;
    
    CGFloat gstPrice = totalPrice * 5/100;
    
    totalPrice = gstPrice + totalPrice;
    
    CGFloat pdfFontSize = 15.0f;
    CGFloat screenFontSize = 21.0f;
    
    UILabel *GSTNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, *posy, 250.0f, 70.0f)];
    [invoiceSubviews addObject:GSTNameLabel];
    [GSTNameLabel setFont:[UIFont systemFontOfSize:screenFontSize]];
    [GSTNameLabel setText:@"GST (5%) "];
    
    posx += 600.0;
    
    UILabel *priceGSTLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, *posy, 250.0f, 70.0f)];
    [invoiceSubviews addObject:priceGSTLabel];
    [priceGSTLabel setFont:[UIFont systemFontOfSize:screenFontSize]];
    [priceGSTLabel setText:[NSString stringWithFormat:@"$%.02f ", gstPrice]];
    
    posx -= 600.0;
    
    *posy += 60.0;
    
    UILabel *priceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, *posy, 250.0f, 70.0f)];
    [invoiceSubviews addObject:priceNameLabel];
    [priceNameLabel setFont:[UIFont systemFontOfSize:screenFontSize]];
    [priceNameLabel setText:@"Total "];
    
    posx += 600.0;
    //pdfx += 625.0;
    
    UILabel *priceTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, *posy, 250.0f, 70.0f)];
    [invoiceSubviews addObject:priceTotalLabel];
    [priceTotalLabel setFont:[UIFont systemFontOfSize:screenFontSize]];
    [priceTotalLabel setText:[NSString stringWithFormat:@"$%.02f ", totalPrice]];
    
    [mainView addSubview:priceNameLabel];
    [mainView addSubview:priceTotalLabel];
    [mainView addSubview:GSTNameLabel];
    [mainView addSubview:priceGSTLabel];
    
    [self drawText:[NSString stringWithFormat: @"GST "] inFrame:CGRectMake(pdfx, *pdfy,250.0, 70.0) withFontSize:pdfFontSize];
    pdfx += 625.0;
    [self drawText:[NSString stringWithFormat: @"$%.02f ", gstPrice] inFrame:CGRectMake(pdfx, *pdfy,250.0, 70.0) withFontSize:pdfFontSize];
    
    pdfx -= 625.0;
    *pdfy += 35.0;
    [self drawText:[NSString stringWithFormat: @"Total "] inFrame:CGRectMake(pdfx, *pdfy,250.0, 70.0) withFontSize:pdfFontSize];
    pdfx += 625.0;
    [self drawText:[NSString stringWithFormat: @"$%.02f ", totalPrice] inFrame:CGRectMake(pdfx, *pdfy,250.0, 70.0) withFontSize:pdfFontSize];
}

-(void) printSubserviceDiscountService: (NSString*) service_name PosX: (CGFloat) posx PosY: (CGFloat) posy PdfX: (CGFloat) pdfx PdfY: (CGFloat) pdfy {
    CGFloat subserviceFontSize = 13.0f;
    
    UILabel *discountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, posy, 250.0f, 70.0f)];
    UILabel *discountNameLabelpdf = [[UILabel alloc] initWithFrame:CGRectMake(pdfx, pdfy, 400.0f, 70.0f)];
    
    [invoiceSubviews addObject:discountNameLabel];
    [invoiceSubviews addObject:discountNameLabelpdf];
    
    [discountNameLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [discountNameLabel setNumberOfLines:0];  // allows for multiline
    [discountNameLabel setText:@"Discount"];
    //[discountNameLabelpdf setFont:[UIFont systemFontOfSize:17.0f]];
    
    // add the subview to the screen
    [mainView addSubview:discountNameLabel];
    [self drawText:[NSString stringWithFormat: @"Discount"] inFrame:discountNameLabelpdf.frame withFontSize:subserviceFontSize];
    
    posx += 600.0;
    pdfx += 625.0;
    
    UILabel *discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, posy, 250.0f, 70.0f)];
    UILabel *discountLabelpdf = [[UILabel alloc] initWithFrame:CGRectMake(pdfx, pdfy, 400.0f, 70.0f)];
    
    [discountLabel setFont:[UIFont systemFontOfSize:17.0f]];
    //[discountLabel setTextAlignment:NSTextAlignmentCenter];
    
    [invoiceSubviews addObject:discountLabel];
    [invoiceSubviews addObject:discountLabelpdf];
    
    NSString *discountToDisplay = @"";
    if ([service_name isEqualToString:@"carpet"]){
        discountToDisplay = [NSString stringWithFormat:@"-$%.02f ", [self carpetDiscount]];
    } else if([service_name isEqualToString:@"upholstery"]){
        discountToDisplay = [NSString stringWithFormat:@"-$%.02f ", [self upholsteryDiscount]];
    } else if([service_name isEqualToString:@"mattress"]){
        discountToDisplay = [NSString stringWithFormat:@"-$%.02f ", [self mattressDiscount]];
    } else if([service_name isEqualToString:@"miscellaneous"]){
        discountToDisplay = [NSString stringWithFormat:@"-$%.02f ", [self miscellaneousDiscount]];
    } else if([service_name isEqualToString:@"areaRugs"]){
        discountToDisplay = [NSString stringWithFormat:@"-$%.02f ", [self areaRugsDiscount]];
    } else if([service_name isEqualToString:@"floodcleanup"]){
        discountToDisplay = [NSString stringWithFormat:@"-$%.02f ", [self floodDiscount]];
    } else if([service_name isEqualToString:@"autoSpa"]){
        discountToDisplay = [NSString stringWithFormat:@"-$%.02f ", [self autospaDiscount]];
    } else if([service_name isEqualToString:@"ductFurnaceCleaning"]){
        discountToDisplay = [NSString stringWithFormat:@"-$%.02f ", [self ductFurnaceDiscount]];
    } else {
        discountToDisplay = [NSString stringWithFormat:@"-$%.02f ", 0.0f];
    }
    
    [discountLabel setText:discountToDisplay];
    [self drawText:discountToDisplay inFrame:discountLabelpdf.frame withFontSize:subserviceFontSize];

    [mainView addSubview:discountLabel];
}

-(void) printSubserviceNotes: (ServiceDataCell*) data_cell PosX: (CGFloat) posx PosY: (CGFloat*) posy PdfX: (CGFloat) pdfx PdfY: (CGFloat*) pdfy {
    UILabel *serviceDataNotes = [[UILabel alloc] initWithFrame:CGRectMake(posx, *posy, 670.0f, 100.0f)];
    
    UILabel *serviceDataNotesPdf = [[UILabel alloc] initWithFrame:CGRectMake(pdfx, *pdfy, 670.0f, 50.0f)];
    
    [invoiceSubviews addObject:serviceDataNotes];
    [serviceDataNotes setNumberOfLines:0];  // allows for multiline
    [serviceDataNotes setFont:[UIFont systemFontOfSize:17.0f]];
    
    CGFloat subserviceFontSize = 13.0f;
    
    [serviceDataNotes setText:[NSString stringWithFormat:@"Notes: %@", [data_cell notes]]];
    
    [serviceDataNotes sizeToFit];
    int numLines = (int)(serviceDataNotes.frame.size.height/serviceDataNotes.font.leading);
    
    // add the subview to the screen
    [mainView addSubview:serviceDataNotes];
    
    [self drawText:[NSString stringWithFormat:@"Notes: %@", [data_cell notes]] inFrame:serviceDataNotesPdf.frame withFontSize:subserviceFontSize];
    
    *posy += 25.0 * numLines;
    *pdfy += 35.0 * numLines;
    
    //*pdfy += 20.0;
}

-(void) printSubservice: (ServiceDataCell*) data_cell PosX: (CGFloat*) posx PosY: (CGFloat*) posy PdfX: (CGFloat*) pdfx PdfY: (CGFloat*) pdfy {
    UILabel *serviceDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(*posx, *posy, 400.0f, 70.0f)];
    UILabel *serviceDataLabelpdf = [[UILabel alloc] initWithFrame:CGRectMake(*pdfx, *pdfy, 400.0f, 70.0f)];
    
    [invoiceSubviews addObject:serviceDataLabel];
    [invoiceSubviews addObject:serviceDataLabelpdf];
    
    [serviceDataLabel setNumberOfLines:0];  // allows for multiline
    [serviceDataLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    CGFloat subserviceFontSize = 13.0f;
    
    float extraPosy = 0;
    float extraPdfy = 0;
    
    NSString *servicetype = [data_cell serviceType];
    
    if ([servicetype isEqualToString:@"carpet"]){
        subtotalCarpetPrice += [data_cell price];   // add price to subtotal
        discountedCarpetPrice = subtotalCarpetPrice - carpetDiscount;
        if ([[data_cell itemAttribute] isEqualToString:@"Room"] ){
            
            [serviceDataLabel setText:[NSString stringWithFormat: @"Room: %@, Area: %.02fx%.02f, Rate: $%.02f\naddons: %s%s%s",[data_cell name] , [data_cell rlength], [data_cell rwidth], [data_cell priceRate], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ]];
            [self drawText:[NSString stringWithFormat: @"Room: %@, Area: %.02fx%.02f, Rate: $%.02f\naddons: %s%s%s",[data_cell name] , [data_cell rlength], [data_cell rwidth], [data_cell priceRate], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ] inFrame:serviceDataLabelpdf.frame withFontSize:subserviceFontSize];
        } else {
            [serviceDataLabel setText:[NSString stringWithFormat: @"%@, # of stairs: %u, # of landings: %u",[data_cell name] ,
                                       [data_cell quantity], [data_cell quantity2] ]];
            
            [self drawText:[NSString stringWithFormat: @"%@, # of stairs: %u, # of landings: %u",[data_cell name] ,
                            [data_cell quantity], [data_cell quantity2] ] inFrame:serviceDataLabelpdf.frame withFontSize:subserviceFontSize];
        }
    } else if ([servicetype isEqualToString:@"upholstery"]){
        subtotalUpholsteryPrice += [data_cell price];   // add price to subtotal
        discountedUpholsteryPrice = subtotalUpholsteryPrice - upholsteryDiscount;
        [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Material: %@\nClean Type: %@, quantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell materialType], [data_cell vacOrFull], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ]];
        
        [self drawText:[NSString stringWithFormat: @"Item: %@, Material: %@\nClean Type: %@, quantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell materialType], [data_cell vacOrFull], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ] inFrame:serviceDataLabelpdf.frame withFontSize:subserviceFontSize];
        
    } else if ([servicetype isEqualToString:@"mattress"]){
        subtotalMattressPrice += [data_cell price];     // add price to subtotal
        discountedMattressPrice = subtotalMattressPrice - mattressDiscount;
        [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Clean Type: %@\nquantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell vacOrFull], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ]];
        
        [self drawText:[NSString stringWithFormat: @"Item: %@, Clean Type: %@\nquantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell vacOrFull], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ] inFrame:serviceDataLabelpdf.frame withFontSize:subserviceFontSize];
        
    } else if ([servicetype isEqualToString:@"miscellaneous"]){
        subtotalMiscePrice += [data_cell price];     // add price to subtotal
        discountedMiscePrice = subtotalMiscePrice - miscellaneousDiscount;
        [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Price per item: %.02f\nquantity: %u",[data_cell name] , [data_cell priceRate], [data_cell quantity] ]];
        
        [self drawText:[NSString stringWithFormat: @"Item: %@, Price per item: %.02f\nquantity: %u",[data_cell name] , [data_cell priceRate], [data_cell quantity] ] inFrame:serviceDataLabelpdf.frame withFontSize:subserviceFontSize];
        
    } else if ([servicetype isEqualToString:@"areaRugs"]){
        subtotalAreaRugsPrice += [data_cell price];     // add price to subtotal
        discountedAreaRugsPrice = subtotalAreaRugsPrice - areaRugsDiscount;
        [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Material: %@\nquantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell materialType], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ]];
        
        [self drawText:[NSString stringWithFormat: @"Item: %@, Material: %@\nquantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell materialType], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ] inFrame:serviceDataLabelpdf.frame withFontSize:subserviceFontSize];
        
    } else if ([servicetype isEqualToString:@"floodcleanup"]){
        subtotalFloodPrice += [data_cell price];     // add price to subtotal
        discountedFloodPrice = subtotalFloodPrice - floodDiscount;
        if ([[data_cell name] isEqualToString:@"Blowers"] || [[data_cell name] isEqualToString:@"Dehumidifiers"]){
            
            [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Rate per day: %.02f\n# of days: %u, quantity: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity], [data_cell quantity2]]];
            
            [self drawText:[NSString stringWithFormat: @"Item: %@, Rate per day: %.02f\n# of days: %u, quantity: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity], [data_cell quantity2]] inFrame:serviceDataLabelpdf.frame withFontSize:subserviceFontSize];
            
        } else if ([[data_cell name] isEqualToString:@"Biocide Application"]){
            
            [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Rate per sq.ft.: %.02f\nsquare feet: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity] ]];
            
            [self drawText:[NSString stringWithFormat: @"Item: %@, Rate per sq.ft.: %.02f\nsquare feet: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity] ] inFrame:serviceDataLabelpdf.frame withFontSize:subserviceFontSize];
            
        } else if ([[data_cell name] isEqualToString:@"Water Extraction"] || [[data_cell name] isEqualToString:@"Demolition"]){
            [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Rate per hr: %.02f\n# of hours: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity] ]];
            
            [self drawText:[NSString stringWithFormat: @"Item: %@, Rate per hr: %.02f\n# of hours: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity] ] inFrame:serviceDataLabelpdf.frame withFontSize:subserviceFontSize];
        }
    } else if ([servicetype isEqualToString:@"autoSpa"]){
        subtotalAutospaPrice += [data_cell price];     // add price to subtotal
        discountedAutospaPrice = subtotalAutospaPrice - autospaDiscount;
        [serviceDataLabel setText:[NSString stringWithFormat: @"Package: %@, Car Type: %@\nquantity: %u",[data_cell name] , [data_cell itemAttribute], [data_cell quantity] ]];
        
        [self drawText:[NSString stringWithFormat: @"Package: %@, Car Type: %@\nquantity: %u",[data_cell name] , [data_cell itemAttribute], [data_cell quantity] ] inFrame:serviceDataLabelpdf.frame withFontSize:subserviceFontSize];
        
    } else if ([servicetype isEqualToString:@"ductFurnaceCleaning"]){
        subtotalDuctFurnace += [data_cell price];     // add price to subtotal
        discountedDuctFurnace = subtotalDuctFurnace - ductFurnaceDiscount;
        
        [serviceDataLabel setText:[[data_cell attributesListTwo] objectAtIndex:23]];
        [serviceDataLabel sizeToFit];
        //[serviceDataLabelpdf setText:[[data_cell attributesListTwo] objectAtIndex:23]];
        //[serviceDataLabelpdf sizeToFit];
        int numLines = (int)(serviceDataLabel.frame.size.height/serviceDataLabel.font.leading);
        
        extraPosy = numLines * 15.0f;
        extraPdfy = numLines * 13.0f;
        //[serviceDataLabel sizeToFit];
        
        [serviceDataLabelpdf setFrame:CGRectMake(*pdfx, (*pdfy + extraPdfy), serviceDataLabelpdf.frame.size.width, 70.0f + extraPdfy)];        
        
        [self drawText:[[data_cell attributesListTwo] objectAtIndex:23] inFrame:serviceDataLabelpdf.frame withFontSize:subserviceFontSize];
    }    
    
    // add the subview to the screen
    [mainView addSubview:serviceDataLabel];
    
    float pricePosx = *posx + 600.0;
    float pricePdfx = *pdfx + 625.0;
    
    /* Print/draw the price of the subservice */
    UILabel *priceDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(pricePosx, *posy, 150.0f, 70.0f)];
    UILabel *priceDataLabelpdf = [[UILabel alloc] initWithFrame:CGRectMake(pricePdfx, *pdfy, 400.0f, 70.0f)];
    
    [priceDataLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [priceDataLabel setText:[NSString stringWithFormat:@"$%.02f ", [data_cell price]]];
    
    if ([servicetype isEqualToString:@"ductFurnaceCleaning"]){
        //[priceDataLabel setFrame:CGRectMake(posx, posy, 150.0f, 180.0f)];
        [priceDataLabel sizeToFit];
    }
    
    [priceDataLabelpdf setText:[NSString stringWithFormat:@"$%.02f ", [data_cell price]]];
    
    [invoiceSubviews addObject:priceDataLabel];
    [invoiceSubviews addObject:priceDataLabelpdf];
    
    [mainView addSubview:priceDataLabel];
    [self drawText:[NSString stringWithFormat:@"$%.02f ", [data_cell price]] inFrame:priceDataLabelpdf.frame withFontSize:subserviceFontSize];
    
    *posy += 135.0 + extraPosy;
    *pdfy += 40.0 + extraPdfy;
}

/* if current y ( posy ) is 200 pixels within the signatureImageView, then the 'mainView' needs to be extended. */
-(void) adjustScreenSize_CurrentY: (CGFloat) posy {
    if ((posy + 200) > signatureImageView.frame.size.height){
        //NSLog(@" ++ INCREASING SCROLLVIEWER HEIGHT ++ ");
        [mainView setContentSize:CGSizeMake(mainView.frame.size.width, posy + 600)];
        CGFloat maxY = posy + 600;
        [signatureImageView setFrame:CGRectMake(28.0f, maxY - 446.0f,331.0f, 257.0f)];
        [signaturebtn setFrame:CGRectMake(28.0f + 331.0f + 30.0f, maxY - 246.0f, 190.0f, 43.0f)];
        [backbtn setFrame:CGRectMake(47.0f, maxY - 107, 286.0f, 62.0f)];
    }
}

// check if there is any more room on the current pdf page; if there isn't, start a new page
-(void) adjustPdfPages_currentPdfY: (CGFloat *) pdfy{
    if ( (*pdfy + 100) > 1024 ){
        // pdfy = 130.0;
        *pdfy = 130.0;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 768.0, 1024.0), nil);
    }
}

// check if there is any more room on the current pdf page; if there isn't, start a new page
-(void) adjustPdfPagesLong_currentPdfY: (CGFloat *) pdfy{
    if ( (*pdfy + 600) > 1024 ){
        // pdfy = 130.0;
        *pdfy = 130.0;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 768.0, 1024.0), nil);
    }
}

// start new pdf page and restart the pdf y coordinate (pdfy)
-(void) adjustNewPdfPage: (CGFloat*) pdfy {
    *pdfy = 130.0;
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 768.0, 1024.0), nil);
}

-(void) printServiceNameAtX: (CGFloat) posx AtY: (CGFloat) posy AtPdfX: (CGFloat) pdfx AtPdfY: (CGFloat) pdfy withServiceName: (NSString*) service_name {
    /* Print Service Name */
    UILabel *serviceNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(posx, posy, 315.0f, 38.0f)];
    UILabel *serviceNameLabelpdf = [[UILabel alloc] initWithFrame: CGRectMake(pdfx, pdfy, 250.0f, 38.0f)];
    
    // add to an array of subviews
    [invoiceSubviews addObject:serviceNameLabel];
    [invoiceSubviews addObject:serviceNameLabelpdf];
    
    // create label for the service name
    NSLog(@"service name is %@", service_name);
    if ([service_name isEqualToString:@"carpet"]){
        [serviceNameLabel setText:@"Carpet Service"];
        [self drawText:@"Carpet Service" inFrame:CGRectMake(pdfx, pdfy, 250.0f, 38.0f) withFontSize:14.0f];         // print to pdf
    } else if ([service_name isEqualToString:@"upholstery"]){
        [serviceNameLabel setText:@"Upholstery Service"];
        [self drawText:@"Upholstery Service" inFrame:CGRectMake(pdfx, pdfy, 250.0f, 38.0f) withFontSize:14.0f];     // print to pdf
    } else if ([service_name isEqualToString:@"mattress"]){
        [serviceNameLabel setText:@"Mattress Service"];
        [self drawText:@"Mattress Service" inFrame:CGRectMake(pdfx, pdfy, 250.0f, 38.0f) withFontSize:14.0f];       // print to pdf
    } else if ([service_name isEqualToString:@"miscellaneous"]){
        [serviceNameLabel setText:@"Miscellaneous Service"];
        [self drawText:@"Miscellaneous Service" inFrame:CGRectMake(pdfx, pdfy, 250.0f, 38.0f) withFontSize:14.0f];  // print to pdf
    } else if ([service_name isEqualToString:@"areaRugs"]){
        [serviceNameLabel setText:@"Area Rugs Service"];
        [self drawText:@"Area Rugs Service" inFrame:CGRectMake(pdfx, pdfy, 250.0f, 38.0f) withFontSize:14.0f];      // print to pdf
    } else if ([service_name isEqualToString:@"floodcleanup"]){
        [serviceNameLabel setText:@"Flood Cleanup Service"];
        [self drawText:@"Flood Cleanup Service" inFrame:CGRectMake(pdfx, pdfy, 250.0f, 38.0f) withFontSize:14.0f];  // print to pdf
    } else if ([service_name isEqualToString:@"autoSpa"]){
        [serviceNameLabel setText:@"Auto Spa Service"];
        [self drawText:@"Auto Spa Service" inFrame:CGRectMake(pdfx, pdfy, 250.0f, 38.0f) withFontSize:14.0f];       // print to pdf
    } else if ([service_name isEqualToString:@"ductFurnaceCleaning"]){
        [serviceNameLabel setText:@"Duct & Furnace Cleaning"];
        [self drawText:@"Duct & Furnace Cleaning" inFrame:CGRectMake(pdfx, pdfy, 250.0f, 38.0f) withFontSize:14.0f];    // print to pdf
    }
    
    [serviceNameLabel setFont:[UIFont systemFontOfSize:25.0f]];
    //[serviceNameLabelpdf setText:[NSString stringWithFormat:@"%@ service ", service_name]];
    //[serviceNameLabelpdf setFont:[UIFont systemFontOfSize:25.0f]];
    // print to screen
    [mainView addSubview:serviceNameLabel];
}

// prints a discount UIButton on screen
-(void) printDiscountButtonAtX: (CGFloat) px AtY: (CGFloat) py withServiceName: (NSString*) service_name {
    UIButton *addDiscount = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addDiscount retain];
    [addDiscount setFrame:CGRectMake(px, py, 139.0f, 43.0f)];
    [addDiscount setTitle:@"Add Discount" forState:UIControlStateNormal];
    [addDiscount setRestorationIdentifier:service_name];
    //NSLog(@"()()()ADD DISCOUNT restoration id is %@", service_name);
    [addDiscount addTarget:self action:@selector(displayDiscountPopover:)
          forControlEvents:UIControlEventTouchDown];
    [mainView addSubview:addDiscount];  // add the uibutton to the 'mainView'
    [invoiceSubviews addObject:addDiscount];
}

// prints a horizontal line on screen and in pdf context
-(void) printHorizLineBelowX: (CGFloat)posx Y:(CGFloat) posy pdfX: (CGFloat) pdfx pdfY: (CGFloat) pdfy {
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(posx, posy, 698.0f, 3.0f)];
    UIImageView *linepdf = [[UIImageView alloc] initWithFrame:CGRectMake(pdfx, pdfy, 698.0f, 3.0f)];
    [line setImage:[UIImage imageNamed:@"horizontalLine5.png"]];
    [linepdf setImage:[UIImage imageNamed:@"horizontalLine5.png"]];
    [invoiceSubviews addObject:line];
    [invoiceSubviews addObject:linepdf];
    
    [mainView addSubview:line];
    
    [self drawImage:@"horizontalLine.png" withRect:CGRectMake(pdfx, pdfy, 698.0f, 3.0f)];
}

/* END of print/draw functions */

-(IBAction) sendMail {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    
    
    // adding attachment
    
    [controller addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"MightyCleanInvoice.pdf"];  // attach the pdf invoice
    
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Mighty Clean Invoice"];
    [controller setMessageBody:@"Please find attached a pdf copy of your invoice." isHTML:NO];
    
    // add the customer's email as a recipient
    InvoiceManager *invMngr = [InvoiceManager sharedInvoiceManager];
    NSArray *toRecipients = [NSArray arrayWithObjects:[invMngr customerEmail], nil];
    [controller setToRecipients:toRecipients];
    
    if (controller) {
        //[self presentModalViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
    }
    [controller release];
    
}

- (void)updateSignature:(SignaturePopoverVC *)optionsVS callType: (NSString *) call_type image: (UIImage*) image_arg {
    if ([call_type isEqualToString:@"cancel"]){
        [popoverController dismissPopoverAnimated:YES];
    } else if ([call_type isEqualToString:@"add"]){
        [popoverController dismissPopoverAnimated:YES];
        [signatureImageView setImage:image_arg];
    }
    [self createInvoice];
}

// instantiate popover (+ Add item) in terms of what service type page is generated
-(IBAction) displaySigPopover: (id) sender {
    
    // create new popover UIViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    
    SignaturePopoverVC *signatureVC = (SignaturePopoverVC*) [storyboard instantiateViewControllerWithIdentifier:@"SignaturePopoverVC"];
    if (popoverController){
        [popoverController setContentViewController:signatureVC];
    } else {
        popoverController = [[UIPopoverController alloc] initWithContentViewController:signatureVC];
    }
    signatureVC.signatureDelegate = self;
    // set the popover vc's content size
    [popoverController setPopoverContentSize:CGSizeMake(657, 515)];
    [popoverController presentPopoverFromRect:[signaturebtn frame] inView:mainView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    //[popoverController presentPopoverFromRect:[signaturebtn frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)updateDiscount:(InvoiceDiscountVC *)optionsVS updateType:(NSString*)update_type discountType: (NSString *) discountType_arg amount: (float) amount_arg forService: (NSString*) service_name_arg {
    
    if ([update_type isEqualToString:@"save"]){
        
        if ([service_name_arg isEqualToString:@"carpet"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                [self setCarpetDiscount:((amount_arg / 100.0) * subtotalCarpetPrice)];
            } else if ([discountType_arg isEqualToString:@"amount"]){
                [self setCarpetDiscount:amount_arg];
            }
        } else if ([service_name_arg isEqualToString:@"upholstery"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                [self setUpholsteryDiscount:(amount_arg / 100.0) * subtotalUpholsteryPrice];
            } else if ([discountType_arg isEqualToString:@"amount"]){
                [self setUpholsteryDiscount:amount_arg];
            }
        } else if ([service_name_arg isEqualToString:@"mattress"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                [self setMattressDiscount:(amount_arg / 100.0) * subtotalMattressPrice];
            } else if ([discountType_arg isEqualToString:@"amount"]){
                [self setMattressDiscount:amount_arg];
            }
        } else if ([service_name_arg isEqualToString:@"miscellaneous"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                [self setMiscellaneousDiscount:(amount_arg / 100.0) * subtotalMiscePrice];
            } else if ([discountType_arg isEqualToString:@"amount"]){
                [self setMiscellaneousDiscount:amount_arg];
            }
        } else if ([service_name_arg isEqualToString:@"areaRugs"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                [self setAreaRugsDiscount:(amount_arg / 100.0) * subtotalAreaRugsPrice];
            } else if ([discountType_arg isEqualToString:@"amount"]){
                [self setAreaRugsDiscount:amount_arg];
            }
        } else if ([service_name_arg isEqualToString:@"floodcleanup"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                [self setFloodDiscount:((amount_arg / 100.0) * subtotalFloodPrice)];
            } else if ([discountType_arg isEqualToString:@"amount"]){
                [self setFloodDiscount:amount_arg];
            }
        } else if ([service_name_arg isEqualToString:@"autoSpa"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                [self setAutospaDiscount:((amount_arg / 100.0) * subtotalAutospaPrice)];
            } else if ([discountType_arg isEqualToString:@"amount"]){
                [self setAutospaDiscount:amount_arg];
            }
        } else if ([service_name_arg isEqualToString:@"ductFurnaceCleaning"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                [self setDuctFurnaceDiscount:((amount_arg / 100.0) * subtotalDuctFurnace)];
            } else if ([discountType_arg isEqualToString:@"amount"]){
                [self setDuctFurnaceDiscount:amount_arg];
            }
        }
        
        [self clearView];
        [self createInvoice];
        
        [popoverController dismissPopoverAnimated:YES];
    } else if ([update_type isEqualToString:@"cancel"]){
        [popoverController dismissPopoverAnimated:YES];
    }
}

// display discount popover
-(IBAction) displayDiscountPopover: (id) sender {
    
    // create new popover UIViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    
    InvoiceDiscountVC *discountVC = (InvoiceDiscountVC*) [storyboard instantiateViewControllerWithIdentifier:@"InvoiceDiscountVC"];
    if (popoverController){
        [popoverController setContentViewController:discountVC];
    } else {
        popoverController = [[UIPopoverController alloc] initWithContentViewController:discountVC];
    }
    
    discountVC.discountDelegate = self;
    [discountVC setServiceName:[sender restorationIdentifier]];
    [popoverController setPopoverContentSize:CGSizeMake(657, 188)];
    [popoverController presentPopoverFromRect:[sender frame] inView:mainView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

/*=======================================================================================================*/
- (void) generatePdfWithFilePath: (NSString *)thefilePath
{
    //UIGraphicsBeginPDFContextToData(<#NSMutableData *data#>, <#CGRect bounds#>, <#NSDictionary *documentInfo#>)
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
    
    NSInteger currentPage = 0;
    //BOOL done = NO;
    //do
    //{
    //Start a new page.
    //UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    //UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 500, 1000), nil);
    //UIGraphicsE
    //Draw a page number at the bottom of each page.
    currentPage++;
    //[self drawPageNumber:currentPage];
    
    //Draw a border for each page.
    //[self drawBorder];
    
    //Draw text fo our header.
    //[self drawHeader];
    
    //Draw a line below the header.
    //[self drawLine];
    
    //Draw some text for the page.
    //[self drawText];
    //NSLog(@"width: %f, %f", pageSize.width, pageSize.height);
    [self drawText:@"Hello world2s" inFrame:CGRectMake(40, 80, 100, 50) withFontSize:23.0f];
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 500, 1000), nil);
    [self drawText:@"Hello world" inFrame:CGRectMake(40, 80, 100, 80) withFontSize:23.0f];
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 500, 1000), nil);
    [self drawText:@"Hello world" inFrame:CGRectMake(40, 80, 100, 80) withFontSize:23.0f];
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 500, 1000), nil);
    //[self drawText:@"Hello world" inFrame:CGRectMake(40, 80, 100, 1650)];
    //Draw an image
    //[self drawImage];
    //done = YES;
    //}
    //while (!done);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

- (void) drawImage: (NSString*) image_name withRect: (CGRect) rect_arg {
    UIImage * demoImage = [UIImage imageNamed:image_name];
    // [demoImage drawInRect:CGRectMake( (pageSize.width - demoImage.size.width/2)/2, 350, demoImage.size.width/2, demoImage.size.height/2)];
    // [demoImage drawInRect:CGRectMake( 100, 150, demoImage.size.width/2, demoImage.size.height/2)];
    [demoImage drawInRect:rect_arg];
}

-(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect withFontSize: (CGFloat)fontSize_arg
{
    //CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    CFStringRef stringRef = (CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    
    // Still unsure of why CFMutableAttributedStringRef instead of CFAttributedStringRef doesnt work, or what the mutable version
    // does extra// setting the font seems to work without it being mutable.
    
    // set the font size:
    int length=[textToDraw length];
    CTFontRef font = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize_arg, nil);
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)currentText,CFRangeMake(0, length-1),kCTFontAttributeName,font);
    
    /* // the mutable version.. gives bad exec access error if used
     CFMutableAttributedStringRef currentText = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
     CFStringRef stringRef = (CFStringRef) textToDraw;
     CFMutableAttributedStringRef currentText = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
     CFAttributedStringReplaceString (currentText,CFRangeMake(0, 0), string); */
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetFontSize(currentContext, fontSize_arg);
    
    //CGContextSetCMYKFillColor(currentContext, 1.0, 0.0, 0.0, 0.0, 0.0);
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    //CGContextTranslateCTM(currentContext, 0, 100);
    //CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    //CTFrameDraw(frameRef, currentContext);
    
    
    /*NEW ADDED:*/
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    // Modify this to take into consideration the origin.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    
    // Add these two lines to reverse the earlier transformation.
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    /*TILL HERE*/
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
    
}

/*=======================================================================================================*/

/*
 -(void)drawImage:(UIImage*)image inRect:(CGRect)rect
 {
 
 [image drawInRect:rect];
 
 }*/

-(IBAction) makeMeAPDF {
    /*
     // Create the PDF context using the default page size of 612 x 792.
     UIGraphicsBeginPDFContextToFile(@"Users/Oprescu/new.pdf", CGRectZero, nil);
     // Mark the beginning of a new page.
     UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
     
     // DRAW LOGO:
     for (UIView* view in [mainView subviews]) {
     if([view isKindOfClass:[UIImageView class]])
     {
     UIImage* logo = [UIImage imageNamed:@"mightyCleanCarpetCareLogo.png"];
     [self drawImage:logo inRect:CGRectMake(60.0f, 100.0f, 313.0f, 186.0f)];
     }
     }
     
     //[self drawText:@"Hello World" inFrame:CGRectMake(0, 0, 300, 50)];
     
     for (UIView* view in mainView.subviews) {
     for (UIView *view2 in view.subviews){
     if([view2 isKindOfClass:[UILabel class]])
     {
     UILabel* label2 = (UILabel*)view2;
     NSLog(@"label2 text is %@", [label2 text]);
     //[self drawText:label2.text inFrame:label2.frame];
     }
     }
     if([view isKindOfClass:[UILabel class]])
     {
     UILabel* label = (UILabel*)view;
     NSLog(@"label text is %@", [label text]);
     [self drawText:label.text inFrame:label.frame];
     }
     }
     
     
     UIGraphicsEndPDFContext(); */
    
    
    /*InvoiceManager *bla = [InvoiceManager sharedInvoiceManager];
     [bla createPDFfromUIView:self.view saveToDocumentsWithFileName:@"hello.pdf"];
     NSMutableData *pdfData = [bla createPDFDatafromUIView:mainView];*/
    //[self.view setNeedsDisplay];
    
    //[self.view setBackgroundColor:[UIColor clearColor]];
    //[mainView setBackgroundColor:[UIColor clearColor]];
    
    /*[self.view setNeedsDisplay];
     [mainView setNeedsDisplay];
     for (UIView *aSubview2 in [mainView subviews]){
     NSLog(@"name of view: %@", [aSubview2 restorationIdentifier]);
     [aSubview2 setNeedsDisplay];
     for (UIView *blah in aSubview2.subviews){
     [blah setNeedsDisplay];
     }
     }*/
    
    
    /*
     UIGraphicsBeginPDFContextToFile(@"Users/Oprescu/DUDE.pdf", CGRectMake(0, 0, 1000.0f, 600.0f), nil);
     
     UIGraphicsBeginPDFPage();
     
     
     CGContextRef pdfContext = UIGraphicsGetCurrentContext();
     [mainView.layer renderInContext:pdfContext];
     UIGraphicsEndPDFContext();*/
    
    [self generatePdfWithFilePath:@"Users/Oprescu/blah.pdf"];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//==================================== FOR SIGNATURE CAPTURE BELOW
//====================================
/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 
 mouseSwiped = NO;
 UITouch *touch = [touches anyObject];
 
 if ([touch tapCount] == 2) {
 drawImage.image = nil;
 return;
 }
 NSLog(@"Hello There !");
 lastPoint = [touch locationInView:signatureView];
 lastPoint.y -= 20;
 
 }
 
 
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 mouseSwiped = YES;
 NSLog(@"Hello There MOVEWD !");
 UITouch *touch = [touches anyObject];
 CGPoint currentPoint = [touch locationInView:signatureView];
 currentPoint.y -= 20;
 
 
 UIGraphicsBeginImageContext(signatureView.frame.size);
 NSLog(@"drawing");
 [drawImage.image drawInRect:CGRectMake(0, 0, signatureView.frame.size.width, signatureView.frame.size.height)];
 CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
 CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
 CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
 CGContextBeginPath(UIGraphicsGetCurrentContext());
 CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
 CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
 CGContextStrokePath(UIGraphicsGetCurrentContext());
 drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 lastPoint = currentPoint;
 
 mouseMoved++;
 
 if (mouseMoved == 10) {
 mouseMoved = 0;
 }
 
 }
 
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 NSLog(@"Hello There ENDED!");
 UITouch *touch = [touches anyObject];
 
 if ([touch tapCount] == 2) {
 drawImage.image = nil;
 return;
 }
 
 
 if(!mouseSwiped) {
 UIGraphicsBeginImageContext(signatureView.frame.size);
 [drawImage.image drawInRect:CGRectMake(0, 0, signatureView.frame.size.width, signatureView.frame.size.height)];
 CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
 CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
 CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
 CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
 CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
 CGContextStrokePath(UIGraphicsGetCurrentContext());
 CGContextFlush(UIGraphicsGetCurrentContext());
 drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 }
 }*/
//====================================
//==================================== FOR SIGNATURE CAPTURE ABOVE

-(IBAction) gotoLastView {
    //NSArray *viewsToRemove = [mainView subviews];
    for (UIView *v in invoiceSubviews){
        [v removeFromSuperview];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
