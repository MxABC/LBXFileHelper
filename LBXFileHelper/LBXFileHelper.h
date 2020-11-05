//
//  LBXFileManager.h
//  LBXKit
//
//  Created by lbx on 2017/11/8.
//  Copyright © 2017年 lbx. All rights reserved.
#import <Foundation/Foundation.h>


/**
 获取硬盘大小及剩余空间，存储管理
 */
@interface LBXFileHelper : NSObject

#pragma mark- 各种路径目录获取,测试时,build每次目录会变

/**
 /Users/userName/Library/Developer/CoreSimulator/Devices/5FDB65E6-5AF5-4575-B513-ED4BFC016655/data/Containers/Data/Application/190DA528-3083-471B-B5E0-F8E2814E1042/Documents

 UUID "190DA528-3083-471B-B5E0-F8E2814E1042"
在Application与Documents之间的应该是根据可执行包生成的UUID，每次调试Build，这个UUID会变(但是之前保存的文件不会少，
 系统会帮助移动到新的路径下，或者理解为系统修改了UUID文件夹名称)
 ，所以可以存储文件名称或子路径，不能保存绝对固定路径，需要使用时，根据子路径或文件名称动态组装总路径
 */

+ (NSString*)homeDir;

+ (NSString*)documentDir;

+ (NSString*)cachesDir;

+ (NSString*)tmpDir;

+ (NSString*)libraryDir;


//各种路径截取,组装参考
+ (void)pathComponet;


#pragma mark- 获取磁盘容量
//和系统设置里面的显示的总容量和可用容量有少许出入
//系统设置里面的总容量比下面的代码获取的容量大，但是可用容量比下面代码或的又少一点，查看微信里面也是如此
//单位 Bytes
+ (long long)getDiskTotalSize;

//和系统设置里面的显示的总容量和可用容量有少许出入
//系统设置里面的总容量比下面的代码获取的容量大，但是可用容量比下面代码或的又少一点，查看微信里面获取的容量也是如此
//单位 Bytes
+ (long long)getDiskFreeSize;


+ (NSString*)stringWithBytes:(int64_t)size;


#pragma mark- 文件处理

+ (unsigned long long) getFileSize:(NSString *)path;

+ (BOOL)fileExistsAtPath:(NSString *)path;

/// 创建文件
/// @param path 文件路径
+ (BOOL)createFileAtPath:(NSString*)path;


/// 删除文件或文件夹(包含文件内所有文件)
/// @param path 文件或文件夹路径
+ (BOOL)deleteFileAtPath:(NSString *)path;

/// 移动文件夹，源文件夹会被删除，目标文件夹需要的路径会自动创建
/// @param srcPath 源文件路径
/// @param dstPath 目标文件夹
+ (BOOL)moveFileFromPath:(NSString*)srcPath toPath:(NSString*)dstPath;


/// 拷贝文件夹，目标文件夹已经存在会被删除，需要的路径会自动创建
/// @param srcPath 源文件路径
/// @param dstPath 目标文件夹
+ (BOOL)copyFileFromPath:(NSString*)srcPath toPath:(NSString*)dstPath;


/// 文件或文件夹属性
/// @param path 文件(文件夹)路径
+ (NSDictionary*)fileAttriutes:(NSString *)path;

/// 文件或文件夹大小 Bytes
/// @param path 文件(文件夹)路径
+ (unsigned long long)fileSizeAtPath:(NSString*)path;

#pragma mark- 文件夹操作

/// 拷贝文件夹，目标文件夹已经存在会被删除，需要的路径会自动创建
/// @param srcPath 源文件路径
/// @param dstPath 目标文件夹
+ (BOOL)copyFolderFromPath:(NSString*)srcPath toPath:(NSString*)dstPath;

/// copy文件，单个文件进行copy,目标文件夹已经存在也可以,不会被删除
/// @param srcPath 源文件路径
/// @param dstPath 目标文件夹
+ (BOOL)copyFolder2FromPath:(NSString *)srcPath toPath:(NSString *)dstPath;


/// 移动文件夹，源文件夹会被删除，目标文件夹需要的路径会自动创建
/// @param srcPath 源文件路径
/// @param dstPath 目标文件夹
+ (BOOL)moveFolderFromPath:(NSString*)srcPath toPath:(NSString*)dstPath;


/// 根据文件夹路径，不存在路径即去创建
/// @param folderPath 文件夹路径
+ (BOOL)createFolder:(NSString*)folderPath;

/// 根据文件夹路径，不存在路径即去创建
/// @param folderPath 文件夹路径
+ (BOOL)createCustomFolder:(NSString*)folderPath;

/// 删除文件夹或文件
/// @param path 文件(文件夹路径)
+ (BOOL)deleteFolderPath:(NSString*)path;

/// 获取文件夹所有文件及子文件夹名称
/// @param folderPath 文件路径
+ (NSArray*)allFileNamesAtFolder:(NSString*)folderPath;

/// 获取文件夹所有文件路径
/// @param folderPath 文件路径
+ (NSArray*)allFilePathsAtFolder:(NSString*)folderPath;


#pragma mark- bundle

+ (NSString*)mainBundlePath;

+ (NSString*)curBundlePath;

#pragma mark- 设置文件或文件夹不需要iCloud备份

///可在APP启动时调用,设置document目录不备份iCloud
+ (void)skipDocumentBackUpiCloud;
/**
 *屏蔽iOS文件或文件夹不备份到iCloud
 */
+ (BOOL)skipBackupiCloudAtFile:(NSString *)filePath;




@end
