//
//  CustomTableViewCell.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-15.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIButton.h"

@interface CustomTableViewCell : UITableViewCell {
    IBOutlet UILabel *colOne;    // roomName
    IBOutlet UILabel *colTwo;    // roomSize = length x width
    IBOutlet UILabel *colThree;  // roomArea = l x w
    IBOutlet UILabel *colFour;   // roomPrice
    CustomUIButton *deleteBtn;
}

@property (nonatomic, retain) CustomUIButton *deleteBtn;
@property (nonatomic, retain) UILabel *colOne, *colTwo, *colThree, *colFour;

@end
