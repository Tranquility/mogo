//
//  MailManipulator.m
//  MoGO
//
//  Created by DW on 04.12.12.
//
//

#import "MailManipulator.h"

@implementation MailManipulator

-(BOOL) isMailFormatValid : (NSString*) theMailToTest
{
    //more detailed filter could be built though
    return [theMailToTest rangeOfString:@"^.+@.+\\..{2,}$" options:NSRegularExpressionSearch].location != NSNotFound;
}


//Function to generate mails, if required
//TODO: Delete if not required for project
-(void) sendMailToAdressee : (NSString*) theAdressee withContent: (NSString*) mailContent
{

}





@end
