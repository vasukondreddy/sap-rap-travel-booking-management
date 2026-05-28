
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection view for travel'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZVAS_TRAVEL_P
provider contract transactional_query
  as projection on zvas_travel_i
{
    key TravelId,
        CustomerId,
        CustomerName,       
        TravelPurpose,
        SourceCity,
        DestinationCity,
        StartDate,
        EndDate,
        OverallStatus,
        StatusCriticality,
        StatusText,
        LocalLastChangedAt,

        _Booking : redirected to composition child ZVAS_BOOKING_P
}
