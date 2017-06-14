*OMOP Common Data Model v5.1 Specifications*
<br>*Authors: Christian Reich, Patrick Ryan, Rimma Belenkaya, Karthik Natarajan, Clair Blacketer*
<br>***Release date needed***

[Back to Table of Contents](TableofContents.md)
[Back to Background](Background.md)

---

# 1.2 Design Principles 

The CDM is designed to include all observational health data elements (experiences of the patient receiving health care) that are relevant for analysis use cases to support the generation of reliable scientific evidence about disease natural history, healthcare delivery, effects of medical interventions, the identification of demographic information, health care interventions and outcomes. 

Therefore, the CDM is designed to store observational data to allow for research, under the following principles: 
  - **Suitability for purpose.** The CDM aims at providing data organized in a way optimal for analysis, rather than for the purpose of operational needs of health care providers or payers. 
  - **Data protection.** All data that might jeopardize the identity and protection of patients, such as names, precise birthdays etc. are limited. Exceptions are possible where the research expressly requires more detailed information, such as precise birth dates for the study of infants.
  - **Design of domains.** The domains are modeled in a person-centric relational data model, where for each record the identity of the person and a date is captured as a minimum.
  - **Rationale for domains. ** Domains are identified and separately defined in an Entity-relationship model if they have an analysis use case and the domain has specific attributes that are not otherwise applicable.  All other data can be preserved as an observation in an entity-attribute-value structure.
  - **Standardized Vocabularies.** To standardize the content of those records, the CDM relies on the Standardized Vocabularies containing all necessary and appropriate corresponding standard healthcare concepts.
  - **Reuse of existing vocabularies.** If possible, these concepts are leveraged from national or industry standardization or vocabulary definition organizations or initiatives, such as the National Library of Medicine, the Department of Veterans' Affairs, the Center of Disease Control and Prevention, etc.
  - **Maintaining source codes.** Even though all codes are mapped to the Standardized Vocabularies, the model also stores the original source code to ensure no information is lost.
  - **Technology neutrality.** The CDM does not require a specific technology. It can be realized in any relational database, such as Oracle, SQL Server etc., or as SAS analytical datasets.
  - **Scalability.** The CDM is optimized for data processing and computational analysis to accommodate data sources that vary in size, including databases with up to hundreds of millions of persons and billions of clinical observations.
  - **Backwards compatibility.** All changes from previous CDMs are clearly delineated. Older versions of the CDM can be easily created from this CDMv5, and no information is lost that was present previously.
