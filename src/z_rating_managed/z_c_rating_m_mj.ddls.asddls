@EndUserText.label: 'Rating view for Managed Scenario'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { typeName: 'Rating',
               typeNamePlural: 'Ratings', 
               title: { type: #STANDARD, value: 'Product' } } }

@Search.searchable: true
@Metadata.allowExtensions: true
define view entity Z_C_RATING_M_MJ
  as projection on Z_I_RATING_MJ
{
  key RatingUUID,
      Product,
      Name,
      Email,
      Rating,
      Review,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      Status, 
      StatusCriticality,

      /* Associations */
      _Product : redirected to parent Z_C_Product_M_MJ
}
