The LOCATION table represents a generic way to capture physical location or address information of Persons and Care Sites.

Field|Required|Type|Description
:----------------------|:--------|:------------|:--------------------------------------------
|location_id|Yes|integer|A unique identifier for each geographic location.|
|address_1|No|varchar(50)|The address field 1, typically used for the street address, as it appears in the source data.|
|address_2|No|varchar(50)|The address field 2, typically used for additional detail such as buildings, suites, floors, as it appears in the source data.|
|city |No|varchar(50)|The city field as it appears in the source data.|
|state|No|varchar(2)|The state field as it appears in the source data.|
|zip|No|varchar(9)|The zip or postal code.|
|county|No|varchar(20)|The county.|
|country|No|varchar(100)|The country|
|location_source_value|No|varchar(50)|The verbatim information that is used to uniquely identify the location as it appears in the source data.|
|latitude|No|float|The geocoded latitude|
|longitude|No|float|The geocoded longitude|

### Conventions 

No.|Convention Description
:--------|:------------------------------------
| 1  | Each address or Location is unique and is present only once in the table. |
| 2  | Locations do not contain names, such as the name of a hospital. In order to construct a full address that can be used in the postal service, the address information from the Location needs to be combined with information from the Care Site. The PERSON table does not contain name information at all. |
| 3  | All fields in the Location tables contain the verbatim data in the source, no mapping or normalization takes place. None of the fields are mandatory. If the source data have no Location information at all, all Locations are represented by a single record. Typically, source data contain full or partial zip or postal codes or county or census district information. |
| 4  | Zip codes are handled as strings of up to 9 characters length. For US addresses, these represent either a 3-digit abbreviated Zip code as provided by many sources for patient protection reasons, the full 5-digit Zip or the 9-digit (ZIP + 4) codes. Unless for specific reasons analytical methods should expect and utilize only the first 3 digits. For international addresses, different rules apply. |
| 5  | The county information can be provided and is not redundant with information from the zip codes as not all of these have an unambiguous county designation. |
| 6  | For standardized geospatial visualization and analysis, addresses need to be, at the minimum be geocoded into latitude and longitude. This allows it to put as a point on a map. This proposal is to add two fields, latitude and longitude to the location table. |
