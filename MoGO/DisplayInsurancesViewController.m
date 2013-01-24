//
//  DisplayInsurancesViewController.m
//  MoGO
//
//  Created by 0weislow on 24.01.13.
//
//

#import "DisplayInsurancesViewController.h"
#import "UserDefaultConstants.h"

@interface DisplayInsurancesViewController ()
@property (nonatomic) NSArray *insuranceList;

@end

@implementation DisplayInsurancesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initInsurances];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.insuranceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"standard";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.insuranceList objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString* selectedInsurance = [self.insuranceList objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:selectedInsurance forKey:UD_USER_INSURANCE];

    [self.navigationController popViewControllerAnimated:YES];
}

-(void) initInsurances
{
        NSArray *insuranceList = @[
        @"Allianz",
        @"AOK",
        @"ARAG",
        @"BKK",
        @"Deutscher Ring",
        @"Gothaer",
        @"Huk-Coburg",
        @"IKK",
        @"LKK",
        @"Münchener Verein",
        @"Pax Familienfürsorge",
        @"Provinzial",
        @"Württembergische",
        @"Keine Versicherung"
        ];
    
    self.insuranceList = [[NSArray alloc] initWithArray:insuranceList];
}

- (void)viewDidUnload {
    [self setInsuranceTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UIPickerViewDataSource/Delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}





@end
