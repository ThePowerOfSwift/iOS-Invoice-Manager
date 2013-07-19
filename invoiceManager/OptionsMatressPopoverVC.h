//
//  OptionsPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionsMatressPopoverVC;

@protocol OptionsMatressPopoverVCDelegate <NSObject>
//- (void)updateMatressDataTable:(OptionsMatressPopoverVC *)optionsMVC editType: (NSString*) editType withItem: (NSString *) item_name withCleanType: (NSString *) vac_or_full andQuantity: (NSInteger) quantity_arg andPrice: (float) item_price_arg andNotes:(NSString *) notesAboutRoom;
- (void)updateMatressDataTable:(OptionsMatressPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg;
@end

@interface OptionsMatressPopoverVC : UIViewController <UITextViewDelegate> {
    
    id <OptionsMatressPopoverVCDelegate> MVCDelegate;  // options view controller delegate
    
    NSString *itemName;
    NSString *notes;
    float price;
    NSString *vacOrFull;
    NSInteger quantity;
    bool addonDeodorizer, addonFabricProtector, addonBiocide;
    
    IBOutlet UITextField *quantityField;
    IBOutlet UILabel *priceLabel;
    IBOutlet UITextView *notesField;
}

@property (assign, readwrite) bool addonDeodorizer, addonFabricProtector, addonBiocide;
@property (assign, readwrite) NSInteger quantity;
@property (assign, readwrite) NSString *vacOrFull;
@property (assign) IBOutlet UITextView *notesField;
@property (nonatomic, assign) IBOutlet UITextField *quantityField;
@property (assign, readwrite) NSString *itemName, *notes;
@property (assign, readwrite) float price;

@property (nonatomic, assign) id <OptionsMatressPopoverVCDelegate> MVCDelegate;

-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onClickingBtn: (id) sender;
-(IBAction) onCustomEditingDone: (id) sender;
-(BOOL) textViewShouldBeginEditing: (UITextView*)textView;
-(IBAction) saveAddon:(id)sender;

@end
