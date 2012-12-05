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
    self.drugList = [[NSArray alloc] initWithObjects:@"HNO", @"Pillen", nil];
    self.transferList = [[NSArray alloc] initWithObjects:@"Dr.Scrum", @"Dr.Master", nil];
    self.recordList =[[NSArray alloc]initWithObjects:@"Patient X", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSString *cellIdentifier = @"viewcell1";
        
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
        NSString *cellIdentifier = @"viewcell2";
        
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
        NSString *cellIdentifier = @"viewcell3";
        
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
