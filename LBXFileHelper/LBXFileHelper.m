//
//  LBXFileManager.m
//  LBXKit
//
//  Created by lbx on 2017/11/8.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "LBXFileHelper.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@implementation LBXFileHelper


#pragma mark- 系统路径目录

+ (NSString*)homeDir
{
    return NSHomeDirectory();
}

+ (NSString*)documentDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths lastObject];
    return docDir;
}

+ (NSString*)cachesDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

+ (NSString*)libraryDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

+ (NSString*)tmpDir
{
    return NSTemporaryDirectory();
}


#pragma mark- 获取磁盘容量
+ (long long)getDiskTotalSize
{
    //和系统设置里面的显示的总容量和可用容量有少许出入
    //系统设置里面的总容量比下面的代码获取的容量大，但是可用容量比下面代码或的又少一点，查看微信里面也是如此
    
    long long totalSize = 0;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *systemAttributes = [[NSFileManager defaultManager]attributesOfFileSystemForPath:paths.lastObject error:nil];
    
    NSString *diskTotalSize = systemAttributes[NSFileSystemSize];
    
    totalSize =  [diskTotalSize longLongValue];
    
//    NSLog(@"磁盘大小：%.2f GB", totalSize/1024);
    
    return totalSize;
}

+ (long long)getDiskFreeSize
{    
    //和系统设置里面的显示的总容量和可用容量有少许出入
    //系统设置里面的总容量比下面的代码获取的容量大，但是可用容量比下面代码或的又少一点，查看微信里面获取的容量也是如此
    
    long long freeSize = 0;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *systemAttributes = [[NSFileManager defaultManager]attributesOfFileSystemForPath:paths.lastObject error:nil];
    
    NSString *diskFreeSize = systemAttributes[NSFileSystemFreeSize];
    
    freeSize = [diskFreeSize longLongValue];
    
    return freeSize;
}

+ (NSString*)stringWithBytes:(int64_t)size
{
    float unitMB = 1024*1024*1.0;
    float unitGB = unitMB *1024;
    
    if (size > unitGB) {
        return [NSString stringWithFormat:@"%.1fG",size/unitGB];
    }
    
    return [NSString stringWithFormat:@"%.1fM",size/unitMB];
}

#pragma mark- 文件处理

+ (unsigned long long) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    unsigned long long filesize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        filesize = [[fileDic objectForKey:NSFileSize] unsignedLongLongValue];
    }
    return filesize;
}

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    if (!path) {
        return NO;
    }
    return  [[NSFileManager defaultManager]fileExistsAtPath:path];
}

/// 创建文件
/// @param path 文件路径
+ (BOOL)createFileAtPath:(NSString*)path
{
    if (!path) {
        return NO;
    }
    
    if( [[NSFileManager defaultManager]fileExistsAtPath:path] )
        return YES;
    
    return  [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
}

/// 删除文件或文件夹(包含文件内所有文件)
/// @param path 文件或文件夹路径
+ (BOOL)deleteFileAtPath:(NSString *)path
{
    BOOL success = YES;
    if ( [self fileExistsAtPath:path] )
    {
        NSError *error = nil;
        success = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
        if (error) {
//            NSLog(@"deleteFileAtPath error:%@",error);
        }
        if (success) {
            
//            NSLog(@"文件删除成功");
        }
        return success;
    }
    return success;
}

/// 移动文件，源文件夹会被删除，目标文件夹需要的路径会自动创建
/// @param srcPath 源文件路径
/// @param dstPath 目标文件路径
+ (BOOL)moveFileFromPath:(NSString*)srcPath toPath:(NSString*)dstPath
{
    return [self moveFolderFromPath:srcPath toPath:dstPath];
}

/// 拷贝文件夹，目标文件夹已经存在会被删除，需要的路径会自动创建
/// @param srcPath 源文件路径
/// @param dstPath 目标文件夹
+ (BOOL)copyFileFromPath:(NSString*)srcPath toPath:(NSString*)dstPath
{
    return [self copyFolderFromPath:srcPath toPath:dstPath];
}

+ (void)copyFileFromPath2:(NSString *)srcPath toPath:(NSString *)dstPath
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:srcPath error:nil];
    
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [srcPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        NSString *fullToPath = [dstPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        //判断是不是文件夹
        BOOL isFolder = NO;
        
        //判断是不是存在路径 并且是不是文件夹
        BOOL isExist = [fileManager fileExistsAtPath:fullPath isDirectory:&isFolder];
        
        if (isExist)
        {
            NSError *err = nil;
            
            [[NSFileManager defaultManager] copyItemAtPath:fullPath toPath:fullToPath error:&err];
            
            if (err) {
//                NSLog(@"%@",err);
            }
            
            if (isFolder)
            {
                [self copyFileFromPath:fullPath toPath:fullToPath];
            }
        }
    }
}


/// 文件或文件夹属性
/// @param path 文件(文件夹)路径
+ (NSDictionary*)fileAttriutes:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
        
        return fileAttributes;
    }
    return nil;
}


/// 文件或文件夹大小 Bytes
/// @param path 文件(文件夹)路径
+ (unsigned long long)fileSizeAtPath:(NSString*)path
{
   
    //文件管理者
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断字符串是否为文件/文件夹
    BOOL dir = NO;
    BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&dir];
    //文件/文件夹不存在
    if (exists == NO) return 0;
    //self是文件夹
    if (dir){
        //遍历文件夹中的所有内容
        NSArray *subpaths = [fileManager subpathsAtPath:path];
        //计算文件夹大小
        NSInteger totalByteSize = 0;
        for (NSString *subpath in subpaths){
            //拼接全路径
            NSString *fullSubPath = [path stringByAppendingPathComponent:subpath];
            //判断是否为文件
            BOOL dir = NO;
            [fileManager fileExistsAtPath:fullSubPath isDirectory:&dir];
            if (dir == NO){//是文件
//                NSDictionary *attr = [fileManager attributesOffItemAtPath:fullSubPath error:ni];
                NSDictionary *attr = [fileManager attributesOfItemAtPath:fullSubPath error:nil];
                totalByteSize += [attr[NSFileSize] longLongValue];
            }
        }
        return totalByteSize;
    } else{//是文件
        NSDictionary *attr = [fileManager attributesOfItemAtPath:path error:nil];
        return [attr[NSFileSize] longLongValue];
    }
    
}

#pragma mark- 读写操作


#pragma mark- 文件夹操作

/// 拷贝文件夹，目标文件夹已经存在会被删除，需要的路径会自动创建
/// @param srcPath 源文件路径
/// @param dstPath 目标文件夹
+ (BOOL)copyFolderFromPath:(NSString*)srcPath toPath:(NSString*)dstPath
{
    if( ![[NSFileManager defaultManager] fileExistsAtPath:srcPath] )
    {
        return NO;
    }
    
    //目标文件夹最后一级，不能存在,否则会报错
    //Cannot make directory /private/.../tmp/h5Resource: File exists
    if( [[NSFileManager defaultManager] fileExistsAtPath:dstPath] )
    {
        if( ![[NSFileManager defaultManager] removeItemAtPath:dstPath error:nil] )
        {
            return NO;
        }
    }
    
    //目标文件夹路径，倒数第二级以及之前的文件夹，必须存在，不存在需要创建
    NSString *prePath = [dstPath stringByDeletingLastPathComponent];
    if ( [self createFolder:prePath] )
    {
        NSError* err = nil;
        BOOL success = [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:&err];
        
        return success;
    }
    return NO;
}

/// copy文件，单个文件进行copy,目标文件夹已经存在也可以
/// @param srcPath 源文件路径
/// @param dstPath 目标文件夹
+ (BOOL)copyFolder2FromPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
    if( ![[NSFileManager defaultManager] fileExistsAtPath:srcPath] )
    {
        return NO;
    }
   
    if ( ![self createFolder:dstPath] ) {
        return NO;
    }
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:srcPath error:nil];
    
    for( int i = 0; i<[array count]; i++ )
    {
        NSString *fullPath = [srcPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        NSString *fullToPath = [dstPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        //判断是不是文件夹
        BOOL isFolder = NO;
        
        //判断是不是存在路径 并且是不是文件夹
        BOOL isExist = [fileManager fileExistsAtPath:fullPath isDirectory:&isFolder];
        
        if (isExist)
        {
            NSError *err = nil;
            
            [[NSFileManager defaultManager] copyItemAtPath:fullPath toPath:fullToPath error:&err];
            
            if (err) {
//                NSLog(@"%@",err);
                return NO;
            }
            
            if (isFolder)
            {
                return [self copyFolder2FromPath:fullPath toPath:fullToPath];
            }
        }
    }
    return YES;
}


/// 移动文件夹，源文件夹会被删除，目标文件夹需要的路径会自动创建
/// @param srcPath 源文件路径
/// @param dstPath 目标文件夹
+ (BOOL)moveFolderFromPath:(NSString*)srcPath toPath:(NSString*)dstPath
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:srcPath])
    {
        return NO;
    }
    
    //目标文件夹最后一级，不能存在,否则会报错
    //Cannot make directory /private/.../tmp/h5Resource: File exists
    if([[NSFileManager defaultManager] fileExistsAtPath:dstPath])
    {
        if( ![[NSFileManager defaultManager] removeItemAtPath:dstPath error:nil] )
        {
            return NO;
        }
    }
    
    //目标文件夹路径，倒数第二级以及之前的文件夹，必须存在，不存在需要创建
    NSString *prePath = [dstPath stringByDeletingLastPathComponent];
    if ([self createFolder:prePath])
    {
        NSError* err = nil;
//        BOOL success = [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:&err];
        
        BOOL success = [[NSFileManager defaultManager]moveItemAtPath:srcPath toPath:dstPath error:&err];
        
        return success;
    }
    
    return NO;
}


/// 删除文件夹或文件
/// @param path 文件(文件夹路径)
+ (BOOL)deleteFolderPath:(NSString*)path
{
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return  [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
    }
    return YES;
}


/// 根据文件夹路径，不存在路径即去创建
/// @param folderPath 文件夹路径
+ (BOOL)createFolder:(NSString*)folderPath
{
    BOOL isDirectory = NO;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDirectory];
    
    if (exist && isDirectory) {
        return YES;
    }
    //withIntermediateDirectories  YES，会创建中间不存在的路径
    BOOL successCreate = [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    return successCreate;
}

/// 根据文件夹路径，不存在路径即去创建
/// @param folderPath 文件夹路径
+ (BOOL)createCustomFolder:(NSString*)folderPath
{
    if ( [[NSFileManager defaultManager] fileExistsAtPath:folderPath] )
        return YES;
    
    NSString *prePath = [folderPath stringByDeletingLastPathComponent];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:prePath]) {
        //上一级存在，创建当前级文件夹即可
        BOOL successCreate = [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
        return successCreate;
    }
    else
    {
        return [self createFolder:prePath];
    }
    
    return YES;
}

/// 获取文件夹所有文件名称
/// @param folderPath 文件路径
+ (NSArray*)allFileNamesAtFolder:(NSString*)folderPath
{
    
    NSArray *filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath
    error:nil];
    
    return filesArray ? filesArray :@[];
}


/// 获取文件夹所有文件路径
/// @param folderPath 文件路径
+ (NSArray*)allFilePathsAtFolder:(NSString*)folderPath
{
    
    NSArray *filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath
    error:nil];
    
    if (filesArray) {
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:filesArray.count];
        
        for (int i = 0; i < filesArray.count; i++) {
            
            NSString *fullPath = [folderPath stringByAppendingPathComponent:filesArray[i]];
            [array addObject:fullPath];
        }

        return array;
    }
    
    return @[];
}


#pragma mark- bundle

+ (NSString*)mainBundlePath
{
    NSString *bundleDir = [[NSBundle mainBundle] bundlePath];
    return bundleDir;
}

+ (NSString*)curBundlePath
{
    return  [[NSBundle bundleForClass:self.class] bundlePath];
}


#pragma mark- 设置文件不需要iCloud备份

+ (void)skipDocumentBackUpiCloud
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* docPath = [documentPaths objectAtIndex:0];
    [self skipBackupiCloudAtFile:docPath];
}

/**
 *屏蔽iOS文件或文件夹不备份到icloud
 */
+ (BOOL)skipBackupiCloudAtFile:(NSString *)filePath
{
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath: [fileURL path]])
    {
        return YES;
    }
    
    NSError *error = nil;
    BOOL success = [fileURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];

    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [fileURL lastPathComponent], error);
    }
    return success;
}

#pragma mark -各种路径截取参考
+ (void)pathComponet
{
    //    createFileAtPath
    
    
    //对路径截取的9种操作
    NSString* filePath=@"/private/var/mobile/Containers/Data/Application/BF89C2F2-FBE8-436E-A1FB-18648F445DEF/tmp/h5Resource/html/h52.html";
    //    NSString* filePath=@"/private/var/mobile/Containers/Data/Application/BF89C2F2-FBE8-436E-A1FB-18648F445DEF/tmp/h5Resource/html";
    
    //文件路径最后一级
    NSLog(@"1=%@",[filePath lastPathComponent]);
    
    //文件路径除掉最后一级
    NSLog(@"2=%@",[filePath stringByDeletingLastPathComponent]);
    
    //文件扩展名称，如果 docx pdf html
    NSLog(@"3=%@",[filePath pathExtension]);
    
    //删除文件扩展
    NSLog(@"4=%@",[filePath stringByDeletingPathExtension]);
    
    
    NSLog(@"5=%@",[filePath stringByAbbreviatingWithTildeInPath]);
    
    //    将路径中的代字符扩展成用户主目录（~）或指定用户主目录（~user）
    NSLog(@"6=%@",[filePath stringByExpandingTildeInPath]);
    
    //通过尝试解析~、..、.、和符号链接来标准化路径
    NSLog(@"7=%@",[filePath stringByStandardizingPath]);
    
    //尝试解析路径中的符号链接
    NSLog(@"8=%@",[filePath stringByResolvingSymlinksInPath]);
    
    //文件名称，不包含扩展名
    NSLog(@"9=%@",[[filePath lastPathComponent] stringByDeletingPathExtension]);
    
    
    filePath = [filePath stringByAppendingPathComponent:@"sub"];
    
}


@end
