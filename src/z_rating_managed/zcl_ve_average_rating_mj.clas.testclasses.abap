CLASS ltcl_average_rating DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA cut TYPE REF TO if_sadl_exit_calc_element_read.

    METHODS:
      setup.
    METHODS:
      " GIVEN: Input data for Product DXTR1000 WHEN: Calculate average rating THEN: ...
      should_calculate_correctly FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_average_rating IMPLEMENTATION.

  METHOD setup.
    cut = NEW zcl_ve_average_rating_mj( ).
  ENDMETHOD.

  METHOD should_calculate_correctly.
    DATA products        TYPE STANDARD TABLE OF Z_C_Product_M_MJ WITH DEFAULT KEY.
    DATA calculated_data TYPE STANDARD TABLE OF Z_C_Product_M_MJ WITH DEFAULT KEY.
    DATA expected_values TYPE STANDARD TABLE OF Z_C_Product_M_MJ WITH DEFAULT KEY.

    " Set Input Data
    products        = VALUE #( ( ProductId = 'DXTR1000' ProductDescription = 'Deluxe Touring Bike Black'   AverageRating = 0 ) ).

    calculated_data = VALUE #( ( ProductId = 'DXTR1000' ProductDescription = 'Deluxe Touring Bike Black'   AverageRating = 4 ) ).

    " Set Expected Result
    expected_values = VALUE #( ( ProductId = 'DXTR1000' ProductDescription = 'Deluxe Touring Bike Black'   AverageRating = '4.5' ) ).

    " Execute calculation
    cut->calculate( EXPORTING it_original_data           = products
                              it_requested_calc_elements = VALUE if_sadl_exit_calc_element_read=>tt_elements( )
                    CHANGING  ct_calculated_data         = calculated_data ).

    " Compare expected and calculated data
    cl_abap_unit_assert=>assert_equals( exp = expected_values
                                        act = calculated_data ).


  ENDMETHOD.

ENDCLASS.
