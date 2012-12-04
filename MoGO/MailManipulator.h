//
//  MailManipulator.h
//  MoGO
//
//  Created by DW on 04.12.12.
//
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface MailManipulator : NSObject <MFMailComposeViewControllerDelegate>
-(BOOL) isMailFormatValid : (NSString*) theMailToTest;
-(void) sendMailToAdressee : (NSString*) theAdressee withContent: (NSString*) mailContent;



@end
