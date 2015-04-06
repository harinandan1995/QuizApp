//
//  LoginViewController.m
//  QuizApp
//
//  Created by Harinandan Teja on 10/02/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import "LoginViewController.h"
#import "GlobalFn.h"
#import <AFNetworking/AFNetworking.h>
#import <UIView+Toast.h>
#import "QuizIDViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor]; //#009688
    UsernameField.backgroundColor = [GlobalFn getColor:0];
    UsernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"LDAP ID" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]; //#004D40
    PasswordField.backgroundColor = [GlobalFn getColor:0];
    PasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    loginButton.backgroundColor = [UIColor whiteColor];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 3;
    loginButton.backgroundColor = [GlobalFn getColor:0];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    loading.hidden = YES;
    
    UsernameField.text = @"120050066";
    PasswordField.text = @"hari@ldap";
}

-(void)dismissKeyboard {
    [UsernameField resignFirstResponder];
    [PasswordField resignFirstResponder];
}

-(IBAction)loginAction:(id)sender {
    [PasswordField resignFirstResponder];
    [UsernameField resignFirstResponder];
    if ([PasswordField.text isEqualToString:@""] || [UsernameField.text isEqualToString:@""]) {
        [self.view makeToast:@"Please fill all the fields"];
    }
    else {
        [loading startAnimating];
        loading.hidden = NO;
        NSDictionary *parameters = @{@"ldap_id":UsernameField.text,@"ldap_password":PasswordField.text,@"key":@"123"};
        NSLog(@"Param : %@",parameters);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:@"http://bodhitree3.cse.iitb.ac.in:8080/api/ldap-auth" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
            [loading stopAnimating];
            loading.hidden = YES;
            NSLog(@"JSON: %@", responseObject);
            NSDictionary *help = (NSDictionary *) responseObject;
            NSString *errormsg = [NSString stringWithFormat:@"%@",help[@"error"]];
            if ([errormsg isEqualToString:@"0"]) {
                QuizIDViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuizIDViewController"];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                navigationController.navigationBarHidden  = YES;
                viewController.stu_id = help[@"student_id"];
                viewController.stu_name = help[@"student_name"];
                [self presentViewController:navigationController animated:NO completion:nil];
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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
