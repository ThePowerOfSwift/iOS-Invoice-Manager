//
//  OptionsAutoSpaPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsSemiDetailPVC.h"

@interface OptionsSemiDetailPVC ()

@end

@implementation OptionsSemiDetailPVC

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
    [scrollViewer setContentSize:CGSizeMake(614, 2570)];
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
    
    if ([senderID isEqualToString:@"extWashWipeWindowsTireShineCar"]){
        [self setPriceRate:119.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Wash, Wipe Windows & Tire Shine (Day Cab) (Exterior)"];
    } else if ([senderID isEqualToString:@"extWashWipeWindowsTireShineSUV"]){
        [self setPriceRate:149.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Wash, Wipe Windows & Tire Shine (Sleeper Unit) (Exterior)"];
    } else if ([senderID isEqualToString:@"extWashCar"]){
        [self setPriceRate:79.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Exterior Wash (Day Cab) (Exterior)"];
    } else if ([senderID isEqualToString:@"extWashSUV"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Exterior Wash (Sleeper Unit) (Exterior)"];
    } else if ([senderID isEqualToString:@"extEngineShampooCar"]){
        [self setPriceRate:149.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Engine Shampoo (Day Cab) (Exterior)"];
    } else if ([senderID isEqualToString:@"extEngineShampooSUV"]){
        [self setPriceRate:149.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Engine Shampoo (Sleeper Unit) (Exterior)"];
    } else if ([senderID isEqualToString:@"extPowerPolishCar"]){
        [self setPriceRate:299.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Power Polish (Day Cab) (Exterior)"];
    } else if ([senderID isEqualToString:@"extPowerPolishSUV"]){
        [self setPriceRate:399.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Power Polish (Sleeper Unit) (Exterior)"];
    } else if ([senderID isEqualToString:@"extClayBarPolishCar"]){
        [self setPriceRate:349.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Clay Bar & Polish (Day Cab) (Exterior)"];
    } else if ([senderID isEqualToString:@"extClayBarPolishSUV"]){
        [self setPriceRate:349.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Clay Bar & Polish (Sleeper Unit) (Exterior)"];
    } else if ([senderID isEqualToString:@"extWetWaxCar"]){
        [self setPriceRate:69.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Wet Wax (Day Cab) (Exterior)"];
    } else if ([senderID isEqualToString:@"extWetWaxSUV"]){
        [self setPriceRate:89.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Wet Wax (Sleeper Unit) (Exterior)"];
    }  else if ([senderID isEqualToString:@"extBugSapTarRemovalCar"]){
        [self setPriceRate:79.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Bug/Sap/Tar Removal (Day Cab) (Exterior)"];
    } else if ([senderID isEqualToString:@"extBugSapTarRemovalSUV"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Bug/Sap/Tar Removal (Sleeper Unit) (Exterior)"];
    } else if ([senderID isEqualToString:@"extRainXGlassTreatmentCar"]){
        [self setPriceRate:39.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Rain-X Glass Treatment (Day Cab) (Exterior)"];
    } else if ([senderID isEqualToString:@"extRainXGlassTreatmentSUV"]){
        [self setPriceRate:39.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Rain-X Glass Treatment (Sleeper Unit) (Exterior)"];
        // Interior services below:
    } else if ([senderID isEqualToString:@"intCarpetUpholsteryShampooCar"]){
        [self setPriceRate:149.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Carpet & Upholstery Shampoo (Day Cab) (Interior)"];
    } else if ([senderID isEqualToString:@"intCarpetUpholsteryShampooSUV"]){
        [self setPriceRate:199.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Carpet & Upholstery Shampoo (Sleeper Unit) (Interior)"];
    } else if ([senderID isEqualToString:@"intFabricGuardCar"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Fabric Guard (Day Cab) (Interior)"];
    } else if ([senderID isEqualToString:@"intFabricGuardSUV"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Fabric Guard (Sleeper Unit) (Interior)"];
    } else if ([senderID isEqualToString:@"intHeadlinerCleaningCar"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Headliner Cleaning (Day Cab) (Interior)"];
    } else if ([senderID isEqualToString:@"intHeadlinerCleaningSUV"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Headliner Cleaning (Sleeper Unit) (Interior)"];
    } else if ([senderID isEqualToString:@"intPetHairRemovalCar"]){
        [self setPriceRate:49.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Pet Hair Removal (Day Cab) (Interior)"];
    } else if ([senderID isEqualToString:@"intPetHairRemovalSUV"]){
        [self setPriceRate:69.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Pet Hair Removal (Sleeper Unit) (Interior)"];
    } else if ([senderID isEqualToString:@"intLeatherCleanConditioningCar"]){
        [self setPriceRate:149.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Leather Clean & Conditioning (Day Cab) (Interior)"];
    } else if ([senderID isEqualToString:@"intLeatherCleanConditioningSUV"]){
        [self setPriceRate:149.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Leather Clean & Conditioning (Sleeper Unit) (Interior)"];
    } else if ([senderID isEqualToString:@"intBenefectDisinfectantCar"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Benefect Disinfectant (Day Cab) (Interior)"];
    } else if ([senderID isEqualToString:@"intBenefectDisinfectantSUV"]){
        [self setPriceRate:99.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Benefect Disinfectant (Sleeper Unit) (Interior)"];
    } else if ([senderID isEqualToString:@"intOzoneDeodorizingCar"]){
        [self setPriceRate:149.95f];
        [self setCarType:@"Day Cab"];
        [self setServiceType:@"Ozone Deodorizing (Day Cab) (Interior)"];
    } else if ([senderID isEqualToString:@"intOzoneDeodorizingSUV"]){
        [self setPriceRate:149.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Ozone Deodorizing (Sleeper Unit) (Interior)"];
    } else if ([senderID isEqualToString:@"intTwinMattressSUV"]){
        [self setPriceRate:79.95f];
        [self setCarType:@"Sleeper Unit"];
        [self setServiceType:@"Twin Mattress (Sleeper Unit) (Interior)"];
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
        newCell.name = [self serviceType];  // 'Interior Vacuum' or 'Fabric Guard' or etc..
        newCell.itemAttribute = [self carType]; // 'Day Cab' or 'Sleeper Unit'
        newCell.materialType = [self serviceTypeRestorationID]; // 'intVacuumCar' or intOzoneDeodorizingSUV' or etc..
        newCell.quantity = [self quantity];
        newCell.priceRate = [self priceRate];
        newCell.price = [self price];
        newCell.notes = [self notesAboutRoom];
        newCell.vacOrFull = @"Semi Detail";
        
        [ADelegate updateSpaSemiDetailDataTable:self editType:@"add" withServiceCell:newCell];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        
        [[self editingCell] setServiceType:@"autoSpa"];
        [[self editingCell] setName:[self serviceType]];
        [[self editingCell] setMaterialType:[self serviceTypeRestorationID]];
        [[self editingCell] setItemAttribute:[self carType]];
        [[self editingCell] setQuantity:[self quantity]];
        [[self editingCell] setPriceRate:[self priceRate]];
        [[self editingCell] setPrice:[self price]];
        [[self editingCell] setNotes:[self notesAboutRoom]];
        [[self editingCell] setVacOrFull:@"Semi Detail"];
        
        [ADelegate updateSpaSemiDetailDataTable:self editType:@"edit" withServiceCell:nil];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [ADelegate updateSpaSemiDetailDataTable:self editType:@"cancel" withServiceCell:nil];
    }
}



@end
