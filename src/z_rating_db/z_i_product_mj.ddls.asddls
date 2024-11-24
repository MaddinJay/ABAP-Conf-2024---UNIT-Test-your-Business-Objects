@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Z_I_Product_MJ'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Z_I_Product_MJ
  as select from zproduct_mj
        composition [0..*] of Z_I_RATING_MJ as _Rating
{
  key product_id   as ProductId,
      product_desc as ProductDescription,
                _Rating
}
