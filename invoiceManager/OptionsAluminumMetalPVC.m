//  OptionsAutoSpaPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsAluminumMetalPVC.h"

@interface OptionsAluminumMetalPVC ()

@end

@implementation OptionsAluminumMetalPVC

@synthesize ADelegate;
@synthesize scrollViewer;
@synthesize price, notesAboutRoom, priceRate, priceLabel, carType, serviceType, serviceTypeRestorationID;
@synthesize quantity;
@synthesize quantityField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    if ([self editMode]){
        [saveOrEditBtn setRestorationIdentifier:@"edit"];
        [saveOrEditBtn setTitle:@"Edit" forState:UIControlStateNormal];
        //[self doCalculations];  // do calculations in case some variables changes ( rate per square feet )
        [self restoreSavedSelections];
    } else {
        // set up the notes field
        notesField.text = @"Place notes and comments here";
        notesField.textColor = [UIColor lightGrayColor];
        [notesField setDelegate:self];
        
        // init vars in case error occurs
        price = 0;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [scrollViewer setScrollEnabled:YES];
    [scrollViewer setContentSize:CGSizeMake(614, 4610)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// restore the selected gui buttons to the ones saved in the 'editingCell'
-(void) restoreSavedSelections {
    
    // de-select all buttons with a specific tag and select the ones that were saved
    for (UIButton *v in scrollViewer.subviews) {
        if ([v isKindOfClass:[UIButton class]]){
            if ( ([v tag] == 5) || ([v tag] == 10) ){
                [v setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            }
            if ([[v restorationIdentifier] isEqualToString:[editingCell materialType]]){
                [v setTag:10];
                [v setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    [self setQuantity:[editingCell quantity]];
    [self setNotesAboutRoom:[editingCell notes]];
    [priceLabel setText:[NSString stringWithFormat:@"$%.02f", [editingCell price]]];
    [quantityField setText:[NSString stringWithFormat:@"%d", [editingCell quantity]]];
    
    // restore the notes saved
    [notesField setText:[editingCell notes]];
}

-(IBAction) clearAllSelections {
    for (UIButton *v in scrollViewer.subviews) {
        if ([v isKindOfClass:[UIButton class]]){
            if ( ([v tag] == 5) || ([v tag] == 10) ){
                [v setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            }
        }
    }
}

-(void) getValueFromFieldWithId: (NSString *) restoration_id {
    for (UITextField *field in scrollViewer.subviews){
        if ([field isKindOfClass:[UITextField class]]){
            if ([[field restorationIdentifier] isEqualToString:restoration_id]){
                NSLog(@"THE VALUE IS %f", [[field text] floatValue]);
                [self setPriceRate:[[field text] floatValue]];
                
            }
        }
    }
}

// only supports UIButton's right now
-(IBAction) onChoosingServiceType: (id) sender {
    // set last selected back to normal
    for (UIButton *aSubview in scrollViewer.subviews){
        if ([aSubview isKindOfClass:[UIButton class]]){
            if ([aSubview tag] == 10){
                [aSubview setTag:5];
                [aSubview setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    // put background image view under the newly selected button
    UIButton *btn = (UIButton*)sender;
    NSString *senderID = [btn restorationIdentifier];
    [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
    
    // save the restoration id of the button selected
    [self setServiceTypeRestorationID:senderID];
    
    // Aluminum Semi-Truck ones first 
    if ([senderID isEqualToString:@"aluminumRimsOneSide"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Aluminum Rims ( One Side ) (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"aluminumFuelTank"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Aluminum Fuel Tank ( Mounted ) (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"aluminumBatteryUtilityBox"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Aluminum Battery/Utility Box (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"aluminumAirTank"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Aluminum Air Tank (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"aluminumGrillCapHeadlightBuckets"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Aluminum Grill Cap & Headlight Buckets (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"aluminumPolishedFrontFender"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Aluminum Polished Front Fender (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"aluminumPolishedRearFender"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Aluminum Polished Rear Fender (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"aluminumMooseBumper"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Aluminum Moose Bumper (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"aluminumHeadacheRack"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Aluminum Headache Rack (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"aluminumDeckPerHour"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Aluminum Deck (per hour) (Semi-Truck)"];
        // Stainless Steel Semi-Truck
    } else if ([senderID isEqualToString:@"stainlessSteelBreathers"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Stainless Steel Breathers (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"stainlessSteelStackGuards"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Stainless Steel Stack Guards (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"stainlessSteelVisors"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Stainless Steel Visors (Semi-Truck)"];
    } else if ([senderID isEqualToString:@"stainlessSteelMirrors"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Stainless Steel Mirrors (Semi-Truck)"];
        // Snowmobiles Recreational
    } else if ([senderID isEqualToString:@"snowmobilesTunnel"]){
        [self setPriceRate:150.00f];
        [self setServiceType:@"Tunnel (Snowmobiles)"];
    } else if ([senderID isEqualToString:@"snowmobilesClutchCover"]){
        [self setPriceRate:20.00f];
        [self setServiceType:@"Clutch Cover (Snowmobiles)"];
    } else if ([senderID isEqualToString:@"snowmobilesOtherAccess"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Other Accessory (Snowmobiles)"];
        // Boats Recreational
    } else if ([senderID isEqualToString:@"boatsPolishingFT"]){
        [self setPriceRate:50.00f];
        [self setServiceType:@"Polishing /FT (Boats)"];
        // Trailers Recreational
    } else if ([senderID isEqualToString:@"trailersOther"]){
        [self getValueFromFieldWithId:[NSString stringWithFormat:@"%@Value", senderID]];
        [self setServiceType:@"Trailer Service"];
        // Auto
    } else if ([senderID isEqualToString:@"autoRims"]){
        [self setPriceRate:35.00f];
        [self setServiceType:@"Rims (Auto)"];
    } else if ([senderID isEqualToString:@"autoStepSides"]){
        [self setPriceRate:60.00f];
        [self setServiceType:@"Step Sides (Auto)"];
    } else if ([senderID isEqualToString:@"autoBushGuards"]){
        [self setPriceRate:120.00f];
        [self setServiceType:@"Bush Guards (Auto)"];
    } else if ([senderID isEqualToString:@"autoToolUtilityBoxes"]){
        [self setPriceRate:100.00f];
        [self setServiceType:@"Tool/Utility Boxes (Auto)"];
    }
    
    [btn setTag:10];
    
    [self doCalculations];
}

-(IBAction) quantityChanged: (id) sender {
    UITextField* qField = (UITextField*) sender;
    NSLog(@"the quantity is %ld", (long)[[qField text] integerValue]);
    [self setQuantity:[[qField text] integerValue]];
    [self doCalculations];
}

-(void) doCalculations {
    NSLog(@"doing calculations ! price rate is %f", [self priceRate]);
    // if quantity is > 0
    if ([self quantity] && [self serviceType]){
        NSLog(@"GOT HERE? price rate is %f", [self priceRate]);
        [self setPrice: ([self priceRate] * [self quantity]) ];
        [[self priceLabel] setText:[NSString stringWithFormat:@"$%.02f", [self price] ]];
    } else {
        
        [self setPrice:0.0f];
        [[self priceLabel] setText:[NSString stringWithFormat:@"$%.02f", [self price]]];
    }
    
}

-(IBAction) saveOrCancel: (id) sender {
    [self doCalculations];
    notesAboutRoom = notesField.text;
    
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
        ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
        newCell.serviceType = @"autoSpa";
        newCell.name = [self serviceType];  // 'Aluminum Rims ( One Side ) (Semi-Truck)' or 'Aluminum Fuel Tank ( Mounted ) (Semi-Truck)' or etc..
        newCell.materialType = [self serviceTypeRestorationID]; // 'intVacuumCar' or intOzoneDeodorizingSUV' or etc..
        newCell.quantity = [self quantity];
        newCell.priceRate = [self priceRate];
        newCell.price = [self price];
        newCell.notes = [self notesAboutRoom];
        newCell.vacOrFull = @"Aluminum Metal";
        
        [ADelegate updateSpaAluminumMetalDataTable:self editType:@"add" withServiceCell:newCell];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        
        [[self editingCell] setServiceType:@"autoSpa"];
        [[self editingCell] setName:[self serviceType]];
        [[self editingCell] setMaterialType:[self serviceTypeRestorationID]];
        [[self editingCell] setItemAttribute:[self carType]];
        [[self editingCell] setQuantity:[self quantity]];
        [[self editingCell] setPriceRate:[self priceRate]];
        [[self editingCell] setPrice:[self price]];
        [[self editingCell] setNotes:[self notesAboutRoom]];
        [[self editingCell] setVacOrFull:@"Aluminum Metal"];
        
        [ADelegate updateSpaAluminumMetalDataTable:self editType:@"edit" withServiceCell:nil];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        NSLog(@"quantity is %d", [self quantity]);
        [ADelegate updateSpaAluminumMetalDataTable:self editType:@"cancel" withServiceCell:nil];
    }
}



@end
