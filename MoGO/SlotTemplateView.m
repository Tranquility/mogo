//
//  SlotTemplateView.m
//  MoGO
//
//  Created by 0eisenbl on 12.12.12.
//
//

#import "SlotTemplateView.h"

@implementation SlotTemplateView

- (id)initWithFrame:(CGRect)frame startTime:(Time*)time parent:(MakeAppointmentViewController*)parentVC;

{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.myParentVC = parentVC;

        //Load the nib-File and set this object as owner
        [[NSBundle mainBundle] loadNibNamed:@"SlotTemplateView" owner:self options:nil];
        
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
    //Slot has been clicked: This will call the saveNewAppointment:sender method in
    //MakeAppointmentViewController. Sender is set to this Objects reference, so we can access properties at the callee
    [self.myParentVC saveNewAppointment:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
