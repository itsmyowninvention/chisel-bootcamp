// Predef file for Chisel Bootcamp
interp.repositories() ::: List(
  coursierapi.MavenRepository.of("https://oss.sonatype.org/content/repositories/snapshots")
)

interp.configureCompiler(x => x.settings.source.value = scala.tools.nsc.settings.ScalaVersion("2.11.12"))

import $ivy.`com.lihaoyi::ammonite-ops:2.5.9`
import $ivy.`edu.berkeley.cs::chisel3:3.4.+`
import $ivy.`edu.berkeley.cs::chisel-iotesters:1.5.+`
import $ivy.`edu.berkeley.cs::chiseltest:0.3.+`
import $ivy.`edu.berkeley.cs::dsptools:1.4.+`
import $ivy.`org.scalanlp::breeze:0.13.2`
import $ivy.`edu.berkeley.cs::rocket-dsptools:1.2.0`
import $ivy.`edu.berkeley.cs::firrtl-diagrammer:1.3.+`
import $ivy.`org.scalatest::scalatest:3.2.2`

// Load the load-ivy.sc file
val path = System.getProperty("user.dir") + "/source/load-ivy.sc"
interp.load.module(ammonite.ops.Path(java.nio.file.Paths.get(path)))
