//
//  DaySlotView.m
//  MoGO
//
//  Created by 0eisenbl on 12.12.12.
//
//

#import "DaySlotView.h"
#import "SlotTemplateView.h"

@implementation DaySlotView

- (id)initWithFrame:(CGRect)frame andDay:(int)startDay andMonth:(int)startMonth andYear:(int)startYear andParentVC:(MakeAppointmentViewController*)myParentVC;
{
    self = [super initWithFrame:frame];
    [[NSBundle mainBundle] loadNibNamed:@"DaySlotView" owner:self options:nil];
    
    //Set ParentVC to enable notifications
    self.myParentVC = myParentVC;
    
    self.mainView.frame = frame;
        
    if (self) {
        
        //TODO: This needs to be connected to the AvailableSlot - Datasource
        //given the parameters day,month,year to determine the number of free slots
        //and initialize/display them
        int numberOfAvailableSlots = 10; //Dummy
        for (int i = 0; i < numberOfAvailableSlots; i++) {
               
                //Each slot width is 320, height 49, with a 1px border between them
                //Y-Offset is set to i*50
                CGRect r = CGRectMake(0, i*50, 320,49);
            
                //TODO: Get start and end Time from DataSource
                NSString* startTime = @"09:30";
                NSString* endTime = @"08:45 Uhr";

                //Draw Slot to SlotView (by adding a sub-view)
                SlotTemplateView *newSlot =[[SlotTemplateView alloc] initWithFrame:r andStartTime:startTime andEndTime:endTime andParentVC:self.myParentVC];
                [self.slotView addSubview:newSlot];
            }

    }
    
    return self;
    
        
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
