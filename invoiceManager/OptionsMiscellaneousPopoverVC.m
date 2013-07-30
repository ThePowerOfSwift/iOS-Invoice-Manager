//
//  OptionsPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsMiscellaneousPopoverVC.h"

@interface OptionsMiscellaneousPopoverVC ()

@end

@implementation OptionsMiscellaneousPopoverVC

@synthesize MIVCDelegate;
@synthesize itemNameField, quantityField, notesField, pricePerItemField;
@synthesize priceLabel;
@synthesize itemName, itemPrice, notes, quantity, price;

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
    } else {
        // set up the notes field
        notesField.text = @"Place notes and comments here";
        notesField.textColor = [UIColor lightGrayColor];
        [notesField setDelegate:self];
        
        // init vars in case error occurs
        itemName = @"";
        quantity = 0;
        notes = @"";
        itemPrice = 0.0f;
        price = 0.0f;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(IBAction) onCustomEditingDone: (id) sender {
    if ([[sender restorationIdentifier] isEqualToString:@"itemName"]){
        itemName = [itemNameField text];
    } else if ([[sender restorationIdentifier] isEqualToString:@"itemPrice"]){
        itemPrice = [[pricePerItemField text] floatValue];
    } else if ([[sender restorationIdentifier] isEqualToString:@"itemQuantity"]){
        quantity = [[quantityField text] integerValue];
    }
    [self doCalculations];
}

-(void) doCalculations {
    if (itemPrice && itemName && quantity){
        price = itemPrice * quantity;
    }
    [priceLabel setText:[NSString stringWithFormat: @"$%.02f", price]];
}

-(IBAction) saveOrCancel: (id) sender {
    notes = notesField.text;
    itemName = [itemNameField text];
    
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
        ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
        
        newCell.serviceType = @"miscellaneous";
        newCell.notes = notes;
        newCell.name = itemName;
        newCell.quantity = quantity;
        newCell.priceRate = itemPrice;
        newCell.price = price;
        [MIVCDelegate updateMiscellaneousDataTable:self editType:@"add" withServiceCell:newCell];
        //[MIVCDelegate updateMiscellaneousDataTable:self editType:@"add" withItemName:itemName withItemPrice:itemPrice withQuantity:quantity withSubtotalPrice:price andNotes:notes];
    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        //[MIVCDelegate updateMiscellaneousDataTable:self editType:@"cancel" withServiceCell:nil];
        //[MIVCDelegate updateMiscellaneousDataTable:self editType:@"cancel" withItemName:nil withItemPrice:0.0f withQuantity:0 withSubtotalPrice:0.0f andNotes:nil];
        
        self.editingCell.serviceType = @"miscellaneous";
        self.editingCell.notes = notes;
        self.editingCell.name = itemName;
        self.editingCell.quantity = quantity;
        self.editingCell.priceRate = itemPrice;
        self.editingCell.price = price;
        [MIVCDelegate updateMiscellaneousDataTable:self editType:@"edit" withServiceCell:nil];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [MIVCDelegate updateMiscellaneousDataTable:self editType:@"cancel" withServiceCell:nil];
        //[MIVCDelegate updateMiscellaneousDataTable:self editType:@"cancel" withItemName:nil withItemPrice:0.0f withQuantity:0 withSubtotalPrice:0.0f andNotes:nil];
    }
}



@end
