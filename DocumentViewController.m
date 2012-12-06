//
//  DocumentViewController.m
//  MoGO
//
//  Created by 0leschen on 05.12.12.
//
//

#import "DocumentViewController.h"
#import "DocumentTableViewCell.h"

@interface DocumentViewController ()

@end

@implementation DocumentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.drugList = @[@"HNO", @"Pillen"];
    self.transferList = @[@"Dr.Scrum", @"Dr.Master"];
    self.recordList = @[@"Patient X"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return self.drugList.count;
    }
    
    if (section == 1)
    {
        return self.transferList.count;
    }
    
    if (section == 2)
    {
        return self.recordList.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        NSString *cellIdentifier = @"drugcell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        // Configure the cell.
        cell.textLabel.text = [self.drugList objectAtIndex:[indexPath row]];
        cell.detailTextLabel.text = @"4.12.12";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
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
        cell.textLabel.text = [self.transferList objectAtIndex:[indexPath row]];
        cell.detailTextLabel.text = @"1.12.12";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"toDrugDetail" sender:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0)
    {
        return @"Rezepte";
    }
    if (section == 1)
    {
        return @"Überweisungen";
    }
    if (section == 2)
    {
        return @"Patientakte";
    }
}


@end
