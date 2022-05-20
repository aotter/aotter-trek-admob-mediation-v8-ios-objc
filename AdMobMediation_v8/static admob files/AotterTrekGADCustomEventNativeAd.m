//
//  TrekGADCustomEventNativeAd.m
//  GoogleMediation
//
//  Created by JustinTsou on 2020/12/11.
//

#import "AotterTrekGADCustomEventNativeAd.h"
#import "AotterTrekGADMediatedNativeAd.h"
#import "AotterTrekGADMediatedSuprAd.h"
#import <GoogleMobileAds/Mediation/GADMediationAdapter.h>


#if AotterServiceTestRunning
    #import "TKAdNative.h"
    #import "TKAdSuprAd.h"
#elif AotterServiceTestV8
    #import "TKAdNative.h"
    #import "TKAdSuprAd.h"
#else
    #import <AotterTrek-iOS-SDK/AotterTrek-iOS-SDK.h>
#endif

static NSString *const customEventErrorDomain = @"com.aotter.AotterTrek.GADCustomEvent";
/*
@interface AotterTrekGADCustomEventNativeAd() {
    NSString *_adType;
    NSString *_adPlace;
    NSError *_jsonError;
    NSString *_errorDescription;
    NSDictionary *_jsonDic;
    TKAdSuprAd *_suprAd;
    TKAdNative *_adNatve;
    NSMutableDictionary *_requeatMeta;
}

@property NSString *contentTitle;
@property NSString *contentUrl;
@end

@implementation AotterTrekGADCustomEventNativeAd

@synthesize delegate;

- (void)requestNativeAdWithParameter:(NSString *)serverParameter request:(GADCustomEventRequest *)request adTypes:(NSArray *)adTypes options:(NSArray *)options rootViewController:(UIViewController *)rootViewController {
    
    NSString *category = @"";
    if ([[request.additionalParameters allKeys]containsObject:@"category"]) {
        category = request.additionalParameters[@"category"];
    }
    if([[request.additionalParameters allKeys] containsObject:@"contentTitle"]){
        NSString *_title = request.additionalParameters[@"contentTitle"];
        if([_title isKindOfClass:[NSString class]]){
            self.contentTitle = _title;
        }
    }
    if([[request.additionalParameters allKeys] containsObject:@"contentUrl"]){
        NSString *_url = request.additionalParameters[@"contentUrl"];
        if([_url isKindOfClass:[NSString class]]){
            self.contentUrl = _url;
        }
    }
    
    // update sdk need to update mediationVersion and mediationVersionCode
    _requeatMeta = [[NSMutableDictionary alloc]initWithDictionary:@{@"mediationVersionCode":[NSNumber numberWithInt:1],@"mediationVersion":@"AdMob_1.0.6"}];

    
    // Parse serverParameter
    
    if (serverParameter != nil && ![serverParameter isEqual: @""]) {
        NSData *data = [serverParameter dataUsingEncoding:NSUTF8StringEncoding];
        _jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
    }else {
        _errorDescription = @"You must add AotterTrek adType in Google AdMob CustomEvent protal.";
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : _errorDescription,
                                   NSLocalizedFailureReasonErrorKey : _errorDescription};
        
        NSError *error = [NSError errorWithDomain:customEventErrorDomain
                                             code:0
                                         userInfo:userInfo];
        
        [self.delegate customEventNativeAd:self didFailToLoadWithError:error];
        return;
    }
    
    if ([[_jsonDic allKeys] containsObject:@"adType"] && [[_jsonDic allKeys] containsObject:@"adPlace"] ) {
        //will be deprecated
        _adType = [_jsonDic objectForKey:@"adType"];
        _adPlace = [_jsonDic objectForKey:@"adPlace"];
        
        if ([_adType isEqualToString:@"nativeAd"]) {
            [self fetchTKAdNativeWithAdPlace:_adPlace category:category];
        }else if ([_adType isEqualToString:@"suprAd"]) {
            [self fetchTKSuprAdWithAdPlace:_adPlace category:category WithRootViewController:rootViewController];
        }
    }
    else if ([[_jsonDic allKeys] containsObject:@"clientId"] && [[_jsonDic allKeys] containsObject:@"placeUid"] ) {
        
        //WIP..
        _adPlace = [_jsonDic objectForKey:@"placeUid"];
        
        [self fetchTKAdNativeWithAdPlace:_adPlace category:category];
    
    }
}

- (BOOL)handlesUserClicks {
    return YES;
}


- (BOOL)handlesUserImpressions {
    return YES;
}

#pragma mark - Life cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Method

- (void)fetchTKAdNativeWithAdPlace:(NSString *)adPlace category:(NSString *)category {
    
    if (_adNatve != nil) {
        [_adNatve destroy];
    }
    
    _adNatve = [[TKAdNative alloc] initWithPlace:_adPlace category:category];
    _adNatve.requestMeta = _requeatMeta;
    if(self.contentTitle){
        if([_adNatve respondsToSelector:@selector(setAdContentTitle:)]){
            [_adNatve performSelector:@selector(setAdContentUrl:) withObject:self.contentUrl];
        }
    }
    if(self.contentUrl){
        if([_adNatve respondsToSelector:@selector(setAdContentUrl:)]){
            [_adNatve performSelector:@selector(setAdContentUrl:) withObject:self.contentUrl];
        }
    }
    
    [_adNatve fetchAdWithCallback:^(NSDictionary *adData, TKAdError *adError) {
        if(adError){
            NSLog(@"[AotterTrek-iOS-SDK: adMob mediation] TKAdNative fetched Ad error: %@", adError.message);
           
            self->_errorDescription = adError.message;
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : self->_errorDescription, NSLocalizedFailureReasonErrorKey : self->_errorDescription};
            NSError *err = [NSError errorWithDomain:customEventErrorDomain code:0 userInfo:userInfo];
            
            [self.delegate customEventNativeAd:self didFailToLoadWithError:err];
        }
        else{
            NSLog(@"[AotterTrek-iOS-SDK: adMob mediation] TKAdNative fetched Ad");
            
            AotterTrekGADMediatedNativeAd *mediatedAd = [[AotterTrekGADMediatedNativeAd alloc] initWithTKNativeAd:self->_adNatve withAdPlace:adPlace];
            
            [self.delegate customEventNativeAd:self didReceiveMediatedUnifiedNativeAd:mediatedAd];
        }
    }];
}

- (void)fetchTKSuprAdWithAdPlace:(NSString *)adPlace category:(NSString *)category WithRootViewController:(UIViewController *)rootViewController {
    
    if (_suprAd != nil) {
        [_suprAd destroy];
    }
    
    _suprAd = [[TKAdSuprAd alloc] initWithPlace:adPlace category:category];
    _suprAd.requestMeta = _requeatMeta;
    if(self.contentTitle){
        if([_suprAd respondsToSelector:@selector(setAdContentTitle:)]){
            [_suprAd performSelector:@selector(setAdContentTitle:) withObject:self.contentTitle];
        }
    }
    if(self.contentUrl){
        if([_suprAd respondsToSelector:@selector(setAdContentUrl:)]){
            [_suprAd performSelector:@selector(setAdContentUrl:) withObject:self.contentUrl];
        }
    }
    
    [_suprAd registerPresentingViewController:rootViewController];
    
    [_suprAd fetchAdWithCallback:^(NSDictionary *adData, CGSize preferedAdSize, TKAdError *adError, BOOL isVideoAd, void (^loadAd)(void)) {
        
        if(adError){
            NSLog(@"[AotterTrek-iOS-SDK: adMob mediation] TKAdSuprAd fetched Ad error: %@", adError.message);
            NSString *errorDescription = adError.message;
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errorDescription, NSLocalizedFailureReasonErrorKey : errorDescription};
            NSError *err = [NSError errorWithDomain:customEventErrorDomain code:0 userInfo:userInfo];
            
            [self.delegate customEventNativeAd:self didFailToLoadWithError:err];
        }
        else{
            
            NSLog(@"[AotterTrek-iOS-SDK: adMob mediation] TKAdSuprAd fetched Ad");
            
            AotterTrekGADMediatedSuprAd *mediatedAd = [[AotterTrekGADMediatedSuprAd alloc] initWithTKSuprAd:self->_suprAd withAdPlace:adPlace withAdSize:preferedAdSize];

            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(getNotification:)
                                                        name:@"SuprAdScrolled"
                                                      object:nil];
            
            [self.delegate customEventNativeAd:self didReceiveMediatedUnifiedNativeAd:mediatedAd];
        }
    }];
    
}

#pragma mark - PrivateMethod

-(void)getNotification:(NSNotification *)notification{
    if (_suprAd != nil) {
        [_suprAd notifyAdScrolled];
    }
}

@end
 */

#include <stdatomic.h>

@interface AotterTrekGADCustomEventNativeAd()<GADMediationNativeAd> {
    TKAdSuprAd *_suprAd;
    TKAdNative *_adNatve;
    NSError *_jsonError;
    NSString *_errorDescription;
    NSMutableDictionary *_requeatMeta;
    
    GADMediationNativeLoadCompletionHandler _loadCompletionHandler;
    __weak id<GADMediationNativeAdEventDelegate> _deletage;
}
@property NSString *adType;
@property NSString *contentTitle;
@property NSString *contentUrl;
@property NSString *category;
@property NSString *clientId;
@property NSString *placeUid;
@end


@implementation AotterTrekGADCustomEventNativeAd

+ (GADVersionNumber)adSDKVersion {
    GADVersionNumber a;
    a.majorVersion = 1;
    a.minorVersion = 2;
    a.patchVersion = 3;
    return a;
}

+ (GADVersionNumber)adapterVersion {
    GADVersionNumber a;
    a.majorVersion = 1;
    a.minorVersion = 2;
    a.patchVersion = 3;
    return a;
}
+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return [GADCustomEventExtras class];
}

#define ATOMIC_FLAG_INIT { 0 }

-(void)loadNativeAdForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler{
    //TODO: refactor with singleton version handler
    _requeatMeta = [[NSMutableDictionary alloc]initWithDictionary:@{@"mediationVersionCode":[NSNumber numberWithInt:1],@"mediationVersion":@"AdMob_1.0.6"}];
    
    NSLog(@"[AotterTrekGADCustomEventNativeAd] loadNativeAdForAdConfiguration");
    
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationNativeLoadCompletionHandler originalCompletionHandler =
        [completionHandler copy];

    _loadCompletionHandler = ^id<GADMediationNativeAdEventDelegate>(
        _Nullable id<GADMediationNativeAd> ad, NSError *_Nullable error) {
      // Only allow completion handler to be called once.
      if (atomic_flag_test_and_set(&completionHandlerCalled)) {
        return nil;
      }

      id<GADMediationNativeAdEventDelegate> delegate = nil;
      if (originalCompletionHandler) {
        // Call original handler and hold on to its return value.
        delegate = originalCompletionHandler(ad, error);
      }

      // Release reference to handler. Objects retained by the handler will also be released.
      originalCompletionHandler = nil;

      return delegate;
    };
    
    
    self.adType = @"NativeAd";
    
    //try extract clientId & placeUid from credentials.settings
    @try {
        NSString *serverParameter = adConfiguration.credentials.settings[@"parameter"];
        NSData *data = [serverParameter dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if([parameters.allKeys containsObject:@"clientId"]){
            self.clientId = parameters[@"clientId"];
        }
        
        if([parameters.allKeys containsObject:@"placeUid"]){
            self.placeUid = parameters[@"placeUid"];
        }
        
        if([parameters.allKeys containsObject:@"adType"]){
            self.adType = parameters[@"adType"];
        }
    } @catch (NSException *exception) {
        NSLog(@"[AotterTrekGADCustomEventNativeAd] extract info from adConfiguration.credentials.settings failed. exception: %@", exception.description);
    } @finally{
        NSLog(@"[AotterTrekGADCustomEventNativeAd] extracted clientId: %@, placeUid: %@", self.clientId, self.placeUid);
    }
    
    
    if([self.placeUid length] == 0){
        return;
    }
        
    
    //try extract extras from CustomEventExtras
    @try {
        GADCustomEventExtras *extras = adConfiguration.extras;
        NSDictionary *myExtras = [extras extrasForLabel:@"AotterTrekGADCustomEventNativeAd"];
        if([myExtras.allKeys containsObject:@"category"]){
            self.category = myExtras[@"category"];
        }
        if([myExtras.allKeys containsObject:@"contentTitle"]){
            self.contentTitle = myExtras[@"contentTitle"];
        }
        if([myExtras.allKeys containsObject:@"contentUrl"]){
            self.contentUrl = myExtras[@"contentUrl"];
        }
    } @catch (NSException *exception) {
        NSLog(@"[AotterTrekGADCustomEventNativeAd] extract info from adConfiguration.extras failed. exception: %@", exception.description);
    } @finally{
        NSLog(@"[AotterTrekGADCustomEventNativeAd] extracted category: %@, contentTitle: %@, contentUrl: %@", self.category, self.contentTitle, self.contentUrl);
    }
    
    if([self.adType isEqualToString:@"SuprAd"]){
        [self fetchTKSuprAdWithRootViewController:adConfiguration.topViewController];
    }
    else {
        [self fetchTKAdNative];
    }
    
}


- (void)fetchTKAdNative{
    if (_adNatve != nil) {
        [_adNatve destroy];
    }
    
    
    _adNatve = [[TKAdNative alloc] initWithPlace:self.placeUid category:self.category];
    _adNatve.requestMeta = _requeatMeta;
    if(self.contentTitle){
        if([_adNatve respondsToSelector:@selector(setAdContentTitle:)]){
            [_adNatve performSelector:@selector(setAdContentUrl:) withObject:self.contentUrl];
        }
    }
    if(self.contentUrl){
        if([_adNatve respondsToSelector:@selector(setAdContentUrl:)]){
            [_adNatve performSelector:@selector(setAdContentUrl:) withObject:self.contentUrl];
        }
    }
    
    [_adNatve fetchAdWithCallback:^(NSDictionary *adData, TKAdError *adError) {
        if(adError){
            NSLog(@"[AotterTrek-iOS-SDK: adMob mediation] TKAdNative fetched Ad error: %@", adError.message);
           
            self->_errorDescription = adError.message;
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : self->_errorDescription, NSLocalizedFailureReasonErrorKey : self->_errorDescription};
            NSError *err = [NSError errorWithDomain:customEventErrorDomain code:0 userInfo:userInfo];
            
            _deletage = _loadCompletionHandler(nil, err);
        }
        else{
            NSLog(@"[AotterTrek-iOS-SDK: adMob mediation] TKAdNative fetched Ad");
            
            AotterTrekGADMediatedNativeAd *mediatedAd = [[AotterTrekGADMediatedNativeAd alloc] initWithTKNativeAd:self->_adNatve withAdPlace:self.placeUid];
            _deletage = _loadCompletionHandler(mediatedAd, nil);
        }
    }];
}

- (void)fetchTKSuprAdWithRootViewController:(UIViewController *)rootViewController {
    
    if (_suprAd != nil) {
        [_suprAd destroy];
    }
    
    _suprAd = [[TKAdSuprAd alloc] initWithPlace:self.placeUid category:self.category];
    _suprAd.requestMeta = _requeatMeta;
    if(self.contentTitle){
        if([_suprAd respondsToSelector:@selector(setAdContentTitle:)]){
            [_suprAd performSelector:@selector(setAdContentTitle:) withObject:self.contentTitle];
        }
    }
    if(self.contentUrl){
        if([_suprAd respondsToSelector:@selector(setAdContentUrl:)]){
            [_suprAd performSelector:@selector(setAdContentUrl:) withObject:self.contentUrl];
        }
    }
    
    [_suprAd registerPresentingViewController:rootViewController];
    
    [_suprAd fetchAdWithCallback:^(NSDictionary *adData, CGSize preferedAdSize, TKAdError *adError, BOOL isVideoAd, void (^loadAd)(void)) {
        
        if(adError){
            NSLog(@"[AotterTrek-iOS-SDK: adMob mediation] TKAdSuprAd fetched Ad error: %@", adError.message);
            NSString *errorDescription = adError.message;
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errorDescription, NSLocalizedFailureReasonErrorKey : errorDescription};
            NSError *err = [NSError errorWithDomain:customEventErrorDomain code:0 userInfo:userInfo];
            
            _deletage = _loadCompletionHandler(nil, err);
        }
        else{
            
            NSLog(@"[AotterTrek-iOS-SDK: adMob mediation] TKAdSuprAd fetched Ad");
            
            AotterTrekGADMediatedSuprAd *mediatedAd = [[AotterTrekGADMediatedSuprAd alloc] initWithTKSuprAd:self->_suprAd withAdPlace:self.placeUid withAdSize:preferedAdSize];

            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(getNotification:)
                                                        name:@"SuprAdScrolled"
                                                      object:nil];
            
            _deletage = _loadCompletionHandler(mediatedAd, nil);
        }
    }];
    
}

-(void)getNotification:(NSNotification *)notification{
    if (_suprAd != nil) {
        [_suprAd notifyAdScrolled];
    }
}

@end
