//
//  QuizIDViewController.m
//  QuizApp
//
//  Created by Harinandan Teja on 02/03/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import "QuizIDViewController.h"
#import "GlobalFn.h"
#import <AFNetworking.h>
#import <UIView+Toast.h>
#import "PasscodeViewController.h"
#import "questionViewController.h"

@interface QuizIDViewController ()

@end

@implementation QuizIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor]; //#009688
    ipField.backgroundColor = [GlobalFn getColor:0];
    ipField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Instructors IP" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]; //#004D40
    quizIdField.backgroundColor = [GlobalFn getColor:0];
    quizIdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Quiz ID" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    continueButton.backgroundColor = [UIColor whiteColor];
    continueButton.layer.masksToBounds = YES;
    continueButton.layer.cornerRadius = 3;
    continueButton.backgroundColor = [GlobalFn getColor:0];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navigationView.backgroundColor = [GlobalFn getColor:1];
    [navigationView.layer setShadowColor:[UIColor blackColor].CGColor];
    [navigationView.layer setShadowOpacity:0.5];
    [navigationView.layer setShadowRadius:3.0];
    [navigationView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    loading.hidden = YES;
    
    quizIdField.text = @"CS101:1";
}

-(void)dismissKeyboard {
    [quizIdField resignFirstResponder];
    [ipField resignFirstResponder];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)continueAction:(id)sender
{
    [quizIdField resignFirstResponder];
    [ipField resignFirstResponder];
    if ([quizIdField.text isEqualToString:@""]) {
        [self.view makeToast:@"Please enter the quiz ID"];
    }
    else{
        [loading startAnimating];
        loading.hidden = NO;
        NSDictionary *parameters = @{@"quiz_id":quizIdField.text,@"student_id":_stu_id,@"key":@"123",@"student_name":_stu_name};
        NSLog(@"Param : %@",parameters);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager POST:@"http://quizapp.prateekchandan.me/api/quiz" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSLog(@"JSON: %@", responseObject);
            NSDictionary *help = (NSDictionary *) responseObject;
            NSString *errormsg = [NSString stringWithFormat:@"%@",help[@"error"]];
            [loading stopAnimating];
            loading.hidden = YES;
            if ([errormsg isEqualToString:@"0"]) {
                uniqueID = help[@"uniq_id"];
                if([help[@"skip_symbol_auth"] isEqualToString:@"0"]) {
                    PasscodeViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PasscodeViewController"];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                    navigationController.navigationBarHidden  = YES;
                    viewController.uniqueID = uniqueID;
                    viewController.quizID = quizIdField.text;
                    viewController.stu_name = _stu_name;
                    viewController.stu_id = _stu_id;
                    viewController.symbolArray = (NSMutableArray *)help[@"unicodes"];
                    [self presentViewController:navigationController animated:NO completion:nil];
                }
                else {
                    questionViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"questionViewController"];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                    navigationController.navigationBarHidden  = YES;
                    viewController.uniqueID = uniqueID;
                    viewController.quizID = quizIdField.text;
                    viewController.stu_name = _stu_name;
                    viewController.stu_id = _stu_id;
                    [self presentViewController:navigationController animated:NO completion:nil];
                }
            }
            else {
                [self.view makeToast:help[@"message"]];
            }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [loading stopAnimating];
                loading.hidden = YES;
                [self.view makeToast:@"Check your internet connection"];
            }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
