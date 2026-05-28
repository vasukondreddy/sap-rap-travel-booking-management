CLASS lhc_zvas_travel_i DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zvas_travel_i RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zvas_travel_i RESULT result.

      " Validate name
      METHODS validateCustomerName
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR zvas_travel_i~validateCustomerName.
    " Method to validate dates in travel
    METHODS validate_dates FOR VALIDATE ON SAVE
        IMPORTING keys FOR zvas_travel_i~validate_dates.

    METHODS validateCities FOR VALIDATE ON SAVE
        IMPORTING keys FOR zvas_travel_i~validateCities.

    "determiation for overal status
    METHODS set_initial_status FOR DETERMINE ON MODIFY
  IMPORTING keys FOR zvas_travel_i~set_initial_status.

  " accept buttons
  METHODS acceptTravel
  FOR MODIFY
  IMPORTING keys FOR ACTION zvas_travel_i~acceptTravel
  RESULT result.

METHODS rejectTravel
  FOR MODIFY
  IMPORTING keys FOR ACTION zvas_travel_i~rejectTravel
  RESULT result.

METHODS cancelTravel
  FOR MODIFY
  IMPORTING keys FOR ACTION zvas_travel_i~cancelTravel
  RESULT result.

 " feature control -  if the status is accepted and remaining button not visible
  METHODS get_instance_features
  FOR INSTANCE FEATURES
  IMPORTING keys REQUEST requested_features
  FOR zvas_travel_i RESULT result.

ENDCLASS.

CLASS lhc_zvas_travel_i IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.
  " ----------- validation of customer name ------------
  METHOD validateCustomerName.

  READ ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    FIELDS ( CustomerName )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

  LOOP AT lt_travel INTO DATA(ls_travel).

    IF ls_travel-CustomerName IS INITIAL.

      APPEND VALUE #(
        %tky = ls_travel-%tky
      ) TO failed-zvas_travel_i.

      APPEND VALUE #(
        %tky = ls_travel-%tky

        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Customer Name cannot be empty' )

        %element-CustomerName = if_abap_behv=>mk-on

      ) TO reported-zvas_travel_i.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

" ----------- Method to validate dates in travel -----------------
  METHOD validate_dates.

  READ ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    FIELDS ( StartDate EndDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

  DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

  LOOP AT lt_travel INTO DATA(ls_travel).

    "Start date cannot be in past
    IF ls_travel-StartDate < lv_today.

      APPEND VALUE #(
        %tky = ls_travel-%tky
      ) TO failed-zvas_travel_i.

      APPEND VALUE #(
        %tky = ls_travel-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Start Date cannot be in the past' )
      ) TO reported-zvas_travel_i.

    ENDIF.

    "End date cannot be in past
    IF ls_travel-EndDate < lv_today.

      APPEND VALUE #(
        %tky = ls_travel-%tky
      ) TO failed-zvas_travel_i.

      APPEND VALUE #(
        %tky = ls_travel-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'End Date cannot be in the past' )
      ) TO reported-zvas_travel_i.

    ENDIF.

    "End date must be >= start date
    IF ls_travel-EndDate < ls_travel-StartDate.

      APPEND VALUE #(
        %tky = ls_travel-%tky
      ) TO failed-zvas_travel_i.

      APPEND VALUE #(
        %tky = ls_travel-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'End Date must be greater than or equal to Start Date' )
      ) TO reported-zvas_travel_i.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

" --------------validation for source and destination---------------
METHOD validateCities.

  READ ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    FIELDS ( SourceCity DestinationCity )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

  LOOP AT lt_travel INTO DATA(ls_travel).

    DATA(lv_source)      = to_upper( ls_travel-SourceCity ).
    DATA(lv_destination) = to_upper( ls_travel-DestinationCity ).

    IF lv_source = lv_destination.

      APPEND VALUE #(
        %tky = ls_travel-%tky
      ) TO failed-zvas_travel_i.

      APPEND VALUE #(
        %tky = ls_travel-%tky

        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Source City and Destination City cannot be the same' )

        %element-SourceCity      = if_abap_behv=>mk-on
        %element-DestinationCity = if_abap_behv=>mk-on

      ) TO reported-zvas_travel_i.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

" --------Implementation of determination for overalStatus -------------------
METHOD set_initial_status.

  MODIFY ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #(
      FOR key IN keys
      (
        %tky          = key-%tky
        OverallStatus = 'O'
      )
    ).

ENDMETHOD.

" ----- accept Travel action button ------
METHOD acceptTravel.

  READ ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    FIELDS ( OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

  LOOP AT lt_travel INTO DATA(ls_travel).

    IF ls_travel-OverallStatus <> 'O'.

      APPEND VALUE #(
        %tky = ls_travel-%tky
      ) TO failed-zvas_travel_i.

      APPEND VALUE #(
        %tky = ls_travel-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Only Open travels can be accepted' )
      ) TO reported-zvas_travel_i.

      RETURN.

    ENDIF.

  ENDLOOP.

  MODIFY ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #(
      FOR key IN keys
      (
        %tky          = key-%tky
        OverallStatus = 'A'
      )
    ).

  READ ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

  result = VALUE #(
    FOR ls IN lt_result
    (
      %tky   = ls-%tky
      %param = ls
    )
  ).

ENDMETHOD.

" ---------- reject action button -----------

METHOD rejectTravel.

  READ ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    FIELDS ( OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

  LOOP AT lt_travel INTO DATA(ls_travel).

    IF ls_travel-OverallStatus <> 'O'.

      APPEND VALUE #(
        %tky = ls_travel-%tky
      ) TO failed-zvas_travel_i.

      APPEND VALUE #(
        %tky = ls_travel-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Only Open travels can be rejected' )
      ) TO reported-zvas_travel_i.

      RETURN.

    ENDIF.

  ENDLOOP.

  MODIFY ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #(
      FOR key IN keys
      (
        %tky          = key-%tky
        OverallStatus = 'R'
      )
    ).

  READ ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

  result = VALUE #(
    FOR ls IN lt_result
    (
      %tky   = ls-%tky
      %param = ls
    )
  ).

ENDMETHOD.

" ---------- cancel action button -------------
METHOD cancelTravel.

  READ ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    FIELDS ( OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

  LOOP AT lt_travel INTO DATA(ls_travel).

    IF ls_travel-OverallStatus <> 'O'
       AND ls_travel-OverallStatus <> 'A'.

      APPEND VALUE #(
        %tky = ls_travel-%tky
      ) TO failed-zvas_travel_i.

      APPEND VALUE #(
        %tky = ls_travel-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Only Open or Accepted travels can be cancelled' )
      ) TO reported-zvas_travel_i.

      RETURN.

    ENDIF.

  ENDLOOP.

  MODIFY ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #(
      FOR key IN keys
      (
        %tky          = key-%tky
        OverallStatus = 'X'
      )
    ).

  READ ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

  result = VALUE #(
    FOR ls IN lt_result
    (
      %tky   = ls-%tky
      %param = ls
    )
  ).

ENDMETHOD.

" -----------feature Control to make action buttons visible or not--------------
METHOD get_instance_features.

  READ ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_travel_i
    FIELDS ( OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

  result = VALUE #( FOR ls_travel IN lt_travel (

    %tky = ls_travel-%tky

    %action-acceptTravel =
      COND #(
        WHEN ls_travel-OverallStatus = 'O'
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

    %action-rejectTravel =
      COND #(
        WHEN ls_travel-OverallStatus = 'O'
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

    %action-cancelTravel =
      COND #(
        WHEN ls_travel-OverallStatus = 'O'
          OR ls_travel-OverallStatus = 'A'
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

  ) ).

ENDMETHOD.


ENDCLASS.

"------------- Booking class ----------------
CLASS lhc_zvas_booking_i DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validate_flight_date
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR zvas_booking_i~validate_flight_date.

    METHODS validatePassenger
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR zvas_booking_i~validatePassenger.

ENDCLASS.


" ------------------ Implementation for booking ----------------------
CLASS lhc_zvas_booking_i IMPLEMENTATION.

  METHOD validate_flight_date.

    READ ENTITIES OF zvas_travel_i IN LOCAL MODE
      ENTITY zvas_booking_i
      FIELDS ( TravelId FlightDate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_booking).

    LOOP AT lt_booking INTO DATA(ls_booking).

      SELECT SINGLE start_date,
                    end_date
        FROM zvas_travel
        WHERE travel_id = @ls_booking-TravelId
        INTO @DATA(ls_travel).

      IF sy-subrc = 0.

        IF ls_booking-FlightDate < ls_travel-start_date
           OR ls_booking-FlightDate > ls_travel-end_date.

          APPEND VALUE #(
            %tky = ls_booking-%tky
          ) TO failed-zvas_booking_i.

          APPEND VALUE #(
            %tky = ls_booking-%tky
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = 'Flight Date must be within Travel Start & End Dates'
                   )
          ) TO reported-zvas_booking_i.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

" --------- passenger Validation -----------
METHOD validatePassenger.

  READ ENTITIES OF zvas_travel_i IN LOCAL MODE
    ENTITY zvas_booking_i
    FIELDS ( PassengerName )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_booking).

  LOOP AT lt_booking INTO DATA(ls_booking).

    IF ls_booking-PassengerName IS INITIAL.

      APPEND VALUE #(
        %tky = ls_booking-%tky
      ) TO failed-zvas_booking_i.

      APPEND VALUE #(
        %tky = ls_booking-%tky

        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Passenger Name cannot be empty' )

        %element-PassengerName = if_abap_behv=>mk-on

      ) TO reported-zvas_booking_i.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

ENDCLASS.
