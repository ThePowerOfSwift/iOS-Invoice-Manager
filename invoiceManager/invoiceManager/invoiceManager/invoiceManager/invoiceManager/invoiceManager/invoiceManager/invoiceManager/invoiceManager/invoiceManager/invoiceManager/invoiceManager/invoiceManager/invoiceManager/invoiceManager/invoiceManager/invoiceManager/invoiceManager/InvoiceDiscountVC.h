//
//  InvoiceDiscountVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-30.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvoiceDiscountVC;

@protocol InvoiceDiscountVCDelegate <NSObject>
- (void)updateDiscount:(InvoiceDiscountVC *)optionsVS updateType:(NSString*)update_type discountType: (NSString *) discountType_arg amount: (float) amount_arg forService: (NSString*) service_name_arg;
@end

@interface InvoiceDiscountVC : UIViewController {
    id <InvoiceDiscountVCDelegate> discountDelegate;  // options view controller delegate
    
    NSString *serviceName;
    NSString *discountType;
    IBOutlet UITextField *userInput;
}

@property (assign, nonatomic) IBOutlet UITextField *userInput;
@property (assign, readwrite) NSString *discountType, *serviceName;
@property (nonatomic, assign) id <InvoiceDiscountVCDelegate> discountDelegate;

-(IBAction) onClickingBtn: (id) sender;
-(IBAction) saveOrCancel: (id) sender;

@end
