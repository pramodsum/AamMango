//
//  LoginViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/13/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *docsDir;
    NSArray *dirPaths;

    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);

    docsDir = dirPaths[0];

    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"users.db"]];

    NSFileManager *filemgr = [NSFileManager defaultManager];

    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];

        if (sqlite3_open(dbpath, &_userDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";

            if (sqlite3_exec(_userDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                _status.text = @"Username or Password is incorrect!";
            }
            sqlite3_close(_userDB);
        } else {
            _status.text = @"Failed to open/create database";
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)login:(id)sender {
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;

    if (sqlite3_open(dbpath, &_userDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT username, password FROM users WHERE username=\"%@\"",
                              _username.text];

        const char *query_stmt = [querySQL UTF8String];

        if (sqlite3_prepare_v2(_userDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *usernameField = [[NSString alloc]
                                          initWithUTF8String:
                                          (const char *) sqlite3_column_text(
                                                                             statement, 0)];
                _username.text = usernameField;
                NSString *passwordField = [[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 1)];
                _password.text = passwordField;
                _status.text = @"Match found";
            } else {
                _status.text = @"Match not found";
                _username.text = @"";
                _password.text = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_userDB);
    }
//    sqlite3_stmt    *statement;
//    const char *dbpath = [_databasePath UTF8String];
//
//    if (sqlite3_open(dbpath, &_userDB) == SQLITE_OK)
//    {
//
//        NSString *insertSQL = [NSString stringWithFormat:
//                               @"INSERT INTO CONTACTS (name, address) VALUES (\"%@\", \"%@\")",
//                               _username.text, _password.text];
//
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(_userDB, insert_stmt,
//                           -1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            _status.text = @"Username added";
//            _username.text = @"";
//            _password.text = @"";
//        } else {
//            _status.text = @"Failed to add contact";
//        }
//        sqlite3_finalize(statement);
//        sqlite3_close(_userDB);
//    }
}
@end
