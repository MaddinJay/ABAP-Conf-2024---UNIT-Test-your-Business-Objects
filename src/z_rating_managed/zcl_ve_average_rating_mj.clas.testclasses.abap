CLASS ltcl_average_rating DEFINITION DEFERRED.
CLASS zcl_ve_average_rating_mj DEFINITION LOCAL FRIENDS ltcl_average_rating.

CLASS ltcl_average_rating DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      cds_test_environment TYPE REF TO if_cds_test_environment,
      sql_test_environment TYPE REF TO if_osql_test_environment,
      ratings              TYPE STANDARD TABLE OF zrating_mj.

    DATA:
      cut                  TYPE REF TO if_sadl_exit_calc_element_read.

    CLASS-METHODS:
      class_setup,
      class_teardown.

    METHODS:
      setup.

    METHODS:
      " GIVEN: Input data for Product DXTR1000 WHEN: Calculate average rating THEN: ...
      should_calculate_correctly FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_average_rating IMPLEMENTATION.

  METHOD setup.
    cut = NEW zcl_ve_average_rating_mj( ).

    " clear the test doubles per test
    cds_test_environment->clear_doubles( ).

    " insert test data into test doubles
    cds_test_environment->insert_test_data( ratings ).
  ENDMETHOD.

  METHOD should_calculate_correctly.
    " Set Input Data
    DATA(products)        = VALUE zcl_ve_average_rating_mj=>tt_products(
                              ( ProductId = 'DXTR1000' ProductDescription = 'Deluxe Touring Bike Black'   AverageRating = 0 ) ).

    DATA(calculated_data) = VALUE zcl_ve_average_rating_mj=>tt_products(
                              ( ProductId = 'DXTR1000' ProductDescription = 'Deluxe Touring Bike Black'   AverageRating = 4 ) ).

    " Set Expected Result
    DATA(expected_values) = VALUE zcl_ve_average_rating_mj=>tt_products(
                              ( ProductId = 'DXTR1000' ProductDescription = 'Deluxe Touring Bike Black'   AverageRating = '4.5' ) ).

    " Execute calculation
    cut->calculate( EXPORTING it_original_data           = products
                              it_requested_calc_elements = VALUE if_sadl_exit_calc_element_read=>tt_elements( )
                    CHANGING  ct_calculated_data         = calculated_data ).

    " Compare expected and calculated data
    cl_abap_unit_assert=>assert_equals( exp = expected_values
                                        act = calculated_data ).


  ENDMETHOD.

  METHOD class_setup.
    " create the test doubles for the underlying CDS entities
    cds_test_environment = cl_cds_test_environment=>create(
                      i_for_entity      = 'Z_C_RATING_M_MJ'
                      i_dependency_list = VALUE #( ( name = 'ZRATING_MJ'  type = 'TABLE' ) ) ).

    ratings = VALUE #( ( rating_uuid = '1' product = 'DXTR1000' rating = 4 )
                       ( rating_uuid = '2' product = 'DXTR1000' rating = 5 )
                       ( rating_uuid = '3' product = 'DXTR2000' rating = 5 ) ).
  ENDMETHOD.

  METHOD class_teardown.
    " remove test doubles
    cds_test_environment->destroy(  ).
  ENDMETHOD.

ENDCLASS.
