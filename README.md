🚀 Multi-Select in Object Page using RAP (Step-by-Step End-to-End Implementation)

________________________________________
🔹 Introduction
In SAP RAP (RESTful Application Programming Model), implementing a multi-select field in the Object Page is not as straightforward as adding a UI property.
Instead, it requires a clean architectural approach using:
•	✅ Composition (Parent–Child Model)
•	✅ Child Entity Records (for multi-values)
•	✅ Value Help Integration
•	✅ Draft-enabled Behavior Definition
In this blog, we will implement a Project → Multiple Users assignment scenario, where users can be selected dynamically and maintained using RAP best practices.
________________________________________
🔹 Business Requirement
We want to build:
Object	Requirement
Project	Maintain project details
Users	Assign multiple users to project
UI	Show users as multi-select values
System Behavior	Draft-enabled transactional flow
________________________________________
🔹 Step 1: Create Project Table
define table zhar_project {

  key mandt          : abap.clnt not null;
  key proj_id        : abap.numc(10) not null;
  name               : abap.char(40);
  uname              : abap.char(10);

  localcreatedby     : abp_creation_user;
  localcreatedat     : abp_creation_tstmpl;
  locallastchangedby : abp_locinst_lastchange_user;
  locallastchangedat : abp_locinst_lastchange_tstmpl;
  lastchangedat      : abp_lastchange_tstmpl;

}

Step 2: Generate ABAP Repository Objects
 
<img width="974" height="759" alt="image" src="https://github.com/user-attachments/assets/a3f3ca69-6230-43ef-a2cb-cb2d0bae5fa0" />

<img width="975" height="1210" alt="image" src="https://github.com/user-attachments/assets/feee41d0-307f-4026-8662-7e33183cd58d" />


Once objects are created publish the service
 <img width="975" height="609" alt="image" src="https://github.com/user-attachments/assets/f3d9ca76-c940-4cb6-8be7-c14fb01d0f6c" />



________________________________________
🔹 Step 2: Create Users Table (Child Entity)
@EndUserText.label : 'Project Users'
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #ALLOWED
define table zhar_users1 {

  key client  : abap.clnt not null;
  key proj_id : abap.numc(10) not null;
  uname       : abap.char(10);

}
________________________________________
🔹 Step 3: Create Interface View for Users
define view entity ZI_PROJ_USERS as select from zhar_users
  association to parent ZR_HAR_PROJECT as _proj 
    on $projection.ProjId = _proj.ProjID
{
  key proj_id as ProjId,
  uname as Uname,
      _proj
}
✅ This acts as a child entity linking users to project
________________________________________
🔹 Step 4: Create Consumption View
define view entity ZC_PROJ_USERS as projection on ZI_PROJ_USERS
{
key ProjId,
    @Consumption.valueHelpDefinition: [{ entity: {
                                           name: 'ZI_HAR_USER_VH',
                                           element: 'UserName'
                                       } }]
    Uname,
    /* Associations */
    _proj: redirected to parent ZC_HAR_PROJECT
}
________________________________________
🔹 Step 5: Add Composition in Root Interface View of project
define root view entity ZR_HAR_PROJECT
  as select from zhar_project
  composition [0..*] of ZI_PROJ_USERS as _Usr
{
  key proj_id as ProjID,
  name as Name,
  uname as Uname,
  _Usr
}
________________________________________
🔹 Step 6: Add redirected to Composition child in Root Consumption View of project

_Usr : redirected to composition child ZC_PROJ_USERS
________________________________________
🔹 Step 7: UI Annotation for Multi-Select Display
@UI.lineItem: [
  { label: 'User list', position: 80, value: '_Usr.Uname' }
]

@UI.identification: [
  { label: 'User list', position: 80, value: '_Usr.Uname' }
]
_Usr;
✅ Displays multiple users on Object Page
________________________________________
🔹 Step 8: Value Help Setup
User Value Help Table
define table zms_user_table {

  key mandt : abap.clnt not null;
  key uname : abap.char(10) not null;
  uname_txt : abap.char(40);

}
________________________________________
Value Help CDS View
define view entity ZI_HAR_USER_VH
  as select from zms_user_table
{
  key uname as UserName
}
________________________________________
Data Insert Class
CLASS zcl_insert_data_user IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lt_users TYPE STANDARD TABLE OF zms_user_table.

    lt_users = VALUE #(
      ( uname = 'HARSHA' uname_txt = 'Harsha Boddula' )
      ( uname = 'SIVA'   uname_txt = 'Siva Satish' )
      ( uname = 'RAM'    uname_txt = 'Ram Kumar' )
      ( uname = 'JOHN'   uname_txt = 'John David' )
    ).

    INSERT zms_user_table FROM TABLE @lt_users
      ACCEPTING DUPLICATE KEYS.

    out->write( '✅ User data inserted successfully!' ).

  ENDMETHOD.

ENDCLASS.
________________________________________
 ________________________________________
🔴 🔹 Step 8: Behavior Definition (FULL IMPLEMENTATION)
________________________________________
Root Behavior Definition (ZC_HAR_PROJECT)
managed implementation in class ZBP_R_HAR_PROJECT unique;
strict ( 2 );
with draft;
extensible;

define behavior for ZR_HAR_PROJECT alias ZrHarProject
persistent table ZHAR_PROJECT
draft table ZHAR_PROJECT_D
etag master Locallastchangedat
lock master total etag Lastchangedat
authorization master( global )
{
  field ( mandatory : create )
    ProjID;

  field ( readonly )
    Localcreatedby,
    Localcreatedat,
    Locallastchangedby,
    Locallastchangedat,
    Lastchangedat;

  field ( readonly : update )
    ProjID;

  create;
  update;
  delete;

  draft action Activate optimized;
  draft action Discard;
  draft action Edit;
  draft action Resume;
  draft determine action Prepare;

  association _Usr { create; with draft; }

  mapping for ZHAR_PROJECT corresponding extensible
  {
    ProjID = PROJ_ID;
    Name   = NAME;
    Uname  = UNAME;
  }
}
________________________________________
Child Behavior Definition
define behavior for ZI_PROJ_USERS
persistent table zhar_users
draft table zhar_users_d
lock dependent by _proj
authorization dependent by _proj
{
  update;
  delete;

  field ( readonly ) ProjId;

  association _proj { with draft; }

  mapping for ZHAR_USERS {
    ProjId = proj_id;
    Uname  = uname;
  }
}
________________________________________
Draft Table
@EndUserText.label : 'Draft table for entity ZI_PROJ_USERS'
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zhar_users1_d {

  key mandt  : mandt not null;
  key projid : abap.numc(10) not null;
  uname      : abap.char(10);
  "%admin"   : include sych_bdl_draft_admin_inc;

}
________________________________________
🔵 🔹 Step 9: Projection Behavior Definition
projection implementation in class ZBP_C_HAR_PROJECT unique;
strict ( 2 );
extensible;

use draft;
use side effects;

define behavior for ZC_HAR_PROJECT alias ZcHarProject
extensible
use etag
{
  use create;
  use update;
  use delete;

  use action Edit;
  use action Activate;
  use action Discard;
  use action Resume;
  use action Prepare;

  use association _Usr { create; with draft; }
}
________________________________________
define behavior for ZC_PROJ_USERS
{
  use update;
  use delete;
  use association _proj { with draft; }
}
________________________________________
🔹 Step 10: Service Definition
define service ZUI_HAR_PROJECT_O4
  provider contracts odata_v4_ui {

  expose ZC_HAR_PROJECT;
  expose ZC_PROJ_USERS;

}
________________________________________
 
________________________________________
🔹 Final Output
<img width="975" height="573" alt="image" src="https://github.com/user-attachments/assets/fd1aa0ad-2d57-4d01-970a-611d967aaf0f" />

✔ Create Project
 <img width="975" height="494" alt="image" src="https://github.com/user-attachments/assets/b6fd5897-83f8-43de-9155-326e6869c706" />

✔ Add multiple users
 <img width="975" height="501" alt="image" src="https://github.com/user-attachments/assets/6ba36c47-0973-4d47-8a41-e7f6170c599c" />

✔ Value help selection
 <img width="975" height="508" alt="image" src="https://github.com/user-attachments/assets/6054ffdb-0fc1-43bd-86b4-f0b22dc076ab" />

________________________________________
✅ Key Learnings
•	Multi-select is not field-based in RAP
•	Achieved using child entity (composition)
•	Value help drives selection
•	Behavior definition controls lifecycle
•	Draft ensures transactional consistency

