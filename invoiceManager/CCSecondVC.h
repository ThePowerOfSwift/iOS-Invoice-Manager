//
//  SecondVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIButton.h"
#import "ConfirmationPopoverVC.h"

@interface CCSecondVC : UIViewController <ConfirmationPopoverVCDelegate> {
    IBOutlet UITextField *estimationDate;
    IBOutlet UITextField *ratePerSqFeet;
    IBOutlet UIView *hey;
    IBOutlet UIImageView *selectedBtnBgThree;
    
    CGPoint lastPoint;
	UIImageView *drawImage;
	BOOL mouseSwiped;
	int mouseMoved;
    
    UIPopoverController *popoverController;
}

@property (assign, readwrite) IBOutlet UIView *hey;
@property (assign, readwrite) IBOutlet UIImageView *selectedBtnBgThree;
@property (nonatomic, assign) UIPopoverController *popoverController;

-(IBAction) gotoNextView;
-(IBAction) gotoLastView;
-(IBAction) onChoosingGreenProducts: (id) sender;
-(IBAction) onCustomEditingDone:(id) sender;

@end
