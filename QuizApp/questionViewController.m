//
//  questionViewController.m
//  QuizApp
//
//  Created by Harinandan Teja on 02/03/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import "questionViewController.h"
#import "GlobalFn.h"
#import <Toast/UIView+Toast.h>
#import <AFNetworking/AFNetworking.h>
#import "summaryViewController.h"
#import "mcqCell.h"

@interface questionViewController ()

@end

@implementation questionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    navigationView.backgroundColor = [GlobalFn getColor:1];
    [navigationView.layer setShadowColor:[UIColor blackColor].CGColor];
    [navigationView.layer setShadowOpacity:0.5];
    [navigationView.layer setShadowRadius:3.0];
    [navigationView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [submitButton setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [clearButton setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [questionView addGestureRecognizer:tap1];
    [navigationView addGestureRecognizer:tap2];
    
    ansView.layer.masksToBounds = YES;
    ansView.layer.borderColor = [[GlobalFn getColor:0] CGColor];
    ansView.layer.borderWidth = 1;
    quesNo = @"0";
    
    quesTable.delegate = self;
    quesTable.dataSource = self;
    prevButton.hidden = YES;
    prevButton.enabled = NO;
    questionArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"backgroundNotification"
                                               object:nil];
    
    shufAns = @"1";
    shufQues = @"1";
    NSLog(@"%@ - %@",_quizID,_uniqueID);
    NSDictionary *parameters = @{@"quiz_id":_quizID,@"uniq_id":_uniqueID,@"key":@"123"};
    NSLog(@"Param : %@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:@"http://bodhitree3.cse.iitb.ac.in:8080/api/quiz/get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *help = (NSDictionary *) responseObject;
        NSString *errormsg = [NSString stringWithFormat:@"%@",help[@"error"]];
        shufAns = [NSString stringWithFormat:@"%@",help[@"randomize_options"]];
        shufQues = [NSString stringWithFormat:@"%@",help[@"randomize_questions"]];
        if ([errormsg isEqualToString:@"0"]) {
            if(![help[@"message"] isEqualToString:@"Successfully transferred the quiz"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                message:help[@"message"]
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            NSMutableArray *help2 = (NSMutableArray *)help[@"questions"];
            for (NSDictionary *help3 in help2) {
                NSMutableDictionary *help4 = [help3 mutableCopy];
                if ([help4[@"type"] integerValue] <= 2) {
                    if ([shufAns isEqualToString:@"1"]) {
                        NSMutableArray *optShuf = [help4[@"options"] mutableCopy];
                        NSUInteger count = [optShuf count];
                        for (NSUInteger i = 0; i < count; ++i) {
                            NSInteger remainingCount = count - i;
                            NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
                            [optShuf exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
                        }
                        [help4 setObject:optShuf forKey:@"options"];
                        //NSLog(@"%@",help4[@"options"]);
                    }
                }
                NSMutableArray *answerArray = [[NSMutableArray alloc] init];
                [help4 setObject:answerArray forKey:@"answer"];
                [questionArray addObject:help4];
            }
            if ([shufQues isEqualToString:@"1"]) {
                NSUInteger count = [questionArray count];
                for (NSUInteger i = 0; i < count; ++i) {
                    NSInteger remainingCount = count - i;
                    NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
                    [questionArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
                }
                qNoLabel.text = [NSString stringWithFormat:@"Question %ld",(long)[quesNo integerValue]+1];
            }
            else {
                qNoLabel.text = [NSString stringWithFormat:@"Question %@",questionArray[[quesNo integerValue]][@"question_no"]];
            }
            
            questionView.text = [NSString stringWithFormat:@"%@",questionArray[[quesNo integerValue]][@"question"]];
            questionView.backgroundColor = [GlobalFn getColor:0];
            [questionView setFont:[UIFont systemFontOfSize:17]];
            questionView.textColor = [UIColor whiteColor];
            if ([questionArray[[quesNo integerValue]][@"type"] integerValue] <= 2) {
                quesTable.hidden = NO;
                ansView.hidden = YES;
            }
            else {
                quesTable.hidden = YES;
                ansView.hidden = NO;
                ansView.text = @"";
            }
            [quesTable reloadData];
        }
        else {
            [self.view makeToast:help[@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.view makeToast:@"Check your internet connection"];
    }];
    
    for (int i=0; i<[questionArray count]; i++) {
        NSLog(@"asdasd");
        if ([questionArray[i][@"type"] integerValue] <= 2) {
            if ([shufAns isEqualToString:@"1"]) {
                NSMutableArray *optShuf = [questionArray[i][@"options"] mutableCopy];
                NSUInteger count = [optShuf count];
                for (NSUInteger i = 0; i < count; ++i) {
                    NSInteger remainingCount = count - i;
                    NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
                    [optShuf exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
                }
                [questionArray[i] setObject:optShuf forKey:@"options"];
                NSLog(@"%@",questionArray[i][@"options"]);
            }
        }
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)dismissKeyboard {
    [ansView resignFirstResponder];
}

- (void) receiveNotification:(NSNotification *) notification{
    NSDictionary *parameters = @{@"quiz_id":_quizID,@"uniq_id":_uniqueID,@"key":@"123",@"message":[NSString stringWithFormat:@"%@ went background",_stu_name]};
    NSLog(@"Param : %@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:@"http://bodhitree3.cse.iitb.ac.in:8080/api/add-log" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"JSON: %@", responseObject);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Warning : You went background, this event is logged to instructor"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.view makeToast:@"Check your internet connection"];
        [self receiveNotification:nil];
    }];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"From table %lu",(unsigned long)[questionArray[[quesNo integerValue]][@"options"] count]);
    if ([questionArray count]>0) {
        if ([questionArray[[quesNo integerValue]][@"type"] integerValue] <= 2) {
            return [questionArray[[quesNo integerValue]][@"options"] count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"mcqCell";
    mcqCell *cell = (mcqCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"mcqCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell.optionLabel removeFromSuperview];
    CGRect labelFrame = CGRectMake(60, 16, 210, 350);
    cell.optionLabel = [[UILabel alloc] initWithFrame:labelFrame];
    cell.optionLabel.layer.masksToBounds = YES;
    //cell.optionLabel.backgroundColor = [UIColor orangeColor];
    cell.optionLabel.font=[cell.optionLabel.font fontWithSize:15];
    [cell.optionLabel setNumberOfLines:0];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectButton.tag = indexPath.row;
    if ([questionArray[[quesNo integerValue]][@"type"] integerValue] == 1) {
        if([questionArray[[quesNo integerValue]][@"answer"] containsObject:[NSString stringWithFormat:@"%ld",(long)cell.selectButton.tag]]) {
            cell.optionImage.image = [UIImage imageNamed:@"fullCircleIndigoIcon.png"];
        }
        else {
            cell.optionImage.image = [UIImage imageNamed:@"zeroCircleIndigoIcon.png"];
        }
        [cell.selectButton addTarget:self action:@selector(mcqButAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([questionArray[[quesNo integerValue]][@"type"] integerValue] == 2) {
        //if(cell.selectButton.tag == [questionArray[[quesNo integerValue]][@"answer"] integerValue]) {
        if([questionArray[[quesNo integerValue]][@"answer"] containsObject:[NSString stringWithFormat:@"%ld",(long)cell.selectButton.tag]]) {
            cell.optionImage.image = [UIImage imageNamed:@"checkIndigoIcon.png"];
        }
        else {
            cell.optionImage.image = [UIImage imageNamed:@"uncheckIndigoIcon.png"];
        }
        [cell.selectButton addTarget:self action:@selector(mcqButAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    

    NSString *labelText = questionArray[[quesNo integerValue]][@"options"][indexPath.row][@"text"];
    [cell.optionLabel setText:labelText];
    [cell.optionLabel sizeToFit];
    [cell.contentView addSubview:cell.optionLabel];
    NSString *height = [NSString stringWithFormat:@"%f",cell.optionLabel.frame.size.height];
    [questionArray[[quesNo integerValue]] setObject:height forKey:@"height"];
    return cell;
}

-(IBAction)mcqButAction:(id)sender {
    UIButton* myButton = (UIButton*)sender;
    if ([questionArray[[quesNo integerValue]][@"type"] integerValue] == 1) {
        questionArray[[quesNo integerValue]][@"answer"] = [[NSMutableArray alloc] init];
    }
    [questionArray[[quesNo integerValue]][@"answer"] addObject:[NSString stringWithFormat:@"%ld", (long)myButton.tag]];
    [quesTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [questionArray[[quesNo integerValue]][@"height"] floatValue]+40;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)nextAction:(id)sender {
    [ansView resignFirstResponder];
    quesNo = [NSString stringWithFormat:@"%d",[quesNo integerValue]+1];
    if([quesNo integerValue] == [questionArray count]-1){
        nextButton.enabled = NO;
        nextButton.hidden = YES;
    }
    if ([shufQues isEqualToString:@"1"]) {
        qNoLabel.text = [NSString stringWithFormat:@"Question %ld",(long)[quesNo integerValue]+1];
    }
    else {
        qNoLabel.text = [NSString stringWithFormat:@"Question %@",questionArray[[quesNo integerValue]][@"question_no"]];
    }
    questionView.text = [NSString stringWithFormat:@"%@",questionArray[[quesNo integerValue]][@"question"]];
    questionView.backgroundColor = [GlobalFn getColor:0];
    [questionView setFont:[UIFont systemFontOfSize:17]];
    questionView.textColor = [UIColor whiteColor];
    prevButton.enabled = YES;
    prevButton.hidden = NO;
    if ([questionArray[[quesNo integerValue]][@"type"] integerValue] <= 2) {
        quesTable.hidden = NO;
        ansView.hidden = YES;
    }
    else {
        quesTable.hidden = YES;
        ansView.hidden = NO;
        if ([questionArray[[quesNo integerValue]][@"answer"] count]>0) {
            ansView.text = questionArray[[quesNo integerValue]][@"answer"][0];
        }
        else{
            ansView.text = @"";
        }
    }
    [quesTable reloadData];
}

-(IBAction)clearAction:(id)sender {
    questionArray[[quesNo integerValue]][@"answer"] = [[NSMutableArray alloc] init];
    [quesTable reloadData];
}

-(IBAction)prevAction:(id)sender {
    [ansView resignFirstResponder];
    quesNo = [NSString stringWithFormat:@"%d",[quesNo integerValue]-1];
    if([quesNo integerValue] == 0){
        prevButton.enabled = NO;
        prevButton.hidden = YES;
    }
    if ([shufQues isEqualToString:@"1"]) {
        qNoLabel.text = [NSString stringWithFormat:@"Question %ld",(long)[quesNo integerValue]+1];
    }
    else {
        qNoLabel.text = [NSString stringWithFormat:@"Question %@",questionArray[[quesNo integerValue]][@"question_no"]];
    }
    questionView.text = [NSString stringWithFormat:@"%@",questionArray[[quesNo integerValue]][@"question"]];
    questionView.backgroundColor = [GlobalFn getColor:0];
    [questionView setFont:[UIFont systemFontOfSize:17]];
    questionView.textColor = [UIColor whiteColor];
    nextButton.enabled = YES;
    nextButton.hidden = NO;
    if ([questionArray[[quesNo integerValue]][@"type"] integerValue] <= 2) {
        quesTable.hidden = NO;
        ansView.hidden = YES;
    }
    else {
        quesTable.hidden = YES;
        ansView.hidden = NO;
        if ([questionArray[[quesNo integerValue]][@"answer"] count]>0) {
            ansView.text = questionArray[[quesNo integerValue]][@"answer"][0];
        }
        else{
            ansView.text = @"";
        }
    }
    [quesTable reloadData];
}

-(IBAction)submitAction:(id)sender {
    for(int i=0;i<[questionArray count];i++) {
        //NSLog(@"Question : %@",questionArray[i][@"question"]);
        //NSLog(@"Answer : %@",questionArray[i][@"answer"]);
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Are you sure you want to submit the quiz?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes",nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSMutableArray *finalAns = [[NSMutableArray alloc] init];
        for(int i=0;i<[questionArray count];i++) {
            NSMutableDictionary * help = [[NSMutableDictionary alloc] init];
            [help setObject:questionArray[i][@"id"] forKey:@"question_id"];
            NSMutableArray *responseArray = (NSMutableArray *)questionArray[i][@"answer"];
            
            if ([questionArray[i][@"type"] integerValue] <= 2) {
                for (int j=0;j<[responseArray count] ; j++) {
                    NSMutableArray *optArray = questionArray[i][@"options"];
                    int temp = [[responseArray objectAtIndex:j] integerValue];
                    responseArray[j] = [optArray objectAtIndex:temp][@"id"];
                }
            }
            [help setObject:responseArray forKey:@"response"];
            [finalAns addObject:help];
        }
        NSMutableDictionary * subDic = [[NSMutableDictionary alloc] init];
        [subDic setObject:@"500" forKey:@"submit_time"];
        [subDic setObject:finalAns forKey:@"submission"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *submission = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [submission stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"DATA : %@",submission);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bodhitree3.cse.iitb.ac.in:8080/api/quiz/submit?key=123&uniq_id=%@&quiz_id=%@",_uniqueID,_quizID]]];
        [request setHTTPBody:jsonData];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (theConnection) {
            NSLog(@"connected");
        } else {
            NSLog(@"not connected");
            [self.view makeToast:@"Check your internet connection"];
        }
        
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData *receivedData=[[NSMutableData alloc]init];
    [receivedData appendData:data];
    NSDictionary *help = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil];
    NSLog(@"response: %@",help);
    NSString *errormsg = [NSString stringWithFormat:@"%@",help[@"error"]];

    if ([errormsg isEqualToString:@"0"]) {
        if(![help[@"message"] isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:help[@"message"]
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        if ([help[@"show_result"] integerValue] == 1) {
            summaryViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"summaryViewController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            navigationController.navigationBarHidden  = YES;
            viewController.quizID = _quizID;
            viewController.uniqueID = _uniqueID;
            viewController.stu_id = _stu_id;
            viewController.stu_name = _stu_name;
            viewController.msg = help[@"message"];
            
            [self presentViewController:navigationController animated:NO completion:nil];
        }
        else {
            questionView.hidden = YES;
            qNoLabel.text = @"Done";
            prevButton.hidden = YES;
            nextButton.hidden = YES;
            ansView.hidden = YES;
            quesTable.hidden = YES;
        }
    }
    else {
        [self.view makeToast:help[@"message"]];
    }
}

-(IBAction)textEditingAction:(id)sender {
    UITextField * help = (UITextField *) sender;
    NSLog(@"%@",help.text);
    questionArray[[quesNo integerValue]][@"answer"] = [[NSMutableArray alloc] initWithObjects:help.text, nil];
}

////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
