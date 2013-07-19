//
//  OptionsPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionsAreaRugsPopoverVC;

@protocol OptionsAreaRugsPopoverVCDelegate <NSObject>
//-(void)updateAreaRugsDataTable:(OptionsAreaRugsPopoverVC *)optionsFVC editType: (NSString*) editType withItemName: (NSString *) item_name_arg withRate: (float) rate_arg withQuantity: (float) quantity_arg withQuantity2: (float) quantity2_arg withPrice: (float) price_arg andNotes: (NSString *) notes_arg;
- (void)updateAreaRugsDataTable:(OptionsAreaRugsPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg;
@end

@interface OptionsAreaRugsPopoverVC : UIViewController <UITextViewDelegate> {
    
    id <OptionsAreaRugsPopoverVCDelegate> ARVCDelegate;  // options view controller delegate
    
    NSString *itemName;
    NSString *itemType;
    NSString *notes;
    float price;
    NSString *vacOrFull;
    NSInteger quantity, quantity2;
    float rate_price;
    
    bool addonDeodorizer, addonFabricSoftener, addonBiocide;
    
    IBOutlet UITextView *notesField;
    
    IBOutlet UITextField *quantityField;
    IBOutlet UILabel *quantityLabel;
    IBOutlet UITextField *quantityField2;
    IBOutlet UILabel *quantityLabel2;
    IBOutlet UITextField *priceRateField;
    IBOutlet UILabel *priceRateLabel;
    IBOutlet UILabel *priceLabel;
}

@property (assign, readwrite) bool addonDeodorizer, addonFabricSoftener, addonBiocide;
@property (assign, readwrite) NSInteger quantity, quantity2;
@property (assign, readwrite) NSString *itemName, *notes, *vacOrFull, *itemType;
@property (assign, readwrite) float price, rate_price;

@property (assign, readwrite) IBOutlet UITextView *notesField;
@property (assign, readwrite) IBOutlet UILabel *priceRateLabel, *quantityLabel, *quantityLabel2, *priceLabel;
@property (nonatomic, assign) IBOutlet UITextField *quantityField, *priceRateField, *quantityField2;

@property (nonatomic, assign) id <OptionsAreaRugsPopoverVCDelegate> ARVCDelegate;

-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onClickingBtn: (id) sender;
-(IBAction) onSelectingType:(id)sender;
-(BOOL) textViewShouldBeginEditing: (UITextView*)textView;
-(IBAction) saveAddon:(id)sender;
-(IBAction)onCustomEditingDone:(id)sender;

@end
