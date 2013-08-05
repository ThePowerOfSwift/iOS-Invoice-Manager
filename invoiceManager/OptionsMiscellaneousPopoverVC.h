//
//  OptionsPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePopoverVC.h"

@class OptionsMiscellaneousPopoverVC;

@protocol OptionsMiscellaneousPopoverVCDelegate <NSObject>
- (void)updateMiscellaneousDataTable:(OptionsMiscellaneousPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg;
@end

@interface OptionsMiscellaneousPopoverVC : BasePopoverVC <UITextViewDelegate> {
    
    // delegate variables
    id <OptionsMiscellaneousPopoverVCDelegate> MIVCDelegate;  // options view controller delegate
    
    // variables
    NSString *itemName;
    float itemPrice;
    NSInteger quantity;
    float price;
    NSString *notes;
    
    // outlets
    IBOutlet UILabel *sqfeetLabel;
    IBOutlet UILabel *priceLabel;
    IBOutlet UITextField *itemNameField, *pricePerItemField;
    IBOutlet UITextField *quantityField;
    IBOutlet UITextView *notesField;
}

@property (nonatomic, assign) id <OptionsMiscellaneousPopoverVCDelegate> MIVCDelegate;

@property (assign, readwrite) float itemPrice, price;
@property (assign, readwrite) NSString *itemName, *notes;
@property (assign, readwrite) NSInteger quantity;

@property (nonatomic, assign) IBOutlet UILabel *priceLabel;
@property (nonatomic, assign) IBOutlet UITextView *notesField;
@property (nonatomic, assign) IBOutlet UITextField *itemNameField, *quantityField, *pricePerItemField;

-(BOOL)textViewShouldBeginEditing: (UITextView*)textView;
-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onClickingBtn: (id) sender;
-(IBAction) onCustomEditingDone: (id) sender;
@end
