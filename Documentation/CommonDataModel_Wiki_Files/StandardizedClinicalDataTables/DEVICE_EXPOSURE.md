The 'Device' domain captures information about a person's exposure to a foreign physical object or instrument which is used for diagnostic or therapeutic purposes through a mechanism beyond chemical action. Devices include implantable objects (e.g. pacemakers, stents, artificial joints), medical equipment and supplies (e.g. bandages, crutches, syringes), other instruments used in medical procedures (e.g. sutures, defibrillators) and material used in clinical care (e.g. adhesives, body material, dental material, surgical material).

Field|Required|Type|Description
:--------------------------------|:--------|:------------|:--------------------------------------------
| device_exposure_id			| Yes	| bigint	| A system-generated unique identifier for each Device Exposure.                                                                                                                     |
| person_id						| Yes	| bigint	| A foreign key identifier to the Person who is subjected to the Device. The demographic details of that Person are stored in the PERSON table.                                      |
| device_concept_id				| Yes	| integer	| A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies belonging to the 'Device' domain.                                                    |   
| device_exposure_start_date	| Yes	| date		| The date the Device or supply was applied or used.                                                                                                                                 |
| device_exposure_start_datetime| No	| datetime	| The date and time the Device or supply was applied or used.                                                                                                                                 |
| device_exposure_end_date		| No	| date		| The date use of the Device or supply was ceased.                                                                                                                                   |
| device_exposure_end_datetime	| No	| datetime	| The date and time use of the Device or supply was ceased.                                                                                                                          |
| device_type_concept_id		| Yes	| integer	| A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of Device Exposure recorded. It indicates how the Device Exposure was represented in the source data and belongs to the 'Device Type' domain.|
| unique_device_id 				| No	| varchar(50)| A UDI or equivalent identifying the instance of the Device used in the Person.                                                                                                     |
| quantity						| No	| integer	| The number of individual Devices used in the exposure.                                                                                                                             |
| provider_id					| No	| integer	| A foreign key to the provider in the PROVIDER table who initiated or administered the Device.                                                                                      |
| visit_occurrence_id			| No	| integer	| A foreign key to the visit in the VISIT_OCCURRENCE table during which the Device was used.                                                                                         |
| visit_detail_id				| No	| integer	| A foreign key to the visit detail record in the VISIT_DETAIL table during which the Device was used.                                                                               |
| device_source_value			| No	| varchar(50)| The source code for the Device as it appears in the source data. This code is mapped to a Standard Device Concept in the Standardized Vocabularies and the original code is stored here for reference.|
| device_source_concept_id		| No	| integer	| A foreign key to a Device Concept that refers to the code used in the source.|

### Conventions

No.|Convention Description
:--------|:------------------------------------ 
| 1  | The distinction between Devices or supplies and Procedures are sometimes blurry, but the former are physical objects while the latter are actions, often to apply a Device or supply.| 
| 2  | For medical devices that are regulated by the FDA, a Unique Device Identification (UDI) is provided if available in the data source and is recorded in the UNIQUE_DEVICE_ID field.|
| 3  | Valid Device Concepts belong to the 'Device' domain.  The Concepts of this domain are derived from the DI portion of a UDI or based on other source vocabularies, like HCPCS.|
| 4  | A Device Type is assigned to each Device Exposure to track from what source the information was drawn or inferred. The valid vocabulary for these Concepts is 'Device Type'.|
| 5  | The Visit during which the Device was first used is recorded through a reference to the VISIT_OCCURRENCE table. |
| 6  | The Visit Detail during which the Device was first used is recorded through a reference to the VISIT_DETAIL table.| 
| 7  | The Provider exposing the patient to the Device is recorded through a reference to the PROVIDER table. 
| 8  | When dealing with duplicate records, the ETL must determine whether to sum them up into one record or keep them separate. Things to consider are:<br><ul><li>Same Device/Procedure</li><li>Same DEVICE_EXPOSURE_START_DATETIME</li><li> Same Visit Occurrence or Visit Detail</li><li>Same Provider</li><li>Same Modifier for Procedures</li><li>Same COST_ID</li></ul> |
| 9  | If a Device Exposure has a quantity of '0' in the source, this should default to '1' in the ETL. If there is a record in the source it can be assumed the exposure occurred at least once. |