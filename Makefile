PIP3 ?= pip3
PYTHON3 ?= python3
VERSION = 0.3.0
CDM_JAR = netcdfAll-5.0.0-SNAPSHOT.jar
WHEEL = dist/geopyspark_netcdf-$(VERSION)-py3-none-any.whl
JAR = backend/gddp/target/scala-2.11/geopyspark-gddp-assembly-$(VERSION).jar


.PHONY: install

install:
	rm -rf build/
	$(PIP3) install --upgrade --user .

$(WHEEL): $(JAR)
	rm -rf build/
	mkdir -p build/lib/geopyspark-netcdf/jars/
	cp -f $< build/lib/geopyspark-netcdf/jars/
	$(PYTHON3) setup.py bdist_wheel

/tmp/%: archives/%
	cp -f $^ $@

archives/s3+hdfs.zip:
	curl -L "https://github.com/Unidata/thredds/archive/feature/s3+hdfs.zip" -o $@

thredds-feature-s3-hdfs: archives/s3+hdfs.zip
	rm -rf $@
	unzip -qu $<

archives/$(CDM_JAR): archives/s3+hdfs.zip
	rm -rf thredds-feature-s3-hdfs/
	unzip -qu $<
	(cd $< ; patch -p2 -s < ../patches/thredds-dependencies.diff ; ./gradlew assemble)
	cp -f $</build/libs/$(CDM_JAR) $@

$(JAR): /tmp/$(CDM_JAR)
	(cd backend ; ./sbt "project geopyspark-gddp" assembly)
	touch $@
	rm $(shell echo $^ | sed 's,archives/,/tmp/,g')

clean:
	(cd backend ; ./sbt clean)
	rm -f archives/*.jar
	rm -rf build/
	rm -rf geopyspark_netcdf.egg-info
	rm -rf thredds-feature-s3-hdfs/

cleaner: clean
	rm -f archives/*

cleanest: cleaner
