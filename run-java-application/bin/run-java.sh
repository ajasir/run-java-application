#!/bin/bash
### Description: Used to trigger java program and send failed status as email.
### USAGE="./<script>.sh <config file>"
### Config file has the following key value pairs.
###     -   java.job.name=Your job name
###	-   java.executable.jar=Path to jar file
###     -   java.ext.libs=Thrid party libraries required for your job. Colon seperated jar files.
###	-   java.classname=Full qualified class name
### 	-   java.args=Java arguments
###     -   log.directory=Where you want to have your logs
###	-   to.email.ids=Comma seperated email addresses
###	-   from.email.id=From email address
###	-   email.subject=Email subject
###	-   email.config.smtp=SMTP host and port details. Example smtp://smtp.gmail.com:587
###     -   email.auth.uesrname=Mail user name
###     -   email.auth.password=Mail password

USAGE="./<script.sh> <config.cfg>"

if [[ "$#" -ne 1 ]]
then
    echo "[ERROR] - Invalid number of parameters passed as arguments."
    echo "Usage is $USAGE"
    exit 1
fi

# Get the property file passesd as argument
pptyFile=$1

# Read property file.
function readPropertyFile {
   key=$1
   value=`cat $pptyFile | grep "$key" | cut -d'=' -f2`
   echo $value
}

# Read property file and assign to variables.
jobName=$(readPropertyFile "java.job.name")
execJar=$(readPropertyFile "java.executable.jar")
extLibs=$(readPropertyFile "java.ext.libs")
className=$(readPropertyFile "java.classname")
args=$(readPropertyFile "java.args")
logDir=$(readPropertyFile "log.directory")
to=$(readPropertyFile "to.email.ids")
from=$(readPropertyFile "from.email.id")
subject=$(readPropertyFile "email.subject")
smtpConfig=$(readPropertyFile "email.config.smtp")
userName=$(readPropertyFile "email.auth.uesrname")
password=$(readPropertyFile "email.auth.password")

# Used to create and name log file.
RUNTIME=`date +%Y-%m-%d-%H-%M-%S`

# Create log file directory if not exist.
if [[ ! -e $logDir ]] 
then 	
	mkdir -p $logDir 
fi

if [ ! -d "$logDir" ]; then
  echo "[ERROR] - Failed to create log directory. No logs will be registered unless your application has log file configured."
fi

# Run java program.
echo "[INFO] - Starting java program"
nohup java -cp ${execJar}:${extLibs} ${className} ${args} > $logDir/log_$RUNTIME.log &

# Get job id
pid=$!
echo "[INFO] - Started the job with process id = ${pid}"
wait ${pid}

# Checking whether pid exists or not. If not, job failed, hence trigger email.
EXIT_STATUS=$?

#Send email
if [[ ! $EXIT_STATUS -eq 0 ]] 
then
echo "[ERROR] - Job has failed. Job id is " ${pid}
        echo "
Hi,

${jobName} has failed. Please check the log file - $logDir/log_$RUNTIME.log for more details or application specific log directory.

Thanks " | mailx -v \
	 -s "$subject" \
	 -S from=$from \
	 -S smtp=$smtpConfig \
	 -S smtp-use-starttls \
	 -S ssl-verify=ignore \
	 -S smtp-auth=login \
	 -S smtp-auth-user=$userName \
	 -S smtp-auth-password=$password \
	 $to
fi
exit $EXIT_STATUS
