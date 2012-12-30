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
        
        //Date formatter for a single day
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH";
        NSInteger hour = [[formatter stringFromDate:date] integerValue];
        
        //extract the minute of the date
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

-(void)saveNewAppointment:(id)sender
{
    [self.observer notifyFromSender:slotTemplate withValue:self.dateForAppointment];
}

@end
