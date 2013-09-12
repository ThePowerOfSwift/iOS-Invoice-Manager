//
//  ConfirmationPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-07-26.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsPopoverVC;

@protocol SettingsPopoverVCDelegate <NSObject>
-(void) sendConfirmation: (NSString*) answer forSender: (id) serviceSender;
@end

@interface SettingsPopoverVC : UIViewController {
    //id <SettingsPopoverVCDelegate> settingsVCdelegate;
    
}

//@property (nonatomic, assign) id <SettingsPopoverVCDelegate> settingsVCdelegate;

-(IBAction) selectCompany:(id)sender;

@end
