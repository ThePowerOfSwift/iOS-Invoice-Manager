//
//  ConfirmationPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-07-26.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConfirmationPopoverVC;

@protocol ConfirmationPopoverVCDelegate <NSObject>
-(void) sendConfirmation: (NSString*) answer forSender: (id) serviceSender;
@end

@interface ConfirmationPopoverVC : UIViewController {
    id <ConfirmationPopoverVCDelegate> confirmationDelegate;
    id serviceSender;
}

@property (assign, readwrite) id serviceSender;
@property (nonatomic, assign) id <ConfirmationPopoverVCDelegate> confirmationDelegate;

-(IBAction) selectAction:(id)sender;

@end
