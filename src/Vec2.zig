const std = @import("std");
const math = std.math;
const assert = std.debug.assert;

const Root = @import("./_root.zig");
const PointOrientation = Root.CommonTypes.PointOrientation;

pub fn define_vec2_type(comptime T: type) type {
    return struct {
        const T_Vec2 = @This();
        const T_AABB2 = Root.Geometry.AABB2.define_aabb2_type(T);

        x: T = 0,
        y: T = 0,

        pub const ZERO = T_Vec2{ .x = 0, .y = 0 };
        pub const HALF_HALF = T_Vec2{ .x = 0.5, .y = 0.5 };
        pub const ZERO_ONE = T_Vec2{ .x = 0, .y = 1 };
        pub const ONE_ZERO = T_Vec2{ .x = 1, .y = 0 };
        pub const ONE_ONE = T_Vec2{ .x = 1, .y = 1 };

        pub fn new(x: T, y: T) T_Vec2 {
            return T_Vec2{
                .x = x,
                .y = y,
            };
        }

        pub fn dot(self: T_Vec2, other: T_Vec2) T {
            return (self.x * other.x) + (self.y * other.y);
        }

        pub fn cross(self: T_Vec2, other: T_Vec2) T {
            return (self.x * other.y) - (self.y * other.x);
        }

        pub fn add(self: T_Vec2, other: T_Vec2) T_Vec2 {
            return T_Vec2{ .x = self.x + other.x, .y = self.y + other.y };
        }

        pub fn subtract(self: T_Vec2, other: T_Vec2) T_Vec2 {
            return T_Vec2{ .x = self.x - other.x, .y = self.y - other.y };
        }

        pub fn multiply(self: T_Vec2, other: T_Vec2) T_Vec2 {
            return T_Vec2{ .x = self.x * other.x, .y = self.y * other.y };
        }

        pub fn scale(self: T_Vec2, val: T) T_Vec2 {
            return T_Vec2{ .x = self.x * val, .y = self.y * val };
        }

        pub fn add_scale(self: T_Vec2, add_vec: T_Vec2, scale_add_vec_by: T) T_Vec2 {
            return T_Vec2{ .x = self.x + (add_vec.x * scale_add_vec_by), .y = self.y + (add_vec.y * scale_add_vec_by) };
        }

        pub fn divide(self: T_Vec2, other: T_Vec2) T_Vec2 {
            assert(other.x != 0 and other.y != 0);
            return T_Vec2{ .x = self.x / other.x, .y = self.y / other.y };
        }

        pub fn distance_to(self: T_Vec2, other: T_Vec2) T {
            const diff = T_Vec2{ .x = other.x - self.x, .y = other.y - self.y };
            return math.sqrt((diff.x * diff.x) + (diff.y * diff.y));
        }

        pub fn distance_to_squared(self: T_Vec2, other: T_Vec2) T {
            const diff = T_Vec2{ .x = other.x - self.x, .y = other.y - self.y };
            return (diff.x * diff.x) + (diff.y * diff.y);
        }

        pub fn length(self: T_Vec2) T {
            return math.sqrt((self.x * self.x) + (self.y * self.y));
        }

        pub fn length_squared(self: T_Vec2) T {
            return (self.x * self.x) + (self.y * self.y);
        }

        pub fn length_using_squares(x_squared: T, y_squared: T) T {
            assert(x_squared >= 0 and y_squared >= 0);
            return math.sqrt(x_squared + y_squared);
        }

        pub fn normalize(self: T_Vec2) T_Vec2 {
            assert(self.x != 0 or self.y != 0);
            const len = math.sqrt((self.x * self.x) + (self.y * self.y));
            return T_Vec2{ .x = self.x / len, .y = self.y / len };
        }

        pub fn normalize_using_length(self: T_Vec2, len: T) T_Vec2 {
            assert(len != 0);
            return T_Vec2{ .x = self.x / len, .y = self.y / len };
        }

        pub fn normalize_using_squares(self: T_Vec2, x_squared: T, y_squared: T) T_Vec2 {
            assert(x_squared != 0 or y_squared != 0);
            assert(x_squared >= 0 and y_squared >= 0);
            const len = math.sqrt(x_squared + y_squared);
            return T_Vec2{ .x = self.x / len, .y = self.y / len };
        }

        pub fn angle_between(self: T_Vec2, other: T_Vec2) T {
            const dot_prod = (self.x * other.x) + (self.y * other.y);
            const lengths_multiplied = math.sqrt((self.x * self.x) + (self.y * self.y)) * math.sqrt((other.x * other.x) + (other.y * other.y));
            return math.acos(dot_prod / lengths_multiplied);
        }

        pub fn angle_between_using_lengths(self: T_Vec2, other: T_Vec2, len_self: T, len_other: T) T {
            const dot_prod = (self.x * other.x) + (self.y * other.y);
            const lengths_multiplied = len_self * len_other;
            return math.acos(dot_prod / lengths_multiplied);
        }

        pub fn angle_between_using_norms(self: T_Vec2, other: T_Vec2) T {
            const dot_prod = (self.x * other.x) + (self.y * other.y);
            return math.acos(dot_prod);
        }

        pub fn ratio_a_to_b(a: T_Vec2, b: T_Vec2) T {
            assert(a.x != 0 or a.y != 0);
            if (a.x == 0) return b.y / a.y;
            return b.x / a.x;
        }

        pub fn perp_ccw(self: T_Vec2) T_Vec2 {
            return T_Vec2{ .x = -self.y, .y = self.x };
        }

        pub fn perp_cw(self: T_Vec2) T_Vec2 {
            return T_Vec2{ .x = self.y, .y = -self.x };
        }

        pub fn lerp(self: T_Vec2, other: T_Vec2, percent: T) T_Vec2 {
            return T_Vec2{ .x = ((other.x - self.x) * percent) + self.x, .y = ((other.y - self.y) * percent) + self.y };
        }

        pub fn lerp_delta_min_max(self: T_Vec2, other: T_Vec2, min_delta: T, max_delta: T, delta: T) T_Vec2 {
            const percent = (delta - min_delta) / (max_delta - min_delta);
            return T_Vec2{ .x = ((other.x - self.x) * percent) + self.x, .y = ((other.y - self.y) * percent) + self.y };
        }

        pub fn lerp_delta_max(self: T_Vec2, other: T_Vec2, max_delta: T, delta: T) T_Vec2 {
            const percent = delta / max_delta;
            return T_Vec2{ .x = ((other.x - self.x) * percent) + self.x, .y = ((other.y - self.y) * percent) + self.y };
        }

        pub fn rotate_radians(self: T_Vec2, radians: T) T_Vec2 {
            const cos = @cos(radians);
            const sin = @sin(radians);
            return T_Vec2{ .x = (self.x * cos) - (self.y * sin), .y = (self.x * sin) + (self.y * cos) };
        }

        pub fn rotate_degrees(self: T_Vec2, degrees: T) T_Vec2 {
            const rads = degrees * math.rad_per_deg;
            const cos = @cos(rads);
            const sin = @sin(rads);
            return T_Vec2{ .x = (self.x * cos) - (self.y * sin), .y = (self.x * sin) + (self.y * cos) };
        }

        pub fn rotate_sin_cos(self: T_Vec2, sin: T, cos: T) T_Vec2 {
            return T_Vec2{ .x = (self.x * cos) - (self.y * sin), .y = (self.x * sin) + (self.y * cos) };
        }

        pub fn reflect(self: T_Vec2, reflect_normal: T_Vec2) T_Vec2 {
            const fix_scale = 2 * ((self.x * reflect_normal.x) + (self.y * reflect_normal.y));
            return T_Vec2{ .x = self.x - (reflect_normal.x * fix_scale), .y = self.y - (reflect_normal.y * fix_scale) };
        }

        pub fn negate(self: T_Vec2) T_Vec2 {
            return T_Vec2{ .x = -self.x, .y = -self.y };
        }

        pub fn equals(self: T_Vec2, other: T_Vec2) bool {
            return self.x == other.x and self.y == other.y;
        }

        pub fn approx_equal(self: T_Vec2, other: T_Vec2) bool {
            return Root.Math.approx_equal(T, self.x, other.x) and Root.Math.approx_equal(T, self.y, other.y);
        }

        pub fn is_zero(self: T_Vec2) bool {
            return self.x == 0 and self.y == 0;
        }

        pub fn approx_colinear(self: T_Vec2, other_a: T_Vec2, other_b: T_Vec2) bool {
            const cross_3 = ((other_b.y - self.y) * (other_a.x - self.x)) - ((other_b.x - self.x) * (other_a.y - self.y));
            return @abs(cross_3) <= math.floatEpsAt(f32, cross_3);
        }

        pub fn colinear(self: T_Vec2, other_a: T_Vec2, other_b: T_Vec2) bool {
            const cross_3 = ((other_b.y - self.y) * (other_a.x - self.x)) - ((other_b.x - self.x) * (other_a.y - self.y));
            return cross_3 == 0;
        }

        pub fn approx_orientation(self: T_Vec2, other_a: T_Vec2, other_b: T_Vec2) PointOrientation {
            const cross_3 = ((other_b.y - self.y) * (other_a.x - self.x)) - ((other_b.x - self.x) * (other_a.y - self.y));
            if (@abs(cross_3) <= math.floatEpsAt(f32, cross_3)) return PointOrientation.COLINEAR;
            if (cross_3 > 0) return PointOrientation.WINDING_CW;
            return PointOrientation.WINDING_CCW;
        }

        pub fn orientation(self: T_Vec2, other_a: T_Vec2, other_b: T_Vec2) PointOrientation {
            const cross_3 = ((other_b.y - self.y) * (other_a.x - self.x)) - ((other_b.x - self.x) * (other_a.y - self.y));
            if (cross_3 == 0) return PointOrientation.COLINEAR;
            if (cross_3 > 0) return PointOrientation.WINDING_CW;
            return PointOrientation.WINDING_CCW;
        }

        pub fn approx_on_segment(self: T_Vec2, line_a: T_Vec2, line_b: T_Vec2) bool {
            if (self.approx_orientation(line_a, line_b) != PointOrientation.COLINEAR) return false;
            const line_aabb = T_AABB2.from_static_line(line_a, line_b);
            return line_aabb.point_approx_within(self);
        }

        pub fn on_segment(self: T_Vec2, line_a: T_Vec2, line_b: T_Vec2) bool {
            if (self.orientation(line_a, line_b) != PointOrientation.COLINEAR) return false;
            const line_aabb = T_AABB2.from_static_line(line_a, line_b);
            return line_aabb.point_within(self);
        }

        pub fn velocity_required_to_reach_point_at_time(self: T_Vec2, point: T_Vec2, time: T) T_Vec2 {
            return point.subtract(self).scale(1.0 / time);
        }

        pub fn velocity_required_to_reach_point_inverse_time(self: T_Vec2, point: T_Vec2, inverse_time: T) T_Vec2 {
            return point.subtract(self).scale(inverse_time);
        }
    };
}
