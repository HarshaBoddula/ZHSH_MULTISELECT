@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZHAR_PROJECT'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_HAR_PROJECT
  as select from zhar_project
  composition [0..*] of ZI_PROJ_USERS as _Usr
{
  key proj_id as ProjID,
  name as Name,
  uname as Uname,
  @Semantics.user.createdBy: true
  localcreatedby as Localcreatedby,
  @Semantics.systemDateTime.createdAt: true
  localcreatedat as Localcreatedat,
  @Semantics.user.localInstanceLastChangedBy: true
  locallastchangedby as Locallastchangedby,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locallastchangedat as Locallastchangedat,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchangedat as Lastchangedat,
  _Usr
}
