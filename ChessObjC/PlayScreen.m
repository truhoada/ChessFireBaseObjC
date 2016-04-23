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

@interface PlayScreen ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *imgNextTurnPlayer;

@end

@implementation PlayScreen {
    CGFloat margin;
    CGFloat h0;
    UIView *containerView;
    CGFloat kCellWidth;
    NSMutableArray *currentPosition;
    NSArray *arrayNames;
    NSMutableArray *baseArray;
    NSString *currentPlayer;
    NSString *currentRival;
    NSString *subNamePlayer;
    NSString *subNameRival;
    UIView *previousChess;
    bool lock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableChess];
    [self addChessPlayerWithTag:100 andSubName:subNamePlayer];
    [self addChessRivalWithTag:200 andSubName:subNameRival];
    
}

- (void)setupValue {
    margin = 10.0;
    h0 = 160.0;
    
    kCellWidth = 0.0;
    currentPosition= [[NSMutableArray alloc] initWithObjects:@0, @0, nil];
    arrayNames = @[@"Rook", @"Knight", @"Bishop", @"Queen", @"King", @"Pawn"];
    currentPlayer = @"Computer";
    currentRival = @"NoName";
    subNamePlayer = @"white";
    subNameRival = @"";
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

- (void)setupTableChess {
    self.labelPlayer.text = currentPlayer;
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
                tempCol = (int)arrayNames.count - tempCol + 1;
            }
            NSString *name = @"";
            if (rowIndex == 7) {
                name = [NSString stringWithFormat:@"%@%@", subName, arrayNames[tempCol]];
            } else {
                name = [NSString stringWithFormat:@"%@%@", subName, arrayNames.lastObject];
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
                tempCol = (int)arrayNames.count - tempCol + 1;
            }
            if(rowIndex == 0) {
                name = [NSString stringWithFormat:@"%@%@", subName, arrayNames[tempCol]];
            }
            else {
                name = [NSString stringWithFormat:@"%@%@", subName, arrayNames.lastObject];
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
                
                
            }
            else {
                ChessView *chessRemove = [self.view viewWithTag:tag];
                if (chessRemove) {
                    [chessRemove removeFromSuperview];
                    if ([chessRemove.nameChess isEqualToString:[chessRemove convertToString:King]] || [chessRemove.nameChess isEqualToString:[NSString stringWithFormat:@"%@%@", @"white", [chessRemove convertToString:King]]]) {
                        //[self sendWinner];//
                        return;
                    }
                    //[self sendData]//
                } else {
                    chess.center= CGPointMake((CGFloat)([currentPosition[1] intValue]) * kCellWidth + kCellWidth/2, (CGFloat)([currentPosition[0] intValue]) * kCellWidth + kCellWidth/2);
                }
            } 
            chess.tag = tag - 100;
        } else {
            chess.center= CGPointMake((CGFloat)([currentPosition[1] intValue]) * kCellWidth + kCellWidth/2, (CGFloat)([currentPosition[0] intValue]) * kCellWidth + kCellWidth/2);        }
    }
}

@end























