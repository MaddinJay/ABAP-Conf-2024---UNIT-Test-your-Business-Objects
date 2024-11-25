CLASS ltcl_i_product_mj DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  private section.
    methods:
      first_test for testing raising cx_static_check.
endclass.


class ltcl_i_product_mj implementation.

  method first_test.
    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  endmethod.

endclass.
