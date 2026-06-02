@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZHAR_PROJECT'
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_HAR_PROJECT
  provider contract transactional_query
  as projection on ZR_HAR_PROJECT
  association [1..1] to ZR_HAR_PROJECT as _BaseEntity on $projection.ProjID = _BaseEntity.ProjID
{
  key ProjID,
  Name,
  Uname,
  @Semantics: {
    user.createdBy: true
  }
  Localcreatedby,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  Localcreatedat,
  @Semantics: {
    user.localInstanceLastChangedBy: true
  }
  Locallastchangedby,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  Locallastchangedat,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  Lastchangedat,
  _BaseEntity,
  _Usr : redirected to composition child ZC_PROJ_USERS
}
