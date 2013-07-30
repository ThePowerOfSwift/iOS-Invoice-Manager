//
//  SecondViewController.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-14.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "ServiceTypeViewController.h"

@interface ServiceTypeViewController ()

@end

@implementation ServiceTypeViewController

//@synthesize tableMode;
//@synthesize listOfTableCells;
@synthesize uilabelsArray;
@synthesize serviceDataCellArray;
@synthesize selectedType;
@synthesize dataTableNoOfRows;
@synthesize VCServiceNameType;
@synthesize SVCdelegate;
@synthesize backBtn;
@synthesize popover;
@synthesize examp;
@synthesize carpetTypeSelection;
@synthesize col1Name, col2Name, col3Name, col4Name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // moved to service type view controller create service method
        //serviceDataCellArray = [[NSMutableArray alloc] initWithCapacity:1];
        //dataTableNoOfRows = 0;
    }
    return self;
}

-(id) init {
    if (self = [super init]){
        NSLog(@"DO I GEEEEET HEREEEE");
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    
    //NSLog(@"view loaded. name of service: %@ and %@", self.VCServiceNameType, invMngr.currActiveVCName);
    //examp.text = VCServiceNameType;
    //NSLog(@" --->> current service name: %@", VCServiceNameType);
    InvoiceManager *invMngr = [InvoiceManager sharedInvoiceManager];
    invMngr.currActiveVCName = self.VCServiceNameType;
    examp.text = VCServiceNameType;
    //dataTableNoOfRows = [serviceDataCellArray count];
    //[dataTable reloadData];
    
    //NSLog(@"initialize service data cell array HERE ");
    //listOfTableCells = [[NSMutableArray alloc] initWithCapacity:1];
    [dataTable reloadData];
    //uilabelsArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    //if (!col1Name){
    col1Name = [[[UILabel alloc] initWithFrame:CGRectMake(78.0f, 324.0f, 161.0f, 21.0f)] autorelease];
    //[col1Name setText:@"room name / stairs"];
    [self.view addSubview:col1Name];
    
    col2Name = [[[UILabel alloc] initWithFrame:CGRectMake(247.0f, 324.0f, 170.0f, 21.0f)] autorelease];
    [self.view addSubview:col2Name];
    
    col3Name = [[[UILabel alloc] initWithFrame:CGRectMake(425.0f, 324.0f, 131.0f, 21.0f)] autorelease];
    [self.view addSubview:col3Name];
    
    col4Name = [[[UILabel alloc] initWithFrame:CGRectMake(564.0f, 324.0f, 86.0, 21.0f)] autorelease];
    [self.view addSubview:col4Name];
    //}
    
    if ([VCServiceNameType isEqualToString:@"carpet"]){
        [carpetTypeSelection setHidden:FALSE];
        
        [col1Name setText:@"room name / stairs"];
        [col2Name setText:@"length x width"];
        [col3Name setText:@"area (sq.ft)"];
        [col4Name setText:@"price"];
        //UILabel *col1 = [[UILabel alloc] initWithFrame:CGRectMake(39.0f, 310.0f, 147.0f, 21.0f)];
        
        //[col1 setText:@"room name / stairs"];
        
        //[self.view addSubview:col1];
    } else if ([VCServiceNameType isEqualToString:@"upholstery"]){
        [col1Name setText:@"product name"];
        [col2Name setText:@"clean type/material"];
        [col3Name setText:@"quantity"];
        [col4Name setText:@"price"];
    } else if ([VCServiceNameType isEqualToString:@"mattress"]){
        [col1Name setText:@"product name"];
        [col2Name setText:@"clean type"];
        [col3Name setText:@"quantity"];
        [col4Name setText:@"price"];
    } else if ([VCServiceNameType isEqualToString:@"miscellaneous"]){
        [col1Name setText:@"product name"];
        [col2Name setText:@"price rate"];
        [col3Name setText:@"quantity"];
        [col4Name setText:@"price"];
    } else if ([VCServiceNameType isEqualToString:@"areaRugs"]){
        [col1Name setText:@"product name"];
        [col2Name setText:@"material type"];
        [col3Name setText:@""];
        [col4Name setText:@"price"];
    } else if ([VCServiceNameType isEqualToString:@"floodcleanup"]){
        [col1Name setText:@"service name"];
        [col2Name setText:@"rate price"];
        [col3Name setText:@""];
        [col4Name setText:@"price"];
    }
    
    NSLog(@"size of data table: %f, %f", [dataTable contentSize].height, [dataTable bounds].size.width );
    
    //
}

-(void) viewDidLayoutSubviews {
    
}

- (void)viewDidLoad
{
    //InvoiceManager *invoiceMngr = [InvoiceManager sharedInvoiceManager];
    //[invoiceMngr printOut];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(IBAction)goBackCUSTOMACTION {
 //[self dismissModalViewControllerAnimated:YES];
 //[self dismissViewControllerAnimated:YES completion:nil];
 [self.navigationController popViewControllerAnimated:YES];
 //NSLog(@"Hi");
 //[SVCdelegate updateTableSVC:self];
 
 }*/

#pragma mark - Table view data source

// ====================================================
// table view data source implementations BELOW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return dataTableNoOfRows;
}

-(UITableViewCell *) tableView:(UITableView *) tableViewArg cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"normalCell";
    InvoiceManager *invoiceMngr = [InvoiceManager sharedInvoiceManager];
    CustomTableViewCell *cell = (CustomTableViewCell *) [tableViewArg dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        //[cell initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    ServiceDataCell *serviceCell = [serviceDataCellArray objectAtIndex:indexPath.row];
    
    // depending on which type it is.. display data
    if ([VCServiceNameType isEqualToString:@"carpet"]){                         // CARPET service
        if ([[serviceCell itemAttribute] isEqualToString:@"Room"]){
            float rl = [serviceCell rlength];
            float rw = [serviceCell rwidth];
            cell.colOne.text = [serviceCell name];
            cell.colThree.text = [NSString stringWithFormat:@"%0.02f", (rl * rw) ];
            cell.colTwo.text = [NSString stringWithFormat:@"%0.02f x %0.02f", rl, rw ];
            
            // get the user-inputted rate per sq feet (invoiceMngr ratePerSquareFeet)
            // CGFloat priceUpdate = [invoiceMngr ratePerSquareFeet] * rl * rw;
            // [serviceCell setPrice:priceUpdate];
            
            // calculating
            CGFloat currentPriceRate = [serviceCell priceRate];
            currentPriceRate = [invoiceMngr ratePerSquareFeet];
            if ([serviceCell addonDeodorizer]) {
                currentPriceRate += 0.10f;
                [serviceCell setPriceRate:currentPriceRate];
                //priceRate = priceRate + 0.10f;
            }
            if ([serviceCell addonFabricProtector]){
                currentPriceRate += 0.15f;
                [serviceCell setPriceRate:currentPriceRate];
                //priceRate = priceRate + 0.15f;
            }
            if ([serviceCell addonBiocide]){
                currentPriceRate += 0.15f;
                [serviceCell setPriceRate:currentPriceRate];
                //priceRate = priceRate + 0.15f;
            }
            CGFloat priceUpdate = currentPriceRate * rl * rw;
            [serviceCell setPriceRate:currentPriceRate];
            [serviceCell setPrice:priceUpdate];
            
            cell.colFour.text = [NSString stringWithFormat:@"%.02f", [serviceCell price] ];
            //cell.colFour.text = [NSString stringWithFormat:@"%0.02f", ([invoiceMngr ratePerSquareFeet] * rl * rw) ];
        } else if ([[serviceCell itemAttribute] isEqualToString:@"Stairs"]){
            cell.colOne.text = [serviceCell name];
            cell.colTwo.text = [NSString stringWithFormat: @"stairs:%u", [serviceCell quantity]];
            cell.colThree.text = [NSString stringWithFormat: @"landings:%u", [serviceCell quantity2]];
            //cell.colFour.text = [NSString stringWithFormat:@"%.02f", [serviceCell price]];
            CGFloat priceUpdate = [serviceCell quantity] * 5.0f + [serviceCell quantity2] * 10.0f;
            [serviceCell setPrice:priceUpdate];
            cell.colFour.text = [NSString stringWithFormat:@"%.02f", [serviceCell price]];
        }
        
    } else if ([VCServiceNameType isEqualToString:@"mattress"]){                // Mattress service
        cell.colOne.text = [serviceCell name];
        cell.colTwo.text = [serviceCell vacOrFull];
        cell.colThree.text = [NSString stringWithFormat:@"%u",[serviceCell quantity]];
        cell.colFour.text = [NSString stringWithFormat:@"%0.02f",[serviceCell price]];
    } else if ([VCServiceNameType isEqualToString:@"upholstery"]){              // Upholstery service
        cell.colOne.text = [serviceCell name];
        NSString *vacAndMat = [NSString stringWithFormat:@"%@, %@", [serviceCell vacOrFull], [serviceCell materialType]];
        cell.colTwo.text = vacAndMat;
        cell.colThree.text = [NSString stringWithFormat:@"%u",[serviceCell quantity]];
        cell.colFour.text = [NSString stringWithFormat:@"%0.02f",[serviceCell price]];
    } else if ([VCServiceNameType isEqualToString:@"floodcleanup"]){              // Flood Cleanup service
        cell.colOne.text = [serviceCell name];
        //NSString *vacAndMat = [NSString stringWithFormat:@"%@, %@", [serviceCell vacOrFull], [serviceCell materialType]];
        cell.colTwo.text = [NSString stringWithFormat:@"%f", [serviceCell ratePerHr]];
        cell.colThree.text = [NSString stringWithFormat:@"%u",[serviceCell quantity]];
        cell.colFour.text = [NSString stringWithFormat:@"%0.02f",[serviceCell price]];
    } else if ([VCServiceNameType isEqualToString:@"miscellaneous"]){
        // ************ TO BE COMPLETED
        cell.colOne.text = [serviceCell name];
        cell.colTwo.text = [NSString stringWithFormat:@"%f",[serviceCell priceRate]];
        cell.colThree.text = [NSString stringWithFormat:@"%u",[serviceCell quantity]];
        cell.colFour.text = [NSString stringWithFormat:@"%0.02f",[serviceCell price]];
    } else if ([VCServiceNameType isEqualToString:@"areaRugs"]){
        cell.colOne.text = [serviceCell name];
        //NSString *vacAndMat = [NSString stringWithFormat:@"%@, %@", [serviceCell vacOrFull], [serviceCell materialType]];
        cell.colTwo.text = [serviceCell materialType];
        //cell.colThree.text = [NSString stringWithFormat:@"%u",[serviceCell quantity]];
        cell.colFour.text = [NSString stringWithFormat:@"%0.02f",[serviceCell price]];
    }
    
    // add a delete button for each cell
    [[cell deleteBtn] setCellIndex:indexPath.row];
    [[cell editBtn] setCellIndex:indexPath.row];
    return cell;
}
// table view data source implementations ABOVE
// ====================================================

// only supports UIButton's right now
-(IBAction) onChoosingType: (id) sender {
    // set last selected back to normal
    for (UIButton *aSubview2 in self.view.subviews){
        for (id aSubview in aSubview2.subviews){
            if ([aSubview isKindOfClass:[UIButton class]]){
                if ([aSubview tag] == 10){
                    NSLog(@"hi, %@, %u", [aSubview restorationIdentifier], [aSubview tag]);
                    [aSubview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    [aSubview setTag:0];
                }
            }
        }
    }
    
    // put background image view under the newly selected button
    UIButton *btn = (UIButton*)sender;
    NSString *senderID = [btn restorationIdentifier];
    if ([senderID isEqualToString:@"nylon"]){
        [selectedType setFrame:CGRectMake(66.0f, selectedType.frame.origin.y, selectedType.frame.size.width, selectedType.frame.size.height)];
    } else if ([senderID isEqualToString:@"polyester"]){
        [selectedType setFrame:CGRectMake(186.0f, selectedType.frame.origin.y, selectedType.frame.size.width, selectedType.frame.size.height)];
    } else if ([senderID isEqualToString:@"olefin"]){
        [selectedType setFrame:CGRectMake(304.0f, selectedType.frame.origin.y, selectedType.frame.size.width, selectedType.frame.size.height)];
    } else if ([senderID isEqualToString:@"wool"]){
        [selectedType setFrame:CGRectMake(417.0f, selectedType.frame.origin.y, selectedType.frame.size.width, selectedType.frame.size.height)];
    } else if ([senderID isEqualToString:@"berber"]){
        [selectedType setFrame:CGRectMake(523.0f, selectedType.frame.origin.y, selectedType.frame.size.width, selectedType.frame.size.height)];
    } else if ([senderID isEqualToString:@"cutpile"]){
        [selectedType setFrame:CGRectMake(626.0f, selectedType.frame.origin.y, selectedType.frame.size.width, selectedType.frame.size.height)];
    }
    [btn setTag:10];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(IBAction)removeRow:(id)sender {
    NSLog(@"removing row with index: %u", [sender cellIndex]);
    [serviceDataCellArray removeObjectAtIndex: [sender cellIndex]];
    
    dataTableNoOfRows--;
    [dataTable reloadData];
}

-(IBAction)editRow:(id)sender {
    
    UIViewController* popoverToEdit = [[serviceDataCellArray objectAtIndex:[sender cellIndex]] popoverVC];
    ServiceDataCell* cellToEdit = [serviceDataCellArray objectAtIndex:[sender cellIndex]];
    BasePopoverVC* popovervcEdit = (BasePopoverVC*) popoverToEdit;
    // NSLog(@"HEY BUDDY EDITING %u, %@", [sender cellIndex], [popoverToEdit restorationIdentifier]);
    // NSLog(@">>>>>>>>>>>index is %u", [sender cellIndex]);
    [popovervcEdit setEditMode:true];
    [popovervcEdit setEditingCell:cellToEdit];
    
    /*NSString* popoverVCrestorationID = [popoverToEdit restorationIdentifier];
     if ([popoverVCrestorationID isEqualToString:@"OptionsPopoverVC"]){
     
     } else if ([popoverVCrestorationID isEqualToString:@"OptionsMatressPopoverVC"]){
     
     } else if ([popoverVCrestorationID isEqualToString:@"OptionsUpholsteryPopoverVC"]){
     
     } else if ([popoverVCrestorationID isEqualToString:@"OptionsRepairPopoverVC"]){
     
     } else if ([popoverVCrestorationID isEqualToString:@"OptionsFloodPopoverVC"]){
     
     } else if ([popoverVCrestorationID isEqualToString:@"OptionsAreaRugsPopoverVC"]){
     
     } else if ([popoverVCrestorationID isEqualToString:@"OptionsMiscellaneousPopoverVC"]){
     
     }*/
    
    //OptionsPopoverVC *blah = (OptionsPopoverVC*) popoverToEdit;
    //[blah setEditMode:true];
    
    NSLog(@"RESTORATION ID is %@", [popoverToEdit restorationIdentifier]);
    if (popover){
        [popover setContentViewController:popovervcEdit];
    }else {
        popover = [[UIPopoverController alloc] initWithContentViewController:popovervcEdit];
    }
    
    //optionsMatressVC.MVCDelegate = self;        // set the popover's delegate to this ui vc (IMPORTANT!)
    [popover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    // [self removeRow:sender];
}

// instantiate popover (+ Add item) in terms of what service type page is generated
-(IBAction)displayOptionsPopoverVC: (id) sender {
    
    // create new popover UIViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    
    if ([VCServiceNameType isEqualToString:@"carpet"]){
        OptionsPopoverVC *optionsVC = (OptionsPopoverVC*) [storyboard instantiateViewControllerWithIdentifier:@"OptionsPopoverVC"];
        
        if (popover){
            //NSLog(@"popover EXISTS !");
            [popover setContentViewController:optionsVC];
        }else {
            //NSLog(@"popover getting INITIALIZED ! !");
            popover = [[UIPopoverController alloc] initWithContentViewController:optionsVC];
        }
        
        optionsVC.OVCDelegate = self;               // set the popover's delegate to this ui vc (IMPORTANT!)
        [popover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else if ([VCServiceNameType isEqualToString:@"mattress"]){
        OptionsMatressPopoverVC *optionsMatressVC = (OptionsMatressPopoverVC*) [storyboard instantiateViewControllerWithIdentifier:@"OptionsMatressPopoverVC"];
        
        if (popover){
            [popover setContentViewController:optionsMatressVC];
        }else {
            popover = [[UIPopoverController alloc] initWithContentViewController:optionsMatressVC];
        }
        
        optionsMatressVC.MVCDelegate = self;        // set the popover's delegate to this ui vc (IMPORTANT!)
        [popover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else if ([VCServiceNameType isEqualToString:@"upholstery"]){
        OptionsUpholsteryPopoverVC *optionsUpholsteryVC = (OptionsUpholsteryPopoverVC*) [storyboard instantiateViewControllerWithIdentifier:@"OptionsUpholsteryPopoverVC"];
        
        if (popover){
            [popover setContentViewController:optionsUpholsteryVC];
        }else {
            popover = [[UIPopoverController alloc] initWithContentViewController:optionsUpholsteryVC];
        }
        
        optionsUpholsteryVC.UVCDelegate = self;     // set the popover's delegate to this ui vc (IMPORTANT!)
        [popover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else if ([VCServiceNameType isEqualToString:@"areaRugs"]){
        OptionsAreaRugsPopoverVC *optionsVC = (OptionsAreaRugsPopoverVC*) [storyboard instantiateViewControllerWithIdentifier:@"OptionsAreaRugsPopoverVC"];
        
        if (popover){
            [popover setContentViewController:optionsVC];
        }else {
            popover = [[UIPopoverController alloc] initWithContentViewController:optionsVC];
        }
        
        optionsVC.ARVCDelegate = self;     // set the popover's delegate to this ui vc (IMPORTANT!)
        [popover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else if ([VCServiceNameType isEqualToString:@"floodcleanup"]){
        OptionsFloodPopoverVC *optionsFloodVC = (OptionsFloodPopoverVC*) [storyboard instantiateViewControllerWithIdentifier:@"OptionsFloodPopoverVC"];
        
        if (popover){
            [popover setContentViewController:optionsFloodVC];
        }else {
            popover = [[UIPopoverController alloc] initWithContentViewController:optionsFloodVC];
        }
        
        optionsFloodVC.FVCDelegate = self;     // set the popover's delegate to this ui vc (IMPORTANT!)
        [popover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else if ([VCServiceNameType isEqualToString:@"miscellaneous"]){
        OptionsMiscellaneousPopoverVC *optionsVC = (OptionsMiscellaneousPopoverVC*) [storyboard instantiateViewControllerWithIdentifier:@"OptionsMiscellaneousPopoverVC"];
        
        if (popover){
            [popover setContentViewController:optionsVC];
        }else {
            popover = [[UIPopoverController alloc] initWithContentViewController:optionsVC];
        }
        
        optionsVC.MIVCDelegate = self;     // set the popover's delegate to this ui vc (IMPORTANT!)
        [popover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    
    
}

// ====================================================
// DELEGATE function implementations BELOW

// matress delegate function
//- (void)updateMatressDataTable:(OptionsMatressPopoverVC *)optionsMVC editType: (NSString*) editType withItem: (NSString *) item_name withCleanType: (NSString *) vac_or_full andQuantity: (NSInteger) quantity_arg andPrice: (float) item_price_arg andNotes:(NSString *) notesAboutRoom {
- (void)updateMatressDataTable:(OptionsMatressPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg {
    if ([editType isEqualToString:@"add"]){
        // save popover info into a Service data cell
        
        /*ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
         newCell.serviceType = @"matress";
         newCell.quantity = quantity_arg;
         newCell.name = item_name;
         newCell.price = item_price_arg;
         newCell.vacOrFull = vac_or_full;
         newCell.notes = notesAboutRoom;
         */
        // save the service data cell to an array ( which will be called upon by table view delegate funcs )
        //[serviceDataCellArray addObject:newCell];
        
        //UIViewController* tempVC = (OptionsMatressPopoverVC*) optionsVS;
        //[tempVC retain];
        [optionsVS retain];
        [cell_arg setPopoverVC:optionsVS];
        
        //[serviceDataCellArray insertObject:cell_arg atIndex:]
        [serviceDataCellArray addObject:cell_arg];
        dataTableNoOfRows++;                    // increase the data table view's # of rows
        [dataTable reloadData];                 // reload table view data
        [popover dismissPopoverAnimated:NO];    // dismiss popover
    } else if ([editType isEqualToString:@"edit"]){
        [popover dismissPopoverAnimated:NO];    // dismiss popover
        [dataTable reloadData];                 // reload table view data
    } else if ([editType isEqualToString:@"cancel"]){
        [popover dismissPopoverAnimated:NO];
    }
}

// carpet delegate function
/*- (void)updateDataTable:(OptionsPopoverVC *)optionsVS editType:(NSString*) editType withLength: (float) length_arg withWidth: (float) width_arg
 andRoom: (NSString*) roomName withPriceRate:(float) priceRate_arg andNotes:(NSString *) notesAboutRoom {*/
- (void)updateDataTable:(OptionsPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg {
    
    if ([editType isEqualToString:@"add"]){
        // save popover info into a Service data cell
        /*ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
         newCell.serviceType = @"carpet";
         newCell.rlength = length_arg;
         newCell.rwidth = width_arg;
         newCell.name = roomName;
         newCell.priceRate = priceRate_arg;
         //NSLog(@"NOTES ARE EQUAL TO : %@", notesAboutRoom);
         newCell.notes = notesAboutRoom;*/
        
        // save the service data cell to an array ( which will be called upon by table view delegate funcs )
        //[serviceDataCellArray addObject:newCell];
        [optionsVS retain];
        [cell_arg setPopoverVC:optionsVS];
        NSLog(@"price is %f", [cell_arg price]);
        /*
         if (optionsVS){
         NSLog(@"its NOT NULL ");
         } else {
         NSLog(@"its  NULL ");
         }*/
        // [[cell_arg popoverVC] retain];
        
        [serviceDataCellArray addObject:cell_arg];
        dataTableNoOfRows++;                    // increase the data table view's # of rows
        [dataTable reloadData];                 // reload table view data
        [popover dismissPopoverAnimated:NO];    // dismiss popover
    } else if ([editType isEqualToString:@"edit"]){
        [dataTable reloadData];                 // update table
        [popover dismissPopoverAnimated:NO];    // dismiss popover
    } else if ([editType isEqualToString:@"cancel"]){
        [popover dismissPopoverAnimated:NO];
    }
}

//- (void)updateUpholsteryDataTable:(OptionsUpholsteryPopoverVC *)optionsVS editType:(NSString*) editType withItemName: (NSString*) item_name_arg withMaterialType: (NSString*) item_material_arg withCleanType: (NSString*) vac_or_full_arg andQuantity: (NSInteger) quantity_arg andPrice: (float) item_price_arg andNotes: (NSString*) notes_arg {
- (void)updateUpholsteryDataTable:(OptionsUpholsteryPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg {
    
    if ([editType isEqualToString:@"add"]){
        // save popover info into a Service data cell
        /*ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
         
         newCell.serviceType = @"upholstery";
         newCell.notes = notes_arg;
         newCell.name = item_name_arg;
         newCell.materialType = item_material_arg;
         newCell.vacOrFull = vac_or_full_arg;
         newCell.quantity = quantity_arg;
         newCell.price = item_price_arg;*/
        
        // save the service data cell to an array ( which will be called upon by table view delegate funcs )
        //[serviceDataCellArray addObject:newCell];
        [optionsVS retain];
        [cell_arg setPopoverVC:optionsVS];
        [serviceDataCellArray addObject:cell_arg];
        dataTableNoOfRows++;                    // increase the data table view's # of rows
        [dataTable reloadData];                 // reload table view data
        [popover dismissPopoverAnimated:NO];    // dismiss popover
    } else if ([editType isEqualToString:@"edit"]){
        [dataTable reloadData];                 // update table
        [popover dismissPopoverAnimated:NO];    // dismiss popover
    } else if ([editType isEqualToString:@"cancel"]){
        [popover dismissPopoverAnimated:NO];
    }
    
}

- (void)updateAreaRugsDataTable:(OptionsUpholsteryPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg {
    if ([editType isEqualToString:@"add"]){
        // save popover info into a Service data cell
        /*ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
         
         newCell.serviceType = @"upholstery";
         newCell.notes = notes_arg;
         newCell.name = item_name_arg;
         newCell.materialType = item_material_arg;
         newCell.vacOrFull = vac_or_full_arg;
         newCell.quantity = quantity_arg;
         newCell.price = item_price_arg;*/
        
        // save the service data cell to an array ( which will be called upon by table view delegate funcs )
        //[serviceDataCellArray addObject:newCell];
        
        [optionsVS retain];
        [cell_arg setPopoverVC:optionsVS];
        [serviceDataCellArray addObject:cell_arg];
        dataTableNoOfRows++;                    // increase the data table view's # of rows
        [dataTable reloadData];                 // reload table view data
        [popover dismissPopoverAnimated:NO];    // dismiss popover
    } else if ([editType isEqualToString:@"edit"]){
        [dataTable reloadData];                 // update table
        [popover dismissPopoverAnimated:NO];    // dismiss popover
    } else if ([editType isEqualToString:@"cancel"]){
        [popover dismissPopoverAnimated:NO];
    }
}

//-(void)updateFloodDataTable:(OptionsFloodPopoverVC *)optionsFVC editType: (NSString*) editType withItemName: (NSString *) item_name_arg withRate: (float) rate_arg withQuantity: (float) quantity_arg withQuantity2: (float) quantity2_arg withPrice:(float)price_arg andNotes: (NSString *) notes_arg {
- (void)updateFloodServicesDataTable:(OptionsFloodPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg {
    
    if ([editType isEqualToString:@"add"]){
        // save popover info into a Service data cell
        /*ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
         
         newCell.serviceType = @"floodcleanup";
         newCell.notes = notes_arg;
         newCell.name = item_name_arg;
         newCell.quantity = quantity_arg;
         newCell.quantity2 = quantity2_arg;
         newCell.price = price_arg;
         newCell.ratePerHr = rate_arg;*/
        
        // save the service data cell to an array ( which will be called upon by table view delegate funcs )
        
        [optionsVS retain];
        [cell_arg setPopoverVC:optionsVS];
        [serviceDataCellArray addObject:cell_arg];
        dataTableNoOfRows++;                    // increase the data table view's # of rows
        [dataTable reloadData];                 // reload table view data
        [popover dismissPopoverAnimated:NO];    // dismiss popover
    } else if ([editType isEqualToString:@"edit"]){
        [dataTable reloadData];                 // update table
        [popover dismissPopoverAnimated:NO];    // dismiss popover
    } else if ([editType isEqualToString:@"cancel"]){
        [popover dismissPopoverAnimated:NO];
    }
    
}

//- (void)updateMiscellaneousDataTable:(OptionsMiscellaneousPopoverVC *)optionsVS editType:(NSString*) editType withItemName: (NSString *) itemName_arg withItemPrice: (float) itemPrice_arg withQuantity: (NSInteger) quantity_arg withSubtotalPrice: (float) price_arg andNotes: (NSString*) notes_arg {
- (void)updateMiscellaneousDataTable:(OptionsMiscellaneousPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg {
    if ([editType isEqualToString:@"add"]){
        // save popover info into a Service data cell
        
        
        // save the service data cell to an array ( which will be called upon by table view delegate funcs )
        
        [optionsVS retain];
        [cell_arg setPopoverVC:optionsVS];
        [serviceDataCellArray addObject:cell_arg];
        dataTableNoOfRows++;                    // increase the data table view's # of rows
        [dataTable reloadData];                 // reload table view data
        [popover dismissPopoverAnimated:NO];    // dismiss popover
    } else if ([editType isEqualToString:@"edit"]){
        [dataTable reloadData];                 // update table
        [popover dismissPopoverAnimated:NO];    // dismiss popover
    } else if ([editType isEqualToString:@"cancel"]){
        [popover dismissPopoverAnimated:NO];
    }
}
// DELEGATE function implementations ABOVE
// ====================================================

// goes to the next VC according to what services are selected ( and in their proper order )
-(IBAction) gotoNextView {
    InvoiceManager *invoiceMngr = [InvoiceManager sharedInvoiceManager];
    
    //NSLog(@"wtf is this %@", [self.navigationController presentingViewController]);
    if (invoiceMngr.getNextVC){
        UIViewController *nextVC = invoiceMngr.getNextVC;
        [self.navigationController pushViewController:nextVC animated:YES];
    } else {
        NSLog(@"NEXT VC IS NULL");
        [self.navigationController pushViewController:[invoiceMngr invoiceVC] animated:YES];
    }
    // if any services exist, push the first service VC
    //ServiceItem *nextitem = [[invoiceMngr listOfServices] objectAtIndex:0];
    /*if ( ([[invoiceMngr listOfServices] count] > 0) && ([[invoiceMngr listOfServices] objectAtIndex:0]) ){
     ServiceItem *nextitem = [[invoiceMngr listOfServices] objectAtIndex:0];
     UIViewController *vcc = nextitem.serviceVC;
     [self.navigationController pushViewController:vcc animated:YES];
     } else {
     NSLog(@"Please add some services ?");
     }*/
}

-(IBAction) gotoLastView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"deallocating service type vc");
    
    // release uilabels allocated
    /*for (int i = 0; i < [uilabelsArray count]; i++){
     [[uilabelsArray objectAtIndex:i] release];
     }*/
    
    for (int i = 0; i < [serviceDataCellArray count]; i++){
        [[serviceDataCellArray objectAtIndex:i] release];
    }
    
    [serviceDataCellArray release];
    [popover release];
    [super dealloc];
}


/*
 // =================================================
 // OTHER:
 
 -(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([[segue identifier] isEqualToString:@"popoverSegue"]) {
 NSLog(@"preparing for segue AAAAA");
 popover = [(UIStoryboardPopoverSegue*) segue popoverController];
 //if (optionsOne){
 //    NSLog(@"segue: initializing..");
 //} else {
 //optionsOne = (OptionsPopoverVC*) popover.contentViewController;
 //[optionsOne retain];
 OptionsPopoverVC *popVC = (OptionsPopoverVC*) popover.contentViewController;
 //}
 //optionsOne.OVCDelegate = self;
 popVC.OVCDelegate = self;
 }
 
 }*/

@end
