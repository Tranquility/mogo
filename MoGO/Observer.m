//
//  Observer.m
//  MoGO
//
//  Created by Andreas Holtz on 30.12.12.
//
//

#import "Observer.h"

@interface Observer ()

@end

@implementation Observer

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notifyFromSender:(Listeners)sender withValue:(id)value {
    
}

@end
