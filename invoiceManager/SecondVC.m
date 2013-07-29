//
//  SecondVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "SecondVC.h"

@interface SecondVC ()

@end

@implementation SecondVC

@synthesize hey;
@synthesize selectedBtnBgThree;
@synthesize popover;

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
    [super viewDidLoad];
    
    
    // load saved values (IF ANY)
    InvoiceManager *invoiceMngr = [InvoiceManager sharedInvoiceManager];
    [invoiceMngr printOut];
    if (invoiceMngr.estimateDate != NULL){
        estimationDate.text = invoiceMngr.estimateDate;
    }
    if (invoiceMngr.ratePerSquareFeet){
        ratePerSqFeet.text = [NSString stringWithFormat:@"%f", invoiceMngr.ratePerSquareFeet];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //NSLog(@"dismiss keyboard?");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
    NSLog(@"aaaas");
	lastPoint = [touch locationInView:self.view];
	lastPoint.y -= 20;
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self.view];
	currentPoint.y -= 20;
	
	
	UIGraphicsBeginImageContext(self.view.frame.size);
	[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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
	
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
	
	
	if(!mouseSwiped) {
		UIGraphicsBeginImageContext(self.view.frame.size);
		[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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
}


// only supports UIButton's right now
-(IBAction) onChoosingGreenProducts: (id) sender {
    // set last selected back to normal
    for (UIButton *aSubview in self.view.subviews){
        //for (id aSubview in aSubview2.subviews){
        if ([aSubview isKindOfClass:[UIButton class]]){
            if ([aSubview tag] == 45){
                
                //NSLog(@"hi, %@, %u", [aSubview restorationIdentifier], [aSubview tag]);
                //[aSubview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [aSubview setTag:40];
            }
        }
        //}
    }
    
    // put background image view under the newly selected button
    UIButton *btn = (UIButton*)sender;
    NSString *senderID = [btn restorationIdentifier];
    
    InvoiceManager *invoiceMngr = [InvoiceManager sharedInvoiceManager];
    
    if ([senderID isEqualToString:@"greenProducts"]){
        [selectedBtnBgThree setFrame:
         CGRectMake(99.0, selectedBtnBgThree.frame.origin.y, selectedBtnBgThree.frame.size.width, selectedBtnBgThree.frame.size.height)];
        [invoiceMngr setUsingProductType:@"Green Products"];
    } else if ([senderID isEqualToString:@"blueProducts"]){
        [selectedBtnBgThree setFrame:
         CGRectMake(226.0, selectedBtnBgThree.frame.origin.y, selectedBtnBgThree.frame.size.width, selectedBtnBgThree.frame.size.height)];
        [invoiceMngr setUsingProductType:@"Normal Products"];
    }
    [btn setTag:45];
    //[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

// - - - - - - START of IBActions
// - - - - - - - - - - - - - - - -
-(IBAction) onCustomEditingDone:(id) sender {
    InvoiceManager *invoiceMngr = [InvoiceManager sharedInvoiceManager];
    if ([[sender restorationIdentifier] isEqualToString:@"estimateDate"]){
        invoiceMngr.estimateDate = estimationDate.text;
        // NSLog(@"est is %@", invoiceMngr.estimateDate);
    } else if ([[sender restorationIdentifier] isEqualToString:@"priceRate"]){
        invoiceMngr.ratePerSquareFeet = [ratePerSqFeet.text floatValue];
        // NSLog(@"rate is %f", invoiceMngr.ratePerSquareFeet);
    }
}

// change button background when user clicks it
-(IBAction)onCustomTouchDown:(id)sender {
    /*NSLog(@"creating pdf..");
     InvoiceManager *blah = [InvoiceManager sharedInvoiceManager];
     [blah createPDFfromUIView:hey saveToDocumentsWithFileName:@"justASimplePdf.pdf"];
     */
    InvoiceManager *invoiceMngr = [InvoiceManager sharedInvoiceManager];    // get invoice manager instance ( will be used to add/remove data )
    if ([sender activeBtn] == 0){
        [sender setBackgroundImage:[UIImage imageNamed:@"checkboxYes6.png"] forState:UIControlStateNormal];
        
        [sender setActiveBtn:1];
        
        // save this into invoice manager ( create a 'service' object )
        [invoiceMngr createServiceItem:[sender restorationIdentifier] withOrderVal:[sender tag]];
        
        // print array ( for testing )
        /*NSMutableArray *hey2 = [invoiceMngr listOfServices];
         for (int i = 0; i < [hey count]; i++){
         //NSLog(@"SORT 2: i IS: %@", [[hey2 objectAtIndex:i] name]);
         }*/
        
    } else {
        
        // confirm that the user actually wants to delete this service:
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        
        ConfirmationPopoverVC *confirmPopover = (ConfirmationPopoverVC*) [storyboard instantiateViewControllerWithIdentifier:@"ConfirmationPopoverVC"];
        
        if (popover){
            //NSLog(@"popover EXISTS !");
            [popover setContentViewController:confirmPopover];
        }else {
            //NSLog(@"popover getting INITIALIZED ! !");
            popover = [[UIPopoverController alloc] initWithContentViewController:confirmPopover];
        }
        
        confirmPopover.confirmationDelegate = self; // set the popover's delegate to this ui vc (IMPORTANT!)
        //confirmPopover.serviceSender = sender;
        [confirmPopover setServiceSender:sender];
        //NSLog(@"AAAAAAAAA %@", [[confirmPopover serviceSender] restorationIdentifier]);
        [popover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        /*[sender setBackgroundImage:[UIImage imageNamed:@"checkboxNo6.png"] forState:UIControlStateNormal];
         
         [sender setActiveBtn:0];
         [invoiceMngr removeServiceItemWithName:[sender restorationIdentifier]];*/
        
        // print array ( for testing )
        /* NSMutableArray *hey2 = [invoiceMngr listOfServices];
         for (int i = 0; i < [hey count]; i++){
         NSLog(@"SORT 2: i IS: %@", [[hey2 objectAtIndex:i] name]);
         }*/
        
    }
}

// receive confirmation whether or not to delete the service clicked
-(void) sendConfirmation: (NSString*) answer forSender: (id) serviceSender {
    InvoiceManager* invoiceMngr = [InvoiceManager sharedInvoiceManager];
    if ([answer isEqualToString:@"yes"]){
        [serviceSender setBackgroundImage:[UIImage imageNamed:@"checkboxNo6.png"] forState:UIControlStateNormal];
        
        [serviceSender setActiveBtn:0];
        [invoiceMngr removeServiceItemWithName:[serviceSender restorationIdentifier]];
    } else {
        // do nothing
    }
    
    [popover dismissPopoverAnimated:NO];
}

// saves the data currently displayed on the page
// goes to the next VC according to what services are selected ( and in their proper order )
-(IBAction) gotoNextView {
    
    // check which services are selected, and save data into the InvoiceManager singleton
    InvoiceManager *invoiceMngr = [InvoiceManager sharedInvoiceManager];
    invoiceMngr.ratePerSquareFeet = [[ratePerSqFeet text] floatValue];  // save the rate per sq feet
    
    // if any services exist, push the first service VC
    //ServiceItem *nextitem = [[invoiceMngr listOfServices] objectAtIndex:0];
    
    
    NSLog(@"number of services: %u", [[invoiceMngr listOfServices] count]);
    //NSLog(@"name for 0: %@", [[[invoiceMngr listOfServices] objectAtIndex:0] serviceVC]);
    
    if ( [[invoiceMngr listOfServices] count] > 0){
        if ([[invoiceMngr listOfServices] objectAtIndex:0]){
            ServiceItem *nextitem = [[invoiceMngr listOfServices] objectAtIndex:0];
            UIViewController *vcc = nextitem.serviceVC;
            [self.navigationController pushViewController:vcc animated:YES];
        }
    } else {
        NSLog(@"Please add some services ?");
        [self.navigationController pushViewController:[invoiceMngr invoiceVC] animated:YES];
    }
}

-(IBAction) gotoLastView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end


/*
 // SORTING ALGOS:
 NSMutableArray *hey = [invoiceMngr listOfServices];
 NSSortDescriptor *sortDescriptor;
 sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES] autorelease];
 NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
 NSArray *sortedArray;
 sortedArray = [hey sortedArrayUsingDescriptors:sortDescriptors];
 */
