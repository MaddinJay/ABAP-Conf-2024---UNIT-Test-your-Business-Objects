CLASS zcl_ve_average_rating_mj DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .

  PRIVATE SECTION.
    TYPES:
      ty_products TYPE STANDARD TABLE OF z_c_product_m_mj WITH DEFAULT KEY,

      BEGIN OF ty_average_product_rating,
        Product        TYPE ze_product_id,
        average_rating TYPE z_c_product_m_mj-AverageRating,
      END OF ty_average_product_rating,

      tt_average_product_ratings TYPE STANDARD TABLE OF ty_average_product_rating WITH DEFAULT KEY.

    METHODS map_average_ratings2products IMPORTING average_product_ratings TYPE tt_average_product_ratings
                                                   products                TYPE ty_products
                                         RETURNING VALUE(result)           TYPE ty_products.

ENDCLASS.

CLASS zcl_ve_average_rating_mj IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA products TYPE STANDARD TABLE OF Z_C_Product_M_MJ.
    DATA average_product_ratings TYPE tt_average_product_ratings.

    products = CORRESPONDING #( it_original_data ).

    " Read the ratings for the product(s) from the Z_C_Product_M_MJ entity
    READ ENTITIES OF Z_C_Product_M_MJ
      ENTITY Product BY \_Rating
      FIELDS ( Rating )
      WITH CORRESPONDING #( products )
      RESULT FINAL(ratings).

    " Calculate the average rating for each product by DB select
    SELECT Product,
           AVG( rating AS DEC( 2, 1 ) ) AS average_rating
      FROM @ratings AS r
      GROUP BY Product
      INTO TABLE @average_product_ratings.

    " Map average ratings to the products (output)
    products = map_average_ratings2products( average_product_ratings = average_product_ratings
                                             products                = products ).

    ct_calculated_data = CORRESPONDING #( products ).
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
