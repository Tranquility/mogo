//
//  AppointmentViewController.m
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppointmentViewController.h"

@implementation AppointmentViewController



@synthesize appointmentList = _appointmentList;
@synthesize doctorsList = _doctorsList;
@synthesize appointmentTableView = _appointmentTableView;
@synthesize doctorsTableView = _doctorsTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appointmentList = [[NSArray alloc] initWithObjects:@"Termin1", @"Termin2",
                       @"Termin3", nil];
    self.doctorsList = [[NSArray alloc] initWithObjects:@"+ neuen Arzt suchen", @"Doktor No", @"Doktor Hulk",
                            @"Doktor Heid", @"Doktor Jekyll", @"Doktor Scrum", nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   if (section == 0)
   {
       return  [self.appointmentList count];

   }
    else 
    {
        return  [self.doctorsList count];

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
    static NSString *CellIdentifier = @"viewcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.text = [self.appointmentList objectAtIndex:[indexPath row]];
    
    return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"viewcell2";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell.
        cell.textLabel.text = [self.doctorsList objectAtIndex:[indexPath row]];
        
        return cell;
    }
}    
    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
        return 2;
    }

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Kommende Termine";
    else
        return @"Neuen Termin buchen bei";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       
    if (indexPath.section == 0)
    {
        [self performSegueWithIdentifier:@"appointmentDetail" sender:self];
    }
    else
    {
        if (indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"toSearch" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"toMakeAppointment" sender:self];

        }
    }
    /*NSArray *listData =self.tableContents objectForKey:
                                         [self.sortedKeys objectAtIndex:[indexPath section]]];
   
    NSUInteger row = [indexPath row];
    
    NSString *rowValue = [listData objectAtIndex:row];
       
    NSString *message = [[NSString alloc] initWithFormat:rowValue];
       UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"You selected"
                         
                          message:message delegate:nil
                          
                          cancelButtonTitle:@"OK"
                        
                          otherButtonTitles:nil];
    
    [alert show];
    
    [alert release];
   
    [message release];
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];*/
   
}


@end
