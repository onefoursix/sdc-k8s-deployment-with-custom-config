### Loading stage libs or other resources from a read-only Volume

This example shows how to load stage libs, config files or other resources from a shared and presumably read-only Volume.  This technique can be used to load any resources needed by SDC at deployment time that are not baked into the SDC image, including stage libs, hadoop config files, lookup files, JDBC drivers, etc... 

It is up to the deployer to populate the shared volume; the [get-stage-libs.sh]()

