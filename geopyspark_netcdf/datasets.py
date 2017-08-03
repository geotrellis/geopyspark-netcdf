from math import floor, ceil

import numpy as np

from pyspark import SparkContext
from shapely.geometry import Point
from geopyspark.geotrellis.constants import LayerType
from geopyspark.geotrellis import SpaceTimeKey, Extent, Tile, get_spark_context
from geopyspark.geotrellis.layer import TiledRasterLayer


class Gddp(object):

    x_offset = (-360.0 + 1/8.0)
    y_offset = (-90.0 + 1/8.0)

    @classmethod
    def rdd_of_rasters(cls, uri, extent, days):

        if not isinstance(uri, str):
            raise Exception

        sc = get_spark_context()

        int_days = list(map(lambda day: int(day), days))
        float_extent = list(map(lambda coord: float(coord), extent))

        jvm = sc._gateway.jvm
        rdd = jvm.geopyspark.netcdf.datasets.Gddp.rasters(uri, float_extent, int_days, sc._jsc.sc())
        return TiledRasterLayer(LayerType.SPACETIME, rdd)

    @classmethod
    def raster(cls, uri, extent, day):

        if not isinstance(uri, str):
            raise Exception

        sc = get_spark_context()

        int_day = int(day)
        float_extent = list(map(lambda coord: float(coord), extent))

        jvm = sc._gateway.jvm
        tup = jvm.geopyspark.netcdf.datasets.Gddp.raster(uri, float_extent, int_day)
        cols = tup._1()
        rows = tup._2()
        jvm_array = tup._3()
        array = np.flipud(np.array(list(jvm_array)).reshape((rows, cols)))
        return array

    @classmethod
    def samples(cls, uri, point, days):

        if not isinstance(uri, str):
            raise Exception

        sc = get_spark_context()

        int_days = list(map(lambda day: int(day), days))
        float_point = list(map(lambda coord: float(coord), point))

        jvm = sc._gateway.jvm
        rdd = jvm.geopyspark.netcdf.datasets.Gddp.samples(uri, float_point, int_days, sc._jsc.sc())
        return rdd
