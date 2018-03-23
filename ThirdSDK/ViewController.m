//
//  ViewController.m
//  ThirdSDK
//
//  Created by He on 2018/3/21.
//  Copyright © 2018年 He. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
@interface ViewController ()<WXApiDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nonceStr;

@property (weak, nonatomic) IBOutlet UITextField *prepayId;
@property (weak, nonatomic) IBOutlet UITextField *timeStamp;
@property (weak, nonatomic) IBOutlet UITextField *sign;
@property (weak, nonatomic) IBOutlet UITextField *order_spec;
@property (weak, nonatomic) IBOutlet UITextField *alsign;
@property (weak, nonatomic) IBOutlet UITextField *sign_type;

@end

@implementation ViewController
- (IBAction)weixin:(id)sender {
    PayReq* payreq = [[PayReq alloc]init];
    payreq.prepayId = self.prepayId.text;
    payreq.partnerId = @"51225773";
    payreq.package = @"Sign=WXPay";
    payreq.nonceStr = self.nonceStr.text;
    payreq.timeStamp = [self.timeStamp.text intValue];
    payreq.sign = self.sign.text;
    payreq.openID = @"wx81971c35613779b1";
    [WXApi sendReq:payreq];
    
}
- (IBAction)alipay:(id)sender {
    NSString* orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",self.order_spec.text,self.alsign.text,self.sign_type.text];
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"milklivezhiboapp" callback:^(NSDictionary *resultDic) {//wap支付宝
        if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
            NSLog(@"支付成功");
        }
        else {
            NSLog(@"支付失败");
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SendAuthReq* req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    [WXApi sendReq:req];
    
}

@end
