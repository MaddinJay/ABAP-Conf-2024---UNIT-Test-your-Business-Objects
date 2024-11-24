INTERFACE zif_ratings_db_access_mj
  PUBLIC .

  TYPES: BEGIN OF ty_average_product_rating,
           Product        TYPE z_c_product_m_mj-ProductId,
           average_rating TYPE z_c_product_m_mj-AverageRating,
         END OF ty_average_product_rating,

         tt_average_product_ratings TYPE STANDARD TABLE OF ty_average_product_rating WITH DEFAULT KEY.

  METHODS read_average_rating4products IMPORTING ratings       TYPE zcl_ve_average_rating_mj=>tt_ratings
                                       RETURNING VALUE(result) TYPE tt_average_product_ratings.
ENDINTERFACE.
