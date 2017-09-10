The NOTE_NLP table will encode all output of NLP on clinical notes. Each row represents a single extracted term from a note.

Field | Required | Type | Description
:------------------------------- | :-------- | :------------ | :---------------------------------------------------
|note_nlp_id | Yes | Big Integer | A unique identifier for each term extracted from a note.|
|note_id | Yes | integer | A foreign key to the Note table note the term was extracted from.|
|section_concept_id | No | integer | A foreign key to the predefined Concept in the Standardized Vocabularies representing the section of the extracted term.|
|snippet | No | varchar(250) | A small window of text surrounding the term.|
|offset | No | varchar(50) | Character offset of the extracted term in the input note.|
|lexical_variant | Yes | varchar(250) | Raw text extracted from the NLP tool.|
|note_nlp_concept_id | No | integer | A foreign key to the predefined Concept in the Standardized Vocabularies reflecting the normalized concept for the extracted term. Domain of the term is represented as part of the Concept table.|
|note_nlp_source_concept_id | no | integer | A foreign key to a Concept that refers to the code in the source vocabulary used by the NLP system|
|nlp_system | No | varchar(250) | Name and version of the NLP system that extracted the term.Useful for data provenance.|
|nlp_date | Yes | date | The date of the note processing.Useful for data provenance.|
|nlp_datetime | No | datetime | The date and time of the note processing. Useful for data provenance.|
|term_exists | No | varchar(1) | A summary modifier that signifies presence or absence of the term for a given patient. Useful for quick querying. *|
|term_temporal | No | varchar(50) | An optional time modifier associated with the extracted term. (for now “past” or “present” only). Standardize it later.|
|term_modifiers | No | varchar(2000) | A compact description of all the modifiers of the specific term extracted by the NLP system. (e.g. “son has rash” ? “negated=no,subject=family, certainty=undef,conditional=false,general=false”).|

### Conventions

**Term_exists**
Term_exists is defined as a flag that indicates if the patient actually has or had the condition. Any of the following modifiers would make Term_exists false:

* Negation = true
* Subject = [anything other than the patient]
* Conditional = true
* Rule_out = true
* Uncertain = very low certainty or any lower certainties
 
A complete lack of modifiers would make Term_exists true. 

For the modifiers that are there, they would have to have these values:

* Negation = false
* Subject = patient
* Conditional = false
* Rule_out = false
* Uncertain = true or high or moderate or even low (could argue about low)

**Term_temporal**
Term_temporal is to indicate if a condition is “present” or just in the “past”.

The following would be past:
 
* History = true
* Concept_date = anything before the time of the report

**Term_modifiers**
Term_modifiers will concatenate all modifiers for different types of entities (conditions, drugs, labs etc) into one string. Lab values will be saved as one of the modifiers. A list of allowable modifiers (e.g., signature for medications) and their possible values will be standardized later.  
