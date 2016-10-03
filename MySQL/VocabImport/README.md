Common-Data-Model / MySQL Loader
=================

This folder contains the a bash script for loading the csv data files.  It should work on both MAC and Debian Family (eg Ubuntu)

It has two modes:

## Interactive
```bash
 ./omop_cmd_vocabulary_load-MySQL.sh  
CDMV5 Loader  
Where have the CDMV5 files been unzipped to?
/users/peterw/tmp/cdm
Local Database Schema?  
cdm  
Local Database username?  
cdm_user  
Local Database password?  
cmd_pwd
```

## Headless
In this mode, all the parameters required are passed on the command line and the nohup command means you can disconnect from the server and the processs will not terminate.  Output is directected to a nohup.out file in the current directory
```bash
nohup ./omop_cmd_vocabulary_load-MySQL.sh /users/peter/tmp/cdm cdm cdm_user cdm_pwd
```
