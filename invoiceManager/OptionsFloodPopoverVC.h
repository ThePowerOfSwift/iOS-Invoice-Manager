//
//  OptionsPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePopoverVC.h"

@class OptionsFloodPopoverVC;

@protocol OptionsFloodPopoverVCDelegate <NSObject>
//-(void)updateFloodDataTable:(OptionsFloodPopoverVC *)optionsFVC editType: (NSString*) editType withItemName: (NSString *) item_name_arg withRate: (float) rate_arg withQuantity: (float) quantity_arg withQuantity2: (float) quantity2_arg withPrice: (float) price_arg andNotes: (NSString *) notes_arg;
- (void)updateFloodServicesDataTable:(OptionsFloodPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg;
@end

@interface OptionsFloodPopoverVC : BasePopoverVC {
    
    id <OptionsFloodPopoverVCDelegate> FVCDelegate;  // options view controller delegate
    
    NSString *itemName;
    NSString *notes;
    float price;
    NSString *vacOrFull;
    NSInteger quantity, quantity2;
    float rate_price;
    
    
    //IBOutlet UITextView *notesField;
    
    IBOutlet UITextField *quantityField;
    IBOutlet UILabel *quantityLabel;
    IBOutlet UITextField *quantityField2;
    IBOutlet UILabel *quantityLabel2;
    IBOutlet UITextField *priceRateField;
    IBOutlet UILabel *priceRateLabel;
    IBOutlet UILabel *priceLabel;
}

@property (assign, readwrite) NSInteger quantity, quantity2;
@property (assign, readwrite) NSString *itemName, *notes, *vacOrFull;
@property (assign, readwrite) float price, rate_price;

//@property (assign, readwrite) IBOutlet UITextView *notesField;
@property (assign, readwrite) IBOutlet UILabel *priceRateLabel, *quantityLabel, *quantityLabel2, *priceLabel;
@property (nonatomic, assign) IBOutlet UITextField *quantityField, *priceRateField, *quantityField2;

@property (nonatomic, assign) id <OptionsFloodPopoverVCDelegate> FVCDelegate;

-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onClickingBtn: (id) sender;
-(IBAction) onSelectingType:(id)sender;
-(BOOL) textViewShouldBeginEditing: (UITextView*)textView;

@end
