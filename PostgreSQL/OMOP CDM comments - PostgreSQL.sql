--
--CLINICAL
--
-- VISIT_OCCURRENCE
COMMENT ON TABLE visit_occurrence IS '[CLINICAL] The VISIT_OCCURRENCE table contains the spans of time a Person continuously receives medical services from one or more providers at a Care Site in a given setting within the health care system. Visits are classified into 4 settings: outpatient care, inpatient confinement, emergency room, and long-term care. Persons may transition between these settings over the course of an episode of care (for example, treatment of a disease onset).';
COMMENT ON COLUMN visit_occurrence.visit_occurrence_id IS 'A unique identifier for each Person''s visit or encounter at a healthcare provider.';
COMMENT ON COLUMN visit_occurrence.person_id IS 'A foreign key identifier to the Person for whom the visit is recorded. The demographic details of that Person are stored in the PERSON table.';
COMMENT ON COLUMN visit_occurrence.visit_concept_id IS 'A foreign key that refers to a visit Concept identifier in the Standardized Vocabularies.';
COMMENT ON COLUMN visit_occurrence.visit_start_date IS 'The start date of the visit.';
COMMENT ON COLUMN visit_occurrence.visit_start_datetime IS 'The date and time of the visit started.';
COMMENT ON COLUMN visit_occurrence.visit_end_date IS 'The end date of the visit. If this is a one-day visit the end date should match the start date.';
COMMENT ON COLUMN visit_occurrence.visit_end_datetime IS 'The date and time of the visit end.';
COMMENT ON COLUMN visit_occurrence.visit_type_concept_id IS 'A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of source data from which the visit record is derived.';
COMMENT ON COLUMN visit_occurrence.provider_id IS 'A foreign key to the provider in the provider table who was associated with the visit.';
COMMENT ON COLUMN visit_occurrence.care_site_id IS 'A foreign key to the care site in the care site table that was visited.';
COMMENT ON COLUMN visit_occurrence.visit_source_value IS 'The source code for the visit as it appears in the source data.';
COMMENT ON COLUMN visit_occurrence.visit_source_concept_id IS 'A foreign key to a Concept that refers to the code used in the source.';
COMMENT ON COLUMN visit_occurrence.admitting_source_concept_id IS 'A foreign key to the predefined concept in the Place of Service Vocabulary reflecting the admitting source for a visit.';
COMMENT ON COLUMN visit_occurrence.admitting_source_value  IS 'The source code for the admitting source as it appears in the source data.';
COMMENT ON COLUMN visit_occurrence.discharge_to_concept_id IS 'A foreign key to the predefined concept in the Place of Service Vocabulary reflecting the discharge disposition for a visit.';
COMMENT ON COLUMN visit_occurrence.discharge_to_source_value IS 'The source code for the discharge disposition as it appears in the source data.';
COMMENT ON COLUMN visit_occurrence.preceding_visit_occurrence_id  IS 'A foreign key to the VISIT_OCCURRENCE table of the visit immediately preceding this visit';
-- CONDITION_OCCURRENCE
COMMENT ON TABLE condition_occurrence IS '[CLINICAL] Conditions are records of a Person suggesting the presence of a disease or medical condition stated as a diagnosis, a sign or a symptom, which is either observed by a Provider or reported by the patient. Conditions are recorded in different sources and levels of standardization, for example:';
COMMENT ON COLUMN condition_occurrence. condition_occurrence_id         IS 'A unique identifier for each Condition Occurrence event.';
COMMENT ON COLUMN condition_occurrence. person_id                       IS 'A foreign key identifier to the Person who is experiencing the condition. The demographic details of that Person are stored in the PERSON table.';
COMMENT ON COLUMN condition_occurrence. condition_concept_id            IS 'A foreign key that refers to a Standard Condition Concept identifier in the Standardized Vocabularies.';
COMMENT ON COLUMN condition_occurrence. condition_start_date            IS 'The date when the instance of the Condition is recorded.';
COMMENT ON COLUMN condition_occurrence. condition_start_datetime        IS 'The date and time when the instance of the Condition is recorded.';
COMMENT ON COLUMN condition_occurrence. condition_end_date              IS 'The date when the instance of the Condition is considered to have ended.';
COMMENT ON COLUMN condition_occurrence. condition_end_datetime          IS 'The date when the instance of the Condition is considered to have ended.';
COMMENT ON COLUMN condition_occurrence. condition_type_concept_id       IS 'A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the source data from which the condition was recorded, the level of standardization, and the type of occurrence.';
COMMENT ON COLUMN condition_occurrence. stop_reason                     IS 'The reason that the condition was no longer present, as indicated in the source data.';
COMMENT ON COLUMN condition_occurrence. provider_id                     IS 'A foreign key to the Provider in the PROVIDER table who was responsible for capturing (diagnosing) the Condition.';
COMMENT ON COLUMN condition_occurrence. visit_occurrence_id             IS 'A foreign key to the visit in the VISIT_OCCURRENCE table during which the Condition was determined (diagnosed).';
COMMENT ON COLUMN condition_occurrence. visit_detail_id             IS 'A foreign key to the visit in the VISIT_DETAIL table during which the Condition was determined (diagnosed).';
COMMENT ON COLUMN condition_occurrence. condition_source_value          IS 'The source code for the condition as it appears in the source data. This code is mapped to a standard condition concept in the Standardized Vocabularies and the original code is stored here for reference.';
COMMENT ON COLUMN condition_occurrence. condition_source_concept_id     IS 'A foreign key to a Condition Concept that refers to the code used in the source.';
COMMENT ON COLUMN condition_occurrence. condition_status_source_value   IS 'The source code for the condition status as it appears in the source data.';
COMMENT ON COLUMN condition_occurrence. condition_status_concept_id     IS 'A foreign key to the predefined concept in the standard vocabulary reflecting the condition status';                                                                                                                               
-- DEATH
COMMENT ON TABLE death IS '[CLINICAL] The death domain contains the clinical event for how and when a Person dies. A person can have up to one record if the source system contains evidence about the Death, such as:';
COMMENT ON COLUMN death.person_id IS 'A foreign key identifier to the deceased person. The demographic details of that person are stored in the person table.';
COMMENT ON COLUMN death.death_date  IS 'The date the person was deceased. If the precise date including day or month is not known or not allowed, December is used as the default month, and the last day of the month the default day.';
COMMENT ON COLUMN death.death_datetime  IS 'The date and time the person was deceased. If the precise date including day or month is not known or not allowed, December is used as the default month, and the last day of the month the default day.';
COMMENT ON COLUMN death.death_type_concept_id IS 'A foreign key referring to the predefined concept identifier in the Standardized Vocabularies reflecting how the death was represented in the source data.';
COMMENT ON COLUMN death.cause_concept_id IS 'A foreign key referring to a standard concept identifier in the Standardized Vocabularies for conditions.';
COMMENT ON COLUMN death.cause_source_value IS 'The source code for the cause of death as it appears in the source data. This code is mapped to a standard concept in the Standardized Vocabularies and the original code is, stored here for reference.';
COMMENT ON COLUMN death.cause_source_concept_id IS 'A foreign key to the concept that refers to the code used in the source. Note, this variable name is abbreviated to ensure it will be allowable across database platforms.';
-- DEVICE_EXPOSURE
COMMENT ON TABLE device_exposure IS '[CLINICAL] The device exposure domain captures information about a person''s exposure to a foreign physical object or instrument that which is used for diagnostic or therapeutic purposes through a mechanism beyond chemical action. Devices include implantable objects (e.g. pacemakers, stents, artificial joints), medical equipment and supplies (e.g. bandages, crutches, syringes), other instruments used in medical procedures (e.g. sutures, defibrillators) and material used in clinical care (e.g. adhesives, body material, dental material, surgical material).';
COMMENT ON COLUMN device_exposure.device_exposure_id IS 'A system-generated unique identifier for each Device Exposure.';
COMMENT ON COLUMN device_exposure.person_id IS 'A foreign key identifier to the Person who is subjected to the Device. The demographic details of that person are stored in the Person table.';
COMMENT ON COLUMN device_exposure.device_concept_id IS 'A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies for the Device concept.';
COMMENT ON COLUMN device_exposure.device_exposure_start_date IS 'The date the Device or supply was applied or used.';
COMMENT ON COLUMN device_exposure.device_exposure_start_datetime IS 'The date and time the Device or supply was applied or used.';
COMMENT ON COLUMN device_exposure.device_exposure_end_date IS 'The date the Device or supply was removed from use.';
COMMENT ON COLUMN device_exposure.device_exposure_end_datetime IS 'The date and time the Device or supply was removed from use.';
COMMENT ON COLUMN device_exposure.device_type_concept_id IS 'A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of Device Exposure recorded. It indicates how the Device Exposure was represented in the source data.';
COMMENT ON COLUMN device_exposure.unique_device_id  IS 'A UDI or equivalent identifying the instance of the Device used in the Person.';
COMMENT ON COLUMN device_exposure.quantity IS 'The number of individual Devices used for the exposure.';
COMMENT ON COLUMN device_exposure.provider_id IS 'A foreign key to the provider in the PROVIDER table who initiated of administered the Device.';
COMMENT ON COLUMN device_exposure.visit_occurrence_id IS 'A foreign key to the visit in the VISIT table during which the device was used.';
COMMENT ON COLUMN device_exposure.device_source_value IS 'The source code for the Device as it appears in the source data. This code is mapped to a standard Device Concept in the Standardized Vocabularies and the original code is stored here for reference.';
COMMENT ON COLUMN device_exposure.device_source_concept_id IS 'A foreign key to a Device Concept that refers to the code used in the source.';
COMMENT ON COLUMN device_exposure.visit_detail_id IS 'A foreign key to the visit in the visit-detail table during which the Drug Exposure was initiated.';
-- DRUG_EXPOSURE
COMMENT ON TABLE drug_exposure IS '[CLINICAL] The drug exposure domain captures records about the utilization of a Drug when ingested or otherwise introduced into the body. A Drug is a biochemical substance formulated in such a way that when administered to a Person it will exert a certain physiological effect. Drugs include prescription and over-the-counter medicines, vaccines, and large-molecule biologic therapies. Radiological devices ingested or applied locally do not count as Drugs.';
COMMENT ON COLUMN drug_exposure.drug_exposure_id IS 'A system-generated unique identifier for each Drug utilization event.';
COMMENT ON COLUMN drug_exposure.person_id IS 'A foreign key identifier to the person who is subjected to the Drug. The demographic details of that person are stored in the person table.';
COMMENT ON COLUMN drug_exposure.drug_concept_id IS 'A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies for the Drug concept.';
COMMENT ON COLUMN drug_exposure.drug_exposure_start_date IS 'The start date for the current instance of Drug utilization. Valid entries include a start date of a prescription, the date a prescription was filled, or the date on which a Drug administration procedure was recorded.';
COMMENT ON COLUMN drug_exposure.drug_exposure_start_datetime IS 'The start date and time for the current instance of Drug utilization. Valid entries include a start date of a prescription, the date a prescription was filled, or the date on which a Drug administration procedure was recorded.';
COMMENT ON COLUMN drug_exposure.drug_exposure_end_date IS 'The end date for the current instance of Drug utilization. It is not available from all sources.';
COMMENT ON COLUMN drug_exposure.drug_exposure_end_datetime IS 'The end date and time for the current instance of Drug utilization. It is not available from all sources.';
COMMENT ON COLUMN drug_exposure.verbatim_end_date IS 'The known end date of a drug_exposure as provided by the source';
COMMENT ON COLUMN drug_exposure.drug_type_concept_id IS 'A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of Drug Exposure recorded. It indicates how the Drug Exposure was represented in the source data.';
COMMENT ON COLUMN drug_exposure.stop_reason IS 'The reason the Drug was stopped. Reasons include regimen completed, changed, removed, etc.';
COMMENT ON COLUMN drug_exposure.refills IS 'The number of refills after the initial prescription. The initial prescription is not counted, values start with 0.';
COMMENT ON COLUMN drug_exposure.quantity  IS 'The quantity of drug as recorded in the original prescription or dispensing record.';
COMMENT ON COLUMN drug_exposure.days_supply IS 'The number of days of supply of the medication as recorded in the original prescription or dispensing record.';
COMMENT ON COLUMN drug_exposure.sig IS 'The directions ("signetur") on the Drug prescription as recorded in the original prescription (and printed on the container) or dispensing record.';
COMMENT ON COLUMN drug_exposure.route_concept_id IS 'A foreign key to a predefined concept in the Standardized Vocabularies reflecting the route of administration.';
COMMENT ON COLUMN drug_exposure.lot_number IS 'An identifier assigned to a particular quantity or lot of Drug product from the manufacturer.';
COMMENT ON COLUMN drug_exposure.provider_id IS 'A foreign key to the provider in the provider table who initiated (prescribed or administered) the Drug Exposure.';
COMMENT ON COLUMN drug_exposure.visit_occurrence_id IS 'A foreign key to the visit in the visit table during which the Drug Exposure was initiated.';
COMMENT ON COLUMN drug_exposure.drug_source_value IS 'The source code for the Drug as it appears in the source data. This code is mapped to a Standard Drug concept in the Standardized Vocabularies and the original code is, stored here for reference.';
COMMENT ON COLUMN drug_exposure.drug_source_concept_id IS 'A foreign key to a Drug Concept that refers to the code used in the source.';
COMMENT ON COLUMN drug_exposure.route_source_value IS 'The information about the route of administration as detailed in the source.';
COMMENT ON COLUMN drug_exposure.dose_unit_source_value IS 'The information about the dose unit as detailed in the source.';
COMMENT ON COLUMN drug_exposure.visit_detail_id IS 'A foreign key to the visit in the VISIT_DETAIL table during which the Drug Exposure was initiated.';
-- FACT_RELATIONSHIP
COMMENT ON TABLE FACT_RELATIONSHIP IS '[CLINICAL] The FACT_RELATIONSHIP table contains records about the relationships between facts stored as records in any table of the CDM. Relationships can be defined between facts from the same domain (table), or different domains. Examples of Fact Relationships include: Person relationships (parent-child), care site relationships (hierarchical organizational structure of facilities within a health system), indication relationship (between drug exposures and associated conditions), usage relationships (of devices during the course of an associated procedure), or facts derived from one another (measurements derived from an associated specimen).';
COMMENT ON COLUMN FACT_RELATIONSHIP.domain_concept_id_1 IS 'The concept representing the domain of fact one, from which the corresponding table can be inferred.';
COMMENT ON COLUMN FACT_RELATIONSHIP.fact_id_1 IS 'The unique identifier in the table corresponding to the domain of fact one.';
COMMENT ON COLUMN FACT_RELATIONSHIP.domain_concept_id_2 IS 'The concept representing the domain of fact two, from which the corresponding table can be inferred.';
COMMENT ON COLUMN FACT_RELATIONSHIP.fact_id_2 IS 'The unique identifier in the table corresponding to the domain of fact two.';
COMMENT ON COLUMN FACT_RELATIONSHIP.relationship_concept_id  IS 'A foreign key to a Standard Concept ID of relationship in the Standardized Vocabularies.';
-- MEASUREMENT
COMMENT ON TABLE MEASUREMENT IS '[CLINICAL] The MEASUREMENT table contains records of Measurement, i.e. structured values (numerical or categorical) obtained through systematic and standardized examination or testing of a Person or Person''s sample. The MEASUREMENT table contains both orders and results of such Measurements as laboratory tests, vital signs, quantitative findings from pathology reports, etc.';
COMMENT ON COLUMN MEASUREMENT.measurement_id IS 'A unique identifier for each Measurement.';
COMMENT ON COLUMN MEASUREMENT.person_id IS 'A foreign key identifier to the Person about whom the measurement was recorded. The demographic details of that Person are stored in the PERSON table.';
COMMENT ON COLUMN MEASUREMENT.measurement_concept_id IS 'A foreign key to the standard measurement concept identifier in the Standardized Vocabularies.';
COMMENT ON COLUMN MEASUREMENT.measurement_date IS 'The date of the Measurement.';
COMMENT ON COLUMN MEASUREMENT.measurement_datetime IS 'The date and time of the Measurement. Some database systems don''t have a datatype of time. To accomodate all temporal analyses, datatype datetime can be used (combining measurement_date and measurement_time [forum discussion](http://forums.ohdsi.org/t/date-time-and-datetime-problem-and-the-world-of-hours-and-1day/314))';
COMMENT ON COLUMN MEASUREMENT.measurement_type_concept_id IS 'A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the provenance from where the Measurement record was recorded.';
COMMENT ON COLUMN MEASUREMENT.operator_concept_id IS 'A foreign key identifier to the predefined Concept in the Standardized Vocabularies reflecting the mathematical operator that is applied to the value_as_number. Operators are <, <=, =, >=, >.';
COMMENT ON COLUMN MEASUREMENT.value_as_number IS 'A Measurement result where the result is expressed as a numeric value.';
COMMENT ON COLUMN MEASUREMENT.value_as_concept_id IS 'A foreign key to a Measurement result represented as a Concept from the Standardized Vocabularies (e.g., positive/negative, present/absent, low/high, etc.).';
COMMENT ON COLUMN MEASUREMENT.unit_concept_id IS 'A foreign key to a Standard Concept ID of Measurement Units in the Standardized Vocabularies.';
COMMENT ON COLUMN MEASUREMENT.range_low IS 'The lower limit of the normal range of the Measurement result. The lower range is assumed to be of the same unit of measure as the Measurement value.';
COMMENT ON COLUMN MEASUREMENT.range_high IS 'The upper limit of the normal range of the Measurement. The upper range is assumed to be of the same unit of measure as the Measurement value.';
COMMENT ON COLUMN MEASUREMENT.provider_id IS 'A foreign key to the provider in the PROVIDER table who was responsible for initiating or obtaining the measurement.';
COMMENT ON COLUMN MEASUREMENT.visit_occurrence_id IS 'A foreign key to the Visit in the VISIT_OCCURRENCE table during which the Measurement was recorded.';
COMMENT ON COLUMN MEASUREMENT.visit_detail_id IS 'A foreign key to the Visit in the VISIT_DETAIL table during which the Measurement was recorded.';
COMMENT ON COLUMN MEASUREMENT.measurement_source_value IS 'The Measurement name as it appears in the source data. This code is mapped to a Standard Concept in the Standardized Vocabularies and the original code is stored here for reference.';
COMMENT ON COLUMN MEASUREMENT.measurement_source_concept_id IS 'A foreign key to a Concept in the Standard Vocabularies that refers to the code used in the source.';
COMMENT ON COLUMN MEASUREMENT.unit_source_value IS 'The source code for the unit as it appears in the source data. This code is mapped to a standard unit concept in the Standardized Vocabularies and the original code is stored here for reference.';
COMMENT ON COLUMN MEASUREMENT.value_source_value IS 'The source value associated with the content of the value_as_number or value_as_concept_id as stored in the source data.';
-- NOTE
COMMENT ON TABLE NOTE IS '[CLINICAL] The NOTE table captures unstructured information that was recorded by a provider about a patient in free text notes on a given date.';
COMMENT ON COLUMN NOTE.note_id IS 'A unique identifier for each note.';
COMMENT ON COLUMN NOTE.person_id IS 'A foreign key identifier to the Person about whom the Note was recorded. The demographic details of that Person are stored in the PERSON table.';
COMMENT ON COLUMN NOTE.note_date  IS 'The date the note was recorded.';
COMMENT ON COLUMN NOTE.note_datetime IS 'The date and time the note was recorded.';
COMMENT ON COLUMN NOTE.note_type_concept_id IS 'A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the type, origin or provenance of the Note.';
COMMENT ON COLUMN NOTE.note_class_concept_id IS 'A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the HL7 LOINC Document Type Vocabulary classification of the note.';
COMMENT ON COLUMN NOTE.note_title  IS 'The title of the Note as it appears in the source.';
COMMENT ON COLUMN NOTE.note_text IS 'The content of the Note.';
COMMENT ON COLUMN NOTE.encoding_concept_id  IS 'A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the note character encoding type';
COMMENT ON COLUMN NOTE.language_concept_id  IS 'A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the language of the note';
COMMENT ON COLUMN NOTE.provider_id IS 'A foreign key to the Provider in the PROVIDER table who took the Note.';
COMMENT ON COLUMN NOTE.note_source_value IS 'The source value associated with the origin of the note';
COMMENT ON COLUMN NOTE.visit_occurrence_id IS 'Foreign key to the Visit in the VISIT_OCCURRENCE table when the Note was taken.';
-- VISIT_DETAIL
COMMENT ON TABLE VISIT_DETAIL IS '[CLINICAL] The VISIT_DETAIL table is an optional table used to represents details of each record in the parent visit_occurrence table. For every record in visit_occurrence table there may be 0 or more records in the visit_detail table with a 1:n relationship where n may be 0. The visit_detail table is structurally very similar to visit_occurrence table and belongs to the similar domain as the visit.';
COMMENT ON COLUMN VISIT_DETAIL.visit_detail_id IS 'A unique identifier for each Person''s visit or encounter at a healthcare provider.';
COMMENT ON COLUMN VISIT_DETAIL.person_id IS 'A foreign key identifier to the Person for whom the visit is recorded. The demographic details of that Person are stored in the PERSON table.';
COMMENT ON COLUMN VISIT_DETAIL.visit_detail_concept_id IS 'A foreign key that refers to a visit Concept identifier in the Standardized Vocabularies.';
COMMENT ON COLUMN VISIT_DETAIL.visit_start_date IS 'The start date of the visit.';
COMMENT ON COLUMN VISIT_DETAIL.visit_start_datetime IS 'The date and time of the visit started.';
COMMENT ON COLUMN VISIT_DETAIL.visit_end_date IS 'The end date of the visit. If this is a one-day visit the end date should match the start date.';
COMMENT ON COLUMN VISIT_DETAIL.visit_end_datetime IS 'The date and time of the visit end.';
COMMENT ON COLUMN VISIT_DETAIL.visit_type_concept_id IS 'A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of source data from which the visit record is derived.';
COMMENT ON COLUMN VISIT_DETAIL.provider_id IS 'A foreign key to the provider in the provider table who was associated with the visit.';
COMMENT ON COLUMN VISIT_DETAIL.care_site_id IS 'A foreign key to the care site in the care site table that was visited.';
COMMENT ON COLUMN VISIT_DETAIL.visit_source_value IS 'The source code for the visit as it appears in the source data.';
COMMENT ON COLUMN VISIT_DETAIL.visit_source_concept_id IS 'A foreign key to a Concept that refers to the code used in the source.';
COMMENT ON COLUMN VISIT_DETAIL.admitting_source_value  IS 'The source code for the admitting source as it appears in the source data.';
COMMENT ON COLUMN VISIT_DETAIL.admitting_source_concept_id  IS 'A foreign key to the predefined concept in the Place of Service Vocabulary reflecting the admitting source for a visit.';
COMMENT ON COLUMN VISIT_DETAIL.discharge_to_source_value IS 'The source code for the discharge disposition as it appears in the source data.';
COMMENT ON COLUMN VISIT_DETAIL.discharge_to_concept_id IS 'A foreign key to the predefined concept in the Place of Service Vocabulary reflecting the discharge disposition for a visit.';
COMMENT ON COLUMN VISIT_DETAIL.preceding_visit_detail_id  IS 'A foreign key to the VISIT_DETAIL table of the visit immediately preceding this visit';
COMMENT ON COLUMN VISIT_DETAIL.visit_detail_parent_id  IS 'A foreign key to the VISIT_DETAIL table record to represent the immediate parent visit-detail record.';
COMMENT ON COLUMN VISIT_DETAIL.visit_occurrence_id  IS 'A foreign key that refers to the record in the VISIT_OCCURRENCE table. This is a required field, because for every visit_detail is a child of visit_occurrence and cannot exist without a corresponding parent record in visit_occurrence.';
-- SPECIMEN
COMMENT ON TABLE SPECIMEN IS '[CLINICAL] The specimen domain contains the records identifying biological samples from a person.';
COMMENT ON COLUMN SPECIMEN.specimen_id IS 'A unique identifier for each specimen.';
COMMENT ON COLUMN SPECIMEN.person_id IS 'A foreign key identifier to the Person for whom the Specimen is recorded.';
COMMENT ON COLUMN SPECIMEN.specimen_concept_id IS 'A foreign key referring to a Standard Concept identifier in the Standardized Vocabularies for the Specimen.';
COMMENT ON COLUMN SPECIMEN.specimen_type_concept_id IS 'A foreign key referring to the Concept identifier in the Standardized Vocabularies reflecting the system of record from which the Specimen was represented in the source data.';
COMMENT ON COLUMN SPECIMEN.specimen_date IS 'The date the specimen was obtained from the Person.';
COMMENT ON COLUMN SPECIMEN.specimen_datetime IS 'The date and time on the date when the Specimen was obtained from the person.';
COMMENT ON COLUMN SPECIMEN.quantity IS 'The amount of specimen collection from the person during the sampling procedure.';
COMMENT ON COLUMN SPECIMEN.unit_concept_id IS 'A foreign key to a Standard Concept identifier for the Unit associated with the numeric quantity of the Specimen collection.';
COMMENT ON COLUMN SPECIMEN.anatomic_site_concept_id IS 'A foreign key to a Standard Concept identifier for the anatomic location of specimen collection.';
COMMENT ON COLUMN SPECIMEN.disease_status_concept_id IS 'A foreign key to a Standard Concept identifier for the Disease Status of specimen collection.';
COMMENT ON COLUMN SPECIMEN.specimen_source_id IS 'The Specimen identifier as it appears in the source data.';
COMMENT ON COLUMN SPECIMEN.specimen_source_value IS 'The Specimen value as it appears in the source data. This value is mapped to a Standard Concept in the Standardized Vocabularies and the original code is, stored here for reference.';
COMMENT ON COLUMN SPECIMEN.unit_source_value IS 'The information about the Unit as detailed in the source.';
COMMENT ON COLUMN SPECIMEN.anatomic_site_source_value IS 'The information about the anatomic site as detailed in the source.';
COMMENT ON COLUMN SPECIMEN.disease_status_source_value IS 'The information about the disease status as detailed in the source.';
-- PROCEDURE_OCCURRENCE
COMMENT ON TABLE PROCEDURE_OCCURRENCE IS '[CLINICAL] The PROCEDURE_OCCURRENCE table contains records of activities or processes ordered by, or carried out by, a healthcare provider on the patient to have a diagnostic or therapeutic purpose. Procedures are present in various data sources in different forms with varying levels of standardization. For example:';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.procedure_occurrence_id IS 'A system-generated unique identifier for each Procedure Occurrence.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.person_id IS 'A foreign key identifier to the Person who is subjected to the Procedure. The demographic details of that Person are stored in the PERSON table.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.procedure_concept_id IS 'A foreign key that refers to a standard procedure Concept identifier in the Standardized Vocabularies.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.procedure_date IS 'The date on which the Procedure was performed.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.procedure_datetime IS 'The date and time on which the Procedure was performed.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.procedure_type_concept_id IS 'A foreign key to the predefined Concept identifier in the Standardized Vocabularies reflecting the type of source data from which the procedure record is derived.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.modifier_concept_id IS 'A foreign key to a Standard Concept identifier for a modifier to the Procedure (e.g. bilateral)';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.quantity IS 'The quantity of procedures ordered or administered.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.provider_id IS 'A foreign key to the provider in the provider table who was responsible for carrying out the procedure.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.visit_occurrence_id IS 'A foreign key to the visit in the visit table during which the Procedure was carried out.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.procedure_source_value IS 'The source code for the Procedure as it appears in the source data. This code is mapped to a standard procedure Concept in the Standardized Vocabularies and the original code is, stored here for reference. Procedure source codes are typically ICD-9-Proc, CPT-4, HCPCS or OPCS-4 codes.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.procedure_source_concept_id IS 'A foreign key to a Procedure Concept that refers to the code used in the source.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.qualifier_source_value IS 'The source code for the qualifier as it appears in the source data.';
COMMENT ON COLUMN PROCEDURE_OCCURRENCE.visit_detail_id IS 'A foreign key to the visit in the visit table during which the Procedure was carried out.';
-- PERSON
COMMENT ON TABLE PERSON IS '[CLINICAL] The Person Domain contains records that uniquely identify each patient in the source data who is time at-risk to have clinical observations recorded within the source systems.';
COMMENT ON COLUMN PERSON.person_id IS 'A unique identifier for each person.';
COMMENT ON COLUMN PERSON.gender_concept_id IS 'A foreign key that refers to an identifier in the CONCEPT table for the unique gender of the person.';
COMMENT ON COLUMN PERSON.year_of_birth  IS 'The year of birth of the person. For data sources with date of birth, the year is extracted. For data sources where the year of birth is not available, the approximate year of birth is derived based on any age group categorization available.';
COMMENT ON COLUMN PERSON.month_of_birth IS 'The month of birth of the person. For data sources that provide the precise date of birth, the month is extracted and stored in this field.';
COMMENT ON COLUMN PERSON.day_of_birth IS 'The day of the month of birth of the person. For data sources that provide the precise date of birth, the day is extracted and stored in this field.';
COMMENT ON COLUMN PERSON.birth_datetime IS 'The date and time of birth of the person.';
COMMENT ON COLUMN PERSON.race_concept_id IS 'A foreign key that refers to an identifier in the CONCEPT table for the unique race of the person.';
COMMENT ON COLUMN PERSON.ethnicity_concept_id IS 'A foreign key that refers to the standard concept identifier in the Standardized Vocabularies for the ethnicity of the person.';
COMMENT ON COLUMN PERSON.location_id IS 'A foreign key to the place of residency for the person in the location table, where the detailed address information is stored.';
COMMENT ON COLUMN PERSON.provider_id IS 'A foreign key to the primary care provider the person is seeing in the provider table.';
COMMENT ON COLUMN PERSON.care_site_id IS 'A foreign key to the site of primary care in the care_site table, where the details of the care site are stored.';
COMMENT ON COLUMN PERSON.person_source_value IS 'An (encrypted) key derived from the person identifier in the source data. This is necessary when a use case requires a link back to the person data at the source dataset.';
COMMENT ON COLUMN PERSON.gender_source_value IS 'The source code for the gender of the person as it appears in the source data. The person’s gender is mapped to a standard gender concept in the Standardized Vocabularies; the original value is stored here for reference.';
COMMENT ON COLUMN PERSON.gender_source_concept_id IS 'A foreign key to the gender concept that refers to the code used in the source.';
COMMENT ON COLUMN PERSON.race_source_value IS 'The source code for the race of the person as it appears in the source data. The person race is mapped to a standard race concept in the Standardized Vocabularies and the original value is stored here for reference.';
COMMENT ON COLUMN PERSON.race_source_concept_id IS 'A foreign key to the race concept that refers to the code used in the source.';
COMMENT ON COLUMN PERSON.ethnicity_source_value IS 'The source code for the ethnicity of the person as it appears in the source data. The person ethnicity is mapped to a standard ethnicity concept in the Standardized Vocabularies and the original code is, stored here for reference.';
COMMENT ON COLUMN PERSON.ethnicity_source_concept_id IS 'A foreign key to the ethnicity concept that refers to the code used in the source.';
-- OBSERVATION_PERIOD
COMMENT ON TABLE OBSERVATION_PERIOD IS '[CLINICAL] The OBSERVATION_PERIOD table contains records which uniquely define the spans of time for which a Person is at-risk to have clinical events recorded within the source systems, even if no events in fact are recorded (healthy patient with no healthcare interactions).';
COMMENT ON COLUMN OBSERVATION_PERIOD.observation_period_id IS 'A unique identifier for each observation period.';
COMMENT ON COLUMN OBSERVATION_PERIOD.person_id IS 'A foreign key identifier to the person for whom the observation period is defined. The demographic details of that person are stored in the person table.';
COMMENT ON COLUMN OBSERVATION_PERIOD.observation_period_start_date IS 'The start date of the observation period for which data are available from the data source.';
COMMENT ON COLUMN OBSERVATION_PERIOD.observation_period_end_date IS 'The end date of the observation period for which data are available from the data source.';
COMMENT ON COLUMN OBSERVATION_PERIOD.period_type_concept_id IS 'A foreign key identifier to the predefined concept in the Standardized Vocabularies reflecting the source of the observation period information';
-- OBSERVATION
COMMENT ON TABLE OBSERVATION IS '[CLINICAL] The OBSERVATION table captures clinical facts about a Person obtained in the context of examination, questioning or a procedure. Any data that cannot be represented by any other domains, such as social and lifestyle facts, medical history, family history, etc. are recorded here.';
COMMENT ON COLUMN OBSERVATION.observation_id IS 'A unique identifier for each observation.';
COMMENT ON COLUMN OBSERVATION.person_id IS 'A foreign key identifier to the Person about whom the observation was recorded. The demographic details of that Person are stored in the PERSON table.';
COMMENT ON COLUMN OBSERVATION.observation_concept_id IS 'A foreign key to the standard observation concept identifier in the Standardized Vocabularies.';
COMMENT ON COLUMN OBSERVATION.observation_date IS 'The date of the observation.';
COMMENT ON COLUMN OBSERVATION.observation_datetime IS 'The date and time of the observation.';
COMMENT ON COLUMN OBSERVATION.observation_type_concept_id IS 'A foreign key to the predefined concept identifier in the Standardized Vocabularies reflecting the type of the observation.';
COMMENT ON COLUMN OBSERVATION.value_as_number IS 'The observation result stored as a number. This is applicable to observations where the result is expressed as a numeric value.';
COMMENT ON COLUMN OBSERVATION.value_as_string IS 'The observation result stored as a string. This is applicable to observations where the result is expressed as verbatim text.';
COMMENT ON COLUMN OBSERVATION.value_as_concept_id IS 'A foreign key to an observation result stored as a Concept ID. This is applicable to observations where the result can be expressed as a Standard Concept from the Standardized Vocabularies (e.g., positive/negative, present/absent, low/high, etc.).';
COMMENT ON COLUMN OBSERVATION.qualifier_concept_id IS 'A foreign key to a Standard Concept ID for a qualifier (e.g., severity of drug-drug interaction alert)';
COMMENT ON COLUMN OBSERVATION.unit_concept_id IS 'A foreign key to a Standard Concept ID of measurement units in the Standardized Vocabularies.';
COMMENT ON COLUMN OBSERVATION.provider_id IS 'A foreign key to the provider in the PROVIDER table who was responsible for making the observation.';
COMMENT ON COLUMN OBSERVATION.visit_occurrence_id IS 'A foreign key to the visit in the VISIT_OCCURRENCE table during which the observation was recorded.';
COMMENT ON COLUMN OBSERVATION.visit_detail_id IS 'A foreign key to the visit in the VISIT_DETAIL table during which the observation was recorded.';
COMMENT ON COLUMN OBSERVATION.observation_source_value IS 'The observation code as it appears in the source data. This code is mapped to a Standard Concept in the Standardized Vocabularies and the original code is, stored here for reference.';
COMMENT ON COLUMN OBSERVATION.observation_source_concept_id IS 'A foreign key to a Concept that refers to the code used in the source.';
COMMENT ON COLUMN OBSERVATION.unit_source_value IS 'The source code for the unit as it appears in the source data. This code is mapped to a standard unit concept in the Standardized Vocabularies and the original code is, stored here for reference.';
COMMENT ON COLUMN OBSERVATION.qualifier_source_value IS 'The source value associated with a qualifier to characterize the observation';
-- NOTE_NLP
COMMENT ON TABLE NOTE_NLP IS '[CLINICAL] The NOTE_NLP table will encode all output of NLP on clinical notes. Each row represents a single extracted term from a note.';
COMMENT ON COLUMN NOTE_NLP.note_nlp_id  IS 'A unique identifier for each term extracted from a note.';
COMMENT ON COLUMN NOTE_NLP.note_id  IS 'A foreign key to the Note table note the term was extracted from.';
COMMENT ON COLUMN NOTE_NLP.section_concept_id  IS 'A foreign key to the predefined Concept in the Standardized Vocabularies representing the section of the extracted term.';
COMMENT ON COLUMN NOTE_NLP.snippet  IS 'A small window of text surrounding the term.';
COMMENT ON COLUMN NOTE_NLP.offset  IS 'Character offset of the extracted term in the input note.';
COMMENT ON COLUMN NOTE_NLP.lexical_variant  IS 'Raw text extracted from the NLP tool.';
COMMENT ON COLUMN NOTE_NLP.note_nlp_concept_id  IS 'A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the normalized concept for the extracted term. Domain of the term is represented as part of the Concept table.';
COMMENT ON COLUMN NOTE_NLP.note_nlp_source_concept_id  IS 'A foreign key to a Concept that refers to the code in the source vocabulary used by the NLP system';
COMMENT ON COLUMN NOTE_NLP.nlp_system  IS 'Name and version of the NLP system that extracted the term.Useful for data provenance.';
COMMENT ON COLUMN NOTE_NLP.nlp_date  IS 'The date of the note processing.Useful for data provenance.';
COMMENT ON COLUMN NOTE_NLP.nlp_datetime  IS 'The date and time of the note processing. Useful for data provenance.';
COMMENT ON COLUMN NOTE_NLP.term_exists  IS 'A summary modifier that signifies presence or absence of the term for a given patient. Useful for quick querying. *';
--
--ECONOMIC
--
-- COST
COMMENT ON TABLE COST IS '[ECONOMIC] The COST table captures records containing the cost of any medical entity recorded in one of the DRUG_EXPOSURE, PROCEDURE_OCCURRENCE, VISIT_OCCURRENCE or DEVICE_OCCURRENCE tables. It replaces the corresponding DRUG_COST, PROCEDURE_COST, VISIT_COST or DEVICE_COST tables that were initially defined for the OMOP CDM V5. However, it also allows to capture cost information for records of the OBSERVATION and MEASUREMENT tables.';
COMMENT ON COLUMN COST.cost_id IS 'A unique identifier for each COST record.';
COMMENT ON COLUMN COST.cost_event_id IS 'A foreign key identifier to the event (e.g. Measurement, Procedure, Visit, Drug Exposure, etc) record for which cost data are recorded.';
COMMENT ON COLUMN COST.cost_domain_id IS 'The concept representing the domain of the cost event, from which the corresponding table can be inferred that contains the entity for which cost information is recorded.';
COMMENT ON COLUMN COST.cost_type_concept_id IS 'A foreign key identifier to a concept in the CONCEPT table for the provenance or the source of the COST data: Calculated from insurance claim information, provider revenue, calculated from cost-to-charge ratio, reported from accounting database, etc.';
COMMENT ON COLUMN COST.currency_concept_id IS 'A foreign key identifier to the concept representing the 3-letter code used to delineate international currencies, such as USD for US Dollar.';
COMMENT ON COLUMN COST.total_charge IS 'The total amount charged by some provider of goods or services (e.g. hospital, physician pharmacy, dme provider) to payers (insurance companies, the patient).';
COMMENT ON COLUMN COST.total_cost IS 'The cost incurred by the provider of goods or services.';
COMMENT ON COLUMN COST.total_paid IS 'The total amount actually paid from all payers for goods or services of the provider.';
COMMENT ON COLUMN COST.paid_by_payer IS 'The amount paid by the Payer for the goods or services.';
COMMENT ON COLUMN COST.paid_by_patient IS 'The total amount paid by the Person as a share of the expenses.';
COMMENT ON COLUMN COST.paid_patient_copay IS 'The amount paid by the Person as a fixed contribution to the expenses.';
COMMENT ON COLUMN COST.paid_patient_coinsurance IS 'The amount paid by the Person as a joint assumption of risk. Typically, this is a percentage of the expenses defined by the Payer Plan after the Person''s deductible is exceeded.';
COMMENT ON COLUMN COST.paid_patient_deductible IS 'The amount paid by the Person that is counted toward the deductible defined by the Payer Plan. paid_patient_deductible does contribute to the paid_by_patient variable.';
COMMENT ON COLUMN COST.paid_by_primary IS 'The amount paid by a primary Payer through the coordination of benefits.';
COMMENT ON COLUMN COST.paid_ingredient_cost IS 'The amount paid by the Payer to a pharmacy for the drug, excluding the amount paid for dispensing the drug.  paid_ingredient_cost contributes to the paid_by_payer field if this field is populated with a nonzero value.';
COMMENT ON COLUMN COST.paid_dispensing_fee IS 'The amount paid by the Payer to a pharmacy for dispensing a drug, excluding the amount paid for the drug ingredient. paid_dispensing_fee contributes to the paid_by_payer field if this field is populated with a nonzero value.';
COMMENT ON COLUMN COST.payer_plan_period_id IS 'A foreign key to the PAYER_PLAN_PERIOD table, where the details of the Payer, Plan and Family are stored.  Record the payer_plan_id that relates to the payer who contributed to the paid_by_payer field.';
COMMENT ON COLUMN COST.amount_allowed IS 'The contracted amount agreed between the payer and provider.';
COMMENT ON COLUMN COST.revenue_code_concept_id IS 'A foreign key referring to a Standard Concept ID in the Standardized Vocabularies for Revenue codes.';
COMMENT ON COLUMN COST.revenue_code_source_value IS 'The source code for the Revenue code as it appears in the source data, stored here for reference.';
COMMENT ON COLUMN COST.drg_concept_id IS 'A foreign key to the predefined concept in the DRG Vocabulary reflecting the DRG for a visit.';
COMMENT ON COLUMN COST.drg_source_value IS 'The 3-digit DRG source code as it appears in the source data.';
-- PAYER_PLAN_PERIOD
COMMENT ON TABLE PAYER_PLAN_PERIOD IS '[ECONOMIC] The PAYER_PLAN_PERIOD table captures details of the period of time that a Person is continuously enrolled under a specific health Plan benefit structure from a given Payer. Each Person receiving healthcare is typically covered by a health benefit plan, which pays for (fully or partially), or directly provides, the care. These benefit plans are provided by payers, such as health insurances or state or government agencies. In each plan the details of the health benefits are defined for the Person or her family, and the health benefit Plan might change over time typically with increasing utilization (reaching certain cost thresholds such as deductibles), plan availability and purchasing choices of the Person. The unique combinations of Payer organizations, health benefit Plans and time periods in which they are valid for a Person are recorded in this table.';
COMMENT ON COLUMN PAYER_PLAN_PERIOD.payer_plan_period_id IS 'A identifier for each unique combination of payer, plan, family code and time span.';
COMMENT ON COLUMN PAYER_PLAN_PERIOD.person_id IS 'A foreign key identifier to the Person covered by the payer. The demographic details of that Person are stored in the PERSON table.';
COMMENT ON COLUMN PAYER_PLAN_PERIOD.payer_plan_period_start_date IS 'The start date of the payer plan period.';
COMMENT ON COLUMN PAYER_PLAN_PERIOD.payer_plan_period_end_date IS 'The end date of the payer plan period.';
COMMENT ON COLUMN PAYER_PLAN_PERIOD.payer_source_value IS 'The source code for the payer as it appears in the source data.';
COMMENT ON COLUMN PAYER_PLAN_PERIOD.plan_source_value IS 'The source code for the Person''s health benefit plan as it appears in the source data.';
COMMENT ON COLUMN PAYER_PLAN_PERIOD.family_source_value IS 'The source code for the Person''s family as it appears in the source data.';
--
--METADATA
--
-- CDM_SOURCE
COMMENT ON TABLE CDM_SOURCE IS '[METADATA] The CDM_SOURCE table contains detail about the source database and the process used to transform the data into the OMOP Common Data Model.';
COMMENT ON COLUMN CDM_SOURCE.cdm_source_name IS 'The full name of the source';
COMMENT ON COLUMN CDM_SOURCE.cdm_source_abbreviation IS 'An abbreviation of the name';
COMMENT ON COLUMN CDM_SOURCE.cdm_holder IS 'The name of the organization responsible for the development of the CDM instance';
COMMENT ON COLUMN CDM_SOURCE.source_description IS 'A description of the source data origin and purpose for collection. The description may contain a summary of the period of time that is expected to be covered by this dataset.';
COMMENT ON COLUMN CDM_SOURCE.source_documentation_reference IS 'URL or other external reference to location of source documentation';
COMMENT ON COLUMN CDM_SOURCE.cdm_etl_reference IS 'URL or other external reference to location of ETL specification documentation and ETL source code';
COMMENT ON COLUMN CDM_SOURCE.source_release_date IS 'The date for which the source data are most current, such as the last day of data capture';
COMMENT ON COLUMN CDM_SOURCE.cdm_release_date IS 'The date when the CDM was instantiated';
COMMENT ON COLUMN CDM_SOURCE.cdm_version IS 'The version of CDM used';
COMMENT ON COLUMN CDM_SOURCE.vocabulary_version IS 'The version of the vocabulary used';
--
--DERIVED
--
-- COHORT_ATTRIBUTE
COMMENT ON TABLE COHORT_ATTRIBUTE IS '[DERIVED] The COHORT_ATTRIBUTE table contains attributes associated with each subject within a cohort, as defined by a given set of criteria for a duration of time. The definition of the Cohort Attribute is contained in the ATTRIBUTE_DEFINITION table.';
COMMENT ON COLUMN COHORT_ATTRIBUTE.cohort_definition_id IS 'A foreign key to a record in the [COHORT_DEFINITION](https://github.com/OHDSI/CommonDataModel/wiki/COHORT_DEFINITION) table containing relevant Cohort Definition information.';
COMMENT ON COLUMN COHORT_ATTRIBUTE.subject_id IS 'A foreign key to the subject in the Cohort. These could be referring to records in the PERSON, PROVIDER, VISIT_OCCURRENCE table.';
COMMENT ON COLUMN COHORT_ATTRIBUTE.cohort_start_date IS 'The date when the Cohort Definition criteria for the Person, Provider or Visit first match.';
COMMENT ON COLUMN COHORT_ATTRIBUTE.cohort_end_date IS 'The date when the Cohort Definition criteria for the Person, Provider or Visit no longer match or the Cohort membership was terminated.';
COMMENT ON COLUMN COHORT_ATTRIBUTE.attribute_definition_id IS 'A foreign key to a record in the [ATTRIBUTE_DEFINITION](https://github.com/OHDSI/CommonDataModel/wiki/ATTRIBUTE_DEFINITION) table containing relevant Attribute Definition information.';
COMMENT ON COLUMN COHORT_ATTRIBUTE.value_as_number IS 'The attribute result stored as a number. This is applicable to attributes where the result is expressed as a numeric value.';
COMMENT ON COLUMN COHORT_ATTRIBUTE.value_as_concept_id IS 'The attribute result stored as a Concept ID. This is applicable to attributes where the result is expressed as a categorical value.';
-- COHORT
COMMENT ON TABLE COHORT IS '[DERIVED] The COHORT table contains records of subjects that satisfy a given set of criteria for a duration of time. The definition of the cohort is contained within the COHORT_DEFINITION table. Cohorts can be constructed of patients (Persons), Providers or Visits.';
COMMENT ON COLUMN COHORT.cohort_definition_id IS 'A foreign key to a record in the COHORT_DEFINITION table containing relevant Cohort Definition information.';
COMMENT ON COLUMN COHORT.subject_id IS 'A foreign key to the subject in the cohort. These could be referring to records in the PERSON, PROVIDER, VISIT_OCCURRENCE table.';
COMMENT ON COLUMN COHORT.cohort_start_date IS 'The date when the Cohort Definition criteria for the Person, Provider or Visit first match.';
COMMENT ON COLUMN COHORT.cohort_end_date IS 'The date when the Cohort Definition criteria for the Person, Provider or Visit no longer match or the Cohort membership was terminated.';
-- CONDITION_ERA
COMMENT ON TABLE CONDITION_ERA IS '[DERIVED] A Condition Era is defined as a span of time when the Person is assumed to have a given condition.';
COMMENT ON COLUMN CONDITION_ERA.condition_era_id IS 'A unique identifier for each Condition Era.';
COMMENT ON COLUMN CONDITION_ERA.person_id IS 'A foreign key identifier to the Person who is experiencing the Condition during the Condition Era. The demographic details of that Person are stored in the PERSON table.';
COMMENT ON COLUMN CONDITION_ERA.condition_concept_id IS 'A foreign key that refers to a standard Condition Concept identifier in the Standardized Vocabularies.';
COMMENT ON COLUMN CONDITION_ERA.condition_era_start_date IS 'The start date for the Condition Era constructed from the individual instances of Condition Occurrences. It is the start date of the very first chronologically recorded instance of the condition.';
COMMENT ON COLUMN CONDITION_ERA.condition_era_end_date IS 'The end date for the Condition Era constructed from the individual instances of Condition Occurrences. It is the end date of the final continuously recorded instance of the Condition.';
COMMENT ON COLUMN CONDITION_ERA.condition_occurrence_count IS 'The number of individual Condition Occurrences used to construct the condition era.';
-- DOSE_ERA
COMMENT ON TABLE DOSE_ERA IS '[DERIVED] A Dose Era is defined as a span of time when the Person is assumed to be exposed to a constant dose of a specific active ingredient.';
COMMENT ON COLUMN DOSE_ERA.dose_era_id IS 'A unique identifier for each Dose Era.';
COMMENT ON COLUMN DOSE_ERA.person_id IS 'A foreign key identifier to the Person who is subjected to the drug during the drug era. The demographic details of that Person are stored in the PERSON table.';
COMMENT ON COLUMN DOSE_ERA.drug_concept_id IS 'A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies for the active Ingredient Concept.';
COMMENT ON COLUMN DOSE_ERA.unit_concept_id IS 'A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies for the unit concept.';
COMMENT ON COLUMN DOSE_ERA.dose_value IS 'The numeric value of the dose.';
COMMENT ON COLUMN DOSE_ERA.dose_era_start_date IS 'The start date for the drug era constructed from the individual instances of drug exposures. It is the start date of the very first chronologically recorded instance of utilization of a drug.';
COMMENT ON COLUMN DOSE_ERA.dose_era_end_date IS 'The end date for the drug era constructed from the individual instance of drug exposures. It is the end date of the final continuously recorded instance of utilization of a drug.';
-- DRUG_ERA
COMMENT ON TABLE DRUG_ERA IS '[DERIVED] A Drug Era is defined as a span of time when the Person is assumed to be exposed to a particular active ingredient. A Drug Era is not the same as a Drug Exposure: Exposures are individual records corresponding to the source when Drug was delivered to the Person, while successive periods of Drug Exposures are combined under certain rules to produce continuous Drug Eras.';
COMMENT ON COLUMN DRUG_ERA.drug_era_id IS 'A unique identifier for each Drug Era.';
COMMENT ON COLUMN DRUG_ERA.person_id IS 'A foreign key identifier to the Person who is subjected to the Drug during the fDrug Era. The demographic details of that Person are stored in the PERSON table.';
COMMENT ON COLUMN DRUG_ERA.drug_concept_id IS 'A foreign key that refers to a Standard Concept identifier in the Standardized Vocabularies for the Ingredient Concept.';
COMMENT ON COLUMN DRUG_ERA.drug_era_start_date IS 'The start date for the Drug Era constructed from the individual instances of Drug Exposures. It is the start date of the very first chronologically recorded instance of conutilization of a Drug.';
COMMENT ON COLUMN DRUG_ERA.drug_era_end_date IS 'The end date for the drug era constructed from the individual instance of drug exposures. It is the end date of the final continuously recorded instance of utilization of a drug.';
COMMENT ON COLUMN DRUG_ERA.drug_exposure_count IS 'The number of individual Drug Exposure occurrences used to construct the Drug Era.';
COMMENT ON COLUMN DRUG_ERA.gap_days IS 'The number of days that are not covered by DRUG_EXPOSURE records that were used to make up the era record.';
--
--SYSTEM
--
-- CARE_SITE
COMMENT ON TABLE CARE_SITE IS '[SYSTEM] The CARE_SITE table contains a list of uniquely identified institutional (physical or organizational) units where healthcare delivery is practiced (offices, wards, hospitals, clinics, etc.).';
COMMENT ON COLUMN CARE_SITE.care_site_id IS 'A unique identifier for each Care Site.';
COMMENT ON COLUMN CARE_SITE.care_site_name IS 'The verbatim description or name of the Care Site as in data source';
COMMENT ON COLUMN CARE_SITE.place_of_service_concept_id IS 'A foreign key that refers to a Place of Service Concept ID in the Standardized Vocabularies.';
COMMENT ON COLUMN CARE_SITE.location_id IS 'A foreign key to the geographic Location in the LOCATION table, where the detailed address information is stored.';
COMMENT ON COLUMN CARE_SITE.care_site_source_value IS 'The identifier for the Care Site in the source data, stored here for reference.';
COMMENT ON COLUMN CARE_SITE.place_of_service_source_value IS 'The source code for the Place of Service as it appears in the source data, stored here for reference.';
-- LOCATION
COMMENT ON TABLE LOCATION IS '[SYSTEM] The LOCATION table represents a generic way to capture physical location or address information of Persons and Care Sites.';
COMMENT ON COLUMN LOCATION.location_id IS 'A unique identifier for each geographic location.';
COMMENT ON COLUMN LOCATION.address_1 IS 'The address field 1, typically used for the street address, as it appears in the source data.';
COMMENT ON COLUMN LOCATION.address_2 IS 'The address field 2, typically used for additional detail such as buildings, suites, floors, as it appears in the source data.';
COMMENT ON COLUMN LOCATION.city  IS 'The city field as it appears in the source data.';
COMMENT ON COLUMN LOCATION.state IS 'The state field as it appears in the source data.';
COMMENT ON COLUMN LOCATION.zip IS 'The zip or postal code.';
COMMENT ON COLUMN LOCATION.county IS 'The county.';
COMMENT ON COLUMN LOCATION.location_source_value IS 'The verbatim information that is used to uniquely identify the location as it appears in the source data.';
-- PROVIDER
COMMENT ON TABLE PROVIDER IS '[SYSTEM] The PROVIDER table contains a list of uniquely identified healthcare providers. These are individuals providing hands-on healthcare to patients, such as physicians, nurses, midwives, physical therapists etc.';
COMMENT ON COLUMN PROVIDER.provider_id IS 'A unique identifier for each Provider.';
COMMENT ON COLUMN PROVIDER.provider_name IS 'A description of the Provider.';
COMMENT ON COLUMN PROVIDER.npi IS 'The National Provider Identifier (NPI) of the provider.';
COMMENT ON COLUMN PROVIDER.dea IS 'The Drug Enforcement Administration (DEA) number of the provider.';
COMMENT ON COLUMN PROVIDER.specialty_concept_id IS 'A foreign key to a Standard Specialty Concept ID in the Standardized Vocabularies.';
COMMENT ON COLUMN PROVIDER.care_site_id IS 'A foreign key to the main Care Site where the provider is practicing.';
COMMENT ON COLUMN PROVIDER.year_of_birth IS 'The year of birth of the Provider.';
COMMENT ON COLUMN PROVIDER.gender_concept_id IS 'The gender of the Provider.';
COMMENT ON COLUMN PROVIDER.provider_source_value IS 'The identifier used for the Provider in the source data, stored here for reference.';
COMMENT ON COLUMN PROVIDER.specialty_source_value IS 'The source code for the Provider specialty as it appears in the source data, stored here for reference.';
COMMENT ON COLUMN PROVIDER.specialty_source_concept_id IS 'A foreign key to a Concept that refers to the code used in the source.';
COMMENT ON COLUMN PROVIDER.gender_source_value IS 'The gender code for the Provider as it appears in the source data, stored here for reference.';
COMMENT ON COLUMN PROVIDER.gender_source_concept_id IS 'A foreign key to a Concept that refers to the code used in the source.';
--
--VOCABULARY
--
-- ATTRIBUTE_DEFINITION
COMMENT ON TABLE ATTRIBUTE_DEFINITION IS '[VOCABULARY] The ATTRIBUTE_DEFINITION table contains records defining Attributes, or covariates, to members of a Cohort through an associated description and syntax and upon instantiation (execution of the algorithm) placed into the COHORT_ATTRIBUTE table. Attributes are derived elements that can be selected or calculated for a subject in a Cohort. The ATTRIBUTE_DEFINITION table provides a standardized structure for maintaining the rules governing the calculation of covariates for a subject in a Cohort, and can store operational programming code to instantiate the Attributes for a given Cohort within the OMOP Common Data Model.';
COMMENT ON COLUMN ATTRIBUTE_DEFINITION.attribute_definition_id IS 'A unique identifier for each Attribute.';
COMMENT ON COLUMN ATTRIBUTE_DEFINITION.attribute_name IS 'A short description of the Attribute.';
COMMENT ON COLUMN ATTRIBUTE_DEFINITION.attribute_description IS 'A complete description of the Attribute definition';
COMMENT ON COLUMN ATTRIBUTE_DEFINITION.attribute_type_concept_id IS 'Type defining what kind of Attribute Definition the record represents and how the syntax may be executed';
COMMENT ON COLUMN ATTRIBUTE_DEFINITION.attribute_syntax IS 'Syntax or code to operationalize the Attribute definition';
-- COHORT_DEFINITION
COMMENT ON TABLE COHORT_DEFINITION IS '[VOCABULARY] The COHORT_DEFINITION table contains records defining a Cohort derived from the data through the associated description and syntax and upon instantiation (execution of the algorithm) placed into the COHORT table. Cohorts are a set of subjects that satisfy a given combination of inclusion criteria for a duration of time. The COHORT_DEFINITION table provides a standardized structure for maintaining the rules governing the inclusion of a subject into a cohort, and can store operational programming code to instantiate the cohort within the OMOP Common Data Model.';
COMMENT ON COLUMN COHORT_DEFINITION.cohort_definition_id IS 'A unique identifier for each Cohort.';
COMMENT ON COLUMN COHORT_DEFINITION.cohort_definition_name IS 'A short description of the Cohort.';
COMMENT ON COLUMN COHORT_DEFINITION.cohort_definition_description IS 'A complete description of the Cohort definition';
COMMENT ON COLUMN COHORT_DEFINITION.definition_type_concept_id IS 'Type defining what kind of Cohort Definition the record represents and how the syntax may be executed';
COMMENT ON COLUMN COHORT_DEFINITION.cohort_definition_syntax IS 'Syntax or code to operationalize the Cohort definition';
COMMENT ON COLUMN COHORT_DEFINITION.subject_concept_id IS 'A foreign key to the Concept to which defines the domain of subjects that are members of the cohort (e.g., Person, Provider, Visit).';
COMMENT ON COLUMN COHORT_DEFINITION.cohort_initiation_date IS 'A date to indicate when the Cohort was initiated in the COHORT table';
-- CONCEPT_ANCESTOR
COMMENT ON TABLE CONCEPT_ANCESTOR IS '[VOCABULARY] The CONCEPT_ANCESTOR table is designed to simplify observational analysis by providing the complete hierarchical relationships between Concepts. Only direct parent-child relationships between Concepts are stored in the CONCEPT_RELATIONSHIP table. To determine higher level ancestry connections, all individual direct relationships would have to be navigated at analysis time. The  CONCEPT_ANCESTOR table includes records for all parent-child relationships, as well as grandparent-grandchild relationships and those of any other level of lineage. Using the CONCEPT_ANCESTOR table allows for querying for all descendants of a hierarchical concept. For example, drug ingredients and drug products are all descendants of a drug class ancestor.';
COMMENT ON COLUMN CONCEPT_ANCESTOR.ancestor_concept_id IS 'A foreign key to the concept in the concept table for the higher-level concept that forms the ancestor in the relationship.';
COMMENT ON COLUMN CONCEPT_ANCESTOR.descendant_concept_id IS 'A foreign key to the concept in the concept table for the lower-level concept that forms the descendant in the relationship.';
COMMENT ON COLUMN CONCEPT_ANCESTOR.min_levels_of_separation IS 'The minimum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an attribute that is used to simplify hierarchic analysis.';
COMMENT ON COLUMN CONCEPT_ANCESTOR.max_levels_of_separation IS 'The maximum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an attribute that is used to simplify hierarchic analysis.';
-- CONCEPT_CLASS
COMMENT ON TABLE CONCEPT_CLASS IS '[VOCABULARY] The CONCEPT_CLASS table is a reference table, which includes a list of the classifications used to differentiate Concepts within a given Vocabulary. This reference table is populated with a single record for each Concept Class:';
COMMENT ON COLUMN CONCEPT_CLASS.concept_class_id IS 'A unique key for each class.';
COMMENT ON COLUMN CONCEPT_CLASS.concept_class_name IS 'The name describing the Concept Class, e.g. "Clinical Finding", "Ingredient", etc.';
COMMENT ON COLUMN CONCEPT_CLASS.concept_class_concept_id IS 'A foreign key that refers to an identifier in the [CONCEPT](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT) table for the unique Concept Class the record belongs to.';
-- CONCEPT
COMMENT ON TABLE CONCEPT IS '[VOCABULARY] The Standardized Vocabularies contains records, or Concepts, that uniquely identify each fundamental unit of meaning used to express clinical information in all domain tables of the CDM. Concepts are derived from vocabularies, which represent clinical information across a domain (e.g. conditions, drugs, procedures) through the use of codes and associated descriptions. Some Concepts are designated Standard Concepts, meaning these Concepts can be used as normative expressions of a clinical entity within the OMOP Common Data Model and within standardized analytics. Each Standard Concept belongs to one domain, which defines the location where the Concept would be expected to occur within data tables of the CDM.';
COMMENT ON COLUMN CONCEPT.concept_id IS 'A unique identifier for each Concept across all domains.';
COMMENT ON COLUMN CONCEPT.concept_name IS 'An unambiguous, meaningful and descriptive name for the Concept.';
COMMENT ON COLUMN CONCEPT.domain_id IS 'A foreign key to the [DOMAIN](https://github.com/OHDSI/CommonDataModel/wiki/DOMAIN) table the Concept belongs to.';
COMMENT ON COLUMN CONCEPT.vocabulary_id IS 'A foreign key to the [VOCABULARY](https://github.com/OHDSI/CommonDataModel/wiki/VOCABULARY) table indicating from which source the Concept has been adapted.';
COMMENT ON COLUMN CONCEPT.concept_class_id IS 'The attribute or concept class of the Concept. Examples are ''Clinical Drug'', ''Ingredient'', ''Clinical Finding''etc.';
COMMENT ON COLUMN CONCEPT.standard_concept IS 'This flag determines where a Concept is a Standard Concept, i.e. is used in the data, a Classification Concept, or a non-standard Source Concept. The allowables values are ''S''(Standard Concept) and ''C''(Classification Concept), otherwise the content is NULL.';
COMMENT ON COLUMN CONCEPT.concept_code IS 'The concept code represents the identifier of the Concept in the source vocabulary, such as SNOMED-CT concept IDs, RxNorm RXCUIs etc. Note that concept codes are not unique across vocabularies.';
COMMENT ON COLUMN CONCEPT.valid_start_date IS 'The date when the Concept was first recorded. The default value is 1-Jan-1970, meaning, the Concept has no (known) date of inception.';
COMMENT ON COLUMN CONCEPT.valid_end_date IS 'The date when the Concept became invalid because it was deleted or superseded (updated) by a new concept. The default value is 31-Dec-2099, meaning, the Concept is valid until it becomes deprecated.';
COMMENT ON COLUMN CONCEPT.invalid_reason IS 'Reason the Concept was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default value.';
-- CONCEPT_RELATIONSHIP
COMMENT ON TABLE CONCEPT_RELATIONSHIP IS '[VOCABULARY] The CONCEPT_RELATIONSHIP table contains records that define direct relationships between any two Concepts and the nature or type of the relationship. Each type of a relationship is defined in the [RELATIONSHIP](https://github.com/OHDSI/CommonDataModel/wiki/RELATIONSHIP) table.';
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.concept_id_1 IS 'A foreign key to a Concept in the [CONCEPT](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT) table associated with the relationship. Relationships are directional, and this field represents the source concept designation.';
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.concept_id_2 IS 'A foreign key to a Concept in the [CONCEPT](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT) table associated with the relationship. Relationships are directional, and this field represents the destination concept designation.';
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.relationship_id IS 'A unique identifier to the type or nature of the Relationship as defined in the [RELATIONSHIP](https://github.com/OHDSI/CommonDataModel/wiki/RELATIONSHIP) table.';
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.valid_start_date IS 'The date when the instance of the Concept Relationship is first recorded.';
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.valid_end_date IS 'The date when the Concept Relationship became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.';
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.invalid_reason IS 'Reason the relationship was invalidated. Possible values are ''D''(deleted), ''U''(replaced with an update) or NULL when valid_end_date has the default value.';
-- CONCEPT_SYNONYM
COMMENT ON TABLE CONCEPT_SYNONYM IS '[VOCABULARY] The CONCEPT_SYNONYM table is used to store alternate names and descriptions for Concepts.';
COMMENT ON COLUMN CONCEPT_SYNONYM.concept_id IS 'A foreign key to the Concept in the CONCEPT table.';
COMMENT ON COLUMN CONCEPT_SYNONYM.concept_synonym_name IS 'The alternative name for the Concept.';
COMMENT ON COLUMN CONCEPT_SYNONYM.language_concept_id IS 'A foreign key to a Concept representing the language.';
-- DOMAIN
COMMENT ON TABLE DOMAIN IS '[VOCABULARY] The DOMAIN table includes a list of OMOP-defined Domains the Concepts of the Standardized Vocabularies can belong to. A Domain defines the set of allowable Concepts for the standardized fields in the CDM tables. For example, the "Condition" Domain contains Concepts that describe a condition of a patient, and these Concepts can only be stored in the condition_concept_id field of the [CONDITION_OCCURRENCE](https://github.com/OHDSI/CommonDataModel/wiki/CONDITION_OCCURRENCE) and [CONDITION_ERA](https://github.com/OHDSI/CommonDataModel/wiki/CONDITION_ERA) tables. This reference table is populated with a single record for each Domain and includes a descriptive name for the Domain.';
COMMENT ON COLUMN DOMAIN.domain_id IS 'A unique key for each domain.';
COMMENT ON COLUMN DOMAIN.domain_name IS 'The name describing the Domain, e.g. "Condition", "Procedure", "Measurement" etc.';
COMMENT ON COLUMN DOMAIN.domain_concept_id IS 'A foreign key that refers to an identifier in the [CONCEPT](https://github.com/OHDSI/CommonDataModel/wiki/CONCEPT) table for the unique Domain Concept the Domain record belongs to.';
-- DRUG_STRENGTH
COMMENT ON TABLE DRUG_STRENGTH IS '[VOCABULARY] The DRUG_STRENGTH table contains structured content about the amount or concentration and associated units of a specific ingredient contained within a particular drug product. This table is supplemental information to support standardized analysis of drug utilization.';
COMMENT ON COLUMN DRUG_STRENGTH.drug_concept_id IS 'A foreign key to the Concept in the CONCEPT table representing the identifier for Branded Drug or Clinical Drug Concept.';
COMMENT ON COLUMN DRUG_STRENGTH.ingredient_concept_id IS 'A foreign key to the Concept in the CONCEPT table, representing the identifier for drug Ingredient Concept contained within the drug product.';
COMMENT ON COLUMN DRUG_STRENGTH.amount_value IS 'The numeric value associated with the amount of active ingredient contained within the product.';
COMMENT ON COLUMN DRUG_STRENGTH.amount_unit_concept_id IS 'A foreign key to the Concept in the CONCEPT table representing the identifier for the Unit for the absolute amount of active ingredient.';
COMMENT ON COLUMN DRUG_STRENGTH.numerator_value IS 'The numeric value associated with the concentration of the active ingredient contained in the product';
COMMENT ON COLUMN DRUG_STRENGTH.numerator_unit_concept_id IS 'A foreign key to the Concept in the CONCEPT table representing the identifier for the numerator Unit for the concentration of active ingredient.';
COMMENT ON COLUMN DRUG_STRENGTH.denominator_value IS 'The amount of total liquid (or other divisible product, such as ointment, gel, spray, etc.).';
COMMENT ON COLUMN DRUG_STRENGTH.denominator_unit_concept_id IS 'A foreign key to the Concept in the CONCEPT table representing the identifier for the denominator Unit for the concentration of active ingredient.';
COMMENT ON COLUMN DRUG_STRENGTH.box_size IS 'The number of units of Clinical of Branded Drug, or Quantified Clinical or Branded Drug contained in a box as dispensed to the patient';
COMMENT ON COLUMN DRUG_STRENGTH.valid_start_date IS 'The date when the Concept was first recorded. The default value is 1-Jan-1970.';
COMMENT ON COLUMN DRUG_STRENGTH.valid_end_date IS 'The date when the concept became invalid because it was deleted or superseded (updated) by a new Concept. The default value is 31-Dec-2099.';
COMMENT ON COLUMN DRUG_STRENGTH.invalid_reason IS 'Reason the concept was invalidated. Possible values are ''D''(deleted), ''U''(replaced with an update) or NULL when valid_end_date has the default value.';
-- RELATIONSHIP
COMMENT ON TABLE RELATIONSHIP IS '[VOCABULARY] The RELATIONSHIP table provides a reference list of all types of relationships that can be used to associate any two concepts in the CONCEPT_RELATIONSHP table.';
COMMENT ON COLUMN RELATIONSHIP.relationship_id IS 'The type of relationship captured by the relationship record.';
COMMENT ON COLUMN RELATIONSHIP.relationship_name IS 'The text that describes the relationship type.';
COMMENT ON COLUMN RELATIONSHIP.is_hierarchical IS 'Defines whether a relationship defines concepts into classes or hierarchies. Values are 1 for hierarchical relationship or 0 if not.';
COMMENT ON COLUMN RELATIONSHIP.defines_ancestry IS 'Defines whether a hierarchical relationship contributes to the concept_ancestor table. These are subsets of the hierarchical relationships. Valid values are 1 or 0.';
COMMENT ON COLUMN RELATIONSHIP.reverse_relationship_id IS 'The identifier for the relationship used to define the reverse relationship between two concepts.';
COMMENT ON COLUMN RELATIONSHIP.relationship_concept_id IS 'A foreign key that refers to an identifier in the CONCEPT table for the unique relationship concept.';
-- SOURCE_TO_CONCEPT_MAP
COMMENT ON TABLE SOURCE_TO_CONCEPT_MAP IS '[VOCABULARY] The source to concept map table is a legacy data structure within the OMOP Common Data Model, recommended for use in ETL processes to maintain local source codes which are not available as Concepts in the Standardized Vocabularies, and to establish mappings for each source code into a Standard Concept as target_concept_ids that can be used to populate the Common Data Model tables. The SOURCE_TO_CONCEPT_MAP table is no longer populated with content within the Standardized Vocabularies published to the OMOP community.';
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.source_code IS 'The source code being translated into a Standard Concept.';
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.source_concept_id IS 'A foreign key to the Source Concept that is being translated into a Standard Concept.';
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.source_vocabulary_id IS 'A foreign key to the VOCABULARY table defining the vocabulary of the source code that is being translated to a Standard Concept.';
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.source_code_description IS 'An optional description for the source code. This is included as a convenience to compare the description of the source code to the name of the concept.';
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.target_concept_id IS 'A foreign key to the target Concept to which the source code is being mapped.';
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.target_vocabulary_id IS 'A foreign key to the VOCABULARY table defining the vocabulary of the target Concept.';
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.valid_start_date IS 'The date when the mapping instance was first recorded.';
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.valid_end_date IS 'The date when the mapping instance became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.';
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.invalid_reason IS 'Reason the mapping instance was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default value.';
-- VOCABULARY
COMMENT ON TABLE VOCABULARY IS '[VOCABULARY] The VOCABULARY table includes a list of the Vocabularies collected from various sources or created de novo by the OMOP community. This reference table is populated with a single record for each Vocabulary source and includes a descriptive name and other associated attributes for the Vocabulary.';
COMMENT ON COLUMN VOCABULARY.vocabulary_id IS 'A unique identifier for each Vocabulary, such as ICD9CM, SNOMED, Visit.';
COMMENT ON COLUMN VOCABULARY.vocabulary_name IS 'The name describing the vocabulary, for example "International Classification of Diseases, Ninth Revision, Clinical Modification, Volume 1 and 2 (NCHS)" etc.';
COMMENT ON COLUMN VOCABULARY.vocabulary_reference IS 'External reference to documentation or available download of the about the vocabulary.';
COMMENT ON COLUMN VOCABULARY.vocabulary_version IS 'Version of the Vocabulary as indicated in the source.';
COMMENT ON COLUMN VOCABULARY.vocabulary_concept_id IS 'A foreign key that refers to a standard concept identifier in the CONCEPT table for the Vocabulary the VOCABULARY record belongs to.';
----------------------|------------------
