//
//  OptionsPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionsRepairPopoverVC;

@protocol OptionsRepairPopoverVCDelegate <NSObject>
- (void)updateMatressDataTable:(OptionsRepairPopoverVC *)optionsMVC editType: (NSString*) editType withItem: (NSString *) item_name withCleanType: (NSString *) vac_or_full andQuantity: (NSInteger) quantity_arg andPrice: (float) item_price_arg andNotes:(NSString *) notesAboutRoom;
@end

@interface OptionsRepairPopoverVC : UIViewController <UITextViewDelegate> {
    
    id <OptionsMatressPopoverVCDelegate> RVCDelegate;  // options view controller delegate
    
    NSString *itemName;
    NSString *notes;
    float price;
    NSString *vacOrFull;
    NSInteger quantity;
    
    IBOutlet UITextField *quantityField;
    IBOutlet UILabel *priceLabel;
    IBOutlet UITextView *notesField;
}

@property (assign, readwrite) NSInteger quantity;
@property (assign, readwrite) NSString *vacOrFull;
@property (assign) IBOutlet UITextView *notesField;
@property (nonatomic, assign) IBOutlet UITextField *quantityField;
@property (assign, readwrite) NSString *itemName, *notes;
@property (assign, readwrite) float price;

@property (nonatomic, assign) id <OptionsMatressPopoverVCDelegate> RVCDelegate;

-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onClickingBtn: (id) sender;
-(IBAction) onCustomEditingDone: (id) sender;
-(BOOL)textViewShouldBeginEditing: (UITextView*)textView;
@end
