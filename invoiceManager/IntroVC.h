//
//  IntroVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-07-30.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroVC : UIViewController {
    NSString *serviceSelected;  // 'carpetCare', 'autoSpa' or 'ductFurnaceCleaning'
}

@property (assign, readwrite) NSString *serviceSelected;

-(IBAction) goToNextVC:(id)sender;
-(IBAction) selectService:(id)sender;

@end
