CLASS zcl_ve_average_rating_mj DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES tt_ratings TYPE TABLE FOR READ RESULT z_c_product_m_mj\\product\_rating.

    INTERFACES if_sadl_exit_calc_element_read .

  PRIVATE SECTION.
    TYPES ty_products TYPE STANDARD TABLE OF z_c_product_m_mj WITH DEFAULT KEY.

    METHODS map_average_ratings2products IMPORTING average_product_ratings TYPE zif_ratings_db_access_mj=>tt_average_product_ratings
                                                   products                TYPE ty_products
                                         RETURNING VALUE(result)           TYPE ty_products.

    METHODS read_average_rating4products IMPORTING ratings       TYPE tt_ratings
                                         RETURNING VALUE(result) TYPE zif_ratings_db_access_mj=>tt_average_product_ratings.

ENDCLASS.

CLASS zcl_ve_average_rating_mj IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA products TYPE STANDARD TABLE OF Z_C_Product_M_MJ.

    products = CORRESPONDING #( it_original_data ).

    " Read the ratings for the product(s) from the Z_C_Product_M_MJ entity
    READ ENTITIES OF Z_C_Product_M_MJ
      ENTITY Product BY \_Rating
      FIELDS ( Rating )
      WITH CORRESPONDING #( products )
      RESULT FINAL(ratings).

    " Calculate the average rating for each product by DB select
    DATA(average_product_ratings) = read_average_rating4products( ratings ).

    " Map average ratings to the products (output)
    products = map_average_ratings2products( average_product_ratings = average_product_ratings
                                             products                = products ).

    ct_calculated_data = CORRESPONDING #( products ).
  ENDMETHOD.

  METHOD read_average_rating4products.
    DATA(ratings_db_access) = NEW zcl_ratings_db_access_mj( ).
    result = ratings_db_access->zif_ratings_db_access_mj~read_average_rating4products( ratings ).
  ENDMETHOD.

  METHOD map_average_ratings2products.

    result = products.

    LOOP AT result ASSIGNING FIELD-SYMBOL(<product>).
      <product>-AverageRating = average_product_ratings[ Product = <product>-ProductId ]-average_rating.
    ENDLOOP.

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.

ENDCLASS.
