#!/usr/bin/env bash

# This script will download SDC stage libs and enterprise stage libs
# and write them to a directory named streamsets-libs

SDC_VERSION=3.16.1

BASE_URL=https://archives.streamsets.com/datacollector

SDC_STAGE_LIBS="streamsets-datacollector-aws-lib streamsets-datacollector-basic-lib streamsets-datacollector-bigtable-lib streamsets-datacollector-dataformats-lib streamsets-datacollector-dev-lib streamsets-datacollector-google-cloud-lib streamsets-datacollector-groovy_2_4-lib streamsets-datacollector-jdbc-lib streamsets-datacollector-jms-lib streamsets-datacollector-jython_2_7-lib streamsets-datacollector-stats-lib streamsets-datacollector-windows-lib"

SDC_ENTERPRISE_STAGE_LIBS="streamsets-datacollector-databricks-lib-1.0.0 streamsets-datacollector-snowflake-lib-1.4.0 streamsets-datacollector-oracle-lib-1.2.0 streamsets-datacollector-sql-server-bdc-lib-1.0.1"

# tmp dir to unpack the stage libs
mkdir tmp-stage-libs

# directory to hold the downloaded and extracted stage libs
rm -rf streamsets-libs
mkdir streamsets-libs 

cd tmp-stage-libs

# Download and extract stage libs
for s in $SDC_STAGE_LIBS; 
do 
  wget ${BASE_URL}/${SDC_VERSION}/tarball/${s}-${SDC_VERSION}.tgz; 
  tar -xvf ${s}-${SDC_VERSION}.tgz ;
  rm ${s}-${SDC_VERSION}.tgz
done

# move the stage libs to the streamsets-libs dir
cp -R streamsets-datacollector-${SDC_VERSION}/streamsets-libs/* ../streamsets-libs

# clean up 
rm -rf streamsets-datacollector-${SDC_VERSION}

# Download and extract enterprise stage libs
for s in $SDC_ENTERPRISE_STAGE_LIBS; 
do 
  wget ${BASE_URL}/latest/tarball/enterprise/${s}.tgz; 
  tar -xvf ${s}.tgz ;
  rm -rf ${s}.tgz
done

# move the enterprise stage libs to the streamsets-libs dir
cp -R streamsets-libs/* ../streamsets-libs
cd ..

# clean up
rm -rf tmp-stage-libs