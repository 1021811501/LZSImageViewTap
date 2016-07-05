//
//  DownSheetCell.m
//  audioWriting
//
//  Created by wolf on 14-7-19.
//  Copyright (c) 2014年 wangruiyy. All rights reserved.
//

#import "DownSheetCell.h"

@implementation DownSheetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        self.InfoLabel = [[UILabel alloc]init];
        self.InfoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.InfoLabel];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.InfoLabel.frame = CGRectMake(0, 0, ScreenWidth, 43);
    self.InfoLabel.font = [UIFont systemFontOfSize:17];
    self.InfoLabel.textAlignment = NSTextAlignmentCenter;
    self.InfoLabel.textColor = [UIColor blackColor];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected){
        self.backgroundColor = [UIColor grayColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
              self.InfoLabel.textColor = [UIColor blackColor];
    }
   
}

@end

