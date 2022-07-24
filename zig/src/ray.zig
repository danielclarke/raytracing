const Vec3 = @import("vec3.zig").Vec3;
const Point3 = @import("point3.zig").Point3;

pub const Ray = struct {
    origin: Point3 = Point3{},
    direction: Vec3 = Vec3{},

    pub fn at(self: Ray, t: f32) Point3 {
        return self.origin + self.direction.mul(t);
    }
};