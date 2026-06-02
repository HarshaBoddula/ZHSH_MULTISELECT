@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Project Users'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_PROJ_USERS as projection on ZI_PROJ_USERS
{
    
    key ProjId,
    @Consumption.valueHelpDefinition: [{ entity: {
                                           name: 'ZI_HAR_USER_VH',
                                           element: 'UserName'
                                       } }]
    key Uname,
    /* Associations */
    _proj: redirected to parent ZC_HAR_PROJECT
}
