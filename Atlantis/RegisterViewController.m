//
//  JVFloatLabeledTextFieldViewController.m
//  JVFloatLabeledTextField
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Jared Verdi
//  Original Concept by Matt D. Smith
//  http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RegisterViewController.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "ServerComm.h"
#import "ViewController.h"

const static CGFloat kJVFieldHeight = 55.0f; //44
const static CGFloat kJVFieldHMargin = 10.0f; //10

const static CGFloat kJVFieldFontSize = 20.0f; //16

const static CGFloat kJVFieldFloatingLabelFontSize = 13.0f; //11

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Update Personal Info", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneRegister)
                                                 name:@"DoneRegister"
                                               object:nil];


    [self.view setTintColor:[UIColor blueColor]];
    
    CGFloat topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height + 85.0f;
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    CGFloat currentTopMargin = topOffset;
    
    JVFloatLabeledTextField *firstNameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, currentTopMargin, 140.0f, kJVFieldHeight)];
    firstNameField.tag = 0;
    firstNameField.placeholder = NSLocalizedString(@"First Name", @"");
    firstNameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    firstNameField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    firstNameField.floatingLabelTextColor = floatingLabelColor;
    firstNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    firstNameField.delegate = self;
    firstNameField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:firstNameField];
    
    // HORIZONTAL SPACER
//    currentTopMargin += kJVFieldHeight;
//    UIView *div1 = [UIView new];
//    div1.frame = CGRectMake(kJVFieldHMargin, currentTopMargin,
//                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
//    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
//    [self.view addSubview:div1];
    
    // VERTICAL SPACER
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(kJVFieldHMargin + firstNameField.frame.size.width,
                            currentTopMargin,
                            1.0f, kJVFieldHeight);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div1];
    
    // LAST NAME FIELD
    JVFloatLabeledTextField *lastNameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                            CGRectMake(kJVFieldHMargin + kJVFieldHMargin + firstNameField.frame.size.width + 1.0f,
                                                       currentTopMargin,
                                                       self.view.frame.size.width - 2 * kJVFieldHMargin,
                                                       kJVFieldHeight)];
    lastNameField.tag = 1;
    lastNameField.placeholder = NSLocalizedString(@"Last Name", @"");
    lastNameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    lastNameField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    lastNameField.floatingLabelTextColor = floatingLabelColor;
    lastNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    lastNameField.delegate = self;
    lastNameField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:lastNameField];
    
    // HORIZONTAL SPACER
    currentTopMargin += kJVFieldHeight;
    UIView *div2 = [UIView new];
    div2.frame = CGRectMake(kJVFieldHMargin, currentTopMargin,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div2];
    
    // ANDREW ID FIELD
    currentTopMargin += 4.0f;
    JVFloatLabeledTextField *andrewField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                              CGRectMake(kJVFieldHMargin, currentTopMargin, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    andrewField.tag = 2;
    andrewField.placeholder = NSLocalizedString(@"Andrew ID", @"");
    andrewField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    andrewField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    andrewField.floatingLabelTextColor = floatingLabelColor;
    andrewField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    andrewField.autocorrectionType = UITextAutocorrectionTypeNo;
    andrewField.clearButtonMode = UITextFieldViewModeWhileEditing;
    andrewField.delegate = self;
    andrewField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:andrewField];
    
    // HORIZONTAL SPACER
    currentTopMargin += kJVFieldHeight;
    UIView *div3 = [UIView new];
    div3.frame = CGRectMake(kJVFieldHMargin, currentTopMargin,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div3];
    
    // HORIZONTAL SPACER
//    UIView *divLN = [UIView new];
//    
//    currentTopMargin += lastNameField.frame.origin.y + lastNameField.frame.size.height;
//    divLN.frame = CGRectMake(kJVFieldHMargin, 50.0f,
//                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
//    divLN.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
//    [self.view addSubview:divLN];
    
    
    currentTopMargin += 4.0f;
    
    JVFloatLabeledTextField *heightField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, currentTopMargin, 80.0f, kJVFieldHeight)];
    heightField.tag = 3;
    heightField.placeholder = NSLocalizedString(@"Height", @"");
    heightField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    heightField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    heightField.floatingLabelTextColor = floatingLabelColor;
    heightField.keyboardType = UIKeyboardTypeNumberPad;
    heightField.delegate = self;
    heightField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:heightField];
    
    
    // VERTICAL SPACER
    UIView *div5 = [UIView new];
    div5.frame = CGRectMake(kJVFieldHMargin + heightField.frame.size.width,
                            115 + topOffset,
                            1.0f, kJVFieldHeight + 3.0f);
    div5.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div5];
    
    
    JVFloatLabeledTextField *hairField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                              CGRectMake(kJVFieldHMargin + kJVFieldHMargin + heightField.frame.size.width + 1.0f,
                                                         currentTopMargin,
                                                         self.view.frame.size.width - 3*kJVFieldHMargin - heightField.frame.size.width - 1.0f,
                                                         kJVFieldHeight)];
    hairField.tag = 4;
    hairField.placeholder = NSLocalizedString(@"Hair Color", @"");
    hairField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    hairField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    hairField.floatingLabelTextColor = floatingLabelColor;
    hairField.delegate = self;
    hairField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:hairField];
    
    UIView *div4 = [UIView new];
    div4.frame = CGRectMake(kJVFieldHMargin, heightField.frame.origin.y + heightField.frame.size.height,
                            self.view.frame.size.width - 2*kJVFieldHMargin, 1.0f);
    div4.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div4];
    
//    JVFloatLabeledTextView *descriptionField = [[JVFloatLabeledTextView alloc] initWithFrame:CGRectZero];
//    descriptionField.frame = CGRectMake(kJVFieldHMargin - descriptionField.textContainer.lineFragmentPadding,
//                                        div3.frame.origin.y + div4.frame.size.height,
//                                        self.view.frame.size.width - 2*kJVFieldHMargin + descriptionField.textContainer.lineFragmentPadding,
//                                        kJVFieldHeight*3);
//    descriptionField.placeholder = NSLocalizedString(@"Description", @"");
//    descriptionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
//    descriptionField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
//    descriptionField.floatingLabelTextColor = floatingLabelColor;
//    [self.view addSubview:descriptionField];
    
    [firstNameField becomeFirstResponder];
    
    
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
    
    if(textField.tag == 3){
    
        // All digits entered
        if (range.location == 5) {
            return NO;
        }
        
        // Reject appending non-digit characters
        if (range.length == 0 &&
            ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
        
        // Auto-add hyphen before appending 4rd or 7th digit
        if (range.length == 0 &&
            (range.location == 0)) {
            textField.text = [NSString stringWithFormat:@"%@%@'", textField.text, string];
            return NO;
        }
        
        if (range.length == 0 &&
            (range.location == 3)) {
            textField.text = [NSString stringWithFormat:@"%@%@\"", textField.text, string];
            // move the cursor to the 'hair color' text field
            UITextField *hairColor;
            for (int i = 0; i < self.view.subviews.count; i++){
                UIView *subview = self.view.subviews[i];
                if([subview isKindOfClass:[UITextField class]]) {
                    if (subview.tag == 4){
                        NSLog(@"found hair color");
                        hairColor = (UITextField *)subview;
                    }
                }
            }
            [hairColor becomeFirstResponder];
            return NO;
        }
        
        // Delete hyphen when deleting its trailing digit
        if (range.length == 1 &&
            (range.location == 1 || range.location == 4))  {
            range.location--;
            range.length = 2;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
        
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    UITextField *firstName, *lastName, *andrewID, *height, *hairColor;
    for (int i = 0; i < self.view.subviews.count; i++){
        UIView *subview = self.view.subviews[i];
        if([subview isKindOfClass:[UITextField class]]) {
            if (subview.tag == 0){
                NSLog(@"found first name");
                firstName = (UITextField *)subview;
                
            } else if(subview.tag == 1){
                NSLog(@"found last name");
                lastName = (UITextField *)subview;
            } else if (subview.tag == 2){
                NSLog(@"andrew");
                andrewID = (UITextField *)subview;
            } else if (subview.tag == 3){
                NSLog(@"height");
                height = (UITextField *)subview;
            } else if (subview.tag == 4){
                NSLog(@"hair color");
                hairColor = (UITextField *)subview;
            }
        }
    }

    if(theTextField==firstName){
        [lastName becomeFirstResponder];
    }
    if(theTextField==lastName){
        [andrewID becomeFirstResponder];
    }
    if(theTextField==andrewID){
        [height becomeFirstResponder];
    }
    if(theTextField==height){
        [hairColor becomeFirstResponder];
    }
    if(theTextField==hairColor){
        // TODO: VALIDATE FORM IS FILLED OUT CORRECTLY
        //ServerComm *serverComm = [[ServerComm alloc] init];
        //[serverComm registerUser:[firstName text]:[lastName text]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DoneRegister"
                                                            object:self];
    }
    return YES;
}



- (IBAction)buttonClicked:(id)sender {
    UITextField *firstName, *lastName;
    for (int i = 0; i < self.view.subviews.count; i++){
        UIView *subview = self.view.subviews[i];
        if([subview isKindOfClass:[UITextField class]]) {
            if (subview.tag == 0){
                NSLog(@"found first name");
                firstName = (UITextField *)subview;
            } else if(subview.tag == 1){
                NSLog(@"found last name");
                lastName = (UITextField *)subview;
            }
        }
    }
    NSLog([firstName text]);
    NSLog([lastName text]);
    
    // TODO: VALIDATE FORM IS FILLED OUT CORRECTLY
    ServerComm *serverComm = [[ServerComm alloc] init];
    serverComm.id = self.id;
    [serverComm registerUser:[firstName text]:[lastName text]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DoneRegister"
                                                        object:self];
        
}

- (void)doneRegister
{
    [self performSegueWithIdentifier:@"DoneRegisterSegue" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DoneRegisterSegue"]) {
        ViewController * con = [segue destinationViewController];
        con.id = self.id;
        NSLog(@"REG_VIEW_CON_VIEW");
        NSLog(self.id);
    } else {
            NSLog(@"Invalid segue attempted from JettaLoginViewController. ");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
