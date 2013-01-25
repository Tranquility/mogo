//
//  ViewController.m
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "CredentialStore.h"
@interface ViewController ()
 @property (nonatomic) CredentialStore *credentialStore;
@end

@implementation ViewController
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.checkinButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.checkinButton.titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;

    [self.checkinButton setTitle:NSLocalizedString(@"Praxis betreten", @"CHECKIN") forState:UIControlStateNormal];
    
    self.credentialStore = [[CredentialStore alloc] init];
    
    if ([self.credentialStore isLoggedIn]) {
        NSLog(@"User is already Logged in");
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButton:)];
    }else {
        NSLog(@"User is not Logged in");
        [self performSegueWithIdentifier:@"mainToLogin" sender:self];
    }
    
}

- (IBAction)logoutButton:(id)sender {
    UIAlertView *logout = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bitte bestätigen", @"PLEASE_COMFIRM")
                                                                message:NSLocalizedString(@"Möchten sie sich wirklich abmelden?", @"LOGOUT_PATIENT")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                                      otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];
    [logout show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.credentialStore isLoggedIn]) {
        NSLog(@"User is already Logged in");
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButton:)];
    }else {
        NSLog(@"User is not Logged in");
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark UIAlertViewDelegage methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.credentialStore clearSavedCredentials];
        [self performSegueWithIdentifier:@"mainToLogin" sender:self];
    }
}
@end
