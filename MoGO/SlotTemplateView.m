//
//  SlotTemplateView.m
//  MoGO
//
//  Created by 0eisenbl on 12.12.12.
//
//

#import "SlotTemplateView.h"

@interface SlotTemplateView ()

@property (nonatomic) NSDate *dateForAppointment;

@end

@implementation SlotTemplateView
- (id)initWithFrame:(CGRect)frame date:(NSDate*)date observer:(Observer*)observer
{
    self = [super initWithFrame:frame];
    if (self) {        
        self.dateForAppointment = date;
        self.observer = observer;

        //Load the nib-File and set this object as owner
        [[NSBundle mainBundle] loadNibNamed:@"SlotTemplateView" owner:self options:nil];
        
        //Extract the time from the NSDate
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH";
        NSInteger hour = [[formatter stringFromDate:date] integerValue];
        
        formatter.dateFormat = @"mm";
        NSInteger minute = [[formatter stringFromDate:date] integerValue];
        Time *time = [[Time alloc] initWithHour:hour andMinute:minute];
        
        self.appointmentLabel.text = [time description];
        
        //Add this view to the mainView, which will later be added to the Calendar-View
        self.clipsToBounds = NO;
        self.mainView.frame = self.bounds;
        [self addSubview:self.mainView];

    }
    return self;
}

- (IBAction)saveNewAppointment:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"'am' dd.MM.yyyy 'um' HH:mm 'Uhr'";
    NSString *dateString = [formatter stringFromDate:self.dateForAppointment];
    NSString *message = [NSString stringWithFormat:@"Wollen Sie %@ verbindlich einen Termin vereinbaren?", dateString];
    
    UIAlertView *confirmAppointment = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bitte bestätigen", @"PLEASE_COMFIRM")
                                                message:NSLocalizedString(message, @"ADD_DOCTOR_TO_FAV")
                                               delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                      otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];

    [confirmAppointment show];
}

#pragma mark UIAlertView Delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.observer notifyFromSender:slotTemplate withValue:self.dateForAppointment];
    }
}

@end
