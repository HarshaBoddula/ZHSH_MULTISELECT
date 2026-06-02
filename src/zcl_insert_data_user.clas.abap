CLASS zcl_insert_data_user DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_insert_data_user IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lt_users TYPE STANDARD TABLE OF zms_user_table.

    lt_users = VALUE #(
      ( uname = 'HARSHA' uname_txt = 'Harsha Boddula' )
      ( uname = 'SIVA'   uname_txt = 'Siva Satish' )
      ( uname = 'RAM'    uname_txt = 'Ram Kumar' )
      ( uname = 'JOHN'   uname_txt = 'John David' )
    ).

    INSERT zms_user_table FROM TABLE @lt_users
      ACCEPTING DUPLICATE KEYS.

    out->write( '✅ User data inserted successfully!' ).

  ENDMETHOD.

ENDCLASS.

