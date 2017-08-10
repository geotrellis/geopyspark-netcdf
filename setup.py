from setuptools import setup
import sys
import os

if sys.version_info < (3, 3):
    sys.exit("GeoPySpark does not support Python versions before 3.3")

setup_args = dict(
    name='geopyspark_netcdf',
    version='0.2.0',
    author='James McClain',
    author_email='jmcclain@azavea.com',
    download_url='http://github.com/geotrellis/geopyspark-netcdf',
    description='NetCDF capability for geopyspark',
    install_requires=[
        'geopyspark>=0.2.0rc5',
    ],
    packages=[
        'geopyspark_netcdf',
        'geopyspark_netcdf.jars',
    ],
    include_package_data=True
)

if __name__ == "__main__":
    setup(**setup_args)
