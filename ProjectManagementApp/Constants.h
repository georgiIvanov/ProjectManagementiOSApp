//
//  Constants.h
//  ProjectManagementApp
//
//  Created by Georgi Ivanov on 11/2/13.
//  Copyright (c) 2013 Georgi Ivanov. All rights reserved.
//

#ifndef ProjectManagementApp_Constants_h
#define ProjectManagementApp_Constants_h

#define DOMAIN_ROOT "https://projectmanagement-4.apphb.com/api/"

static const NSInteger ORGANIZATION_OWNER = 50;
static const NSInteger ORGANIZATION_MANAGER = 30;
static const NSInteger PROJECT_MANAGER = 20;
static const NSInteger SENIOR_EMPLOYEE = 15;
static const NSInteger EMPLOYEE = 10;
static const NSInteger JUNIOR_EMPLOYEE = 5;
static const NSInteger UNDETERMINED_ROLE = 0;


typedef NS_ENUM(NSInteger, Role){
    OrganizationOwner = ORGANIZATION_OWNER,
    OrganizationManager = ORGANIZATION_MANAGER,
    ProjectManager = PROJECT_MANAGER,
    SeniorEmployee = SENIOR_EMPLOYEE,
    Employee = EMPLOYEE,
    JuniorEmployee = JUNIOR_EMPLOYEE,
    Undetermined = UNDETERMINED_ROLE
};


#endif
