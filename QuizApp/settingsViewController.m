//
//  settingsViewController.m
//  QuizApp
//
//  Created by Harinandan Teja on 06/04/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import "settingsViewController.h"
#import "GlobalFn.h"
#import "LoginViewController.h"

@interface settingsViewController ()

@end

@implementation settingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor]; //#009688
    addressField.backgroundColor = [GlobalFn getColor:0];
    saveButton.backgroundColor = [UIColor whiteColor];
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 3;
    saveButton.backgroundColor = [GlobalFn getColor:0];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navigationView.backgroundColor = [GlobalFn getColor:1];
    [navigationView.layer setShadowColor:[UIColor blackColor].CGColor];
    [navigationView.layer setShadowOpacity:0.5];
    [navigationView.layer setShadowRadius:3.0];
    [navigationView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    addressField.text = [GlobalFn getAddress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    // Do any additional setup after loading the view.
}

-(void)dismissKeyboard {
    [addressField resignFirstResponder];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)saveAction:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:addressField.text
                                              forKey:@"serveraddress"];
    LoginViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBarHidden  = YES;
    [self presentViewController:navigationController animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
