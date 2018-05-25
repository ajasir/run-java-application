# Run Java Application From Shell Script
Run java application through shell script and send status mail if job fails
# Description
**run-java.sh** is a shell script to run any java programs. It can send status email if the job fails. Job details can be passed through configuration file (**run-java-configuration.cfg**) provided.
# Usage
- **Syntax** 
> nohup ./<run-java.sh> <run-java-configuration.cfg> &
- **Example**
> nohup run-java-application/bin/run-java.sh run-java-application/conf/run-java-configuration.cfg &

# Configuration Parameters
Below are the properties in configuration file

|Key                 |Value                                            |Description                                                 |
|--------------------|-------------------------------------------------|------------------------------------------------------------|
|java.job.name       |Your job name                                    |Your java application name                                  |
|java.executable.jar |/path/to/your/jar/application.jar                |Path to your executable application jar file                |
|java.ext.libs       |/path/to/extlib/jar1.jar:/path/to/extlib/jar2.jar|**:** seperated third party libraries required <br> for your                                                                              application                                                  |
|java.classname      |com.test.yourproject.classname                   |Full qualified class name                                   |
|java.args           |Java arguments                                   |Java or application arguments                               |
|log.directory       |/path/to/your/log/directory/                     |Directory where you want to have your logs.                 |
|to.email.ids        |test1@gmail.com,test2@gmail.com                  |**,** seperated **TO** email ids                            |
|from.email.id       |from@gmail.com                                   |From email id                                               |
|email.subject       |Email Subject                                    |Email Subject                                               |
|email.config.smtp   |SMTP configuration                               |Example - smtp://smtp.gmail.com:587                         |
|email.auth.uesrname |Email username                                   |Email username                                              |
|email.auth.password |Email password                                   |Email password                                              |
