CLASS ltcl_i_product_mj DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CLASS-DATA: cut                  TYPE REF TO lhc_rating,  " Must be static, because local class is static
                cds_test_environment TYPE REF TO if_cds_test_environment.

    CLASS-METHODS:
      "! Instantiate class under test and setup test double frameworks
      class_setup,

      "! Destroy test environments and test doubles
      class_teardown.

    DATA:
      keys             TYPE TABLE FOR VALIDATION z_i_product_mj\\rating~checkrating,
      rating_mock_data TYPE STANDARD TABLE OF zrating_mj,
      failed           TYPE RESPONSE FOR FAILED LATE z_i_product_mj,
      reported         TYPE RESPONSE FOR REPORTED LATE  z_i_product_mj.

    METHODS:
      "! Reset test doubles
      setup,

      "! Reset transactional buffer
      teardown.

    METHODS:
      " GIVEN: Rating Input of value 5 WHEN: Check_Rating is executed THEN: ...
      should_accept_rating_5 FOR TESTING RAISING cx_static_check,
      " GIVEN: Rating Input of value 6 WHEN: Check_Rating is executed THEN: ...
      should_reject_rating_6 FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_i_product_mj IMPLEMENTATION.

  METHOD class_setup.
    CREATE OBJECT cut FOR TESTING.

    cds_test_environment = cl_cds_test_environment=>create( i_for_entity = 'Z_I_RATING_MJ'
                                                            i_dependency_list = VALUE #( ( name = 'ZRATING_MJ' type = 'TABLE' ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
    cds_test_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
    cds_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.                                 "#EC CI_ROLLBACK
  ENDMETHOD.

  METHOD should_accept_rating_5.
    " Setup Rating Mock Data
    rating_mock_data = VALUE #( ( rating_uuid = 'E21FD1B74D261EEFAACE709FC448FB29' product = 'DXTR1000' rating = '5' ) ).
    cds_test_environment->insert_test_data( rating_mock_data ).

    " Call method to be tested
    keys = VALUE #( ( RatingUuid = 'E21FD1B74D261EEFAACE709FC448FB29' ) ). " Table entry in ZRATING_MJ existing with this UUID
    cut->check_rating( EXPORTING keys     = CORRESPONDING #( keys )
                       CHANGING  failed   = failed
                                 reported = reported ).

    cl_abap_unit_assert=>assert_initial( failed ).
    cl_abap_unit_assert=>assert_initial( reported ).
  ENDMETHOD.

  METHOD should_reject_rating_6.
    " Setup Rating Mock Data
    rating_mock_data = VALUE #( ( rating_uuid = 'E21FD1B74D261EEFAACE709FC448FB29' product = 'DXTR1000' rating = '6' ) ).
    cds_test_environment->insert_test_data( rating_mock_data ).

    " Call method to be tested
    keys = VALUE #( ( RatingUuid = 'E21FD1B74D261EEFAACE709FC448FB29' ) ). " Table entry in ZRATING_MJ existing with this UUID
    cut->check_rating( EXPORTING keys     = CORRESPONDING #( keys )
                       CHANGING  failed   = failed
                                 reported = reported ).

    cl_abap_unit_assert=>assert_not_initial( failed ).
    cl_abap_unit_assert=>assert_not_initial( reported ).
  ENDMETHOD.

ENDCLASS.
