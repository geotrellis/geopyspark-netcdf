import sbtassembly.PathList

lazy val commonSettings = Seq(
  version := "0.3.0-postvp",
  scalaVersion := "2.11.11",
  organization := "org.locationtech.geotrellis",
  licenses := Seq("Apache-2.0" -> url("http://www.apache.org/licenses/LICENSE-2.0.html")),
  test in assembly := {},
  scalacOptions ++= Seq(
    "-deprecation",
    "-unchecked",
    "-feature",
    "-language:implicitConversions",
    "-language:reflectiveCalls",
    "-language:higherKinds",
    "-language:postfixOps",
    "-language:existentials",
    "-language:experimental.macros",
    "-feature"),
  assemblyMergeStrategy in assembly := {
    case "log4j.properties" => MergeStrategy.first
    case "reference.conf" => MergeStrategy.concat
    case "application.conf" => MergeStrategy.concat
    case PathList("META-INF", xs @ _*) =>
      xs match {
        case ("MANIFEST.MF" :: Nil) => MergeStrategy.discard
        case ("services" :: _ :: Nil) =>
          MergeStrategy.concat
        case ("javax.media.jai.registryFile.jai" :: Nil) | ("registryFile.jai" :: Nil) | ("registryFile.jaiext" :: Nil) =>
          MergeStrategy.concat
        case (name :: Nil) => {
          if (name.endsWith(".RSA") || name.endsWith(".DSA") || name.endsWith(".SF"))
            MergeStrategy.discard
          else
            MergeStrategy.first
        }
        case _ => MergeStrategy.first
      }
    case _ => MergeStrategy.first
  },
  shellPrompt := { s => Project.extract(s).currentProject.id + " > " },
  resolvers  ++= Seq(
    "LocationTech GeoTrellis Snapshots" at "https://repo.locationtech.org/content/repositories/geotrellis-snapshots",
    "LocationTech GeoTrellis Releases" at "https://repo.locationtech.org/content/repositories/releases",
    Resolver.bintrayRepo("azavea", "maven"),
    Resolver.mavenLocal
  )
)

lazy val publishSettings =
  Seq(
    bintrayOrganization := Some("azavea"),
    bintrayRepository := "maven",
    bintrayVcsUrl := Some("https://github.com/geotrellis/geopyspark-netcdf.git"),
    publishMavenStyle := true,
    publishArtifact in Test := false,
    pomIncludeRepository := { _ => false},
    homepage := Some(url("https://github.com/geotrellis/geopyspark-netcdf/"))
  )

lazy val gddp = Project("geopyspark-gddp", file("gddp"))
  .settings(commonSettings: _*)
  .settings(publishSettings: _*)
