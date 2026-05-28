@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view for travel'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define root view entity zvas_travel_i 
as select from zvas_travel
composition [0..*] of zvas_booking_i as _Booking
{
    key travel_id            as TravelId,
    @Search.defaultSearchElement: true
    customer_id              as CustomerId,
    customer_name            as CustomerName,
    travel_purpose           as TravelPurpose,
    source_city              as SourceCity,
    destination_city         as DestinationCity,
    start_date               as StartDate,
    end_date                 as EndDate,
    overall_status           as OverallStatus,
 
// it add the colours to the overall status
cast(
  case overall_status 
    when 'O' then 2
    when 'A' then 3
    when 'R' then 1
    when 'X' then 1
    else 0
  end
  as abap.int1
) as StatusCriticality,

// replacing Shotcuts with actual names
case overall_status
  when 'O' then 'Open'
  when 'A' then 'Accepted'
  when 'R' then 'Rejected'
  when 'X' then 'Cancelled'
  else 'Unknown'
end as StatusText,

    
    local_last_changed_at as LocalLastChangedAt,
    _Booking
}
