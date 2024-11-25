CLASS ltcl_i_product_mj DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CLASS-DATA: cut            TYPE REF TO lhc_rating.  " Must be static, because local class is static

    CLASS-METHODS:
      "! Instantiate class under test and setup test double frameworks
      class_setup,

      "! Destroy test environments and test doubles
      class_teardown.

    METHODS:
      "! Reset test doubles
      setup,

      "! Reset transactional buffer
      teardown.

    METHODS:
      " GIVEN: Rating Input of value 5 WHEN: Check_Rating is executed THEN: ...
      should_accept_rating_5 FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_i_product_mj IMPLEMENTATION.

  METHOD class_setup.
    CREATE OBJECT cut FOR TESTING.
  ENDMETHOD.

  METHOD class_teardown.
  ENDMETHOD.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.                                 "#EC CI_ROLLBACK
  ENDMETHOD.

  METHOD should_accept_rating_5.
    DATA keys     TYPE TABLE FOR VALIDATION z_i_product_mj\\rating~checkrating.
    DATA failed   TYPE RESPONSE FOR FAILED LATE z_i_product_mj.
    DATA reported TYPE RESPONSE FOR REPORTED LATE  z_i_product_mj.

    " Call method to be tested
    keys = VALUE #( ( RatingUuid = 'E21FD1B74D261EEFAACE709FC448FB29' ) ). " Table entry in ZRATING_MJ existing with this UUID
    cut->check_rating( EXPORTING keys     = CORRESPONDING #( keys )
                       CHANGING  failed   = failed
                                 reported = reported ).

    cl_abap_unit_assert=>assert_initial( failed ).
    cl_abap_unit_assert=>assert_initial( reported ).
  ENDMETHOD.

ENDCLASS.
