//
//  Header.h
//  HuiHeadline
//
//  Created by eyuxin on 2017/9/22.
//  Copyright © 2017年 eyuxin. All rights reserved.
//

#ifndef HHInterface_h
#define HHInterface_h


#endif /* HHInterface_h */


//channelList

#define k_default_channel @[@"头条",@"热点",@"娱乐",@"社会",@"搞笑",@"健康",@"国内"]


#define k_all_channel @[@"头条", @"热点",@"娱乐",@"社会",@"搞笑",@"健康", @"国内",@"时尚",@"财经",@"游戏",@"汽车", @"国际", @"科技", @"军事", @"人文", @"体育", @"星座", @"科学", @"互联网", @"数码", @"电视", @"电影"]
//video

#define k_video_baseurl @"http://k.360kan.com/pc/list?notad=1&dl=vh5_hsp&channel_id="

#define k_video_channelDict @{@"推荐":@0,@"娱乐":@1,@"搞笑":@2,@"社会":@3,@"生活":@18,@"军事":@19,@"体育":@12,@"影视":@8,@"音乐":@13,@"科技":@7,@"朋友圈":@6}

#define k_default_videos @[@"推荐",@"娱乐",@"搞笑",@"社会",@"生活",@"军事"]

#define k_all_videos @[@"推荐",@"娱乐",@"搞笑",@"社会",@"生活",@"军事",@"体育",@"影视",@"音乐",@"科技",@"朋友圈"]

#define k_sendsms_success @"我们已经发送了验证码到您的手机"

#define k_common_problem  @"http://toutiao.huadongmedia.com/faq.html";

#define k_user_protocol @"http://toutiao.huadongmedia.com/user-service.html"


//#define k_base_url @"http://192.168.0.114:8080/frontend"
//#define k_base_url @"http://192.168.0.247:9780/frontend"
#define k_base_url @"http://api.cashtoutiao.com/frontend"



#define $(url) [k_base_url stringByAppendingString:url]

//login

#define k_login_url  $(@"/login/by/phone")

#define k_register_url $(@"/register/by/phone")

#define k_update_password $(@"/phone/password/update")

#define k_retrieve_password $(@"/phone/password/retrieve")

//ali wechat

#define k_login_ali_secret $(@"/login/ali/fetch/secret")

#define k_login_by_ali $(@"/login/by/ali")

#define k_login_by_wx $(@"/login/by/weixin")

#define k_bind_wx $(@"/account/bind/weixin")

#define k_authorize_wx $(@"/weixin/account/authorize")

//NewsList
#define k_getkey_url @"http://hspcode.dftoutiao.com/newskey/code"

#define k_newspool_url  @"http://hspapi.dftoutiao.com/newsapi/newspool"

#define k_id @"shgaoxin"
#define k_qid @"huitt"
//top news
#define k_topnews_url @"http://api.media.huadongmedia.com/frontend/pull/self"

//ad request paramater
#define k_getAdStrategy @"http://ad.proxy.huisuoping.com/cash/v1/ad/strategy/ios"
#define k_getBannerAdStrategy @"http://ad.proxy.huisuoping.com//cash/v1/banner/ad/strategy"

//ad list
#define k_ad_list_url @"http://ad.proxy.huisuoping.com/cash/v1/ad/request"

//read

#define k_readConfig_url  $(@"/read/config")

#define k_readConfigRule_url  $(@"/read/config/rule")

#define k_readConfig_description_url  $(@"/read/config/description")

#define k_readIncomeDetail_url  $(@"/read/income/detail")


#define k_sync_duration $(@"/read/sych/duration")

#define k_sync_awardPerhour $(@"/credit/sych/reward/per/hour")

#define k_get_income $(@"/read/income")

#define k_sych_ad_exposure  $(@"/read/sych/list/ad/exposure")

//credit

#define k_get_credict $(@"/credit/summary")

#define k_credit_detail $(@"/credit/detail")

//account

#define k_account_update_nickName $(@"/account/update/nick/name")

#define k_account_update_gender $(@"/account/update/gender")

#define k_account_update_birthday $(@"/account/update/birthday")


#define k_account_check_state $(@"/account/check/state")


#define k_retrieve_password    $(@"/phone/password/retrieve")

//验证码
#define k_verify_send $(@"/verify/send/sms")

//bind phone

#define k_bind_phone $(@"/bind/phone")

#define k_account_bind_phone $(@"/account/bind/phone")

#define k_account_rebind_phone $(@"/account/rebind/phone")


//sign
#define k_sign_notification_list  $(@"/sign/notification/list")

#define k_sign_record  $(@"/sign/record")

#define k_sign  $(@"/sign")

//task

#define k_user_newbie_task   $(@"/newbie/task/list")

#define k_user_daily_task   $(@"/daily/task/list")

#define k_user_newbie_draw   $(@"/newbie/task/draw")

#define k_user_daily_draw   $(@"/daily/task/draw")

//invite

#define k_invite_ui   @"http://cashtoutiao-all-file.oss-cn-shanghai.aliyuncs.com/app/entry/invited_get_money.json"

#define k_invite_constribution_detail  $(@"/invite/contribution/detail")

#define k_invite_constribution_summary  $(@"/invite/contribution/summary")



#define k_invite_init  $(@"/invite/init")

#define k_invite_fetch_summary  $(@"/invite/fetch/summary")

#define k_invite_contribution_detail  $(@"/invite/contribution/detail")

#define k_invite_contribution_summary  $(@"/invite/contribution/summary")

#define k_invite  $(@"/invite") 

#define k_appstore_link @"http://a.app.qq.com/o/simple.jsp?pkgname=com.cashtoutiao&ckey=CK1371494628908"

#define k_android_link @"http://website.cashtoutiao.com/qr/index.html"

//product

#define alipy_category 1002001

#define wechat_category 1002002

#define REAL_CAREFULLY_CHOSEN_DAILY_NECCESSARY 2001001

#define k_product_list $(@"/product/list/by/category")

#define k_product_info $(@"/product/info")

#define k_product_head_picture $(@"/product/category/head/picture")

#define k_product_purchase $(@"/product/purchase")

//alipay wexin
#define k_default_alipay $(@"/alipay/account/get")

#define k_update_alipay $(@"/alipay/account/update")

#define k_default_wechat $(@"/weixin/account/get")

#define k_update_wechat $(@"/weixin/account/update")

//order

#define k_order_list $(@"/order/list")

#define k_order_info $(@"/order/info")

//
#define k_check_version $(@"/version/check")

