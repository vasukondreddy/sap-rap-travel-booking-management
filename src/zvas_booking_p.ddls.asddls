
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection view for booking'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZVAS_BOOKING_P
//provider contract transactional_query
  as projection on zvas_booking_i
{
    key BookingId,
        TravelId,
        PassengerName,
        CarrierId,
        FlightDate,
        SeatNumber,
        LocalLastChangedAt,

        _Travel : redirected to parent ZVAS_TRAVEL_P
}
