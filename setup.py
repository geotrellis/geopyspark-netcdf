from setuptools import setup
import sys
import os

if sys.version_info < (3, 3):
    sys.exit("GeoPySpark does not support Python versions before 3.3")

setup_args = dict(
    name='geopyspark-netcdf',
    version='0.1.0',
    author='James McClain',
    author_email='jmcclain@azavea.com',
    download_url='http://github.com/geotrellis/geopyspark-netcdf',
    description='NetCDF capability for geopyspark',
    install_requires=[
        'geopyspark==0.1.0',
    ],
    packages=[
        'geopyspark-netcdf',
        'geopyspark-netcdf.jars',
    ],
    include_package_data=True
)

if __name__ == "__main__":
    setup(**setup_args)
