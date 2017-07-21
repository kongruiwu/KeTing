//
//  RMIAPHelper.h
//  BookCat
//
//  Created by rm-imac on 14-4-18.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>

@class RMIAPHelper;
@protocol RMIAPHelperDelegate <NSObject>

//购买
- (void)requestProduct:(RMIAPHelper*)sender start:(SKProductsRequest*)request;
- (void)requestProduct:(RMIAPHelper*)sender received:(SKProductsRequest*)request;

- (void)paymentRequest:(RMIAPHelper*)sender start:(SKPayment*)payment;
- (void)paymentRequest:(RMIAPHelper*)sender purchased:(SKPaymentTransaction*)transaction money:(NSString *)rechargeMoney;
- (void)paymentRequest:(RMIAPHelper*)sender restored:(SKPaymentTransaction*)transaction;
- (void)paymentRequest:(RMIAPHelper*)sender failed:(SKPaymentTransaction*)transaction;

//恢复
- (BOOL)restoredArray:(RMIAPHelper*)sender withArray:(NSArray*)productsIdArray;

//不支持内购
- (void)iapNotSupported:(RMIAPHelper*)sender;
@end


@interface RMIAPHelper : NSObject

+ (RMIAPHelper*)sharedInstance;

@property(nonatomic,assign) id<RMIAPHelperDelegate> delegate;

- (void)setup;
- (void)destroy;
- (void)buy:(NSString*)productId;
- (void)restore;

//发送finish
- (void)finishWithWithTransation:(SKPaymentTransaction*)transaction;
@end
