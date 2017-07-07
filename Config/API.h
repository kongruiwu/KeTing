//
//  API.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#ifndef API_h
#define API_h
//#ifdef DEBUG
//    #define Base_Url    @"http://fm.123.com.cn/"
//#else
    #define Base_Url    @"http://36.7.79.242:8091/"
//#endif

//首页 精选
#define Page_home           @"v1/choice"
//财经头条列表
#define page_TopList        @"v1/topList"
//财经头条  标签列表
#define Page_TopTags        @"v1/topsTag"
//财经头条 标签对应音频列表
#define Page_TagAudio       @"/v1/tagsAudio"
//音频详情
#define Page_AudioDetail    @"v1/viewAudio"
//声度列表
#define Page_VoiceList      @"v1/voice"
//声度详情
#define Page_VoiceDetail    @"v1/viewVoice"

//听书列表
#define Page_ListenList     @"v1/listen"
//听书详情
#define Page_ListenDetail   @"v1/viewListen"
//主播详情
#define Page_AnchorDetail   @"v1/viewAnchor"
//精品推荐
#define Page_Subscribe      @"v1/subscribeRec"
//热门排行数据
#define Page_Hots           @"v1/hots"
//限时免费
#define Page_Free           @"v1/free"

//登录
#define Page_Login          @"v1/login"
//注册
#define Page_Register       @"v1/Register"
//发送验证码
#define Page_SendCode       @"v1/sendSms"
//验证验证码
#define Page_CheckCode      @"v1/checkSms"
//修改用户昵称
#define Page_ChangeName     @"v1/editName"
//上传头像
#define Page_UserAvater     @"v1/modIcon"
//用户信息
#define Page_UserInfo       @"v1/getUser"
//数据字典
#define Page_DataModel      @"v1/dictionary"
//修改个人资料
#define Page_ChangeInfo     @"v1/modUser"
//获取用户余额
#define Page_UserAccount    @"v1/getAsset"
//消费记录
#define Page_TakeUp         @"v1/consumer"
//充值记录
#define Page_TopUp          @"v1/inpour"
//已购
#define Page_Buys           @"v1/buys"
//购物车
#define Page_ShopCar        @"v1/cart"
//收听历史
#define Page_History        @"v1/history"
//删除收听历史
#define Page_DelHistory     @"v1/listenDel"
//我赞过的
#define Page_Liked          @"v1/support"
//下载
#define Page_DownLoad       @"v1/download"
#endif /* API_h */
