//
//  DoctorModel.h
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@interface DoctorModel : NSObject

@property (nonatomic) int id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *discipline;
@property (nonatomic,strong) NSString *street;
@property (nonatomic) int zipcode;
@property (nonatomic,strong) NSString *city;
@property (nonatomic) CLLocationCoordinate2D *coordinate;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *fax;
@property (nonatomic,strong) NSMutableArray *openinghours;

- (DoctorModel*)initWithId:(int)id andName:(NSString*)name andDiscipline:(NSString*)discipline andStreet:(NSString*)street andZipcode:(int)zipcode andCity:(NSString*)city andCoordinate:(CLLocationCoordinate2D*)coordinate andPhone:(NSString*)phone andFax:(NSString*)fax andOpeninghours:(NSMutableArray*)openinghours;

- (DoctorModel*)initWithId:(int)id andName:(NSString*)name andDiscipline:(NSString*)discipline;
@end
