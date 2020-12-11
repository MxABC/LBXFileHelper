//
//  MainViewController.m
//  FileHelperDemo
//
//  Created by 夏利兵 on 2020/11/4.
//

#import "MainViewController.h"
#import "LBXFileHelper.h"
#import <SSZipArchive.h>
#import <AFNetworking.h>

@interface MainViewController ()
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColor.whiteColor;
    
//    [self testFile];
//
//    [self testZip];
    
//    [self testDownLoadFile];
    
    [self testFile2];
}

- (void)testZip
{
    NSString *srcPath = [LBXFileHelper mainBundlePath];
    srcPath = [srcPath stringByAppendingPathComponent:@"res.zip"];
    
    NSString *docPath = [LBXFileHelper documentDir];
    docPath = [docPath stringByAppendingPathComponent:@"res.zip"];
    
    [LBXFileHelper copyFileFromPath:srcPath toPath:docPath];
    
    
    NSString* tmpPath = [LBXFileHelper tmpDir];
    tmpPath = [tmpPath stringByAppendingPathComponent:@"res.zip"];
    
    [LBXFileHelper copyFileFromPath:docPath toPath:tmpPath];
    
    NSString *unZipDir = [LBXFileHelper tmpDir];
    

    [SSZipArchive unzipFileAtPath:tmpPath toDestination:unZipDir progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        
        NSLog(@"process");
        
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        
        //解压成功,删除tmp临时文件  path == tmpPath
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        if (!succeeded) {
            NSLog(@"解压失败");
        }
    }];
}

- (void)testFile
{
    NSString *srcPath = [LBXFileHelper mainBundlePath];
    srcPath = [srcPath stringByAppendingPathComponent:@"resource.bundle"];
  
    NSString* tmpDir = [LBXFileHelper tmpDir];
    
    NSString *dstPath1 = [tmpDir stringByAppendingPathComponent:@"resource"];
    [LBXFileHelper copyFolderFromPath:srcPath toPath:dstPath1];
    
    NSString *dstPath2 = [tmpDir stringByAppendingPathComponent:@"resource1"];
    [LBXFileHelper copyFolderFromPath:srcPath toPath:dstPath2];

    
    NSString *dstPath3 = [tmpDir stringByAppendingPathComponent:@"resource2"];
    [LBXFileHelper moveFolderFromPath:dstPath2 toPath:dstPath3];
        
    
    NSString *filePath = [dstPath1 stringByAppendingPathComponent:@"README.md"];
    unsigned long long fileSize = [LBXFileHelper fileSizeAtPath:filePath];
    
    NSLog(@"file Size:%llu bytes",fileSize);
    
    fileSize = [LBXFileHelper fileSizeAtPath:dstPath1];
    
    NSLog(@"folder Size:%llu bytes",fileSize);
    
    NSArray *array = [LBXFileHelper allFileNamesAtFolder:dstPath1];
    
    for (NSString* fileName in array) {
        NSLog(@"fileName:%@",fileName);
    }
}

- (void)testFile2
{
    NSString *srcPath = [LBXFileHelper mainBundlePath];
    srcPath = [srcPath stringByAppendingFormat:@"/resource.bundle/sub1/README1.md"];
  
    NSString* tmpDir = [LBXFileHelper tmpDir];
    
    NSString *dstPath = [tmpDir stringByAppendingFormat:@"/signleFile/README1.md"];
    [LBXFileHelper copyFileFromPath:srcPath toPath:dstPath];
       
}

- (void)unzipWithSrcPath:(NSString*)srcPath dstDir:(NSString*)dstDir
{
    if ([LBXFileHelper createFolder:dstDir]){
        
        [SSZipArchive unzipFileAtPath:srcPath toDestination:dstDir progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            
            NSLog(@"process");
            
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
            
            NSLog(@"解压:%@",succeeded ? @"成功":error);
            
        }];
    }
}

- (void)testDownLoadFile
{
    NSString *downUrl = @"http://192.168.0.109:8080/xlb.zip";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[downUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSString *fileName  =  @"DownResource.zip";
    
    NSString *docStorePath = [[LBXFileHelper documentDir]stringByAppendingPathComponent:fileName];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

        //删除之前的旧文件
        [LBXFileHelper deleteFileAtPath:docStorePath];
        
        //返回下载存储文件路径
        NSURL *dstURL = [NSURL fileURLWithPath:docStorePath];
        return dstURL;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
             
        if (error) {
            NSLog(@"下载失败");
            return;
        }
        
        //和docStorePath一致
        NSLog(@"下载成功-存储路径：%@",filePath);
        
        //tmp 存储下载资源目录
        NSString *tmpResourcePath =  [[LBXFileHelper tmpDir]stringByAppendingPathComponent:@"DownResource.zip"];
        
        //移除旧的Temp下资源文件
        [LBXFileHelper deleteFileAtPath:tmpResourcePath];
        
        //从doc 拷贝到 tmp
        if ([LBXFileHelper copyFileFromPath:filePath.path toPath:tmpResourcePath]) {
            
            //解压缩
            NSString *dstDir = [[LBXFileHelper tmpDir]stringByAppendingPathComponent:@"unzip"];
            [LBXFileHelper deleteFolderPath:dstDir];
            [self unzipWithSrcPath:tmpResourcePath dstDir:dstDir];
        }
        else
        {
            NSLog(@"copy to tmp dir fail");
        }
    }];
    self.downloadTask = downloadTask;
    [downloadTask resume];
}

@end
