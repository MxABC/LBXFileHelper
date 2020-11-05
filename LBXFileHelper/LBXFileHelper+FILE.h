//
//  LBXFileManager+FILE.h
//
//
//  Created by lbxia on 2020/11/4.
//  Copyright © 2020 com.lbx. All rights reserved.
//

#import "LBXFileHelper.h"
#import <UIKit/UIKit.h>


/// C语言文件接口封装
@interface LBXFileHelper (FILE)

/// 打开文件(不存在则创建并打开)
/// @param path 文件路径
/// @param openMode 打开模式，与C语言接口mode一致
///       如： "a" :追加，"rb":二进制读  ,"wb":二进制写
///
+ (FILE*)openAtPath:(NSString*)path mode:(const char*)openMode;

+ (void)closeAtFile:(FILE**)file;

+ (BOOL)deleteAtPath:(NSString *)path;

/// 从文件开始移动指定偏移量位置
/// @param file 文件指针
/// @param offset 偏移量
+ (int)seek:(FILE*)file offset:(int)offset;

+ (size_t)writeAtFile:(FILE*)file data:(NSData*)data;

+ (size_t)writeAtFile:(FILE*)file data:(const char *)data size:(size_t)size;

+ (NSData*)readAtFile:(FILE*)file size:(size_t)size;

#pragma mark- 文件大小
+ (size_t)fileSizeAtFile:(FILE*)file;

+ (size_t)fileSizeAtPath:(NSString*)path;

@end


