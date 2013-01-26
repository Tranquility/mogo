//
//  DocumentViewController.m
//  MoGO
//
//  Created by 0leschen on 05.12.12.
//
//

#import "DocumentViewController.h"
#import "PrescriptionModel.h"
#import "DrugDetailViewController.h"
#import "ApiClient.h"
#import "ReferralModel.h"
#import "ReferralDetailViewController.h"

@interface DocumentViewController ()

@property (nonatomic) PrescriptionModel *selectedPrescription;
@property (nonatomic) ReferralModel *selectedReferral;
@property (nonatomic, copy) NSArray *referralList;
@property (nonatomic, copy) NSArray *prescriptionList;
@property (nonatomic, copy) NSArray *recordList;



@end

@implementation DocumentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.prescriptionList = [[NSArray alloc] init];
        self.referralList = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchDocuments];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDocuments {
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Lade Dokumente", @"LOAD_DOCUMENTS")];
    
    [[ApiClient sharedInstance] getPath:@"mailings.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    NSArray* prescriptions = [response valueForKeyPath:@"Prescription"];
                                    if (prescriptions != nil) {
                                        [self fetchPrescriptions:prescriptions];
                                    }
                                    
                                    NSArray *referrals = [response valueForKeyPath:@"Referral"];
                                    if (referrals != nil) {
                                        [self fetchReferrals:referrals];
                                    }
                                    [SVProgressHUD dismiss];
                                    [self.tableView reloadData];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Verbindungsfehler", @"CONNECTION_FAIL")];
                                }];
    
}

- (void)fetchPrescriptions:(NSArray*)prescriptionsJson {
    NSMutableArray *prescriptionArray = [[NSMutableArray alloc] init];
    for (NSDictionary* dict in prescriptionsJson) {
        PrescriptionModel *prescription = [[PrescriptionModel alloc] initWithDictionary:dict];
        [prescriptionArray addObject:prescription];
    }
    self.prescriptionList = prescriptionArray;
}

- (void)fetchReferrals:(NSArray*)referralsJson {
    NSMutableArray *referralArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in referralsJson) {
        ReferralModel *referral = [[ReferralModel alloc] initWithDictionary:dict];
        [referralArray addObject:referral];
    }
    self.referralList = referralArray;
}

#pragma mark TableViewDelegate/Datasource methods

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return self.prescriptionList.count;
    }
    
    if (section == 1)
    {
        return self.referralList.count;
    }
    
    if (section == 2)
    {
        return self.recordList.count;
    }
    return 0;
}

#pragma mark TableViewDelegate/DataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        NSString *cellIdentifier = @"drugcell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        PrescriptionModel *prescription = [self.prescriptionList objectAtIndex:indexPath.row];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:NSLocalizedString(@"dd.MM.yyyy", @"DAY_FORMAT")];
        NSString *date = [dateFormatter stringFromDate:prescription.creationDate];
        
        NSString *doctorName = [prescription.doctor fullName];
        
        // Configure the cell.
        cell.textLabel.text = prescription.medication;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", date, doctorName];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        return cell;
    }
    
    if (indexPath.section == 1)
    {
        NSString *cellIdentifier = @"transfercell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        // Configure the cell.
        ReferralModel *referral = [self.referralList objectAtIndex:indexPath.row];
        cell.textLabel.text = referral.target;
        cell.detailTextLabel.text = referral.reasonString;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
       
        return cell;
    }
    
    if (indexPath.section == 2)
    {
        NSString *cellIdentifier = @"recordcell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        // Configure the cell.
        cell.textLabel.text = [self.recordList objectAtIndex:[indexPath row]];
        cell.detailTextLabel.text = @"1.1.89";
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        self.selectedPrescription = [self.prescriptionList objectAtIndex:indexPath.row];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"toDrugDetail" sender:self];
    } else if (indexPath.section == 1) {
        self.selectedReferral = [self.referralList objectAtIndex:indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"toReferralDetail" sender:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0)
    {
        return NSLocalizedString(@"Rezepte", @"PRESCRIPTIONS");
    }
    if (section == 1)
    {
        return NSLocalizedString(@"Überweisungen", @"REFERRALS");
    }
    if (section == 2)
    {
        return NSLocalizedString(@"Patientakte", @"PATIENT_FILE");
    }
    return nil;
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDrugDetail"]) {
        DrugDetailViewController *destination = [segue destinationViewController];
        destination.prescription = self.selectedPrescription;
    } else if ([[segue identifier] isEqualToString:@"toReferralDetail"]) {
        ReferralDetailViewController *destination = [segue destinationViewController];
        destination.referral = self.selectedReferral;
    }
}


@end
