//
//  LoginViewController.h
//  QuizApp
//
//  Created by Harinandan Teja on 10/02/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController{
    IBOutlet UITextField *UsernameField;
    IBOutlet UITextField *PasswordField;
    IBOutlet UIButton *loginButton;
    IBOutlet UIActivityIndicatorView *loading;
}

-(IBAction)loginAction:(id)sender;
@end
