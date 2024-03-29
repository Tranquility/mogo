//
//  AppointmentViewController.m
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppointmentViewController.h"
#import "AppointmentModel.h"
#import "DoctorModel.h"
#import "AFNetworking.h"
#import "ApiClient.h"
#import "CredentialStore.h"
#import "UserDefaultConstants.h"
#import "MakeAppointmentViewController.h"
#import "AppointmentDetailViewController.h"

@interface AppointmentViewController ()

@property (nonatomic) DoctorModel *selectedDoctor;
@property (nonatomic) AppointmentModel *selectedAppointment;
@property (nonatomic) CredentialStore *credentialStore;

@end

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchFavouriteDoctorIds];
    [self fetchDoctorList];
    
    [self buttonVisible];
    self.credentialStore = [[CredentialStore alloc] init];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchFavouriteDoctorIds];
    [self fetchAppointments];                     
    [self.editFavoriteButton setTitle: @"Favoriten bearbeiten" forState: UIControlStateNormal];

    [self buttonVisible];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [NSKeyedArchiver archiveRootObject: self.favouriteDoctorIDList toFile: self.saveFilePath];
}

- (void)viewDidUnload
{
    
    [self setEditFavoriteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)fetchDoctorList
{
    self.doctorList = [[NSMutableArray alloc] init];
    
    [SVProgressHUD show];
    
    [[ApiClient sharedInstance] getPath:@"doctors.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    for (id doctorJson in response) {
                                        DoctorModel *doctorModel = [[DoctorModel alloc] initWithDictionary:doctorJson];
                                        [self.doctorList addObject:doctorModel];
                                    }
                                    
                                    [SVProgressHUD dismiss];
                                    [self.appointmentsTableView reloadData];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error fetching docs!");
                                    NSLog(@"%@", error);
                                    
                                }];
}

- (void)fetchFavouriteDoctorIds
{
    //Retrieve the Favourite-Doctor List
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
}

- (void)fetchAppointments
{
    self.appointmentList = [[NSMutableArray alloc] init];

    [SVProgressHUD showWithStatus:NSLocalizedString(@"Lade Termine", @"LOAD_APPOINTMENTS")];
    [[ApiClient sharedInstance] getPath:@"appointments.json"
                             parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    for (NSDictionary *dict in response) {
                                        AppointmentModel *appointment = [[AppointmentModel alloc] initWithDictionary:dict];
                                        [self.appointmentList addObject:appointment];
                                    }
                                    [SVProgressHUD dismiss];
                                    
                                    [self.appointmentsTableView reloadData];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Verbindungsfehler", @"CONNECTION_FAIL")];                                    
                                }];
    
}

//Creates the FilePath for the Favourite-List
- (NSString *) saveFilePath
{
	NSArray *path =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"data.archive"];
    
}

-(DoctorModel*) getDoctorById:(NSString*)doctorId
{
    //For all Doctors, find the one with the given ID...
    for (NSInteger i = 0; i < self.doctorList.count; i++)
    {
        DoctorModel* doctor = [self.doctorList objectAtIndex:i];
        if ([[NSString stringWithFormat:@"%d",doctor.idNumber] isEqualToString:doctorId])
        {
            return doctor;
        }
        
    }
    return nil;
}

#pragma mark TableView Delegate and DataSource

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        //If there are no appointments, we show the static entry
        if(self.appointmentList.count==0)
        {
            return 1;
        }
        else{
            return self.appointmentList.count;
        }
        
    } else {
        //We need to be careful here, because the doctorList gets loaded asynchronously, and it could not be loaded yet
        //resuting in a null reference when updating the tableViewController
        if (self.doctorList.count>0)
        {
            //Always add one, because we have a static entry "Doktor suchen"
            return self.favouriteDoctorIDList.count+1;
        } else {
            return 1;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we only want our recently used doctors to be editable, but not the first entry
    return  indexPath.section == 1 && indexPath.row != 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)makeAppointmentCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"viewcell1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell according to the Appointment-Datamodel-Object
    AppointmentModel *appointment = [self.appointmentList objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NSLocalizedString(@"dd.MM. 'um' HH:mm", "DATE_FORMAT")];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", appointment.doctor.title, appointment.doctor.firstName,appointment.doctor.lastName];
    
     //Update the detailText label
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)",[dateFormatter stringFromDate:appointment.date],appointment.doctor.discipline];
    
    //This activates the small arrow to indicate that you can click on it
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (UITableViewCell *)makeDoctorCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"viewcell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = NSLocalizedString(@"+ neuen Arzt suchen", @"SEARCH_NEW_DOCTOR");
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        //Offset the array index by -1 because of the first static entry ("Arzt suchen")
        NSString *doctorID = [self.favouriteDoctorIDList objectAtIndex:[indexPath row]-1];
        DoctorModel* doctorModel = [self getDoctorById:doctorID];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", doctorModel.title, doctorModel.firstName,doctorModel.lastName];
        cell.detailTextLabel.text = doctorModel.discipline;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Show the Appointments
    if (indexPath.section == 0)
    {
        //If we have no appointments: show the static entry
        if(self.appointmentList.count==0)
        {
            NSString *cellIdentifier = @"staticCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            }
            cell.textLabel.text = @"Keine Termine vorhanden";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone; 
            return cell;
        }
        else{
            return [self makeAppointmentCell:tableView indexPath:indexPath];
        }
    }
    else //Show the Doctors
    {
        return [self makeDoctorCell:tableView indexPath:indexPath];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        return NSLocalizedString(@"Kommende Termine", @"UPCOMING_APPOINTMENTS");
    }
    else
    {
        return NSLocalizedString(@"Neuen Termin buchen bei", @"NEW_APPOINTMENT");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //CHeck for Login
    if([self.credentialStore isLoggedIn])
    {
        //Additionally, we need to have our profile filled out
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults boolForKey:UD_USER_DATA_COMPLETE])
        {
            [self performAction:indexPath tableView:tableView];
        }
        else{
            UIAlertView *redirect = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profil nicht ausreichend ausgefüllt", @"UNCOMPLETE_PROFILE")
                                                               message:NSLocalizedString(@"Möchten Sie zu den Einstellungen weitergeleitet werden?", @"REDIRECT_SETTINGS")
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                                     otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];
            
            [redirect show];
        }
        [self.appointmentsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        //Ask user to be redirected to Login
        UIAlertView *logout = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nur mit Anmeldung Möglich", @"ONLY_LOGGEDIN")
                                                         message:NSLocalizedString(@"Möchten Sie zur Anmeldung weitergeleitet werden?", @"REDIRECT_LOGIN")
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                               otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];
        
        [logout show];
        [self.appointmentsTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([alertView.title isEqualToString:NSLocalizedString(@"Profil nicht ausreichend ausgefüllt", @"UNCOMPLETE_PROFILE")])
    {
        if (buttonIndex == 1) {
            [self performSegueWithIdentifier:@"ToSettings" sender:self];
        }
    }
    else{
        if (buttonIndex == 1) {
            [self performSegueWithIdentifier:@"ToLogin" sender:self];
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performAction:indexPath tableView:tableView];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *doctorId = [self.favouriteDoctorIDList objectAtIndex:indexPath.row - 1];
                
        [self.favouriteDoctorIDList removeObject:doctorId];
        [NSKeyedArchiver archiveRootObject: self.favouriteDoctorIDList toFile: self.saveFilePath];
        //Show a notification
        UIAlertView *removeNotification = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Entfernt", @"REMOVED")
                                                                     message:NSLocalizedString(@"Arzt aus den Favoriten entfernt", @"REMOVE_DOCTOR_FROM_FAV")
                                                                    delegate:nil cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
        [removeNotification show];
        if(self.favouriteDoctorIDList.count < 1)
        {
            self.appointmentsTableView.editing = NO;
        }
    }
    //updating view
    [self viewDidLoad];
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"Favorit entfernen", @"REMOVE_FAVORIT");
}

//Helper: Performs the action (show appointment detail or make appointment) when the tableCell or the disclosure Button is pressed
- (void)performAction:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    if (indexPath.section == 0)
    {
        //Only respond if the clicked cell is not the static cell (= we have appointments)
        if(self.appointmentList.count!=0)
        {
            //Get the appointment that has been clicked
            self.selectedAppointment = [self.appointmentList objectAtIndex:indexPath.row];
        
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self performSegueWithIdentifier:@"toAppointmentDetail" sender:self];
        }
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
            NSString *doctorId = [self.favouriteDoctorIDList objectAtIndex:indexPath.row - 1];
            self.selectedDoctor = [self getDoctorById:doctorId];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self performSegueWithIdentifier:@"toMakeAppointment" sender:self];
        }
    }
}

//moving the cells

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.section == 0)
        return NO;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if(destinationIndexPath.row < [self.favouriteDoctorIDList count])
    {
        NSString *stringToMove = [self.favouriteDoctorIDList objectAtIndex:sourceIndexPath.row - 1];
       //replace dragged row with target row
        [self.favouriteDoctorIDList removeObject:stringToMove];
        [self.favouriteDoctorIDList insertObject:stringToMove atIndex:destinationIndexPath.row - 1];

        [NSKeyedArchiver archiveRootObject: self.favouriteDoctorIDList toFile: self.saveFilePath];
        
    }

}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    }
    else {
        return proposedDestinationIndexPath;
    }
}





#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMakeAppointment"]) {
        MakeAppointmentViewController *destination = [segue destinationViewController];
        
        //Set the doctor reference for the upcoming View
        destination.doctor = self.selectedDoctor;
    } else if ([segue.identifier isEqualToString:@"toAppointmentDetail"]) {
        AppointmentDetailViewController *destination = [segue destinationViewController];
        destination.appointment = self.selectedAppointment;
    }
}

 
- (IBAction)editFavorites:(id)sender {
    if(!self.appointmentsTableView.editing)
    {
        [self.editFavoriteButton setTitle: @"Änderungen speichern" forState: UIControlStateNormal];
        [self.appointmentsTableView setEditing:YES animated:YES];
    }
    else
    {
        [self.editFavoriteButton setTitle: @"Favoriten bearbeiten" forState: UIControlStateNormal];
        [self.appointmentsTableView setEditing:NO animated:YES];
    }

}

-(void)buttonVisible
{
    if([self.favouriteDoctorIDList count] < 1)
    {
        self.editFavoriteButton.hidden = YES;
    }
    else
    {
        self.editFavoriteButton.hidden = NO;
    }
}
@end
