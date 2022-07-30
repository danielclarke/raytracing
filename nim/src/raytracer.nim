import math, options, strformat, random, threadpool
{.experimental: "parallel".}

import utils, vec3, point3, color, ray, material, sphere, world, camera

proc rayColor(ray: Ray; world: ref World; depth: int): Color =
  if depth <= 0:
    result = Color(x: 0.0, y: 0.0, z: 0.0)
  else:
    let hr = world[].hit(ray, 0.001, Inf)
    if hr.isSome():
      let hitRecord = hr.get()
      let scatteredRay = hitRecord.material.scatter(ray, hitRecord)
      if scatteredRay.isSome():
        return scatteredRay.get().color * rayColor(scatteredRay.get(), world, depth - 1)
      else:
        return Color(x: 1.0, y: 0.0, z: 0.0)
    else:
      let t = (ray.direction.unit.y + 1.0) * 0.5
      return lerp(Color(x: 1.0, y: 1.0, z: 1.0), Color(x: 0.5, y: 0.7,
          z: 1.0), t)

proc pixelColor(imWidth, imHeight, i, j, numSamples, maxDepth: int; camera: ref Camera; world: ref World): Color =
  var color = Color(x: 0.0, y: 0.0, z: 0.0)
  for s in 0 ..< numSamples:
    let u = (i.float + rand(1.0)) / (imWidth - 1).float
    let v = ((imHeight - j).float + rand(1.0)) / (imHeight - 1).float
    let ray = camera[].getRay(u, v)
    color += rayColor(ray, world, maxDepth)
  return color

proc main =

  # image
  const 
    aspect = 16.0 / 9.0
    imWidth = 400
    imHeight = (imWidth / aspect).int

  # world
  let
    dimA = 10
    dimB = 10
  var world: ref World = new(World)
  for a in -dimA ..< dimA:
    for b in -dimB ..< dimB:
      let center = Vec3(x: a.float + 0.9 * rand(1.0), y: 0.2, z: b.float + 0.9 * rand(1.0))

      let r = rand(1.0)
      let material = if r < 0.8: 
        Material(
          variant: mvLambertian,
          lambertian: Lambertian(albedo: randomVec3(zerosVec3(), onesVec3()))
        )
      elif r < 0.95:
        Material(
          variant: mvMetal,
          metal: Metal(albedo: randomVec3(zerosVec3(), onesVec3()), fuzz: rand(1.0))
        )
      else:
        Material(
          variant: mvDielectric,
          dielectric: Dielectric(albedo: Color(x: 1.0, y: 1.0, z: 1.0), refractiveIndex: 2.5)
        )

      world[].add(
        Sphere(
          center: center,
          radius: 0.2,
          material: material
        )
      )


  world[].add(
    Sphere(
      center: Point3(x: 0.0, y: -1000, z: -1.0),
      radius: 1000.0,
      material: Material(
        variant: mvLambertian,
        lambertian: Lambertian(albedo: Color(x: 0.5, y: 0.5, z: 0.5))
      )
    )
  )
  world[].add(
    Sphere(
      center: Point3(x: -4.0, y: 1.0, z: 0.0),
      radius: 1.0,
      material: Material(
        variant: mvLambertian,
        lambertian: Lambertian(albedo: Color(x: 0.1, y: 0.2, z: 0.5))
      )
    )
  )
  world[].add(
    Sphere(
      center: Point3(x: 0.0, y: 1.0, z: 0.0),
      radius: 1.0,
      material: Material(
        variant: mvDielectric,
        dielectric: Dielectric(albedo: Color(x: 1.0, y: 1.0, z: 1.0), refractiveIndex: 1.5)
      )
    )
  )
  world[].add(
    Sphere(
      center: Point3(x: 4.0, y: 1.0, z: 0.0),
      radius: 1.0,
      material: Material(
        variant: mvMetal,
        metal: Metal(albedo: Color(x: 0.8, y: 0.6, z: 0.2), fuzz: 0.0)
      )
    )
  )

  # camera
  const 
    focalLength = 1.0
    aperture = 0.1
    lookFrom = Point3(x: 9.0, y: 2.0, z: 3.0)
    lookAt = Point3(x: 0.0, y: 0.0, z: 0.0)
    distToFocus = 10.0 #(lookFrom - lookAt).mag()    
    numSamples = 500
    maxDepth = 500
  
  let camera = newRefCamera(PI / 8.0, aspect, focalLength, aperture, distToFocus,
      lookFrom, lookAt, Point3(x: 0.0, y: 1.0, z: 0.0))

  # let camera = newCamera(PI / 8.0, aspect, focalLength, aperture, distToFocus,
  #   lookFrom, lookAt, Point3(x: 0.0, y: 1.0, z: 0.0))

  echo("tracing")
  var f = open("helloworld.ppm", fmWrite)
  defer: f.close()

  f.writeLine(fmt("P3\n{imWidth} {imHeight}\n255\n"))
  var rowBuffer: array[imWidth, Color]
  for j in 0 ..< imHeight:
    echo fmt("Scan lines remaining {imHeight - j}")
    parallel:
      for i in 0 ..< imWidth:
        let pi = i
        let pj = j
        rowBuffer[i] = spawn pixelColor(imWidth, imHeight, pi, pj, numSamples, maxDepth, camera, world)
    for color in rowBuffer:
      f.writeLine(color.ppm(numSamples))

  # f.writeLine(fmt("P3\n{imWidth} {imHeight}\n255\n"))
  # for j in 0 ..< imHeight:
  #   echo fmt("Scan lines remaining {imHeight - j}")
  #   for i in 0 ..< imWidth:
  #     var color = Color(x: 0.0, y: 0.0, z: 0.0)
  #     for s in 0 ..< numSamples:
  #       let u = (i.float + rand(1.0)) / (imWidth - 1)
  #       let v = ((imHeight - j).float + rand(1.0)) / (imHeight - 1)
  #       let ray = camera[].getRay(u, v)
  #       color += rayColor(ray, world, maxDepth)
  #     f.writeLine(color.ppm(numSamples))

  echo "Done"


main()
