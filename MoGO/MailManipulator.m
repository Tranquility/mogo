//
//  MailManipulator.m
//  MoGO
////
//

#import "MailManipulator.h"

@implementation MailManipulator

- (BOOL)isMailFormatValid:(NSString*)mail {
    return [mail rangeOfString:@"^.+@.+\\..{2,}$" options:NSRegularExpressionSearch].location != NSNotFound;
}

//Function to generate mails, if required
//TODO: Delete if not required for project
- (void)sendMailToAddress:(NSString*)address withContent:(NSString*)mailContent {
    
}

@end
