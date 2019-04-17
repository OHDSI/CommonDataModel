```
/*********************************************************************************
# Copyright 2019 Observational Health Data Sciences and Informatics
#
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
********************************************************************************/

/************************

 ####### #     # ####### ######      #####  ######  #     #           ####### 
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #       
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #       
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######  
 #     # #     # #     # #          #       #     # #     #    #    #       # 
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # 
 ####### #     # ####### #           #####  ######  #     #      ##    #####  
                                                                              

Script to load the common data model, version 5.0 vocabulary tables for IBM DB2 database on Windows (MS-DOS style file paths)
The database account running this script must have the "superuser" permission in the database.

Notes

1) There is no data file load for the SOURCE_TO_CONCEPT_MAP table because that table is deprecated in CDM version 5.0
2) This script assumes the CDM version 5 vocabulary zip file has been unzipped into the "C:\CDMV5VOCAB" directory. 
3) If you unzipped your CDM version 5 vocabulary files into a different directory then replace all file paths below, with your directory path.
4) Truncate each table that will be lodaed below, before running this script.

last revised: 16 Abr 2019

author:  Bruno Ambrozio (@bambrozio)


*************************/
```

# DB2 on IBM Cloud

1. Download and install [IBM Lift](https://www.lift-cli.cloud.ibm.com/)
2. In a terminal, declare the folowing environment variables to be used with the lift commands:
    > Find them in your [IBM Cloud Service Credentials](https://console.bluemix.net/services)
    ```
    TARGET_USER=<db user>
    TARGET_PASSWORD=<db password>
    TARGET_SCHEMA=<db schema>
    TARGET_HOST=<host>.services.<az>.bluemix.net
    ```

3. Upload each CSV followed by the data import command. e.g:

- DRUG_STRENGTH
    ```
    ./lift put --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file ~/Downloads/vocabulary.v5/DRUG_STRENGTH.csv

    ./lift load --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file-origin user --target-schema $TARGET_SCHEMA --field-delimiter 0X09 --date-format YYYYMMDD --header-row --remove --verbose --target-table DRUG_STRENGTH --filename DRUG_STRENGTH.csv
    ```
- CONCEPT
    ```
    ./lift put --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file ~/Downloads/vocabulary.v5/CONCEPT.csv

    ./lift load --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file-origin user --target-schema $TARGET_SCHEMA --field-delimiter 0X09 --date-format YYYYMMDD --header-row --remove --verbose --target-table CONCEPT --filename CONCEPT.csv
    ```
- CONCEPT_RELATIONSHIP
    ```
    ./lift put --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file ~/Downloads/vocabulary.v5/CONCEPT_RELATIONSHIP.csv

    ./lift load --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file-origin user --target-schema $TARGET_SCHEMA --field-delimiter 0X09 --date-format YYYYMMDD --header-row --remove --verbose --target-table CONCEPT_RELATIONSHIP --filename CONCEPT_RELATIONSHIP.csv
    ```
- CONCEPT_ANCESTOR
    ```
    ./lift put --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file ~/Downloads/vocabulary.v5/CONCEPT_ANCESTOR.csv

    ./lift load --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file-origin user --target-schema $TARGET_SCHEMA --field-delimiter 0X09 --date-format YYYYMMDD --header-row --remove --verbose --target-table CONCEPT_ANCESTOR --filename CONCEPT_ANCESTOR.csv
    ```
- CONCEPT_SYNONYM
    ```
    ./lift put --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file ~/Downloads/vocabulary.v5/CONCEPT_SYNONYM.csv

    ./lift load --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file-origin user --target-schema $TARGET_SCHEMA --field-delimiter 0X09 --date-format YYYYMMDD --header-row --remove --verbose --target-table CONCEPT_SYNONYM --filename CONCEPT_SYNONYM.csv
    ```
- VOCABULARY
    ```
    ./lift put --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file ~/Downloads/vocabulary.v5/VOCABULARY.csv

    ./lift load --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file-origin user --target-schema $TARGET_SCHEMA --field-delimiter 0X09 --date-format YYYYMMDD --header-row --remove --verbose --target-table VOCABULARY --filename VOCABULARY.csv
    ```
- RELATIONSHIP
    ```
    ./lift put --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file ~/Downloads/vocabulary.v5/RELATIONSHIP.csv

    ./lift load --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file-origin user --target-schema $TARGET_SCHEMA --field-delimiter 0X09 --date-format YYYYMMDD --header-row --remove --verbose --target-table RELATIONSHIP --filename RELATIONSHIP.csv
    ```
- CONCEPT_CLASS
    ```
    ./lift put --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file ~/Downloads/vocabulary.v5/CONCEPT_CLASS.csv

    ./lift load --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file-origin user --target-schema $TARGET_SCHEMA --field-delimiter 0X09 --date-format YYYYMMDD --header-row --remove --verbose --target-table CONCEPT_CLASS --filename CONCEPT_CLASS.csv
    ```
- DOMAIN
    ```
    ./lift put --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file ~/Downloads/vocabulary.v5/DOMAIN.csv

    ./lift load --target-user $TARGET_USER --target-password $TARGET_PASSWORD --target-host $TARGET_HOST --file-origin user --target-schema $TARGET_SCHEMA --field-delimiter 0X09 --date-format YYYYMMDD --header-row --remove --verbose --target-table DOMAIN --filename DOMAIN.csv
    ```

# DB2 on-premise

You can load your CSV files by using `SYSPROC.ADMIN_CMD`. Full documentation can be found [here](https://www.ibm.com/support/knowledgecenter/SSEPGG_10.5.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0023577.html).

e.g.:
```
CALL SYSPROC.ADMIN_CMD('load from ~/Downloads/vocabulary.v5/DOMAIN.csv of del MODIFIED BY coldel0x09 replace into DOMAIN')
```