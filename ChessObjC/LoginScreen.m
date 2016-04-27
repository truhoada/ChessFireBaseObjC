//
//  LoginScreen.m
//  ChessObjC
//
//  Created by hoangdangtrung on 4/18/16.
//  Copyright © 2016 hoangdangtrung. All rights reserved.
//

#import "LoginScreen.h"
#import <Firebase/Firebase.h>
#import "PlayScreen.h"

static NSString * const kFirebaseURL = @"https://chess-techmaster.firebaseio.com/";


@interface LoginScreen ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnSignOut;

@property(nonatomic, strong) Firebase *ref;
@property(nonatomic, strong) Firebase *currentUser;
@property(nonatomic, strong) UIAlertController *alertController;


@end

@implementation LoginScreen {
    NSString *colorPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    colorPlayer = @"white";
    
    self.textFieldEmail.delegate = self;
    self.textFieldPassword.delegate = self;
    
    
    self.ref = [[Firebase alloc] initWithUrl:kFirebaseURL];
    
    //    NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    //    self.currentUser = [[[[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@", self.ref]] childByAppendingPath:@"users"] childByAppendingPath:userID];
    self.textFieldEmail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUserName"];
    self.textFieldPassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Quit" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = myBackButton;
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

- (IBAction)doSignInButton:(id)sender {
    NSString *email = self.textFieldEmail.text;
    NSString *password = self.textFieldPassword.text;
    
    [self loginWithEmail:email andPassword:password];
}

- (IBAction)doSignUpButton:(id)sender {
    NSString *email = self.textFieldEmail.text;
    NSString *password = self.textFieldPassword.text;
    
    if (![email  isEqual: @""] && ![password  isEqual: @""]) {
        [self.ref createUser:email password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
            if (error == nil) {
                [self showAlertWithTitle:@"Sign Up Success" andMessage:@"Sign In Now"];
            } else {
                NSString *err = error.localizedDescription;
                NSRange errRange = [err rangeOfString:@")"];
                err = [err substringFromIndex:errRange.location+2];
                
                [self showAlertWithTitle:@"Fail" andMessage:err];
                //https://www.firebase.com/docs/web/guide/user-auth.html#section-full-error
            }
        }];
    } else {
        [self showAlertWithTitle:@"Fail" andMessage:@"Miss Email or Password"];
    }
}

- (IBAction)doPlayButton:(id)sender {
    PlayScreen *playScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayScreen"];
    
    if ([self.textFieldEmail.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUserName"]]) {
        playScreen.currentPlayer = self.textFieldEmail.text;
        playScreen.colorPlayer = colorPlayer;
        [self.navigationController pushViewController:playScreen animated:YES];
    } else {
        [self showAlertWithTitle:@"Please Sign In" andMessage:nil];
    }
    
    
}

//- (IBAction)doSignOutButton:(id)sender {
//}

- (void)loginWithEmail:(NSString*)email andPassword:(NSString*)pass {
    if (![email  isEqual: @""] && ![pass  isEqual: @""]) {
        [self.ref authUser:email password:pass withCompletionBlock:^(NSError *error, FAuthData *authData) {
            if (error == nil) {
                [[NSUserDefaults standardUserDefaults] setValue:authData.uid forKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"currentUserName"];
                [[NSUserDefaults standardUserDefaults] setValue:pass forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setValue:pass forKey:email];
                
                [self showAlertWithTitle:@"Sign In Success" andMessage:@"Press PLAY now"];
                
            } else {
                NSString *err = error.localizedDescription;
                NSRange errRange = [err rangeOfString:@")"];
                err = [err substringFromIndex:errRange.location+2];
                
                [self showAlertWithTitle:@"Sign In Fail" andMessage:err];
            }
        }];
    } else {
        [self showAlertWithTitle:@"Sign In Fail" andMessage:@"Miss Email or Password"];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:self.textFieldEmail.text]) {
         self.textFieldPassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:self.textFieldEmail.text];
    }
   
    return YES;
}

- (void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)mess {
    self.alertController = [UIAlertController alertControllerWithTitle:title message:mess preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [self.alertController addAction:cancel];
    
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (IBAction)doSegmentControl:(UISegmentedControl *)sender {
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    if (selectedSegment == 0) {
        colorPlayer = @"white";
    }
    else{
        colorPlayer = @"black";
    }
}



@end





















