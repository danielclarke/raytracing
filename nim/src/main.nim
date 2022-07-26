import std/options
import std/strformat
import std/random

import utils
import vec3
import point3
import color
import ray
import hit_record
import sphere
import world
import camera

proc rayColor(ray: Ray; world: World; depth: int): Color =
  if depth <= 0:
    result = Color(x: 0.0, y: 0.0, z: 0.0)
  else:
    let hr = world.hit(ray, 0.001, Inf)
    if hr.isSome():
      let hitRecord = hr.get()
      # let target = hitRecord.p + hitRecord.normal + randomUnitVec3()
      let target = hitRecord.p + randomInHemisphere(hitRecord.normal)
      result = 0.5 * rayColor(Ray(origin: hitRecord.p, direction: target -
          hitRecord.p), world, depth - 1)
    else:
      let t = (ray.direction.unit.y + 1.0) * 0.5
      result = lerp(Color(x: 1.0, y: 1.0, z: 1.0), Color(x: 0.5, y: 0.7,
          z: 1.0), t)

proc main =

  # image
  const aspect = 16.0 / 9.0
  const imWidth = 400
  const imHeight = (imWidth / aspect).int

  # world
  var world: World
  world.add(Sphere(center: Point3(x: 0.0, y: 0.0, z: -1.0), radius: 0.5))
  world.add(Sphere(center: Point3(x: 0.0, y: -100.5, z: -1.0), radius: 100.0))

  # camera
  const viewportHeight = 2.0
  const viewportWidth = aspect * viewportHeight;
  const focalLength = 1.0
  const origin = Point3(x: 0.0, y: 0.0, z: 0.0)
  const camera = newCamera(aspect, viewportWidth, focalLength, origin)

  const numSamples = 50
  const maxDepth = 50

  var f = open("helloworld.ppm", fmWrite)
  defer: f.close()

  f.writeLine(fmt("P3\n{imWidth} {imHeight}\n255\n"))

  for j in 0 ..< imHeight:
    echo fmt("Scan lines remaining {j}")
    for i in 0 ..< imWidth:
      var color = Color(x: 0.0, y: 0.0, z: 0.0)

      for s in 0 ..< numSamples:
        let u = (i.float + rand(1.0)) / (imWidth - 1)
        let v = ((imHeight - j).float + rand(1.0)) / (imHeight - 1)
        let ray = camera.getRay(u, v)
        color += rayColor(ray, world, maxDepth)
      f.writeLine(color.ppm(numSamples))

  echo "Done"


main()
