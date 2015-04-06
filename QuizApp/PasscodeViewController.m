//
//  PasscodeViewController.m
//  QuizApp
//
//  Created by Harinandan Teja on 10/02/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import "PasscodeViewController.h"
#import "questionViewController.h"
#import "GlobalFn.h"
#import <AFNetworking.h>
#import <UIView+Toast.h>

@interface PasscodeViewController ()

@end

@implementation PasscodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    finalCode = [[NSMutableArray alloc] init];
    unicodeArray = [[NSMutableArray alloc] init];
    [finalCode addObject:@"0041"];
    [finalCode addObject:@"0042"];
    [finalCode addObject:@"0043"];
    [finalCode addObject:@"0044"];
    [finalCode addObject:@"0045"];
    [finalCode addObject:@"0046"];
    [finalCode addObject:@"0047"];
    [finalCode addObject:@"0048"];
    
    for (int i=0; i<[_symbolArray count]; i++) {
        NSString *code = _symbolArray[i];
        NSScanner *hexScan = [NSScanner scannerWithString:code];
        unsigned int hexNum;
        [hexScan scanHexInt:&hexNum];
        UTF32Char inputChar = hexNum;
        NSString *res = [[NSString alloc] initWithBytes:&inputChar length:4 encoding:NSUTF32LittleEndianStringEncoding];
        [unicodeArray addObject:res];
    }
    navigationView.backgroundColor = [GlobalFn getColor:1];
    [navigationView.layer setShadowColor:[UIColor blackColor].CGColor];
    [navigationView.layer setShadowOpacity:0.5];
    [navigationView.layer setShadowRadius:3.0];
    [navigationView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    passcodeLabel.layer.masksToBounds = YES;
    passcodeLabel.backgroundColor = [GlobalFn getColor:0];
    passcodeLabel.textColor = [UIColor whiteColor];
    passcodeLabel.layer.cornerRadius = 5;
    
    [self initButton];
    
    /*NSDictionary *parameters = @{@"quiz_id":_quizID,@"uniq_id":_uniqueID,@"key":@"123",@"passcode":finalCode};
    NSLog(@"Param : %@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://quizapp.prateekchandan.me/api/quiz/Auth" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.view makeToast:@"Check your internet connection"];
    }];*/
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)initButton{
    button1.backgroundColor = [UIColor whiteColor];
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = 3;
    button1.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button1.layer.borderWidth = 1;
    [button1 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button1 setTitle: unicodeArray[0] forState: UIControlStateNormal];
    button2.backgroundColor = [UIColor whiteColor];
    button2.layer.masksToBounds = YES;
    button2.layer.cornerRadius = 3;
    button2.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button2.layer.borderWidth = 1;
    [button2 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button2 setTitle: unicodeArray[1] forState: UIControlStateNormal];
    button3.backgroundColor = [UIColor whiteColor];
    button3.layer.masksToBounds = YES;
    button3.layer.cornerRadius = 3;
    button3.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button3.layer.borderWidth = 1;
    [button3 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button3 setTitle: unicodeArray[2] forState: UIControlStateNormal];
    button4.backgroundColor = [UIColor whiteColor];
    button4.layer.masksToBounds = YES;
    button4.layer.cornerRadius = 3;
    button4.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button4.layer.borderWidth = 1;
    [button4 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button4 setTitle: unicodeArray[3] forState: UIControlStateNormal];
    button5.backgroundColor = [UIColor whiteColor];
    button5.layer.masksToBounds = YES;
    button5.layer.cornerRadius = 3;
    button5.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button5.layer.borderWidth = 1;
    [button5 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button5 setTitle: unicodeArray[4] forState: UIControlStateNormal];
    button6.backgroundColor = [UIColor whiteColor];
    button6.layer.masksToBounds = YES;
    button6.layer.cornerRadius = 3;
    button6.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button6.layer.borderWidth = 1;
    [button6 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button6 setTitle: unicodeArray[5] forState: UIControlStateNormal];
    button7.backgroundColor = [UIColor whiteColor];
    button7.layer.masksToBounds = YES;
    button7.layer.cornerRadius = 3;
    button7.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button7.layer.borderWidth = 1;
    [button7 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button7 setTitle: unicodeArray[6] forState: UIControlStateNormal];
    button8.backgroundColor = [UIColor whiteColor];
    button8.layer.masksToBounds = YES;
    button8.layer.cornerRadius = 3;
    button8.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button8.layer.borderWidth = 1;
    [button8 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button8 setTitle: unicodeArray[7] forState: UIControlStateNormal];
    button9.backgroundColor = [UIColor whiteColor];
    button9.layer.masksToBounds = YES;
    button9.layer.cornerRadius = 3;
    button9.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button9.layer.borderWidth = 1;
    [button9 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button9 setTitle: unicodeArray[8] forState: UIControlStateNormal];
    button10.backgroundColor = [UIColor whiteColor];
    button10.layer.masksToBounds = YES;
    button10.layer.cornerRadius = 3;
    button10.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button10.layer.borderWidth = 1;
    [button10 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button10 setTitle: unicodeArray[9] forState: UIControlStateNormal];
    button11.backgroundColor = [UIColor whiteColor];
    button11.layer.masksToBounds = YES;
    button11.layer.cornerRadius = 3;
    button11.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button11.layer.borderWidth = 1;
    [button11 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button11 setTitle: unicodeArray[10] forState: UIControlStateNormal];
    button12.backgroundColor = [UIColor whiteColor];
    button12.layer.masksToBounds = YES;
    button12.layer.cornerRadius = 3;
    button12.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button12.layer.borderWidth = 1;
    [button12 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button12 setTitle: unicodeArray[11] forState: UIControlStateNormal];
    button13.backgroundColor = [UIColor whiteColor];
    button13.layer.masksToBounds = YES;
    button13.layer.cornerRadius = 3;
    button13.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button13.layer.borderWidth = 1;
    [button13 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button13 setTitle: unicodeArray[12] forState: UIControlStateNormal];
    button14.backgroundColor = [UIColor whiteColor];
    button14.layer.masksToBounds = YES;
    button14.layer.cornerRadius = 3;
    button14.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button14.layer.borderWidth = 1;
    [button14 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button14 setTitle: unicodeArray[13] forState: UIControlStateNormal];
    button15.backgroundColor = [UIColor whiteColor];
    button15.layer.masksToBounds = YES;
    button15.layer.cornerRadius = 3;
    button15.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button15.layer.borderWidth = 1;
    [button15 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button15 setTitle: unicodeArray[14] forState: UIControlStateNormal];
    button16.backgroundColor = [UIColor whiteColor];
    button16.layer.masksToBounds = YES;
    button16.layer.cornerRadius = 3;
    button16.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    button16.layer.borderWidth = 1;
    [button16 setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [button16 setTitle: unicodeArray[15] forState: UIControlStateNormal];
    
    clearButton.backgroundColor = [UIColor whiteColor];
    clearButton.layer.masksToBounds = YES;
    clearButton.layer.cornerRadius = 3;
    clearButton.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    clearButton.layer.borderWidth = 1;
    [clearButton setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    continueButton.backgroundColor = [UIColor whiteColor];
    continueButton.layer.masksToBounds = YES;
    continueButton.layer.cornerRadius = 3;
    continueButton.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    continueButton.layer.borderWidth = 1;
    [continueButton setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor whiteColor];
    backButton.layer.masksToBounds = YES;
    backButton.layer.cornerRadius = 3;
    backButton.layer.borderColor = [[GlobalFn getColor:1] CGColor];
    backButton.layer.borderWidth = 1;
    [backButton setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
}

////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)continueAction:(id)sender {
    if ([passcodeLabel.text length]<8) {
        [self.view makeToast:@"Invalid Passcode"];
    }
    else
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalCode options:0 error:nil];
        NSString *passcodeString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *parameters = @{@"quiz_id":_quizID,@"uniq_id":_uniqueID,@"key":@"123",@"passcode":passcodeString};
        NSLog(@"Param : %@",parameters);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:@"http://bodhitree3.cse.iitb.ac.in:8080/api/quiz/Auth" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSLog(@"JSON: %@", responseObject);
            NSDictionary *help = (NSDictionary *) responseObject;
            NSString *errormsg = [NSString stringWithFormat:@"%@",help[@"error"]];
            if ([errormsg isEqualToString:@"0"]) {
                questionViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"questionViewController"];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                navigationController.navigationBarHidden  = YES;
                viewController.stu_id = help[@"student_id"];
                viewController.stu_name = help[@"student_name"];
                viewController.uniqueID = _uniqueID;
                viewController.quizID = _quizID;
                [self presentViewController:navigationController animated:NO completion:nil];
            }
            else {
                [self.view makeToast:help[@"message"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self.view makeToast:@"Check your internet connection"];
        }];
        
    }
}

-(IBAction)buttonAction:(id)sender {
    NSString *title = [(UIButton *)sender currentTitle];
    passcodeLabel.text = [NSString stringWithFormat:@"%@%@",passcodeLabel.text,title];
}

-(IBAction)backAction:(id)sender {
    if(passcodeLabel.text.length !=0)
    {
        passcodeLabel.text = [passcodeLabel.text substringToIndex:[passcodeLabel.text length]-1];
    }
}

-(IBAction)clearAction:(id)sender {
    passcodeLabel.text = @"";
}

////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
