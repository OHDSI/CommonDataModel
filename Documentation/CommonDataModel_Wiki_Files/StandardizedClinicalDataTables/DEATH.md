As of OMOP CDM v6.0, the DEATH table has been deprecated in favor of storing the cause of death in the CONDITION_OCCURRENCE table, any observations relating to death stored in the OBSERVATION table, and a singular death date will be chosen and stored in the PERSON table.

The 'Death' domain contains the clinical events surrounding how and when a Person dies. A Person can have information in the source system containing evidence about the Death, such as:

  * Condition Code in the Header or Detail information of claims
  * Status of enrollment into a health plan
  * Explicit record in EHR data

### Conventions 

No.|Convention Description
:--------|:------------------------------------
| 1  | Living patients should not have a value in PERSON.DEATH_DATETIME, nor should they have any records relating to death either in the CONDITION_OCCURRENCE or OBSERVATION tables
| 2  | Only one death date per individual can be used. If a patient has clinical activity (e.g. prescriptions filled, labs performed, etc) more than 60+ days after death you may want to drop the death record as it may have been falsely reported. If multiple records of death exist on multiple days you may select the death that you deem most reliable (e.g. death at discharge) or select the latest death date ([THEMIS issue #6](https://github.com/OHDSI/Themis/issues/6)).
| 3  | If multiple death records occur, the date and the person have to be the same, but the cause can be different. Can be reported by different sources as well ([THEMIS issue #5](https://github.com/OHDSI/Themis/issues/5)).
| 4  | If PERSON.DEATH_DATETIME cannot be precisely determined from the data, the best approximation should be used.
| 5  | Any cause of death should be stored in the CONDITION_OCCURRENCE table, using the CONDITION_TYPE vocabulary with the DEATH_TYPE concept class.
| 6  | All observations relating to death should be stored in the OBSERVATION table, including the concept [4306655](http://athena.ohdsi.org/search-terms/terms/4306655). 
| 7  | The DEATH_DATETIME in the PERSON table should not be used as the way to find all deaths<br><ul><li>`select * from PERSON where death_datetime is not null` should not be the practice</li><li>Rather, deaths should be found through the OBSERVATION table and the PERSON table is only used to determine which death date should be used in analysis</li></ul>
  
  