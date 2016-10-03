#!/bin/bash
# *********************************************************************************
#  Copyright 2014 Observational Health Data Sciences and Informatics
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#      http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# *******************************************************************************/

# ************************
# 
#  ####### #     # ####### ######      #####  ######  #     #           ####### 
#  #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #       
#  #     # # # # # #     # #     #    #       #     # # # # #    #    # #       
#  #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######  
#  #     # #     # #     # #          #       #     # #     #    #    #       # 
#  #     # #     # #     # #          #     # #     # #     #     #  #  #     # 
#  ####### #     # ####### #           #####  ######  #     #      ##    #####  
#                                                                               
# 
# Script to load the common data model, version 5.0 vocabulary tables for PostgreSQL database on Windows (MS-DOS style file paths)
# 
# Notes
# 
# 1) There is no data file load for the SOURCE_TO_CONCEPT_MAP table because that table is deprecated in CDM version 5.0
# 2) This script assumes the CDM version 5 vocabulary zip file has been unzipped into the "C:\CDMV5VOCAB" directory. 
# 3) If you unzipped your CDM version 5 vocabulary files into a different directory then replace all file paths below, with your directory path.
#
# last revised: 30 Sept 2016
# 
# author:  Lee Evans, Peter G. Williams (modified for MySQL)
# *************************/

function makeFilesLowerCase() {
  cd $loadDir
  for f in `ls *.csv`; do mv "$f" "`echo $f | tr '[A-Z]' '[a-z]'`" 2>&1 | grep -v 'are the same'; done
}

function loadData() {
  tableName=$1
  echo "Loading data into $tableName"
{ mysql --local-infile --host=localhost --user=$dbUser --password=$dbPwd $dbName << END
truncate table $tableName;
load data local 
	infile '$loadDir/$tableName.csv' 
	into table $tableName
	columns terminated by '\t' 
	lines terminated by '\n' 
	ignore 1 lines;
SHOW WARNINGS LIMIT 10;
select '$tableName', count(*) from $tableName;
END
} 2>&1 | grep -v "can be insecure"
}

echo "CDMV5 Loader"
if [ ! -z "$4" ] 
then
loadDir=$1
dbName=$2
dbUser=$3
dbPwd=$4
else 
	echo "Where have the CDMV5 files been unzipped to?"
	read loadDir
	echo "Local Database Schema? "
	read dbName
	echo "Local Database username? "
	read dbUser
	echo "Local Database password? "
	read dbPwd
fi

#Windows scripts don't worry about this, but the archive currently uses all Caps
#We can take some shortcuts with the table name to file mapping if they're all lower
echo "Renaming files as lower case..."
makeFilesLowerCase
dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "Starting load at $dt"
loadData concept_ancestor
loadData concept_class
loadData concept_relationship
loadData concept
loadData domain
loadData drug_strength
loadData relationship
loadData vocabulary
dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "Process complete at $dt"
