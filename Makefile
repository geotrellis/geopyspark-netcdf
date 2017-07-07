PIP3 ?= pip3
PYTHON3 ?= python3
VERSION = 0.1.0
GEOPYSPARK_JAR = geotrellis-backend-assembly-$(VERSION).jar
GEOPYSPARK_JAR_DIR ?= $(HOME)/.local/lib/python3.4/site-packages/geopyspark/jars/
CDM_JAR = netcdfAll-5.0.0-SNAPSHOT.jar
WHEEL = dist/geopyspark_netcdf-$(VERSION)-py3-none-any.whl
JAR = backend/gddp/target/scala-2.11/gddp-assembly-$(VERSION).jar


.PHONY: install

install: $(JAR)
	rm -rf build/
	cp -f $< geopyspark-netcdf/jars/
	$(PIP3) install --upgrade --user .

$(WHEEL): $(JAR)
	rm -rf build/
	cp -f $< geopyspark-netcdf/jars/
	$(PYTHON3) setup.py bdist_wheel

/tmp/%: archives/%
	cp -f $< $@

archives/$(GEOPYSPARK_JAR):
	cp -f $(GEOPYSPARK_JAR_DIR)/$(GEOPYSPARK_JAR) $@

ifdef CDM_JAR_DIR
archives/$(CDM_JAR):
	cp -f $(CDM_JAR_DIR)/$(CDM_JAR) $@
else
archives/s3+hdfs.zip:
	curl -L "https://github.com/Unidata/thredds/archive/feature/s3+hdfs.zip" -o $@

thredds-feature-s3-hdfs: archives/s3+hdfs.zip
	unzip -q $<

archives/$(CDM_JAR): thredds-feature-s3-hdfs
	(cd $< ; ./gradlew assemble)
	cp -f $</build/libs/$(CDM_JAR) $@
endif

$(JAR): archives/$(GEOPYSPARK_JAR) archives/$(CDM_JAR)
	cp -f $^ /tmp/
	(cd backend ; ./sbt "project gddp" assembly)
	touch $@
	rm $(shell echo $^ | sed 's,archives/,/tmp/,g')

clean:
	(cd backend ; ./sbt clean)
	rm -f archives/*.jar
	rm -rf build/
	rm -rf geopyspark_netcdf.egg-info

cleaner: clean
	rm -f archives/*
	rm -rf thredds-feature-s3-hdfs/
