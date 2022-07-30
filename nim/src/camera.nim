import std/math
import color
import point3
import vec3
import ray

type
  Camera* = object
    aspect, height, width, focalLength, lensRadius: float
    origin: Point3
    horizontal, vertical, lowerLeftCorner, u, v, w: Vec3

  RefCamera = ref Camera

func newCamera*(
    verticalFOV, aspect, focalLength, aperture, focusDistance: float;
    lookFrom, lookAt, vUp: Point3
  ): Camera =
  # let theta = verticalFOV * PI / 180.0
  let height = 2.0 * tan(verticalFOV / 2.0)
  let width = aspect * height

  let w = (lookFrom - lookAt).unit()
  let u = vUp.cross(w).unit()
  let v = w.cross(u)

  let horizontal = focusDistance * width * u;
  let vertical = focusDistance * height * v;

  Camera(
    aspect: aspect,
    height: height,
    width: width,
    focalLength: focalLength,
    lensRadius: aperture / 2.0,
    origin: lookFrom,
    horizontal: horizontal,
    vertical: vertical,
    w: w,
    u: u,
    v: v,
    lowerLeftCorner: lookFrom - horizontal / 2.0 - vertical / 2.0 - focusDistance * w
  )

func newRefCamera*(
    verticalFOV, aspect, focalLength, aperture, focusDistance: float;
    lookFrom, lookAt, vUp: Point3
  ): RefCamera =
  # let theta = verticalFOV * PI / 180.0
  let height = 2.0 * tan(verticalFOV / 2.0)
  let width = aspect * height

  let w = (lookFrom - lookAt).unit()
  let u = vUp.cross(w).unit()
  let v = w.cross(u)

  let horizontal = focusDistance * width * u;
  let vertical = focusDistance * height * v;

  RefCamera(
    aspect: aspect,
    height: height,
    width: width,
    focalLength: focalLength,
    lensRadius: aperture / 2.0,
    origin: lookFrom,
    horizontal: horizontal,
    vertical: vertical,
    w: w,
    u: u,
    v: v,
    lowerLeftCorner: lookFrom - horizontal / 2.0 - vertical / 2.0 - focusDistance * w
  )

proc getRay*(self: Camera; s, t: float): Ray =
  let rd = self.lensRadius * randomPointInUnitDisc()
  let offset = self.u * rd.x + self.v * rd.y
  return Ray(
    origin: self.origin + offset,
    direction: self.lowerLeftCorner + s * self.horizontal + t * self.vertical - self.origin - offset,
    color: Color(x: 1.0, y: 1.0, z: 1.0)
  )
