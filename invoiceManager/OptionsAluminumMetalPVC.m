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
    [scrollViewer setContentSize:CGSizeMake(614, 2540)];
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
    [priceLabel setText:[NSString stringWithFormat:@"%.02f", [editingCell price]]];
    [quantityField setText:[NSString stringWithFormat:@"%d", [editingCell quantity]]];
    
    // restore the notes saved
    [notesField setText:[editingCell notes]];
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
    
    if ([senderID isEqualToString:@"extWashDryCar"]){
        [self setPriceRate:14.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Exterior Wash and Dry"];
    } else if ([senderID isEqualToString:@"extWashDrySUV"]){
        [self setPriceRate:19.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Exterior Wash and Dry"];
    } else if ([senderID isEqualToString:@"extHandWashDryCar"]){
        [self setPriceRate:29.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Hand Wash and Dry"];
    } else if ([senderID isEqualToString:@"extHandWashDrySUV"]){
        [self setPriceRate:39.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Hand Wash and Dry"];
    } else if ([senderID isEqualToString:@"extBugSapTarRemovalCar"]){
        [self setPriceRate:49.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Bug/Sap/Tar Removal"];
    } else if ([senderID isEqualToString:@"extBugSapTarRemovalSUV"]){
        [self setPriceRate:69.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Bug/Sap/Tar Removal"];
    } else if ([senderID isEqualToString:@"extEngineShampooCar"]){
        [self setPriceRate:79.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Engine Shampoo"];
    } else if ([senderID isEqualToString:@"extEngineShampooSUV"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Engine Shampoo"];
    } else if ([senderID isEqualToString:@"extWetWaxCar"]){
        [self setPriceRate:49.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Wet Wax"];
    } else if ([senderID isEqualToString:@"extWetWaxSUV"]){
        [self setPriceRate:49.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Wet Wax"];
    } else if ([senderID isEqualToString:@"extHandWaxCar"]){
        [self setPriceRate:149.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Hand Wax"];
    } else if ([senderID isEqualToString:@"extHandWaxSUV"]){
        [self setPriceRate:189.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Hand Wax"];
    } else if ([senderID isEqualToString:@"extClayBarPolishCar"]){
        [self setPriceRate:249.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Clay Bar & Polish"];
    } else if ([senderID isEqualToString:@"extClayBarPolishSUV"]){
        [self setPriceRate:249.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Clay Bar & Polish"];
    } else if ([senderID isEqualToString:@"extPaintSealerCar"]){
        [self setPriceRate:349.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Paint Sealer"];
    } else if ([senderID isEqualToString:@"extPaintSealerSUV"]){
        [self setPriceRate:399.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Paint Sealer"];
    } else if ([senderID isEqualToString:@"extPowerPolishCar"]){
        [self setPriceRate:259.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Power Polish"];
    } else if ([senderID isEqualToString:@"extPowerPolishSUV"]){
        [self setPriceRate:299.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Power Polish"];
    } else if ([senderID isEqualToString:@"extRimsWheelsCleanPolishCar"]){
        [self setPriceRate:44.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Rims/Wheels Clean & Polish"];
    } else if ([senderID isEqualToString:@"extRimsWheelsCleanPolishSUV"]){
        [self setPriceRate:44.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Rims/Wheels Clean & Polish"];
    } else if ([senderID isEqualToString:@"extTireShineCar"]){
        [self setPriceRate:9.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Tire Shine"];
    } else if ([senderID isEqualToString:@"extTireShineSUV"]){
        [self setPriceRate:9.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Tire Shine"];
    } else if ([senderID isEqualToString:@"intVacuumCar"]){
        [self setPriceRate:24.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Interior Vacuum"];
    } else if ([senderID isEqualToString:@"intVacuumSUV"]){
        [self setPriceRate:29.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Interior Vacuum"];
    } else if ([senderID isEqualToString:@"intCarpetShampooSteamCleanCar"]){
        [self setPriceRate:49.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Carpet Shampoo & Steam Clean"];
    } else if ([senderID isEqualToString:@"intCarpetShampooSteamCleanSUV"]){
        [self setPriceRate:59.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Carpet Shampoo & Steam Clean"];
    } else if ([senderID isEqualToString:@"intClothSeatSteamCleanCar"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Cloth Seat Shampoo & Steam Clean"];
    } else if ([senderID isEqualToString:@"intClothSeatSteamCleanSUV"]){
        [self setPriceRate:119.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Cloth Seat Shampoo & Steam Clean"];
    } else if ([senderID isEqualToString:@"intTrunkShampooSteamCleanCar"]){
        [self setPriceRate:49.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Trunk Shampoo & Steam Clean"];
    } else if ([senderID isEqualToString:@"intTrunkShampooSteamCleanSUV"]){
        [self setPriceRate:59.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Trunk Shampoo & Steam Clean"];
    } else if ([senderID isEqualToString:@"intFabricGuardCar"]){
        [self setPriceRate:79.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Fabric Guard"];
    } else if ([senderID isEqualToString:@"intFabricGuardSUV"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Fabric Guard"];
    } else if ([senderID isEqualToString:@"intLeatherCleanConditionCar"]){
        [self setPriceRate:79.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Leather Clean & Conditioning"];
    } else if ([senderID isEqualToString:@"intLeatherCleanConditionSUV"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Leather Clean & Conditioning"];
    } else if ([senderID isEqualToString:@"intHeadlinerVisorCleanCar"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Headline/Visor Cleaning"];
    } else if ([senderID isEqualToString:@"intHeadlinerVisorCleanSUV"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Headline/Visor Cleaning"];
    } else if ([senderID isEqualToString:@"intPetHairRemoveCar"]){
        [self setPriceRate:69.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Pet Hair Removal"];
    } else if ([senderID isEqualToString:@"intPetHairRemoveSUV"]){
        [self setPriceRate:69.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Pet Hair Removal"];
    } else if ([senderID isEqualToString:@"intOzoneDeodorizingCar"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Ozone Deodorizing"];
    } else if ([senderID isEqualToString:@"intOzoneDeodorizingSUV"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Ozone Deodorizing"];
    } else if ([senderID isEqualToString:@"intBenefactDisinfectantCar"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Car"];
        [self setServiceType:@"Benefect Disinfectant"];
    } else if ([senderID isEqualToString:@"intBenefactDisinfectantSUV"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"SUV"];
        [self setServiceType:@"Benefect Disinfectant"];
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
    NSLog(@"doing calculations !");
    // if quantity is > 0
    if ([self quantity] && [self carType]){
        NSLog(@"GOT HERE? price rate is %f", [self priceRate]);
        [self setPrice: ([self priceRate] * [self quantity]) ];
        [[self priceLabel] setText:[NSString stringWithFormat:@"%.02f", [self price] ]];
    } else {
        
        [self setPrice:0.0f];
        [[self priceLabel] setText:[NSString stringWithFormat:@"%.02f", [self price]]];
    }
    
}

-(IBAction) saveOrCancel: (id) sender {
    [self doCalculations];
    notesAboutRoom = notesField.text;
    
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
        ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
        newCell.serviceType = @"autoSpa";
        newCell.name = [self serviceType];  // 'Interior Vacuum' or 'Fabric Guard' or etc..
        newCell.itemAttribute = [self carType]; // 'Car' or 'SUV'
        newCell.materialType = [self serviceTypeRestorationID]; // 'intVacuumCar' or intOzoneDeodorizingSUV' or etc..
        newCell.quantity = [self quantity];
        newCell.priceRate = [self priceRate];
        newCell.price = [self price];
        newCell.notes = [self notesAboutRoom];
        
        [ADelegate updateSpaAutoDetailDataTable:self editType:@"add" withServiceCell:newCell];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        
        [[self editingCell] setServiceType:@"autoSpa"];
        [[self editingCell] setName:[self serviceType]];
        [[self editingCell] setMaterialType:[self serviceTypeRestorationID]];
        [[self editingCell] setItemAttribute:[self carType]];
        [[self editingCell] setQuantity:[self quantity]];
        [[self editingCell] setPriceRate:[self priceRate]];
        [[self editingCell] setPrice:[self price]];
        [[self editingCell] setNotes:[self notesAboutRoom]];
        
        [ADelegate updateSpaAutoDetailDataTable:self editType:@"edit" withServiceCell:nil];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        NSLog(@"quantity is %d", [self quantity]);
        [ADelegate updateSpaAutoDetailDataTable:self editType:@"cancel" withServiceCell:nil];
    }
}



@end
