//
//  AppointmentViewController.m
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppointmentViewController.h"
#import "AppointmentTableViewCell.h"
#import "AppointmentModel.h"
#import "DoctorModel.h"

@implementation AppointmentViewController

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
    self.appointmentList = [[NSMutableArray alloc] init];
    
    /*
    // Todo: Connect this to the DataSource and retrieve Appointments from the Server
    */
     
    //For now: Statically create three Appointments and add to the appointmentList:
    DoctorModel* doctor = [[DoctorModel alloc]initWithId:1 discipline:@"Internist" title:@"Dr." gender:@"Male" firstName:@"Ole" lastName:@"Scrum" mail:@"Nothing" telephone:@"Nothing" address:nil];
    AppointmentModel* appointment = [[AppointmentModel alloc]initWithId:1 doctor:doctor andDate:[[NSDate alloc] init] andNote:@"Nothing"];
    [self.appointmentList addObject:appointment];
    appointment = [[AppointmentModel alloc]initWithId:2 doctor:doctor andDate:[[NSDate alloc] init] andNote:@"Nothing"];
    [self.appointmentList addObject:appointment];
    appointment = [[AppointmentModel alloc]initWithId:3 doctor:doctor andDate:[[NSDate alloc] init] andNote:@"Nothing"];
    [self.appointmentList addObject:appointment];
    
    
    /*
    //Retrieve the Favourite-Doctor List
    */
    //Path to the favourite Doctors file
    NSString *myPath = [self saveFilePath];
    
    //Set up Favourite-List depending on whether there exists a file or not
	if ([[NSFileManager defaultManager] fileExistsAtPath:myPath])
	{
        self.doctorList = [NSKeyedUnarchiver unarchiveObjectWithFile: myPath];
	}
    else
    {
        self.doctorList = [[NSMutableArray alloc] init];
    }
    
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
        return self.appointmentList.count;
    }
    else
    {
        //Always add one, because we have a static entry "Doktor suchen"
        NSLog(@"DoctorList has %d entries",self.doctorList.count);
        return self.doctorList.count+1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 63;
    }
    else
    {
        return 45;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Show the Appointments
    if (indexPath.section == 0)
    {
        NSString *cellIdentifier = @"AppointmentTableViewCell";
        
        AppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[AppointmentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        // Configure the cell according to the Appointment-Datamodel-Object
        AppointmentModel *appointment = [self.appointmentList objectAtIndex:indexPath.row];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd 'um' HH:mm"];

        cell.DateLabel.text = [dateFormatter stringFromDate:appointment.date];
        cell.doctorDisciplineLabel.text = appointment.doctor.discipline;
        cell.doctorLabel.text = [NSString stringWithFormat:@"%@ %@ %@", appointment.doctor.title, appointment.doctor.firstName,appointment.doctor.lastName];
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        return cell;
    }
    else //Show the Doctors
    {
        NSString *cellIdentifier = @"viewcell2";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        if(indexPath.row==0)
        {
            cell.textLabel.text = @"+ neuen Arzt suchen";
            cell.detailTextLabel.text = @"";
        }
        else{
            //Offset the array inde by -1 because of the first static entry ("Arzt suchen")
            DoctorModel *doctor = [self.doctorList objectAtIndex:[indexPath row]-1];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", doctor.title, doctor.firstName,doctor.lastName];
            cell.detailTextLabel.text = [[self.doctorList objectAtIndex:indexPath.row] discipline];
        }
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        return @"Kommende Termine";
    }
    else
    {
        return @"Neuen Termin buchen bei";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"toAppointmentDetail" sender:self];
    }
    else
    {
        if (indexPath.row == 0)
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self performSegueWithIdentifier:@"toSearch" sender:self];
        }
        else
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self performSegueWithIdentifier:@"toMakeAppointment" sender:self];
            
        }
    }
    
}

//Creates the FilePath for the Favourite-List
- (NSString *) saveFilePath
{
	NSArray *path =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"data.archive"];
    
}


@end
