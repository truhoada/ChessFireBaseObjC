//
//  PlayScreen.m
//  ChessObjC
//
//  Created by hoangdangtrung on 4/18/16.
//  Copyright © 2016 hoangdangtrung. All rights reserved.
//

#import "PlayScreen.h"
#import "ChessObj.h"
#import "ChessView.h"
#import "LoginScreen.h"
#import <Firebase/Firebase.h>

static NSString * const kFirebaseURL = @"https://chess-techmaster.firebaseio.com/";

@interface PlayScreen ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *imgNextTurnPlayer;

@property(nonatomic, strong) Firebase *ref;
@property(nonatomic, strong) Firebase *currentUser;

@end

@implementation PlayScreen {
    CGFloat margin;
    CGFloat h0;
    UIView *containerView;
    CGFloat kCellWidth;
    NSMutableArray *currentPosition;
    NSArray *arrayNamesWhite;
    NSArray *arrayNamesBlack;

    NSMutableArray *baseArray;
    NSString *subNamePlayer;
    NSString *subNameRival;
    UIView *previousChess;
    bool lock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Funny Chess";
    
    [self setupValue];
    [self setupTableChess];
    [self addChessPlayerWithTag:100 andSubName:subNamePlayer];
    [self addChessRivalWithTag:200 andSubName:subNameRival];
    
    [self configFireBase];
    
    if ([subNameRival  isEqual: @"white"]) {
        lock = true;
        [self lockPlayerWithRow:0 withCol:0 andLock:true];
    }
    
    [self animateImageNextTurnPlayer];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)setupValue {
    margin = 10.0;
    h0 = 160.0;
    
    kCellWidth = 0.0;
    currentPosition= [[NSMutableArray alloc] initWithObjects:@0, @0, nil];
    arrayNamesWhite = @[@"Rook", @"Knight", @"Bishop", @"Queen", @"King", @"Pawn"];
    arrayNamesBlack = @[@"Rook", @"Knight", @"Bishop", @"King", @"Queen", @"Pawn"];
    
    if ([self.colorPlayer isEqualToString:@"white"]) {
        subNamePlayer = self.colorPlayer;
        subNameRival = @"";
    } else {
        subNameRival = @"white";
        subNamePlayer = @"";
    }

    baseArray = [[NSMutableArray alloc] initWithObjects:
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 nil];
    lock = false;
}


- (void)configFireBase {
    self.ref = [[Firebase alloc] initWithUrl:kFirebaseURL];
    [self.ref removeValue];
    [self.ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        for (FDataSnapshot *childSnap in snapshot.children.allObjects) {
            
            NSString *json = childSnap.value;
            if (json) {
                
                NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonTmp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSString *winner = jsonTmp[@"winner"];
                if (winner) {
                    [self showAlertWinnerWithName:winner];
                    return;
                }
                
                
                NSArray *arrayPosition = jsonTmp[@"chessPosition"];
                NSArray *arrayPreviousPosition = jsonTmp[@"previousChessPosition"];
                int tag = (7 - [arrayPreviousPosition[1] intValue]) + (7 - [arrayPreviousPosition[0] intValue])*8;
                if ([self.currentPlayer isEqualToString:jsonTmp[@"playerMove"]]) {
                    [self lockPlayerWithRow:[arrayPosition[0] intValue] withCol:[arrayPosition[1] intValue] andLock:true];
                    //
                    [self.view.layer removeAllAnimations];
                    lock = true;
                } else {
                    if (previousChess != nil) {
                        previousChess.layer.borderWidth = 0;
                    }
                    lock = false;
//                    Lock Player
                    [self lockPlayerWithRow:[arrayPosition[0] intValue] withCol:[arrayPosition[1] intValue] andLock:false];
                    ChessView *chess = [self.view viewWithTag:tag + 200];
                    if (chess) {
                        if (![baseArray[7 - [arrayPosition[0] intValue]][7 - [arrayPosition[1] intValue]]  isEqual: @0]) {
                            int tag = (7 - [arrayPosition[1] intValue]) + (7 - [arrayPosition[0] intValue])*8;
                            ChessView *chessRemove = [self.view viewWithTag:tag+100];
                            if (chessRemove) {
                                [chessRemove removeFromSuperview];
                            }
                        }
                        chess.center = CGPointMake(((CGFloat)(7 - [arrayPosition[1] intValue])*kCellWidth + kCellWidth/2), (CGFloat)((7 - [arrayPosition[0] intValue])*kCellWidth + kCellWidth/2));
                        chess.tag = 200 + (7 - [arrayPosition[1] intValue]) + (7 - [arrayPosition[0] intValue])*8;
                        if ([arrayPosition[0] intValue] == 0 && ([chess.nameChess isEqualToString:[chess convertToString:Pawn]] || [chess.nameChess isEqualToString:[NSString stringWithFormat:@"white%@", [chess convertToString:Pawn]]])) {
                            NSString *tempName = chess.nameChess;
                            NSRange textRange = [tempName rangeOfString:@"white"];
                            tempName = [tempName substringFromIndex:textRange.length];
                            if (chess.nameChess != tempName) {
                                chess.nameChess = @"whiteQueen";
                            } else {
                                chess.nameChess = @"Queen";
                            }
                            chess.imageView.image = [UIImage imageNamed:chess.nameChess];
                        }
                        previousChess = chess;
                        chess.layer.borderWidth = 2;
                        chess.layer.borderColor = [UIColor redColor].CGColor;
                    }
                    baseArray[7-[arrayPreviousPosition[0] intValue]][7 - [arrayPreviousPosition[1] intValue]] = @0;
                    baseArray[7 - [arrayPosition[0] intValue]][7 - [arrayPosition[1] intValue]] = @1;
                }
            }
        }
    }];
    
}


- (void)handlePan: (UIGestureRecognizer*)pan {
    
    ChessView *chess = (ChessView*)[pan view];
    chess.baseArray = baseArray;
    CGPoint position = [pan locationInView:containerView];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        chess.center = position;
        if (pan.state == UIGestureRecognizerStateBegan) {
            chess.layer.zPosition = 1;
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        int col = ceil(position.x/kCellWidth - 1);
        int row = ceil(position.y/kCellWidth - 1);
        int tag = 200 + col + row*8;
        
        if ((col<8 && row<8) && (col>=0 && row>=0) && (([chess calculatePositionWithCurrentPosition:currentPosition andDestinationPosition:@[[NSNumber numberWithInt:row], [NSNumber numberWithInt:col]]] == true))) {
            baseArray[[currentPosition[0] intValue]][[currentPosition[1] intValue]] = @0;
            chess.center= CGPointMake((CGFloat)col * kCellWidth + kCellWidth/2, (CGFloat)row * kCellWidth + kCellWidth/2);
            if ([baseArray[row][col]  isEqual: @0]) {
                baseArray[row][col] = @1;
                //[self sendData]//
                [self sendDataWithCurrentPosition:@[[NSNumber numberWithInt:row], [NSNumber numberWithInt:col]] withPreviousPosition:currentPosition andChess:chess];
                
            } else {
                ChessView *chessRemove = [self.view viewWithTag:tag];
                if (chessRemove) {
                    [chessRemove removeFromSuperview];
                    if ([chessRemove.nameChess isEqualToString:[chessRemove convertToString:King]] || [chessRemove.nameChess isEqualToString:[NSString stringWithFormat:@"%@%@", @"white", [chessRemove convertToString:King]]]) {
                        [self sendWinner];
                        return;
                    }
                    //[self sendData]//
                    [self sendDataWithCurrentPosition:@[[NSNumber numberWithInt:row], [NSNumber numberWithInt:col]] withPreviousPosition:currentPosition andChess:chess];
                } else {
                    chess.center= CGPointMake((CGFloat)([currentPosition[1] intValue]) * kCellWidth + kCellWidth/2, (CGFloat)([currentPosition[0] intValue]) * kCellWidth + kCellWidth/2);
                }
            }
            chess.tag = tag - 100;
        } else {
            chess.center= CGPointMake((CGFloat)([currentPosition[1] intValue]) * kCellWidth + kCellWidth/2, (CGFloat)([currentPosition[0] intValue]) * kCellWidth + kCellWidth/2);
        }
    }
}

- (void)sendDataWithCurrentPosition:(NSArray*)curPos withPreviousPosition:(NSArray*)prePos andChess:(ChessView*)chess {
   
    ChessObj *chessObj = [[ChessObj alloc] initWithNameChess:chess.nameChess withChessPosition:curPos withPreviousChessPosition:prePos withPlayerMove:self.currentPlayer andBaseArray:chess.baseArray];
    
    NSDictionary *dictChessObj = @{@"nameChess" : chessObj.nameChess, @"chessPosition" : chessObj.chessPosition, @"previousChessPosition" : chessObj.previousChessPosition, @"playerMove" : chessObj.playerMove};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictChessObj options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[self.ref childByAppendingPath:@"data"] setValue:json];
}

- (void)sendWinner {
    NSDictionary *dictWinner = @{@"winner" : self.currentPlayer};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictWinner options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[self.ref childByAppendingPath:@"data"] setValue:json];
}

- (void)reset {
    for (UIView *tmpChess in containerView.subviews) {
        ChessView *chess = (ChessView*)tmpChess;
        [chess removeFromSuperview];
    }
    [self addChessPlayerWithTag:100 andSubName:subNamePlayer];
    [self addChessRivalWithTag:200 andSubName:subNameRival];
}

- (void)lockPlayerWithRow:(int)row withCol:(int)col andLock:(BOOL)isLock {
    for (int rowIndex=0; rowIndex<8; rowIndex++) {
        for (int colIndex=0; colIndex<8; colIndex++) {
            int tag = 100 + colIndex + (rowIndex*8);
            ChessView *chessToLock = [self.view viewWithTag:tag];
            chessToLock.userInteractionEnabled = !isLock;
        }
    }
}

- (void)setupTableChess {
    self.labelPlayer.text = self.currentPlayer;
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - margin*2.0, self.view.bounds.size.width - margin*2.0)];
    
    containerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:containerView];
    containerView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
    kCellWidth = (self.view.bounds.size.width - margin*2.0)/8.0;
    for (int rowIndex=0; rowIndex<8; rowIndex++) {
        for (int colIndex=0; colIndex<8; colIndex++) {
            CGRect rect = CGRectMake((CGFloat)colIndex*kCellWidth, (CGFloat)rowIndex*kCellWidth, kCellWidth, kCellWidth);
            UIView *cell = [[UIView alloc] initWithFrame:rect];
            
            if (rowIndex%2 == 0) {
                cell.backgroundColor = (colIndex%2 == 0) ? [UIColor colorWithRed:255.0/255.0 green:206.0/255.0 blue:158.0/255.0 alpha:1] : [UIColor colorWithRed:209.0/255.0 green:139.0/255.0 blue:71.0/255.0 alpha:1];
            } else {
                cell.backgroundColor = (colIndex%2 == 0) ? [UIColor colorWithRed:209.0/255.0 green:139.0/255.0 blue:71.0/255.0 alpha:1] : [UIColor colorWithRed:255.0/255.0 green:206.0/255.0 blue:158.0/255.0 alpha:1];
            }
            [containerView addSubview:cell];
        }
    }
}


- (void)addChessPlayerWithTag: (int)tag andSubName: (NSString*)subName {
    for (int rowIndex=6; rowIndex<8; rowIndex++) {
        for (int colIndex=0; colIndex<8; colIndex++) {
            CGRect rect = CGRectMake((CGFloat)colIndex*kCellWidth, (CGFloat)rowIndex*kCellWidth, kCellWidth, kCellWidth);
            int tempCol = colIndex;
            if (tempCol > 4) {
                tempCol = (int)arrayNamesWhite.count - tempCol + 1;
            }
            NSString *name = @"";
            if (rowIndex == 7) {
                if ([subNamePlayer isEqualToString:@"white"]) {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesWhite[tempCol]];
                } else {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesBlack[tempCol]];
                }
            } else {
                if ([subNamePlayer isEqualToString:@"white"]) {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesWhite.lastObject];
                } else {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesBlack.lastObject];
                }
            }
            UIImage *img = [UIImage imageNamed:name];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
            imgView.image = img;
            
            ChessView *chess = [[ChessView alloc] initWithFrame:rect];
            chess.tag = tag + colIndex + rowIndex*8;
            chess.nameChess = name;
            baseArray[rowIndex][colIndex] = @1;
            chess.baseArray = baseArray;
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            
            pan.delegate = self;
            chess.imageView.image = img;
            [chess addGestureRecognizer:pan];
            [containerView addSubview:chess];
            
            
        }
    }
}

- (void)addChessRivalWithTag: (int)tag andSubName: (NSString*)subName {
    for (int rowIndex=0; rowIndex<2; rowIndex++) {
        for (int colIndex=0; colIndex<8; colIndex++) {
            CGRect rect = CGRectMake((CGFloat)colIndex*kCellWidth, (CGFloat)rowIndex*kCellWidth, kCellWidth, kCellWidth);
            int tempCol = colIndex;
            NSString *name = @"";
            if(tempCol > 4) {
                tempCol = (int)arrayNamesWhite.count - tempCol + 1;
            }
            if(rowIndex == 0) {
                if ([subNamePlayer isEqualToString:@"white"]) {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesWhite[tempCol]];
                } else {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesBlack[tempCol]];
                }
            }
            else {
                if ([subNamePlayer isEqualToString:@"white"]) {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesWhite.lastObject];
                } else {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesBlack.lastObject];
                }
            }
            UIImage *img = [UIImage imageNamed:name];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
            imgView.image = img;
            
            ChessView *chess = [[ChessView alloc] initWithFrame:rect];
            chess.tag = tag + colIndex + rowIndex*8;
            chess.nameChess = name;
            baseArray[rowIndex][colIndex] = @1;
            chess.baseArray = baseArray;
            
            chess.imageView.image = img;
            [containerView addSubview:chess];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint position = [touch locationInView:containerView];
    currentPosition[0] = [NSNumber numberWithFloat:floor(position.y/kCellWidth)];
    currentPosition[1] = [NSNumber numberWithFloat:floor(position.x/kCellWidth)];
    return true;
}


- (void)animateImageNextTurnPlayer {
    NSString *name;
    if (lock) {
        name = [subNameRival isEqualToString:@""] ? @"Pawn" : @"whitePawn";
    } else {
        name = [subNamePlayer isEqualToString:@""] ? @"Pawn" : @"whitePawn";
    }
    self.imgNextTurnPlayer.image = [UIImage imageNamed:name];
    self.imgNextTurnPlayer.alpha = 0;
    [UIView animateWithDuration:2 animations:^{
        self.imgNextTurnPlayer.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self animateImageNextTurnPlayer];
    }];
}

- (void)showAlertWinnerWithName: (NSString*)nameWinner {
    NSString *title;
    NSString *message;
    
    if ([nameWinner isEqualToString:self.currentPlayer]) {
        title = @"Congratulation!";
        message = @"You Win!";
    } else {
        title = @"Game Over";
        message = @"You lost";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end























