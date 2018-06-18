# Customize environment variables et al
export CLASSPATH=$CLASSPATH:~/github/pivotal-gemfire-9.3.0/gemfire-greenplum-3.1.1.jar:~/github/postgresql-42.2.2.jar
#export JAVA_HOME=$JAVA_HOME:/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home
export GEMFIRE=~/github/pivotal-gemfire-9.3.0
export GF_JAVA=$JAVA_HOME/bin/java
export PATH=$PATH:$JAVA_HOME/bin:GEMFIRE/bin

# Customize this settings for custom Gemfire/Geode
## check if locator port has been set otherwise set to default
export GEODE_LOCATOR_PORT="${GEODE_LOCATOR_PORT:-10334}"
export GEODE_IP=localhost
export GEODE_SERVERIP=$GEODE_IP

# Customize this settings for custom Greenplum
export GREENPLUM_HOST=gpdb-sandbox
export GREENPLUM_USER=gpadmin
export GREENPLUM_DB=gpadmin
export GREENPLUM_DB_PWD=changeme
export PGPASSWORD=${GREENPLUM_DB_PWD}
