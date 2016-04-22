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
    NSArray *currentPosition;
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
    currentPosition = @[@0, @0];
    arrayNames = @[@"Rook", @"Knight", @"Bishop", @"Queen", @"King", @"Pawn"];
    //    baseArray = [NSArray ]
    //    Array(count: 8, repeatedValue: Array(count: 8, repeatedValue: 0))
    currentPlayer = @"Computer";
    currentRival = @"NoName";
    subNamePlayer = @"white";
    subNameRival = @"";
    baseArray = [NSMutableArray arrayWithObjects:
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

- (void)handlePan: (UIGestureRecognizer*)pan {
    NSLog(@"121");
}

@end























