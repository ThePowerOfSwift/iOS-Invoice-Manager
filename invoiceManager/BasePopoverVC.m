//
//  BasePopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-07-27.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "BasePopoverVC.h"

@interface BasePopoverVC ()

@end

@implementation BasePopoverVC

@synthesize notesField;
@synthesize editMode, editingCell, saveOrEditBtn;

-(void) dealloc {
    [super dealloc];
    //[tap release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    NSLog(@"HEEELLLO WORLD !");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)] autorelease];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

// ------------------------ UITextView procol implementation BELOW
// when the text view is getting edited, this will be called

-(BOOL)textViewShouldBeginEditing: (UITextView*)textView {
    NSLog(@"WTFF ! ! ! ! ! ! ! ! ! !! ! ");
    if ([notesField.text isEqualToString:@"Place notes and comments here"]){
        notesField.text = @"";
    }
    notesField.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange: (UITextView*) textView {
    if (notesField.text.length == 0){
        notesField.textColor = [UIColor lightGrayColor];
        notesField.text = @"Place notes and comments here";
        [notesField resignFirstResponder];
    }
}
// ------------------------ UITextView procol implementation ABOVE

@end
