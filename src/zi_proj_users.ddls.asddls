@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Project Users'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PROJ_USERS as select from zhar_users1
  association to parent ZR_HAR_PROJECT as _proj on $projection.ProjId = _proj.ProjID
{
  key proj_id as ProjId,
  key uname as Uname,
    
      _proj

}
