const std = @import("std");
const Vec3 = @import("vec3.zig").Vec3;
const vec3 = @import("vec3.zig");
const Ray = @import("ray.zig").Ray;

pub fn main() anyerror!void {
    // Note that info level log messages are by default printed only in Debug
    // and ReleaseSafe build modes.
    const v = Vec3{};
    _ = v;

    _ = v.prod(v);
    _ = v.scale(1.0);

    // const r = Ray{};
    // _ = r.at(1.0);
    // _ = r;
    std.log.info("All your codebase are belong to us.", .{});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
