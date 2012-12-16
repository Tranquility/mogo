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
#import "AFNetworking.h"
#import "ApiClient.h"
#import "MakeAppointmentViewController.h"

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
        self.favouriteDoctorIDList = [NSKeyedUnarchiver unarchiveObjectWithFile: myPath];
	}
    else
    {
        self.favouriteDoctorIDList = [[NSMutableArray alloc] init];
    }
    
    
    /*
    / Retrieve all Doctors from the Server
    / TODO: This really should be done only once, e.g. when the App starts up.
    */
    self.doctorList = [[NSMutableArray alloc]init];
    
    [[ApiClient sharedInstance] getPath:@"doctors.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    for (id doctorJson in response) {
                                        
                                        CLLocationCoordinate2D location;
                                        location.latitude = [[doctorJson valueForKeyPath:@"latitude"] floatValue];
                                        location.longitude = [[doctorJson valueForKeyPath:@"longitude"] floatValue];
                                        
                                        AddressModel *address = [[AddressModel alloc] initWithStreet:[doctorJson valueForKeyPath:@"street"]
                                                                        streetNumber:[[doctorJson valueForKeyPath:@"street_number"] intValue]
                                                                             zipCode:[doctorJson valueForKeyPath:@"zip_code"]
                                                                                city:[doctorJson valueForKeyPath:@"city"]
                                                                            latitude:[doctorJson valueForKeyPath:@"latitude"]
                                                                           longitude:[doctorJson valueForKeyPath:@"longitude"]];

                                        
                                        DoctorModel *doctorModel = [[DoctorModel alloc] initWithId:[[doctorJson valueForKeyPath:@"id"] intValue]
                                                                                        discipline:[doctorJson valueForKeyPath:@"discipline.name"]
                                                                                             title:[doctorJson valueForKeyPath:@"title"]
                                                                                            gender:[doctorJson valueForKeyPath:@"gender"]
                                                                                         firstName:[doctorJson valueForKeyPath:@"firstname"]
                                                                                          lastName:[doctorJson valueForKeyPath:@"lastname"]
                                                                                              mail:[doctorJson valueForKeyPath:@"mail"]
                                                                                         telephone:[doctorJson valueForKeyPath:@"telephone"]
                                                                                           address:address];
                                        [self.doctorList addObject:doctorModel];
                                    }
     
                                [self.appointmentsTableView reloadData];
     
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error fetching docs!");
                                    NSLog(@"%@", error);
                                    
                                }];
   
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
    if(section == 0)
    {
        return self.appointmentList.count;
    }
    else
    {
        //We need to be careful here, because the doctorList gets loaded asynchronously, and it could not be loaded yet
        //resuting in a null reference when updating the tableViewController
        if(self.doctorList.count>0)
        {
            //Always add one, because we have a static entry "Doktor suchen"
            return self.favouriteDoctorIDList.count+1;
        }
        else{
            return 1;
        }
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
        [dateFormatter setDateFormat:@"dd.MM. 'um' HH:mm"];

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
            cell.textLabel.text = NSLocalizedString(@"+ neuen Arzt suchen", @"neuen Arzt suchen");
            cell.detailTextLabel.text = @"";
        }
        else{
            //Offset the array inde by -1 because of the first static entry ("Arzt suchen")
            NSString *doctorID = [self.favouriteDoctorIDList objectAtIndex:[indexPath row]-1];
            DoctorModel* doctorModel = [self getDoctorByID:doctorID];
                        
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", doctorModel.title, doctorModel.firstName,doctorModel.lastName];
            cell.detailTextLabel.text = doctorModel.discipline;
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
            //Get the doctor that has been clicked
            NSString *doctorID = [self.favouriteDoctorIDList objectAtIndex:[indexPath row]-1];
            self.selectedDoctorIDforAppointment = doctorID;
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self performSegueWithIdentifier:@"toMakeAppointment" sender:self];
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toMakeAppointment"]) {
        MakeAppointmentViewController *destination = [segue destinationViewController];
        
        //Get the selected DoctorID and the corresponding doctor reference
        DoctorModel* doctorModel = [self getDoctorByID:self.selectedDoctorIDforAppointment];
        //Set the doctor reference for the upcoming View
        destination.doctor = doctorModel;
    }
}

//Creates the FilePath for the Favourite-List
- (NSString *) saveFilePath
{
	NSArray *path =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"data.archive"];
    
}

-(DoctorModel*) getDoctorByID:(NSString*)doctorID
{
    //For all Doctors, find the one with the given ID...
    for(int i=0;i<self.doctorList.count;i++)
    {
        DoctorModel* doctor = [self.doctorList objectAtIndex:i];
        if([[NSString stringWithFormat:@"%d",doctor.idNumber] isEqualToString:doctorID])
        {
            return doctor;
        }
        
    }
    return nil;
}
@end
