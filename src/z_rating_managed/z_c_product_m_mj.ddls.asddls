@EndUserText.label: 'Product View for Manages Scenario'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { typeName: 'Product',
               typeNamePlural: 'Products',
               title: { type: #STANDARD, value: 'ProductId' }} }

@Search.searchable: true

@Metadata.allowExtensions: true
define root view entity Z_C_Product_M_MJ
  as projection on Z_I_Product_MJ
{
  key ProductId,
      ProductDescription,
      
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_VE_AVERAGE_RATING_MJ'
      @EndUserText.label: 'Average Customer Rating'
      virtual AverageRating: abap.dec( 2, 1 ),
      
      /* Associations */
      _Rating : redirected to composition child Z_C_RATING_M_MJ
}
