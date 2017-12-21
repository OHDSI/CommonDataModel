Common Data Model Development Branch
=================

This branch is meant to be a place to store DDLs for tables that have been accepted into a future version of the CDM to allow collaborators to begin using them before the official release. 

**Please Note:** These DDLs are only provided in the Sql Server dialect

Dev Tables Available:
=============

COST 
* [#81](https://github.com/OHDSI/CommonDataModel/issues/81#issuecomment-333811290) 
  * Adds PERSON_ID
  * Adds BILLED_DATE and PAID_DATE
  * The structure of the table changes from wide to tall and leverages the new COST_CONCEPT_ID to generalize the cost table and support many cost types