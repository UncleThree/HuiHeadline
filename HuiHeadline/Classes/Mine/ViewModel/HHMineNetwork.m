//
//  HHMainNetwork.m
//  HuiHeadline
//
//  Created by eyuxin on 2017/10/17.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#import "HHMineNetwork.h"
#import "HHAdRequest.h"
#import "HHAdModel.h"
#import "HHInvitedInitResponse.h"

@implementation HHMineNetwork

+ (void)requestCreditSummary:(void(^)(id error, HHUserCreditSummary *summary))callback {
    
    
    [HHNetworkManager postRequestWithUrl:k_get_credict parameters:nil isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            NSDictionary *dict = [respondsStr mj_JSONObject];
            HHCreditSummaryResponse *creditSummaryResponse = [HHCreditSummaryResponse mj_objectWithKeyValues:dict];
            if (creditSummaryResponse.statusCode == 200) {
                callback(nil, creditSummaryResponse.userCreditSummary);
            } else {
                callback(creditSummaryResponse.msg ,nil);
            }
        }
    }];
    
    
}

+ (void)requestAds:(void(^)(NSError *error ,NSArray<HHAdModel *> * result))callback {
    
    [HHHeadlineNetwork requestForBannerAdList:^(NSError *error, id result) {
        callback(error,result);
    }];
}

+ (void)updateNickName:(NSString *)nickName
              callback:(void(^)(id error, HHResponse *response))callback{
    
    NSDictionary *paramaters = @{
                                 @"value":nickName
                                     };
    
    [HHNetworkManager postRequestWithUrl:k_account_update_nickName parameters:paramaters isEncryptedJson:NO otherArg:@{@"requestType":@"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHResponse *response = [HHResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            callback(nil,response);
        }
        
        
    }];
}

+ (void)updateGender:(NSInteger)gender
            callback:(void(^)(id error, HHResponse *response))callback {
    
    NSDictionary *paramaters = @{
                                 @"value":@(gender)
                                 };
    [HHNetworkManager postRequestWithUrl:k_account_update_nickName parameters:paramaters isEncryptedJson:NO otherArg:@{@"requestType":@"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHResponse *response = [HHResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            callback(nil,response);
        }
        
    }];
}

+ (void)updateBirthday:(NSString *)birthday
            callback:(void(^)(id error, HHResponse *response))callback {
    
    NSDictionary *paramaters = @{
                                 @"value":birthday
                                 };
    [HHNetworkManager postRequestWithUrl:k_account_update_birthday parameters:paramaters isEncryptedJson:NO otherArg:@{@"requestType":@"json"} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHResponse *response = [HHResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            callback(nil,response);
        }
        
    }];
}

+ (void)bindPhone:(NSString *)phone
         password:(NSString *)password
       verifyCode:(NSString *)verifyCode
         callback:(void(^)(id error, HHBindPhoneResponse *response))callback {
    NSDictionary *parames = @{
                              @"phone":phone,
                              @"password":password,
                              @"verifyCode":verifyCode
                              };
    [HHNetworkManager postRequestWithUrl:k_account_bind_phone parameters:parames isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        
        if (error) {
            callback(error,nil);
        } else {
            HHBindPhoneResponse *response = [HHBindPhoneResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            response.phone = phone;
            callback(nil,response);
        }
    }];
}

+ (void)rebindPhone:(NSString *)phone
         verifyCode:(NSString *)verifyCode
           callback:(void(^)(id error, HHBindPhoneResponse *response))callback {
    NSDictionary *parames = @{
                              @"phone":phone,
                              @"verifyCode":verifyCode
                              };
    [HHNetworkManager postRequestWithUrl:k_account_rebind_phone parameters:parames isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        
        if (error) {
            callback(error,nil);
        } else {
            HHBindPhoneResponse *response = [HHBindPhoneResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            response.phone = phone;
            callback(nil,response);
        }
    }];
}


+ (void)retrievePasswordWithPhone:(NSString *)phone
                         password:(NSString *)password
                       verifyCode:(NSString *)verifyCode
                         callback:(void(^)(id error, HHStateResponse *response))callback {
    
    NSDictionary *parames = @{
                              @"phone":phone,
                              @"password":password,
                              @"verifyCode":verifyCode
                              };
    [HHNetworkManager postRequestWithUrl:k_retrieve_password parameters:parames isEncryptedJson:YES otherArg:nil handler:^(NSString *respondsStr, NSError *error) {
        
        if (error) {
            callback(error,nil);
        } else {
            HHStateResponse *response = [HHStateResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            callback(nil,response);
        }
    }];
}

+ (void)requestInviteJson:(void(^)(id error, HHInvitedJsonModel *model))callback {
    
    
    [HHNetworkManager GET:k_invite_ui parameters:nil handler:^(id error, id result) {
        if (error) {
            callback(error,nil);
        } else {
            HHInvitedJsonModel *model = [HHInvitedJsonModel mj_objectWithKeyValues:result];
            callback(nil,model);
        }
    }];
    
}


+ (void)recommendWithCode:(NSString *)code
                 callback:(void(^)(id error, HHResponse *response))callback{
    
    NSLog(@"%@", code);
    [HHNetworkManager postRequestWithUrl:k_invite parameters:@{@"code":code} isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHResponse *response = [HHResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil,response);
            } else {
                callback(response.msg,nil);
            }
        }
        
    }];
    
    
    
}

+ (void)requestInviteFetchSummary:(void(^)(id error,HHInvitedFetchSummaryResponse *response))callback {
    
    [HHNetworkManager postRequestWithUrl:k_invite_fetch_summary parameters:nil isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error, nil);
        } else  {
            HHInvitedFetchSummaryResponse *response = [HHInvitedFetchSummaryResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                if (!response.userInviteInfo) {
                    [self inviteFetchSummaryInit:^(id error, NSString *code) {
                        if (error) {
                            callback(error,nil);
                        } else {
                            HHUserInviteInfo *info = [HHUserInviteInfo new];
                            info.code = code;
                            info.totalCredit = 0;
                            info.count = 0;
                            response.userInviteInfo = info;
                            callback(nil, response);
                        }
                    }];
                } else {
                    callback(nil, response);
                }
            } else {
                callback(response.msg, nil);
            }
        }
    }];
}

+ (void)inviteFetchSummaryInit:(void(^)(id error, NSString *code))callback {


    [HHNetworkManager postRequestWithUrl:k_invite_init parameters:nil isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else  {
            HHInvitedInitResponse *response = [HHInvitedInitResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            
            if (response.statusCode == 200) {
                callback(nil, response.criticalValue);
            } else {
                callback(response.msg, nil);
            }

        }
    }];
}



+ (void)requestInviteConstribution:(NSInteger)page callback:(void(^)(id error, NSArray<HHInvitedConstributionSummary *> *constributions))callback {
    
    
    [HHNetworkManager postRequestWithUrl:k_invite_constribution_detail parameters:@{@"page":@(page)} isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHInvitedConstributionSummaryResponse *response = [HHInvitedConstributionSummaryResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil, response.userInviteeContributionSummaries);
            } else {
                callback(response.msg, nil);
            }
        }
        
        
    }];
    
}

+ (void)requestInviteSummary:(NSInteger)page callback:(void(^)(id error, NSArray<HHInvitedSummary *> *summaries))callback {
    
    
    [HHNetworkManager postRequestWithUrl:k_invite_constribution_summary parameters:@{@"page":@(page)} isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHInvitedSummaryResponse *response = [HHInvitedSummaryResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil, response.userInviteeSummarys);
            } else {
                callback(response.msg, nil);
            }
        }
        
        
    }];
    
}

+ (void)getProductListByCategory:(NSNumber *)category
                        callback:(void(^)(id error, NSArray<HHProductOutline *> *products))callback {
    
    NSDictionary *parameters = @{
                                 @"category":category
                                 };
    [HHNetworkManager postRequestWithUrl:k_product_list parameters:parameters isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHProductIndoResponse *response = [HHProductIndoResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil,response.productOutlineList);
            } else {
                callback(response.msg, nil);
            }
        }
        
    }];
}



+ (void)getProductgetInfoByProductId:(NSInteger)productId
                            callback:(void(^)(id error , HHProductInfo *productInfo))callback{
    
    
    [HHNetworkManager postRequestWithUrl:k_product_info parameters:@{@"productId":@(productId)} isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHProductResponse *response = [HHProductResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil,response.productInfo);
            } else {
                callback(response.msg, nil);
            }
        }
        
    }];
    
}



+ (void)purchaseWithProductId:(NSInteger)productId
                        count:(int)count
                      address:(NSString *)address
                      message:(NSString *)message
                    callState:(int)callState
                    voiceCode:(NSString *)voiceCode
                     callback:(void(^)(id error ,HHPurchaseResponse *response))callback{
    
    NSDictionary *paramaters = @{
                                 @"productId":@(productId),
                                 @"count":@(count),
                                 @"address":address,
                                 @"message":message,
                                 @"callState":@(callState),
                                 @"voiceCode":voiceCode
                                 };
    [HHNetworkManager postRequestWithUrl:k_product_purchase parameters:paramaters isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            NSLog(@"%@",respondsStr);
            HHPurchaseResponse *response = [HHPurchaseResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil,response);
            } else {
                callback(response.msg, nil);
            }
        }
        
    }];
    
}

+ (void)getDefaultAlipay:(void(^)(id error ,HHAlipayAccountResponse *response))callback{
    
    [HHNetworkManager postRequestWithUrl:k_default_alipay parameters:nil isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHAlipayAccountResponse *response = [HHAlipayAccountResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil,response);
            } else {
                callback(response.msg,nil);
            }
            
        }
        
        
    }];
    
}


+ (void)updateAliAccount:(HHAlipayAccount *)account
                callback:(void(^)(id error, HHResponse *response))callback {
    
    NSDictionary *para = @{
                           @"alipayAccount" : [account mj_JSONObject]
                           };
    [HHNetworkManager postRequestWithUrl:k_update_alipay parameters:para isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHResponse *response = [HHResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil, response);
            } else {
                callback(response.msg, nil);
            }
        }
        
        
    }];
}


+ (void)getDefaultWechat:(void(^)(id error ,HHWeixinAccountResponse *response))callback{
    
    [HHNetworkManager postRequestWithUrl:k_default_wechat parameters:nil isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHWeixinAccountResponse *response = [HHWeixinAccountResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil,response);
            } else {
                callback(response.msg,nil);
            }
            
        }
        
        
    }];
    
}

+ (void)updateWeixinAccountWithWxAccount:(HHWeixinAccount *)wexinAccount
                                callback:(void(^)(id error, HHResponse *response))callback {
    
    NSMutableDictionary *weixinAccountDict = [wexinAccount mj_JSONObject];
    [weixinAccountDict setObject:@([HHUserManager sharedInstance].userId) forKey:@"userId"];
    NSDictionary *para = @{
                           @"weixinAccount" : weixinAccountDict
                           };
    [HHNetworkManager postRequestWithUrl:k_update_wechat parameters:para isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHResponse *response = [HHResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil, response);
            } else {
                callback(response.msg, nil);
            }
        }
        
    }];
    
}


///0 all 1 进行中
+ (void)getOrderList:(NSInteger)state
           orderTime:(long)orderTime
            callback:(void(^)(id error,NSArray<HHOrderInfo *> *orders))callback   {
    
    NSDictionary *parameters = @{
                                 @"orderTime":@(orderTime ?: [[NSDate date] timeIntervalSince1970] * 1000),
                                 @"state":@(state)
                                 };
    
    [HHNetworkManager postRequestWithUrl:k_order_list parameters:parameters isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHOrderResponse *response = [HHOrderResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil,response.orderInfoList);
            } else {
                callback(response.msg,nil);
            }
        }
        
    }];
    
}

+ (void)getOrderDetailInfo:(NSInteger)orderId
                  callback:(void(^)(id error , HHOrderInfo *orderInfo))callback {
    
    NSDictionary *parameters = @{
                                 @"orderId":@(orderId),
                                 };
    
    [HHNetworkManager postRequestWithUrl:k_order_info parameters:parameters isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {

            HHOrderResponse *response = [HHOrderResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                callback(nil,response.orderInfo);
            } else {
                callback(response.msg,nil);
            }
        }
        
    }];
}


+ (void)requestIncome:(IncomeDetailCategory)category
                 time:(long)time
             callback:(void(^)(id error , HHIncomDetailResponse *response))callback {
    
    long lastTime = (long)[[NSDate date] timeIntervalSince1970] * 1000;
    if (time) {
        lastTime = time;
    }
    NSDictionary *dict = @{
                           @"creditDetailLastTime":@(lastTime),
                           @"category":@(category)
                           };
    
    [HHNetworkManager postRequestWithUrl:k_credit_detail parameters:dict isEncryptedJson:YES otherArg:@{} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error,nil);
        } else {
            HHIncomDetailResponse *response = [HHIncomDetailResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            if (response.statusCode == 200) {
                
                callback(nil,response);
            } else {
                callback(response.msg, nil);
            }
        }
        
    }];
    
    
}

+ (void)versionCheck:(void(^)(id error,HHResponse *response))callback {
    
    [HHNetworkManager postRequestWithUrl:k_check_version parameters:nil isEncryptedJson:YES otherArg:@{@"appendUserInfo":@1} handler:^(NSString *respondsStr, NSError *error) {
        if (error) {
            callback(error, nil);
        } else {
            HHResponse *response = [HHResponse mj_objectWithKeyValues:[respondsStr mj_JSONObject]];
            callback(nil, response);
        }
    }];
}



@end
