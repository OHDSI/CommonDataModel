The device exposure domain captures information about a person's exposure to a foreign physical object or instrument that which is used for diagnostic or therapeutic purposes through a mechanism beyond chemical action. Devices include implantable objects (e.g. pacemakers, stents, artificial joints), medical equipment and supplies (e.g. bandages, crutches, syringes), other instruments used in medical procedures (e.g. sutures, defibrillators) and material used in clinical care (e.g. adhesives, body material, dental material, surgical material).

Field|Required|Type|Description
:--------------------------------|:--------|:------------|:--------------------------------------------
|device_exposure_id|Yes|integer|A system-generated unique identifier for each Device Exposure.|
|person_id|Yes|integer|A foreign key identifier to the Person who is subjected to the Device. The demographic details of that person are stored in the Person table.|
|device_concept_id|Yes|integer|A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies for the Device concept.|
|device_exposure_start_date|Yes|date|The date the Device or supply was applied or used.|
|device_exposure_start_datetime|No|datetime|The date and time the Device or supply was applied or used.|
|device_exposure_end_date|No|date|The date the Device or supply was removed from use.|
|device_exposure_end_datetime|No|datetime|The date and time the Device or supply was removed from use.|
|device_type_concept_id|Yes|integer|A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of Device Exposure recorded. It indicates how the Device Exposure was represented in the source data.|
|unique_device_id |No|varchar(50)|A UDI or equivalent identifying the instance of the Device used in the Person.|
|quantity|No|integer|The number of individual Devices used for the exposure.|
|provider_id|No|integer|A foreign key to the provider in the PROVIDER table who initiated of administered the Device.|
|visit_occurrence_id|No|integer|A foreign key to the visit in the VISIT table during which the device was used.|
|device_source_value|No|varchar(50)|The source code for the Device as it appears in the source data. This code is mapped to a standard Device Concept in the Standardized Vocabularies and the original code is stored here for reference.|
|device_source_ concept_id|No|integer|A foreign key to a Device Concept that refers to the code used in the source.|

### Conventions 

  * The distinction between Devices or supplies and procedures are sometimes blurry, but the former are physical objects while the latter are actions, often to apply a Device or supply. 
  * For medical devices that are regulated by the FDA, if a Unique Device Identification (UDI) is provided if available in the data source, and is recorded in the unique_device_id field.
  * Valid Device Concepts belong to the "Device" domain.  The Concepts of this domain are derived from the DI portion of a UDI or based on other source vocabularies, like HCPCS.
  * A Device Type is assigned to each Device Exposure to track from what source the information was drawn or inferred. The valid domain_id for these Concepts is "Device Type".
  * The Visit during which the Device was first used is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
  * The Provider exposing the patient to the Device is recorded through a reference to the PROVIDER table. This information is not always available.