@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view for booking'
@Metadata.ignorePropagatedAnnotations: true
define view entity zvas_booking_i 
as select from zvas_booking
association to parent zvas_travel_i as _Travel on $projection.TravelId = _Travel.TravelId
{

key booking_id as BookingId,

travel_id as TravelId,
passenger_name as PassengerName,

carrier_id as CarrierId,

flight_date as FlightDate,

seat_number as SeatNumber,

local_last_changed_at as LocalLastChangedAt,
    _Travel
}
