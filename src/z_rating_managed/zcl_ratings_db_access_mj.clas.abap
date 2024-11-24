CLASS zcl_ratings_db_access_mj DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_ratings_db_access_mj.

ENDCLASS.

CLASS zcl_ratings_db_access_mj IMPLEMENTATION.

  METHOD zif_ratings_db_access_mj~read_average_rating4products.
    SELECT Product,
           AVG( rating AS DEC( 2, 1 ) ) AS average_rating
      FROM @ratings AS r
      GROUP BY Product
      INTO TABLE @result.
  ENDMETHOD.

ENDCLASS.
