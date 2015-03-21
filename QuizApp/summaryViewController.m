//
//  summaryViewController.m
//  QuizApp
//
//  Created by Harinandan Teja on 21/03/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import "summaryViewController.h"
#import <UIView+Toast.h>
#import "GlobalFn.h"
#import <AFNetworking.h>

@interface summaryViewController ()

@end

@implementation summaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    navigationView.backgroundColor = [GlobalFn getColor:1];
    [navigationView.layer setShadowColor:[UIColor blackColor].CGColor];
    [navigationView.layer setShadowOpacity:0.5];
    [navigationView.layer setShadowRadius:3.0];
    [navigationView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [self.view makeToast:_msg];
    NSDictionary *parameters = @{@"quiz_id":_quizID,@"uniq_id":_uniqueID,@"key":@"123"};
    NSLog(@"Param : %@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:@"http://quizapp.prateekchandan.me/api/quiz/summary" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *help = (NSDictionary *) responseObject;
        NSString *summary = @"";
        NSMutableArray *responseArray = (NSMutableArray *)help[@"responses"];
        for (NSDictionary *help2 in responseArray) {
            if ([help2[@"show_answers"] integerValue] == 1) {
                summary = [summary stringByAppendingString:[NSString stringWithFormat:@"QNo : %@ Result : %@ \nGiven Ans : %@\nCorrect Ans : %@\nMarks : %@",help2[@"id"],help2[@"result"],help2[@"given_answer"],help2[@"correct_answer"],help2[@"marks_obtained"]]];
            }
            else {
                summary = [summary stringByAppendingString:[NSString stringWithFormat:@"QNo : %@ Result : %@ \nGiven Ans : %@\nMarks : %@\n",help2[@"id"],help2[@"result"],help2[@"given_answer"],help2[@"marks_obtained"]]];
            }
        }
        summaryView.text = summary;
        NSString *errormsg = [NSString stringWithFormat:@"%@",help[@"error"]];
        if ([errormsg isEqualToString:@"1"]) {
            [self.view makeToast:help[@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.view makeToast:@"Check your internet connection"];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
