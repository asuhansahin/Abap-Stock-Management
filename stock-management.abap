*&---------------------------------------------------------------------*
*& Report ZSTOCK_MANAGEMENT_PROGRAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstock_management_program.

TABLES: zstock_management.

DATA: it_stock TYPE TABLE OF zstock_management,
      wa_stock TYPE zstock_management.

" For ALV Grid
DATA: gt_fieldcat TYPE lvc_t_fcat,
      gv_grid TYPE REF TO cl_gui_alv_grid,
      gv_container TYPE REF TO cl_gui_custom_container,
      ls_fcat TYPE lvc_s_fcat.

START-OF-SELECTION.
  CALL SCREEN 0100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  " ALV'yi hazırlıyoruz
  PERFORM prepare_alv.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module USER_COMMAND_0100 INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      SET SCREEN 0.
    WHEN 'SAVE'.
      PERFORM update_stock.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Form UPDATE_STOCK
*&---------------------------------------------------------------------*
FORM update_stock.

  DATA: wa_stock TYPE zstock_management.


  SELECT SINGLE *
    INTO @wa_stock
    FROM zstock_management
    WHERE stock_id = @wa_stock-stock_id.

  IF sy-subrc > 0.

    UPDATE zstock_management
      SET stock_name = @wa_stock-stock_name,
          stock_count = @wa_stock-stock_count,
          changed_by = @sy-uname,
          changed_date = @sy-datum,
          change_time = @sy-uzeit
      WHERE stock_id = @wa_stock-stock_id.
    MESSAGE 'Veriler Update Tabloya Kaydedilmiştir' TYPE 'I'.
  ELSE.
    INSERT INTO zstock_management VALUES @wa_stock.

    MESSAGE 'Yeni Veri Tabloya Eklendi' TYPE 'I'.
  ENDIF.

  COMMIT WORK.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form PREPARE_ALV
*&---------------------------------------------------------------------*
FORM prepare_alv.
  IF gv_container IS INITIAL.

    CREATE OBJECT gv_container
      EXPORTING container_name = 'ALV_CONTAINER'.


    CREATE OBJECT gv_grid
      EXPORTING i_parent = gv_container.
  ENDIF.


  PERFORM build_fieldcat.


  SELECT * INTO TABLE it_stock FROM zstock_management.

  CALL METHOD gv_grid->set_table_for_first_display
    EXPORTING i_structure_name = 'ZSTOCK_MANAGEMEN'
    CHANGING  it_outtab = it_stock
              it_fieldcatalog = gt_fieldcat.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form BUILD_FIELDCAT
*&---------------------------------------------------------------------*
FORM build_fieldcat.
  CLEAR gt_fieldcat.


 PERFORM add_field_to_cat USING 'STOCK_ID' 'Stock ID'.
  PERFORM add_field_to_cat USING 'STOCK_NAME' 'Stock Name'.
  PERFORM add_field_to_cat USING 'STOCK_COUNT' 'Stock Count'.
ENDFORM.


FORM add_field_to_cat USING p_fieldname p_coltext.
  CLEAR ls_fcat.
  ls_fcat-fieldname = p_fieldname.
  ls_fcat-coltext = p_coltext.
  APPEND ls_fcat TO gt_fieldcat.
ENDFORM.