//
//  LBXFileManager+FILE.m
//
//
//  Created by lbxia on 2020/11/4.
//  Copyright © 2020 com.lbx. All rights reserved.
//

#import "LBXFileHelper+FILE.h"

@implementation LBXFileHelper (FILE)



/// 打开文件
/// @param path 文件路径
/// @param openMode 打开模式，符合C语言接口
///       如： "a" :追加，"rb":二进制读  ,"wb":二进制写
///
+ (FILE*)openAtPath:(NSString*)path mode:(const char*)openMode
{
    FILE *file = fopen([path UTF8String], openMode);
    return file;
}

+ (void)closeAtFile:(FILE**)file
{
    if(file == nil) return;
    if(*file == nil) return;
    fclose(*file); *file = NULL;
}

+ (BOOL)deleteAtPath:(NSString *)path {
    return remove(path.UTF8String);
}

/// 从文件开始移动指定偏移量位置
/// @param file 文件指针
/// @param offset 偏移量
+ (int)seek:(FILE*)file offset:(int)offset
{
    return fseek(file, offset, SEEK_SET);
}

+ (size_t)writeAtFile:(FILE*)file data:(NSData*)data
{
    return fwrite(data.bytes, 1, data.length, file);
}

+ (size_t)writeAtFile:(FILE*)file data:(const char *)data size:(size_t)size {
    return fwrite(data, 1, size, file);
}

+ (NSData*)readAtFile:(FILE*)file size:(size_t)size
{
    char* buffer = (char*)malloc(size * sizeof(char));
    size = MAX(0, fread(buffer, 1, size, file));
    
    return   [NSData dataWithBytesNoCopy:buffer length:size freeWhenDone:YES];
}


#pragma mark- 文件大小
+ (size_t)fileSizeAtFile:(FILE*)file
{
    if (file == NULL) return 0;
    long curPos = ftell(file);
    fseek(file, 0, SEEK_END);
    long endPos = ftell(file);
    fseek(file, curPos, SEEK_SET);
    return endPos;
}

+ (size_t)fileSizeAtPath:(NSString*)path
{
    FILE *file = [self openAtPath:path mode:"rb"];
    if(file == NULL) return 0;
    long size = [self fileSizeAtFile:file];
    [self closeAtFile:&file];
    return size;
}

@end
