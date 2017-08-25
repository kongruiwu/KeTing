//
//  RMIAPHelper.m
//  BookCat
//
//  Created by rm-imac on 14-4-18.
//
//

#import "RMIAPHelper.h"

@interface RMIAPHelper()<SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    NSString* coinCount;
    NSString* rechargeMoney;
    
}
@property(nonatomic,weak)  SKPaymentQueue* paymentQueue;

@end

@implementation RMIAPHelper

static RMIAPHelper*    _instance = NULL;

+ (RMIAPHelper*)sharedInstance{
    if(_instance == nil)
    {
        _instance = [[RMIAPHelper alloc]init];
    }
    return _instance;
}

+ (void)release{
    [_instance destroy];
    _instance = nil;
}

- (void)setup{
    _paymentQueue = [SKPaymentQueue defaultQueue];
    //监听SKPayment过程 添加交易观察者对象
    [_paymentQueue addTransactionObserver:self];
    NSLog(@"RMIAPHelper 开启交易监听");
}

- (void)destroy{
    //解除监听
    [_paymentQueue removeTransactionObserver:self];
    _paymentQueue = nil;
    NSLog(@"RMIAPHelper 注销交易监听");
}

- (BOOL)canMakePayments{
    return [SKPaymentQueue canMakePayments];
}

- (void)buy:(NSString*)productId{
    if([self canMakePayments])
    {
       [self requestProduct:productId];
    }
    else
    {
//        NSLog(@"不支持内购");
        [self.delegate iapNotSupported:self];
    }
}

#pragma mark - 从iTunes Connect里面提取产品列表 productId产品标识符
- (void)requestProduct:(NSString*)productId{
//    NSLog(@"====================创建商品请求=============================");
    NSArray* product = [[NSArray alloc] initWithObjects:productId,nil];
    NSSet* nsset = [NSSet setWithArray:product];
    SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate = self;
    [request start];
    
    [self.delegate requestProduct:self start:request];

}

#pragma mark SKProductsRequestDelegate 以上查询的回调函数  收到的回调函数，此函数会返回产品列表
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    [self.delegate requestProduct:self received:request];
//    NSLog(@"prodocuId:%@",response.products);
//    NSLog(@"=============收到SKProductsRequestDelegate回调===================");
    
    NSArray *productArray = response.products;
    if(productArray != nil && productArray.count>0)
    {
        SKProduct *product = [productArray objectAtIndex:0];
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        rechargeMoney = [NSString stringWithFormat:@"%@",product.price];
        
        SKPayment* payment = [SKPayment paymentWithProduct:product];
        [_paymentQueue addPayment:payment];
        [self.delegate paymentRequest:self start:payment];
    
    }else{
        [self.delegate paymentRequestFaild];
    }
}

#pragma mark SKPaymentTransactionObserver 交易队列回调方法 
/* 当交易数组transactions发生变化时就调用此方法  支付完成的时候或者失败的时候这个函数将会被调用  SKPaymentTransaction  */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    NSMutableArray* restoreArray = [[NSMutableArray alloc]init];
    for(SKPaymentTransaction* transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self.delegate paymentRequest:self purchased:transaction money:rechargeMoney];
                break;
            case SKPaymentTransactionStateRestored:
                [restoreArray addObject:transaction.payment.productIdentifier];
                [self.delegate paymentRequest:self restored:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self.delegate paymentRequest:self failed:transaction];
                break;
            default:
                break;
        }
    }
    if(restoreArray.count > 0)
    {
        [self.delegate restoredArray:self withArray:restoreArray];
    }
//    NSLog(@"=======================================================这里是显示产品吗？");
}

/*
   交易完成之后，调用； 据我理解应该是[_paymentQueue finishTransaction:transaction]; 调用成功之后的回掉
   当交易transactions从队列中被移除调用此方法
 */
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"removedTransactions called:");
    NSLog(@"=======================================================调用成功之后的回掉");
}

//恢复失败
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"restoreCompletedTransactionsFailedWithError called:");
    NSLog(@"error:%@",error);
    NSLog(@"=======================================================2222");
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished called:");
    NSLog(@"SKPaymentQueue:%@",queue);
    NSLog(@"=======================================================1111");
}
// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    NSLog(@"updatedDownloads called:");
    NSLog(@"=======================================================这里显示价钱吗？");
}

#pragma 恢复流程
//发起恢复
- (void)restore
{
    [_paymentQueue restoreCompletedTransactions];
}

- (void)finishWithWithTransation:(SKPaymentTransaction*)transaction{
    NSLog(@"发送finish");
    [_paymentQueue finishTransaction:transaction];
}
@end
