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
@synthesize mainView, test;
@synthesize signatureView;

@synthesize popoverController;
@synthesize signatureImageView;
@synthesize scrollViewer;
@synthesize backbtn, signaturebtn;
@synthesize invoiceSubviews;
@synthesize writePDF;
@synthesize carpetDiscount, upholsteryDiscount, mattressDiscount, areaRugsDiscount, miscellaneousDiscount, floodDiscount;
@synthesize discountedAreaRugsPrice, discountedCarpetPrice, discountedFloodPrice, discountedMattressPrice, discountedMiscePrice, discountedUpholsteryPrice;
@synthesize subtotalCarpetPrice, subtotalUpholsteryPrice, subtotalMattressPrice, subtotalMiscePrice, subtotalAreaRugsPrice, subtotalFloodPrice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*-(void) viewDidAppear:(BOOL)animated {
    [mainView setBackgroundColor:[UIColor clearColor]];
    [mainView setOpaque:NO];
}*/

- (void)viewDidLoad
{
    NSLog(@"setting scrollviewer");
    [scrollViewer setScrollEnabled:YES];
    [scrollViewer setContentSize:CGSizeMake(768, 1024)];
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    
    if (!invoiceSubviews){
        invoiceSubviews = [[NSMutableArray alloc] initWithCapacity:2];
        NSLog(@"initiating mutable array..");
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
    
    discountedUpholsteryPrice = 0;
    discountedMattressPrice = 0;
    discountedMiscePrice = 0;
    discountedFloodPrice = 0;
    discountedCarpetPrice = 0;
    discountedAreaRugsPrice = 0;
    
    [self createInvoice];
}

-(IBAction) createInvoice {
    
    float subtotal = 0;
    InvoiceManager *invMngr = [InvoiceManager sharedInvoiceManager];
    
    CGFloat posX = 53.0;
    CGFloat posY = 382.0;
    
    CGFloat pdfX = 53.0;
    CGFloat pdfY = 382.0;
    
    // START PDF CREATION
    UIGraphicsBeginPDFContextToFile(@"Users/Oprescu/blahblah.pdf", CGRectZero, nil);
    //UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1753, 1240), nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 768.0, 1024.0), nil);
    //[self drawText];
    //NSLog(@"width: %f, %f", pageSize.width, pageSize.height);
    //[self drawText:@"Hello world2s" inFrame:CGRectMake(40, 80, 100, 50) withFontSize:223.0f];
    //UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 500, 1000), nil);
    //[self drawText:@"Hello world" inFrame:CGRectMake(40, 80, 100, 80)];
    //UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 500, 1000), nil);
    //[self drawText:@"Hello world" inFrame:CGRectMake(40, 80, 100, 80)];
    //[self drawText:@"Hello world" inFrame:CGRectMake(40, 80, 100, 1650)];
    
    //Draw an image
    //[self drawImage];
    //done = YES;
    //}
    //while (!done);
    [self drawImage:@"pdfBackg.png" withRect:CGRectMake(0.0, 0.0, 768.0f, 1024.0f)];
    [self drawImage:@"invoice_image" withRect:CGRectMake(40.0, 40.0, 174.0f, 35.0f)];
    
    
    /*
    [self drawImage:@"horizontalLine5.png" withRect:CGRectMake(0.0, 100.0, 500.0f, 5.0f)];
    [self drawImage:@"horizontalLine5.png" withRect:CGRectMake(0.0, 200.0, 500.0f, 5.0f)];
    [self drawImage:@"horizontalLine5.png" withRect:CGRectMake(0.0, 300.0, 500.0f, 5.0f)];
    [self drawImage:@"horizontalLine5.png" withRect:CGRectMake(0.0, 400.0, 500.0f, 5.0f)];
    [self drawImage:@"horizontalLine5.png" withRect:CGRectMake(0.0, 500.0, 500.0f, 5.0f)];
     */
    
    // Mighty Clean Invoice Address: 
    [self drawText:[NSString stringWithFormat:@"From: Mighty Clean 1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 8 9 1 2 \n Address \n Edmonton, Alberta"] inFrame:CGRectMake(40.0, 200.0, 300.0f, 100.0f) withFontSize:16.0];
    // Customer Invoice Address:
    
    [self drawText:[NSString stringWithFormat:@"To: %@ %@ \n %@\n email: %@\n haha \n 2 \n 3 \n 4 \n 5 \n 6 \n 7 \n 8", [invMngr customerFirstName], [invMngr customerLastName], [invMngr
        customerAddressOne], [invMngr customerEmail]] inFrame:CGRectMake(40.0, 300.0, 300.0f, 100.0f) withFontSize:16.0];
    
    // NSInteger currentPage = 0;
    
    // [self drawImage:@"mightyCleanCarpetCareLogo.png" withRect:CGRectMake(430.0, 35.0, 313.0f, 186.0f)]; // in the middle ish
    [self drawImage:@"mightyCleanCarpetCareLogo.png" withRect:CGRectMake(425.0, 35.0, 313.0f, 186.0f)];
    
    // [self drawImage:@"horizontalLine5.png" withRect:CGRectMake(0.0, 210.0, 500.0f, 5.0f)];
    //[mainView setBackgroundColor:[UIColor whiteColor]];
    //[self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setSubtotalAreaRugsPrice:0];
    [self setSubtotalCarpetPrice:0];
    [self setSubtotalFloodPrice:0];
    [self setSubtotalMattressPrice:0];
    [self setSubtotalMiscePrice:0];
    [self setSubtotalUpholsteryPrice:0];
    
    for (int i = 0; i < [[invMngr listOfServices] count]; i++){
        //NSLog(@"printout: %@", [[[invMngr listOfServices] objectAtIndex:i] name]);
        ServiceItem *item = [[invMngr listOfServices] objectAtIndex:i];
        ServiceTypeViewController *vc = (ServiceTypeViewController*)[[[invMngr listOfServices] objectAtIndex:i] serviceVC];
        
        UILabel *serviceNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(posX, posY, 250.0f, 38.0f)];
        UILabel *serviceNameLabelpdf = [[UILabel alloc] initWithFrame: CGRectMake(pdfX, pdfY, 250.0f, 38.0f)];
        
        [invoiceSubviews addObject:serviceNameLabel];       // add to an array
        [invoiceSubviews addObject:serviceNameLabelpdf];
        
        [serviceNameLabel setText:[NSString stringWithFormat:@"%@ service", [item name]]];
        [serviceNameLabel setFont:[UIFont systemFontOfSize:25.0f]];
        [serviceNameLabelpdf setText:[NSString stringWithFormat:@"%@ service", [item name]]];
        [serviceNameLabelpdf setFont:[UIFont systemFontOfSize:25.0f]];
        //[self.view addSubview:serviceNameLabel];
        [mainView addSubview:serviceNameLabel];
        [self drawText:[NSString stringWithFormat:@"%@ service", [item name]] inFrame:CGRectMake(pdfX, pdfY, 250.0f, 38.0f) withFontSize:16.0f];
        
        // SUBTOTAL SERVICE PRICE LABEL:
        UILabel *subtotalServiceLabel = [[UILabel alloc] initWithFrame: CGRectMake(posX + 550, posY, 250.0f, 38.0f)];
        UILabel *subtotalServiceLabelpdf = [[UILabel alloc] initWithFrame: CGRectMake(pdfX + 550, pdfY, 150.0f, 70.0f)];
        
        // [subtotalServiceLabelpdf retain];
        
        [invoiceSubviews addObject:subtotalServiceLabel];
        [invoiceSubviews addObject:subtotalServiceLabelpdf];
        
        [subtotalServiceLabel setText:[NSString stringWithFormat:@"$%.02f",0.0f ]];
        
        [mainView addSubview:subtotalServiceLabel];
        // THE FOLLOWING IS WRITTEN MUCH LATERR IN THIS CODE WHEN ITS ACTUALLY CALCULATED ! ____ ******
        //[self drawText:[NSString stringWithFormat:@"%.02f", 0.0f] inFrame:subtotalServiceLabelpdf.frame withFontSize:16.0f];
        
        
        //UIButton *addDiscount = [[UIButton alloc] initWithFrame:CGRectMake(200.0, 200.0, 139.0f, 43.0f)];
        UIButton *addDiscount = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addDiscount setFrame:CGRectMake(posX + 335.0, posY, 139.0f, 43.0f)];
        [addDiscount setTitle:@"Add Discount" forState:UIControlStateNormal];
        [addDiscount setRestorationIdentifier:[item name]];
        //NSLog(@">>>> item name is %@", [item name]);
        [addDiscount addTarget:self action:@selector(displayDiscountPopover:)
              forControlEvents:UIControlEventTouchDown];
        [mainView addSubview:addDiscount];
        //[invoiceSubviews addObject:addDiscount];
        
        //[self drawText:@"asdf asdf asdf asd" inFrame:CGRectMake(0,0,300,50)]; // NEW ADDITION ****
        //posX = posX - 10.0;
        posY = posY + 45.0;
        pdfY = pdfY + 45.0;
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 698.0f, 4.0f)];
        UIImageView *linepdf = [[UIImageView alloc] initWithFrame:CGRectMake(pdfX, pdfY, 698.0f, 4.0f)];
        
        [line setImage:[UIImage imageNamed:@"horizontalLine5.png"]];
        [linepdf setImage:[UIImage imageNamed:@"horizontalLine5.png"]];
        
        [invoiceSubviews addObject:line];
        [invoiceSubviews addObject:linepdf];
        
        [mainView addSubview:line];
        
        posX = posX + 50.0;
        posY = posY + 15.0;
        
        pdfX = pdfX + 50.0;
        pdfY = pdfY + 15.0;
        
        /*if ((posY + 150) > mainView.frame.size.height){
            NSLog(@"increasing scrollviewer by 100 .. ");
            [mainView setContentSize:CGSizeMake(mainView.frame.size.width, mainView.frame.size.height + 300)];
        }*/
        
        NSMutableArray *dataCellArray = [vc serviceDataCellArray];
        float priceOfService = 0;
        // for each data cell..
        for (int j = 0; j < [dataCellArray count]; j++){
            ServiceDataCell *data_cell = [dataCellArray objectAtIndex:j];
            UILabel *serviceDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 520.0f, 70.0f)];
            UILabel *serviceDataLabelpdf = [[UILabel alloc] initWithFrame:CGRectMake(pdfX, pdfY, 520.0f, 70.0f)];
            
            [invoiceSubviews addObject:serviceDataLabel];
            [invoiceSubviews addObject:serviceDataLabelpdf];

            [serviceDataLabel setNumberOfLines:0];  // allows for multiline
            [serviceDataLabel setFont:[UIFont systemFontOfSize:17.0f]];
            
            [serviceNameLabelpdf setNumberOfLines:0];
            [serviceNameLabelpdf setFont:[UIFont systemFontOfSize:17.0f]];
            
            //NSLog(@"IT IS UPHOLSTERY");
            NSString *servicetype = [data_cell serviceType];
            if ([servicetype isEqualToString:@"carpet"]){
                if ([[data_cell itemAttribute] isEqualToString:@"Room"] ){
                    
                    [serviceDataLabel setText:[NSString stringWithFormat: @"Room: %@, Area: %.02fx%.02f, Rate: $%.02f\naddons: %s%s%s",[data_cell name] , [data_cell rlength], [data_cell rwidth], [data_cell priceRate], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ]];
                    [self drawText:[NSString stringWithFormat: @"Room: %@, Area: %.02fx%.02f, Rate: $%.02f\naddons: %s%s%s",[data_cell name] , [data_cell rlength], [data_cell rwidth], [data_cell priceRate], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ] inFrame:serviceDataLabelpdf.frame withFontSize:16.0f];
                } else {
                    [serviceDataLabel setText:[NSString stringWithFormat: @"%@, # of stairs: %u, # of landings: %u",[data_cell name] ,
                                               [data_cell quantity], [data_cell quantity2] ]];
                    
                    [self drawText:[NSString stringWithFormat: @"%@, # of stairs: %u, # of landings: %u",[data_cell name] ,
                                    [data_cell quantity], [data_cell quantity2] ] inFrame:serviceDataLabelpdf.frame withFontSize:16.0f];
                }
            } else if ([servicetype isEqualToString:@"upholstery"]){
                
                    [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Material: %@\nClean Type: %@, quantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell materialType], [data_cell vacOrFull], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ]];
                
                    [self drawText:[NSString stringWithFormat: @"Item: %@, Material: %@\nClean Type: %@, quantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell materialType], [data_cell vacOrFull], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ] inFrame:serviceDataLabelpdf.frame withFontSize:16.0f];
                
            } else if ([servicetype isEqualToString:@"mattress"]){
                [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Clean Type: %@\nquantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell vacOrFull], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ]];
                
                [self drawText:[NSString stringWithFormat: @"Item: %@, Clean Type: %@\nquantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell vacOrFull], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ] inFrame:serviceDataLabelpdf.frame withFontSize:16.0f];
                
            } else if ([servicetype isEqualToString:@"miscellaneous"]){
                
                [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Price per item: %.02f\nquantity: %u",[data_cell name] , [data_cell priceRate], [data_cell quantity] ]];
                
                [self drawText:[NSString stringWithFormat: @"Item: %@, Price per item: %.02f\nquantity: %u",[data_cell name] , [data_cell priceRate], [data_cell quantity] ] inFrame:serviceDataLabelpdf.frame withFontSize:16.0f];
                
            } else if ([servicetype isEqualToString:@"areaRugs"]){
                
                [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Material: %@\nquantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell materialType], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ]];
                
                [self drawText:[NSString stringWithFormat: @"Item: %@, Material: %@\nquantity: %u\naddons: %s%s%s",[data_cell name] , [data_cell materialType], [data_cell quantity], [data_cell addonBiocide] ? " (Biocide)" : "", [data_cell addonDeodorizer] ? " (Deodorizer)" : "", [data_cell addonFabricProtector] ? " (Fabric Protector)" : "" ] inFrame:serviceDataLabelpdf.frame withFontSize:16.0f];
                
            } else if ([servicetype isEqualToString:@"floodcleanup"]){
                
                if ([[data_cell name] isEqualToString:@"Blowers"] || [[data_cell name] isEqualToString:@"Dehumidifiers"]){
                    
                    [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Rate per day: %.02f\n# of days: %u, quantity: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity], [data_cell quantity2]]];
                    
                    [self drawText:[NSString stringWithFormat: @"Item: %@, Rate per day: %.02f\n# of days: %u, quantity: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity], [data_cell quantity2]] inFrame:serviceDataLabelpdf.frame withFontSize:16.0f];
                    
                } else if ([[data_cell name] isEqualToString:@"Biocide Application"]){
                    
                    [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Rate per sq.ft.: %.02f\nsquare feet: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity] ]];
                    
                    [self drawText:[NSString stringWithFormat: @"Item: %@, Rate per sq.ft.: %.02f\nsquare feet: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity] ] inFrame:serviceDataLabelpdf.frame withFontSize:16.0f];
                    
                } else if ([[data_cell name] isEqualToString:@"Water Extraction"] || [[data_cell name] isEqualToString:@"Demolition"]){
                    [serviceDataLabel setText:[NSString stringWithFormat: @"Item: %@, Rate per hr: %.02f\n# of hours: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity] ]];
                    
                    [self drawText:[NSString stringWithFormat: @"Item: %@, Rate per hr: %.02f\n# of hours: %u",[data_cell name], [data_cell ratePerHr], [data_cell quantity] ] inFrame:serviceDataLabelpdf.frame withFontSize:16.0f];
                }
                

            }
            /*
            name = upholstery item name
            materialType = leather, synthetic, natural, specialty
            vacOrFull = (power-vac only | full clean)
            quantity = ..
            price = full price ( quantity * price per item, which is hardcoded )
            */
            //[self.view addSubview:serviceDataLabel];
            [mainView addSubview:serviceDataLabel];
            //NSLog(@"OUT: %@", serviceDataLabel.text);
            //NSLog(@"height of frame is %f, posY is %f", mainView.frame.size.height, posY);
            //[self drawText:@"asdf" inFrame:CGRectMake(93.0, 432.0, 320.0f, 40.0f)];
            
            //[self drawText:serviceDataLabel.text inFrame:serviceDataLabel.frame]; // NEW ADDITION ****
            
            posX = posX + 505.0;
            posY = posY - 10.0;
            pdfX = pdfX + 505.0;
            pdfY = pdfY - 10.0;
            
            //NSLog(@"pdf y for price is: %f, %@", pdfY, );
            UILabel *priceDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 150.0f, 40.0f)];
            UILabel *priceDataLabelpdf = [[UILabel alloc] initWithFrame:CGRectMake(pdfX, pdfY, 150.0f, 40.0f)];
            
            [priceDataLabel setFont:[UIFont systemFontOfSize:17.0f]];
            [priceDataLabel setTextAlignment:NSTextAlignmentCenter];
            [priceDataLabel setText:[NSString stringWithFormat:@"$%.02f", [data_cell price]]];
            
            [priceDataLabelpdf setFont:[UIFont systemFontOfSize:17.0f]];
            [priceDataLabelpdf setTextAlignment:NSTextAlignmentCenter];
            [priceDataLabelpdf setText:[NSString stringWithFormat:@"$%.02f", [data_cell price]]];
            
            [invoiceSubviews addObject:priceDataLabel];
            [invoiceSubviews addObject:priceDataLabelpdf];

            [mainView addSubview:priceDataLabel];
            [self drawText:[NSString stringWithFormat:@"$%.02f", [data_cell price]] inFrame:CGRectMake(pdfX, pdfY, priceDataLabelpdf.frame.size.width, priceDataLabelpdf.frame.size.height) withFontSize:16.0f];
            
            // subtotal includes prices for ALL services
            //subtotal = subtotal + [data_cell price];
            if ([[item name] isEqualToString:@"carpet"]){
                subtotalCarpetPrice += [data_cell price];
                NSLog(@"carpet discount is %f", carpetDiscount);
                discountedCarpetPrice = subtotalCarpetPrice - [self carpetDiscount];
                [subtotalServiceLabel setText:[NSString stringWithFormat:@"$%.02f",discountedCarpetPrice]];
                if (([dataCellArray count] - 1) == j){
                    [self drawText:[NSString stringWithFormat:@"$%.02f", discountedCarpetPrice] inFrame:subtotalServiceLabelpdf.frame withFontSize:16.0f];
                }
                

            } else if([[item name] isEqualToString:@"upholstery"]){
                subtotalUpholsteryPrice += [data_cell price];
                discountedUpholsteryPrice = subtotalUpholsteryPrice - upholsteryDiscount;
                [subtotalServiceLabel setText:[NSString stringWithFormat:@"$%.02f",discountedUpholsteryPrice]];
                if (([dataCellArray count] - 1) == j){
                    [self drawText:[NSString stringWithFormat:@"$%.02f", discountedUpholsteryPrice] inFrame:subtotalServiceLabelpdf.frame withFontSize:16.0f];
                }
            } else if([[item name] isEqualToString:@"mattress"]){
                subtotalMattressPrice += [data_cell price];
                discountedMattressPrice = subtotalMattressPrice - mattressDiscount;
                [subtotalServiceLabel setText:[NSString stringWithFormat:@"$%.02f",discountedMattressPrice]];
                if (([dataCellArray count] - 1) == j){
                    [self drawText:[NSString stringWithFormat:@"$%.02f", discountedMattressPrice] inFrame:subtotalServiceLabelpdf.frame withFontSize:16.0f];
                }
            } else if([[item name] isEqualToString:@"miscellaneous"]){
                subtotalMiscePrice += [data_cell price];
                discountedMiscePrice = subtotalMiscePrice - miscellaneousDiscount;
                [subtotalServiceLabel setText:[NSString stringWithFormat:@"$%.02f",discountedMiscePrice]];
                if (([dataCellArray count] - 1) == j){
                    [self drawText:[NSString stringWithFormat:@"$%.02f", discountedMiscePrice] inFrame:subtotalServiceLabelpdf.frame withFontSize:16.0f];
                }
            } else if([[item name] isEqualToString:@"areaRugs"]){
                subtotalAreaRugsPrice += [data_cell price];
                discountedAreaRugsPrice = subtotalAreaRugsPrice - areaRugsDiscount;
                [subtotalServiceLabel setText:[NSString stringWithFormat:@"$%.02f",discountedAreaRugsPrice]];
                if (([dataCellArray count] - 1) == j){
                    [self drawText:[NSString stringWithFormat:@"$%.02f", discountedAreaRugsPrice] inFrame:subtotalServiceLabelpdf.frame withFontSize:16.0f];
                }
            } else if([[item name] isEqualToString:@"floodcleanup"]){
                subtotalFloodPrice += [data_cell price];
                discountedFloodPrice = subtotalFloodPrice - floodDiscount;
                [subtotalServiceLabel setText:[NSString stringWithFormat:@"$%.02f",discountedFloodPrice]];
                if (([dataCellArray count] - 1) == j){
                    [self drawText:[NSString stringWithFormat:@"$%.02f", discountedFloodPrice] inFrame:subtotalServiceLabelpdf.frame withFontSize:16.0f];
                }
            }
            
            // IF IT IS AT ITS LAST ITERATION..
            if (([dataCellArray count] - 1) == j){
                NSLog(@"LAST ITERATION FOR %@", [item name]);
                posY = posY + 50.0;
                pdfY = pdfY + 50.0;
                UILabel *discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 150.0f, 40.0f)];
                UILabel *discountLabelpdf = [[UILabel alloc] initWithFrame:CGRectMake(pdfX, pdfY, 150.0f, 40.0f)];
                
                [discountLabel setFont:[UIFont systemFontOfSize:17.0f]];
                [discountLabel setTextAlignment:NSTextAlignmentCenter];

                
                [discountLabelpdf setFont:[UIFont systemFontOfSize:17.0f]];
                [discountLabelpdf setTextAlignment:NSTextAlignmentCenter];
                
                
                [invoiceSubviews addObject:discountLabel];
                [invoiceSubviews addObject:discountLabelpdf];
                
                NSString *discountToDisplay = @"";
                if ([[item name] isEqualToString:@"carpet"]){
                    discountToDisplay = [NSString stringWithFormat:@"-$%.02f", [self carpetDiscount]];
                } else if([[item name] isEqualToString:@"upholstery"]){
                    discountToDisplay = [NSString stringWithFormat:@"-$%.02f", [self upholsteryDiscount]];
                } else if([[item name] isEqualToString:@"mattress"]){
                    discountToDisplay = [NSString stringWithFormat:@"-$%.02f", [self mattressDiscount]];
                } else if([[item name] isEqualToString:@"miscellaneous"]){
                    discountToDisplay = [NSString stringWithFormat:@"-$%.02f", [self miscellaneousDiscount]];
                } else if([[item name] isEqualToString:@"areaRugs"]){
                    discountToDisplay = [NSString stringWithFormat:@"-$%.02f", [self areaRugsDiscount]];
                } else if([[item name] isEqualToString:@"floodcleanup"]){
                    discountToDisplay = [NSString stringWithFormat:@"-$%.02f", [self floodDiscount]];
                }
                
                [discountLabel setText:discountToDisplay];
                [self drawText:discountToDisplay inFrame:CGRectMake(pdfX, pdfY, discountLabelpdf.frame.size.width, discountLabelpdf.frame.size.height) withFontSize:16.0f];
                
                [mainView addSubview:discountLabel];
                
            }
            
            // add to the price of the current service
            priceOfService = priceOfService + [data_cell price];
            
            
            
            posY = posY + 10.0;
            pdfY = pdfY + 10.0;
            
            posX = posX - 505.0;
            pdfX = pdfX - 505.0;
            
            posY = posY + 80.0;
            pdfY = pdfY + 80.0;
            
            // start new pdf page if its too close to the edge
            if ( (pdfY + 100) > 1024 ){
                pdfY = 130;
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 768.0, 1024.0), nil);
            }
            
            // ******************************
            if ((posY + 200) > signatureImageView.frame.size.height){
                //NSLog(@"increasing scrollviewer by 100 .. ");
                [mainView setContentSize:CGSizeMake(mainView.frame.size.width, posY + 600)];
                //[signatureImageView setFrame:CGRectMake(28.0f, posY + 200, 331.0f, 257.0f)];
                CGFloat maxY = posY + 600;
                [signatureImageView setFrame:CGRectMake(28.0f, maxY - 446.0f,331.0f, 257.0f)];
                [signaturebtn setFrame:CGRectMake(28.0f + 331.0f + 30.0f, maxY - 246.0f, 190.0f, 43.0f)];
                [backbtn setFrame:CGRectMake(47.0f, maxY - 107, 286.0f, 62.0f)];
            }
            
        }
        
        posX = posX - 50.0;
        pdfX = pdfX - 50.0;
        
        // ******************************
        if ((posY + 200) > signatureImageView.frame.size.height){
            //NSLog(@"increasing scrollviewer by 100 .. ");
            [mainView setContentSize:CGSizeMake(mainView.frame.size.width, posY + 600)];
            //[signatureImageView setFrame:CGRectMake(28.0f, posY + 200, 331.0f, 257.0f)];
            CGFloat maxY = posY + 600;
            [signatureImageView setFrame:CGRectMake(28.0f, maxY - 446.0f,331.0f, 257.0f)];
            [signaturebtn setFrame:CGRectMake(28.0f + 331.0f + 30.0f, maxY - 246.0f, 190.0f, 43.0f)];
            [backbtn setFrame:CGRectMake(47.0f, maxY - 107, 286.0f, 62.0f)];
        }
        if ( (pdfY + 100) > 1024 ){
            pdfY = 130.0;
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 768.0, 1024.0), nil);
        }
        
        //UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 698.0f, 4.0f)];
        //[line2 setImage:[UIImage imageNamed:@"horizontalLine5.png"]];
        //[self.view addSubview:line2];
        //[mainView addSubview:line2];
        
        //[self drawImage:@"horizontalLine5.png" withRect:line2.frame];

        
        
        /*for (int j = 0; j < [[aa serviceDataCellArray] count]; j++){
            NSLog(@"name: %@", [[[aa serviceDataCellArray] objectAtIndex:j] name]);
        }*/
        
    }
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
    //mainView.frame = CGRectIntegral(mainView.frame);
    

    
    //[MFMailComposeViewController canSendMail];
    /*MFMailComposeViewController *vc = [[[MFMailComposeViewController alloc] init] autorelease];
    [vc setSubject:@"my pdf"];
    [vc addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"SomeFile.pdf"];
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    [controller addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"blah.pdf"];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"My Subject"];
    [controller setMessageBody:@"Hello there." isHTML:NO];
    if (controller) {
        //[self presentModalViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
    }
    [controller release];
    
    if ([MFMailComposeViewController canSendMail]) {
        // Show the composer
        NSLog(@"IT IS CONFIGURED");
    } else {
        // Handle the error
        NSLog(@"IT IS NOT CONFIGURED");
    }*/
}

-(IBAction) sendMail {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    //[controller addAttachmentData:nil mimeType:@"application/pdf" fileName:@"blah.pdf"];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"My Subject"];
    [controller setMessageBody:@"Hello there." isHTML:NO];
    if (controller) {
        //[self presentModalViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
    }
    [controller release];

}

- (void)updateSignature:(SignaturePopoverVC *)optionsVS callType: (NSString *) call_type image: (UIImage*) image_arg {
    NSLog(@"HELLO WORLD ! ! !");
    if ([call_type isEqualToString:@"cancel"]){
        [popoverController dismissPopoverAnimated:YES];
    } else if ([call_type isEqualToString:@"add"]){
        [popoverController dismissPopoverAnimated:YES];
        [signatureImageView setImage:image_arg];
    }
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
    [popoverController presentPopoverFromRect:[signaturebtn frame] inView:mainView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];    
}

- (void)updateDiscount:(InvoiceDiscountVC *)optionsVS updateType:(NSString*)update_type discountType: (NSString *) discountType_arg amount: (float) amount_arg forService: (NSString*) service_name_arg {
    InvoiceManager *invMngr = [InvoiceManager sharedInvoiceManager];
    
    if ([update_type isEqualToString:@"save"]){
        
        if ([service_name_arg isEqualToString:@"carpet"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                [self setCarpetDiscount:((amount_arg / 100.0) * subtotalCarpetPrice)];
            } else if ([discountType_arg isEqualToString:@"amount"]){
                [self setCarpetDiscount:amount_arg];
            }
        } else if ([service_name_arg isEqualToString:@"upholstery"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                upholsteryDiscount = (amount_arg / 100.0) * subtotalUpholsteryPrice;
            } else if ([discountType_arg isEqualToString:@"amount"]){
                upholsteryDiscount = amount_arg;
            }
        } else if ([service_name_arg isEqualToString:@"mattress"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                mattressDiscount = (amount_arg / 100.0) * subtotalUpholsteryPrice;
            } else if ([discountType_arg isEqualToString:@"amount"]){
                upholsteryDiscount = amount_arg;
            }
        } else if ([service_name_arg isEqualToString:@"miscellaneous"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                miscellaneousDiscount = (amount_arg / 100.0) * subtotalMiscePrice;
            } else if ([discountType_arg isEqualToString:@"amount"]){
                miscellaneousDiscount = amount_arg;
            }
        } else if ([service_name_arg isEqualToString:@"areaRugs"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                areaRugsDiscount = (amount_arg / 100.0) * subtotalAreaRugsPrice;
            } else if ([discountType_arg isEqualToString:@"amount"]){
                areaRugsDiscount = amount_arg;
            }
        } else if ([service_name_arg isEqualToString:@"floodcleanup"]){
            if ([discountType_arg isEqualToString:@"percent"]){
                [self setFloodDiscount:((amount_arg / 100.0) * subtotalFloodPrice)];
            } else if ([discountType_arg isEqualToString:@"amount"]){
                [self setFloodDiscount:amount_arg];
            }
        }
        [self clearView];
        [self createInvoice];
        
        [popoverController dismissPopoverAnimated:YES];
    } else if ([update_type isEqualToString:@"cancel"]){
        [popoverController dismissPopoverAnimated:YES];
    }
    NSLog(@" !!!carpet disc is %f", [self carpetDiscount]);
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
    //discountVC.serviceName = [sender restorationIdentifier];
    [discountVC setServiceName:[sender restorationIdentifier]];
    NSLog(@"BTN IDENTIFIER IS %@", [sender restorationIdentifier]);
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
    NSLog(@"width: %f, %f", pageSize.width, pageSize.height);
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
