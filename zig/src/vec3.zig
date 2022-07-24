pub const Vec3 = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
    z: f32 = 0.0,

    pub fn add(self: Vec3, v: Vec3) Vec3 {
        return Vec3{ .x = self.x + v.x, .y = self.y + v.y, .z = self.z + v.z };
    }

    pub fn sub(self: Vec3, v: Vec3) Vec3 {
        return Vec3{ .x = self.x - v.x, .y = self.y - v.y, .z = self.z - v.z };
    }

    pub fn scale(self: Vec3, v: f32) Vec3 {
        return Vec3{ .x = self.x * v, .y = self.y * v, .z = self.z * v };
    }

    pub fn prod(self: Vec3, v: Vec3) Vec3 {
        return Vec3{ .x = self.x * v.x, .y = self.y * v.y, .z = self.z * v.z };
    }
};