//
//  questionViewController.h
//  QuizApp
//
//  Created by Harinandan Teja on 02/03/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface questionViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView *navigationView;
    IBOutlet UILabel *qNoLabel;
    IBOutlet UITextView *questionView;
    IBOutlet UITableView *quesTable;
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *prevButton;
    IBOutlet UIButton *submitButton;
    IBOutlet UIButton *clearButton;
    NSString *quesNo;
    NSMutableArray *arrayHelp;
    NSMutableArray *questionArray;
}

@property (nonatomic,weak) NSString *uniqueID;
@property (nonatomic,weak) NSString *quizID;
@property (nonatomic,strong) NSString *stu_name;
@property (nonatomic,strong) NSString *stu_id;

-(IBAction)submitAction:(id)sender;
-(IBAction)clearAction:(id)sender;
-(IBAction)nextAction:(id)sender;
-(IBAction)prevAction:(id)sender;

@end
