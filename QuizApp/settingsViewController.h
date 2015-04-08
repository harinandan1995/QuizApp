//
//  settingsViewController.h
//  QuizApp
//
//  Created by Harinandan Teja on 06/04/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingsViewController : UIViewController{
    IBOutlet UITextView *addressField;
    IBOutlet UIButton *saveButton;
    IBOutlet UIView *navigationView;
    NSString *uniqueID;
}

-(IBAction)saveAction:(id)sender;

@end
