ARG SDC_VERSION=latest
FROM streamsets/datacollector:${SDC_VERSION}
ARG SDC_LIBS

# Install list of stage libs
RUN "${SDC_DIST}/bin/streamsets" stagelibs -install="${SDC_LIBS}"

# Copy the custom sdc.properties file into the image
COPY --chown=sdc:sdc sdc-conf/ ${SDC_CONF}/