//
//  HHMainNetwork.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/17.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHCreditSummaryResponse.h"
#import "HHAdModel.h"
#import "HHInvitedJsonModel.h"
#import "HHInvitedFetchSummaryResponse.h"
#import "HHProductIndoResponse.h"
#import "HHAlipayAccountResponse.h"
#import "HHWeixinAccountResponse.h"
#import "HHOrderResponse.h"
#import "HHIncomDetailResponse.h"
#import "HHProductResponse.h"
#import "HHPurchaseResponse.h"

//0, "全部"
//6, "阅读收益"
//3, "广告收益"
//2, "邀请收益"
//4, "活动收益"
typedef enum : NSUInteger {
    IncomeDetailCategoryAll = 0,
    IncomeDetailCategoryReadIncome = 6,
    IncomeDetailCategoryADIncome = 3,
    IncomeDetailCategoryInvitedIncome = 2,
    IncomeDetailCategoryActiviryIncome = 4,
} IncomeDetailCategory;

@interface HHMineNetwork : NSObject

+ (void)requestCreditSummary:(void(^)(id error, HHUserCreditSummary *summary))callback;

+ (void)requestAds:(void(^)(NSError *error ,NSArray<HHAdModel *> * result))callback;

+ (void)updateNickName:(NSString *)nickName;

+ (void)rebindPhone:(NSString *)phone
         verifyCode:(NSString *)verifyCode
           callback:(void(^)(void))callback;

+ (void)requestInviteJson:(void(^)(id error, HHInvitedJsonModel *model))callback;

+ (void)requestInviteFetchSummary:(void(^)(id error,HHInvitedFetchSummaryResponse *response))callback;


///商城 - 提现
+ (void)getProductListByCategory:(NSNumber *)category
                        callback:(void(^)(id error, NSArray<HHProductOutline *> *products))callback;

+ (void)getProductgetInfoByProductId:(NSInteger)productId
                            callback:(void(^)(id error , HHProductInfo *productInfo))callback;


+ (void)purchaseWithProductId:(NSInteger)productId
                        count:(int)count
                      address:(NSString *)address
                      message:(NSString *)message
                    callState:(int)callState
                    voiceCode:(NSString *)voiceCode
                     callback:(void(^)(id error ,HHPurchaseResponse *response))callback;

//ali

+ (void)getDefaultAlipay:(void(^)(id error ,HHAlipayAccountResponse *response))callback;

+ (void)updateAliAccount:(NSString *)account
                    name:(NSString *)name
                callback:(void(^)(id error, HHResponse *response))callback;

//wechat

+ (void)getDefaultWechat:(void(^)(id error ,HHWeixinAccountResponse *response))callback;


//order
+ (void)getOrderList:(NSInteger)state
            callback:(void(^)(id error,NSArray<HHOrderInfo *> *orders))callback;

+ (void)getOrderDetailInfo:(NSInteger)orderId
                  callback:(void(^)(id error , HHOrderInfo *orderInfo))callback;

///incomeDetail
+ (void)requestIncome:(IncomeDetailCategory)category
                 time:(long)time
             callback:(void(^)(id error , HHIncomDetailResponse *response))callback;



+ (void)versionCheck:(void(^)(id error,HHResponse *response))callback;

@end


