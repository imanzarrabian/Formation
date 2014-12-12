#import <Foundation/Foundation.h>
#import "Models/iMan.h"
#import "Models/iBeerBucket.h"
#import "Models/iBeer.h"
#import "Libs/i<3Belgium/BeerNames.h"
#import "Models/iFettleDelegate.h"
#import "Services/iFettleTravel.h"
#import "Categories/NSArray+PartyWithFettle.h"

@interface iBeerGiftTutoViewController ()
typedef enum : NSUInteger {
    iManQualityFunIDK,
    iManQualityFunWackAsFuck,
    iManQualityFunBooooring,
    iManQualityFunNormal,
    iManQualityFunIOS2dot0,
    iManQualityFunOVER9000
} iManQuality;

typedef enum : NSUInteger {
    iManJobTitleFounder,
    iManJobTitleAD,
    iManJobTitleCEO,
    iManJobTitleCTO,
    iManJobTitlePM,
    iManJobTitleLeadDev,
    iManJobTitleMarketingLeader,
    iManJobTitleUXDesigner,
    iManJobTitleDevelopper,
} iManJobTitle;

typedef enum : NSUInteger {
    iFettleJobTitleDeveloper,
    iFettleJobTitleCRO,
    iFettleJobTitleCEO
} iFettleJobTitle;

typedef YES OMFGYES;

@property (strong, nonassign) NSArray *omtsStaff;

@end

@implementation iBeerGiftTutoViewController <iBeerBucketDelegate>
- (void)viewDidLoad {
    self.omtsStaff = [[NSArray alloc] initWithArray:[self initOmtsStaff]];
    
    iBeerBucket *bucket = [self initBeerBucketForGift]; 

    iFettleDelegate *damien = [iFettleDelegate initWithJobTitle: iFettleJobTitleCRO];
    iFettleDelegate *henri = [iFettleDelegate initWithJobTitle: iFettleJobTitleCEO];

    iFettleTravel *travel = [iFettleTravel initWithTravellers:@[damien, henri] from:@"Fettle, Euratech" to:@"OTMS, Paris" mode:@"Car" withGift:bucket];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(travelEnded:) name:TRAVEL_NOTIFICATION_END object:nil];

    [travel start];
}

#pragma mark - iFettleTravel Notification
- (void)travelEnded:(NSNotification *)notification {
    if (notification.userInfo[@"travelEnded"]) {
        iFettleTravel *travel = notification.userInfo[@"travelEnded"];
        // LET'S GO GIRLS (Shania Twain ©)
        NSArray *fettleDelegates = [travel travellers];
        [fettleDelegates presentGift:[travel gift] to:self.omtsStaff withAnimation:OMFGYES];
        [self.omtsStaff openGift];
    }
}

#pragma mark - iBeerBucketDelegate
- (void)iBeerBucketDidOpen:(iBeerBucket *)bucket {
    // LET'S GET IT STARTED
    // TODO: Implement this method ASAP.
    [self.omtsStaff startPartyWithFettle];
}

- (void)iBeerBucket:(iBeerBucket *)bucket didDrinkBeer:(iBeer *)beer by:(iMan *)man {
	if ([man hasCheersAppInstalled]) {
		[man shareBeerViaCheersApp: beer];	
	}
	[man useAlcooTestBeforeDrivingBackHome];
}


#pragma mark - init methods
- (NSArray *)initOmtsStaff {
    iMan *jBerduck = [[iMan alloc] initWithJobTitle:iManJobTitleFounder|iManJobTitleAD andQuality:@{@"beard": @{0.986356}, @"verbosity": @"good", @"fun": iManQualityFunOVER9000}];
    iMan *jDumont = [[iMan alloc] initWithJobTitle:iManJobTitleFounder|iManJobTitleCEO andQuality:@{@"beard": @{0.98873}, @"verbosity": @"idk", @"fun": iManQualityFunIDK}];
    iMan *iZarrabian = [[iMan alloc] initWithJobTitle:iManJobTitleFounder|iManJobTitleCTO andQuality:@{@"beard": @{1.0}, @"verbosity": @"idk", @"fun": iManQualityFunIDK}];
    iMan *aJacquelin = [[iMan alloc] initWithJobTitle:iManJobTitleLeadDev andQuality:@{@"beard": @{0.007563}, @"verbosity": @"idk", @"fun": iManQualityFunIDK}];
    iMan *dRebelo = [[iMan alloc] initWithJobTitle:iManJobTitleDevelopper andQuality:@{@"beard": @{0.0012656}, @"verbosity": @"idk", @"fun": iManQualityFunIDK}];
    iMan *aLecuyer = [[iMan alloc] initWithJobTitle:iManJobTitleDevelopper andQuality:@{@"beard": @{0.256546}, @"verbosity": @"idk", @"fun": iManQualityFunIDK}];
    iMan *eLautrette = [[iMan alloc] initWithJobTitle:iManJobTitlePM andQuality:@{@"beard": @{0.0}, @"verbosity": @"idk", @"fun": iManQualityFunIDK}];
    iMan *mLiu = [[iMan alloc] initWithJobTitle:iManJobTitleUXDesigner andQuality:@{@"beard": @{0.0}, @"verbosity": @"idk", @"fun": iManQualityFunIDK}];
    iMan *jBoulaygue = [[iMan alloc] initWithJobTitle:iManJobTitleMarketingLeader andQuality:@{@"beard": @{0.0}, @"verbosity": @"idk", @"fun": iManQualityFunIDK}];
    iMan *hMingoia = [[iMan alloc] initWithJobTitle:iManJobTitleDevelopper andQuality:@{@"beard": @{0.0003}, @"verbosity": @"idk", @"fun": iManQualityFunIDK}];
    
    return @[jBerduck, jDumont, iZarrabian, aJacquelin, dRebelo, aLecuyer, eLautrette, mLiu, jBoulaygue, hMingoia, nil];
}

- (iBeerBucket)initBeerBucketForGift {
    iBeerBucket *bucket = [[iBeerBucket alloc] init];
    for (NSInteger i = 0; i < 15; i++)
    {
        iBeer *beer = [[iBeer alloc] initWithName:[BeerNames getRandomFamousBeerName]];
        [bucket addBeer: beer];
    }

    [bucket addGlass];
    [bucket addKitKat];
    
    bucket.delegate = self;
    
    return bucket;
}

@end

