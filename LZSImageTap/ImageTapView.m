//
//  ImageTapView.m
//  warenqi
//
//  Created by 李志帅 on 16/5/3.
//  Copyright © 2016年 Mr.Lin. All rights reserved.
//

#import "ImageTapView.h"
#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
@implementation ImageTapView
{
    UIImageView *imageView;
    UIViewController *VC;
    NSArray *dataArray;
    UITableView *table ;
}
-(id)initWithImageTapWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
        dataArray= @[@"保存到相册",@"取消"];
        [self createViewWithUrl:url];
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapgesture];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPress.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:longPress];
    }
    return self;
}
-(void)createViewWithUrl:(NSString *)url{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = RGBACOLOR(0 , 0, 0, 0.8);
    
    imageView = [[UIImageView alloc] init];
    imageView.center = self.center;
    imageView.bounds = CGRectMake(0, 0, 100, 100);
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
    [self addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                NSLog(@"%f,,%f",image.size.width,image.size.height);
                
                if (image.size.width > kScreenWidth) {
                    imageView.bounds = CGRectMake(0, 0, kScreenWidth, image.size.height/image.size.width * kScreenWidth);
                }
                else{
                    imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
                }
                
            }];
        });
    }];
}
- (void)showInView:(UIViewController *)Sview{
    if(Sview==nil){
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    }else{
        VC = Sview;
        Sview.navigationController.navigationBar.hidden = YES;
        [Sview.view addSubview:self];
    }

}
-(void)tapAction{
   [UIView animateWithDuration:0.25 animations:^{
       if (table) {
           table.frame = CGRectMake(0, kScreenHeight , kScreenWidth, 50*dataArray.count);
       }
       imageView.bounds = CGRectMake(0, 0, 0, 0);
   } completion:^(BOOL finished) {
       if (table) {
           [table removeFromSuperview];
       }
       VC.navigationController.navigationBar.hidden = NO;
       [self removeFromSuperview];
   }];
}
-(void)longPressAction:(UILongPressGestureRecognizer *)press{
    if (press.state == UIGestureRecognizerStateBegan) {
        if (!table) {
            [self createTableView];
            [self doAnimation];
        }
        return;
    }
}
-(void)createTableView{
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 50*dataArray.count)];
    table.delegate = self;
    table.dataSource = self;
    //解决tableView分割线左边不到边的情况
    if ([table respondsToSelector:@selector(setSeparatorInset:)])
    {
        [table setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([table respondsToSelector:@selector(setLayoutMargins:)])
    {
        [table setLayoutMargins:UIEdgeInsetsZero];
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:table];
//    [self addSubview:table];
//    [self addSubview:table]用这句话导致轻点手势和表didselectrow方法冲突didselectrow方法会不执行

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DownSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[DownSheetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.InfoLabel.text = dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self saveImageToPhotos:imageView.image];
    }
    [self tappedCancel];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tappedCancel{
    [UIView animateWithDuration:0.25 animations:^{
        table.frame = CGRectMake(0, kScreenHeight , kScreenWidth, 50*dataArray.count);
    } completion:^(BOOL finished) {
        table = nil;
        [table removeFromSuperview];
    }];
}
-(void)doAnimation{
    [UIView animateWithDuration:0.25 animations:^{
        table.frame = CGRectMake(0, kScreenHeight - 50 *dataArray.count, kScreenWidth, 50*dataArray.count);
    }];
}
-(void)saveImageToPhotos:(UIImage *)saveImage{
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSLog(@"%s",__FUNCTION__);
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[self class]]) {
        return YES;
    }else{
        return NO;
    }
}
@end
