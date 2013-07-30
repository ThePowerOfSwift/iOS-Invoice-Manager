//
//  BasePopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-07-27.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePopoverVC : UIViewController {
    bool editMode;
    ServiceDataCell* editingCell;
    
    IBOutlet UIButton *saveOrEditBtn;
}

@property (nonatomic, assign) IBOutlet UIButton *saveOrEditBtn;
@property (assign, readwrite) bool editMode;
@property (assign, readwrite) ServiceDataCell* editingCell;

@end
