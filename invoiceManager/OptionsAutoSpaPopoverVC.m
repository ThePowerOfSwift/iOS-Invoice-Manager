//
//  OptionsAutoSpaPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsAutoSpaPopoverVC.h"

@interface OptionsAutoSpaPopoverVC ()

@end

@implementation OptionsAutoSpaPopoverVC

@synthesize ASVCDelegate;
@synthesize scrollViewer;
@synthesize price, notesAboutRoom, notesField;
@synthesize packageTypeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    
    
    
    if ([self editMode]){
        [saveOrEditBtn setRestorationIdentifier:@"edit"];
        [saveOrEditBtn setTitle:@"Edit" forState:UIControlStateNormal];
        //[self doCalculations];  // do calculations in case some variables changes ( rate per square feet )
    } else {
        // set up the notes field
        notesField.text = @"Place notes and comments here";
        notesField.textColor = [UIColor lightGrayColor];
        [notesField setDelegate:self];
        
        // init vars in case error occurs
        price = 0;
        
    }
    // NSLog(@"title of uivc is %@", [self title]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [scrollViewer setScrollEnabled:YES];
    [scrollViewer setContentSize:CGSizeMake(614, 2950)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) onChoosingPackageType:(id) sender {
    if ([[sender restorationIdentifier] isEqualToString:@"bronze"]){
        [packageTypeLabel setText:@"Bronze"];
    } else if ([[sender restorationIdentifier] isEqualToString:@"silver"]){
        [packageTypeLabel setText:@"Silver"];
    } else if ([[sender restorationIdentifier] isEqualToString:@"gold"]){
        [packageTypeLabel setText:@"Gold"];
    } else if ([[sender restorationIdentifier] isEqualToString:@"platinum"]){
        [packageTypeLabel setText:@"Platinum"];
    }
}

// ------------------------ UITextView procol implementation BELOW
// when the text view is getting edited, this will be called

-(BOOL)textViewShouldBeginEditing: (UITextView*)textView {
    notesField.text = @"";
    notesField.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange: (UITextView*) textView {
    if (notesField.text.length == 0){
        notesField.textColor = [UIColor lightGrayColor];
        notesField.text = @"Place notes and comments here";
        [notesField resignFirstResponder];
    }
}
// ------------------------ UITextView procol implementation ABOVE

-(IBAction) saveOrCancel: (id) sender {
    notesAboutRoom = notesField.text;
    
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
            //[ASVCDelegate updateAutoSpaDataTable:self editType:@"add" withServiceCell:newCell];

    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        //[OVCDelegate updateDataTable:self editType:@"cancel" withServiceCell:nil];
        //[OVCDelegate updateDataTable: self editType:@"cancel" withLength: 0.0 withWidth: 0.0 andRoom: nil withPriceRate: 0.0 andNotes:nil];
        // NSLog(@"I AM EDITING STUFF!");
        /*if (stairsService){
            self.editingCell.itemAttribute = @"Stairs";
            self.editingCell.serviceType = @"carpet";
            self.editingCell.rlength = 0.0f;
            self.editingCell.rwidth = 0.0f;
            self.editingCell.name = roomName;
            self.editingCell.priceRate = 0.0f;
            self.editingCell.quantity = stairs;
            self.editingCell.quantity2 = landings;
            self.editingCell.notes = notesAboutRoom;
            self.editingCell.price = price;
            //[[self editingCell] setPrice:99.0f];
        } else {
            self.editingCell.itemAttribute = @"Room";
            self.editingCell.serviceType = @"carpet";
            self.editingCell.rlength = rLength;
            self.editingCell.rwidth = rWidth;
            self.editingCell.name = roomName;
            self.editingCell.priceRate = priceRate;
            self.editingCell.notes = notesAboutRoom;
            self.editingCell.addonDeodorizer = addonDeodorizer;
            self.editingCell.addonFabricProtector = addonFabricProtector;
            self.editingCell.addonBiocide = addonBiocide;
            self.editingCell.price = price;
        }*/
        [ASVCDelegate updateDataTable:self editType:@"edit" withServiceCell:nil];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [ASVCDelegate updateDataTable:self editType:@"cancel" withServiceCell:nil];
        //[OVCDelegate updateDataTable: self editType:@"cancel" withLength: 0.0 withWidth: 0.0 andRoom: nil withPriceRate: 0.0 andNotes:nil];
    }
}



@end
