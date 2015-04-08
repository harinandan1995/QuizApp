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
    IBOutlet UITextField *ansView;
    NSString *quesNo;
    NSString *shufAns;
    NSString *shufQues;
    NSMutableArray *arrayHelp;
    NSMutableArray *questionArray;
    IBOutlet UILabel *timeLabel;
    int timeLeft;
}

@property (nonatomic,strong) NSString *uniqueID;
@property (nonatomic,strong) NSString *quizID;
@property (nonatomic,strong) NSString *stu_name;
@property (nonatomic,strong) NSString *stu_id;

-(IBAction)submitAction:(id)sender;
-(IBAction)clearAction:(id)sender;
-(IBAction)nextAction:(id)sender;
-(IBAction)prevAction:(id)sender;
-(IBAction)textEditingAction:(id)sender;
-(NSString *)timeFormatted:(int)totalSeconds;

@end
