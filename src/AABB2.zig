const std = @import("std");
const math = std.math;
const Type = std.builtin.Type;

const Root = @import("./_root.zig");

pub fn define_aabb2_type(comptime T: type) type {
    return struct {
        const T_AABB2 = @This();
        const T_Vec2 = Root.Geometry.Vec2.define_vec2_type(T);
        const INF = if (@typeInfo(T).int) math.maxInt(T) else math.inf(T);
        const NEG_INF = if (@typeInfo(T).int) math.minInt(T) else -math.inf(T);

        x_min: T = INF,
        x_max: T = NEG_INF,
        y_min: T = INF,
        y_max: T = NEG_INF,

        pub fn combine_with(self: T_AABB2, other: T_AABB2) T_AABB2 {
            return T_AABB2{
                .x_min = @min(self.x_min, other.x_min),
                .y_min = @min(self.y_min, other.y_min),
                .x_max = @max(self.x_max, other.x_max),
                .y_max = @min(self.y_max, other.y_max),
            };
        }

        pub fn combine_with_point(self: T_AABB2, point: T_Vec2) T_AABB2 {
            return T_AABB2{
                .x_min = @min(self.x_min, point.x),
                .y_min = @min(self.y_min, point.y),
                .x_max = @max(self.x_max, point.x),
                .y_max = @min(self.y_max, point.y),
            };
        }

        pub fn expand_by(self: T_AABB2, amount: T) T_AABB2 {
            return T_AABB2{
                .x_min = self.x_min - amount,
                .y_min = self.y_min - amount,
                .x_max = self.x_max + amount,
                .y_max = self.y_max + amount,
            };
        }

        pub fn from_static_circle_with_changing_radius(center: T_Vec2, t1_radius: T, t2_radius: T) T_AABB2 {
            return T_AABB2{
                .x_min = @min(center.x - t1_radius, center.x - t2_radius),
                .x_max = @max(center.x + t1_radius, center.x + t2_radius),
                .y_min = @min(center.y - t1_radius, center.y - t2_radius),
                .y_max = @max(center.y + t1_radius, center.y + t2_radius),
            };
        }

        pub fn from_static_circle(center: T_Vec2, radius: T) T_AABB2 {
            return T_AABB2{
                .x_min = center.x - radius,
                .x_max = center.x + radius,
                .y_min = center.y - radius,
                .y_max = center.y + radius,
            };
        }

        pub fn from_static_line(point_a: T_Vec2, point_b: T_Vec2) T_AABB2 {
            return T_AABB2{
                .x_min = @min(point_a.x, point_b.x),
                .x_max = @max(point_a.x, point_b.x),
                .y_min = @min(point_a.y, point_b.y),
                .y_max = @max(point_a.y, point_b.y),
            };
        }

        pub fn from_moving_circle(t1_center: T_Vec2, t2_center: T_Vec2, radius: T) T_AABB2 {
            return T_AABB2{
                .x_min = @min(t1_center.x - radius, t2_center.x - radius),
                .x_max = @max(t1_center.x + radius, t2_center.x + radius),
                .y_min = @min(t1_center.y - radius, t2_center.y - radius),
                .y_max = @max(t1_center.y + radius, t2_center.y + radius),
            };
        }

        pub fn from_moving_circle_with_changing_radius(t1_center: T_Vec2, t2_center: T_Vec2, t1_radius: T, t2_radius: T) T_AABB2 {
            return T_AABB2{
                .x_min = @min(t1_center.x - t1_radius, t2_center.x - t2_radius),
                .x_max = @max(t1_center.x + t1_radius, t2_center.x + t2_radius),
                .y_min = @min(t1_center.y - t1_radius, t2_center.y - t2_radius),
                .y_max = @max(t1_center.y + t1_radius, t2_center.y + t2_radius),
            };
        }

        pub fn from_moving_line(t1_point_a: T_Vec2, t2_point_a: T_Vec2, t1_point_b: T_Vec2, t2_point_b: T_Vec2) T_AABB2 {
            return T_AABB2{
                .x_min = @min(@min(t1_point_a.x, t2_point_a.x), @min(t1_point_b.x, t2_point_b.x)),
                .x_max = @max(@max(t1_point_a.x, t2_point_a.x), @max(t1_point_b.x, t2_point_b.x)),
                .y_min = @min(@min(t1_point_a.y, t2_point_a.y), @min(t1_point_b.y, t2_point_b.y)),
                .y_max = @max(@max(t1_point_a.y, t2_point_a.y), @max(t1_point_b.y, t2_point_b.y)),
            };
        }

        pub fn from_moving_point(t1_point: T_Vec2, t2_point: T_Vec2) T_AABB2 {
            return T_AABB2{
                .x_min = @min(t1_point.x, t2_point.x),
                .x_max = @max(t1_point.x, t2_point.x),
                .y_min = @min(t1_point.y, t2_point.y),
                .y_max = @max(t1_point.y, t2_point.y),
            };
        }

        pub fn from_static_point(t1_point: T_Vec2) T_AABB2 {
            return T_AABB2{
                .x_min = t1_point.x,
                .x_max = t1_point.x,
                .y_min = t1_point.y,
                .y_max = t1_point.y,
            };
        }

        pub fn overlaps(self: T_AABB2, other: T_AABB2) bool {
            return self.x_max >= other.x_min and other.x_max >= self.x_min and self.y_max >= other.y_min and other.y_max >= self.y_min;
        }

        pub fn approx_overlaps(self: T_AABB2, other: T_AABB2) bool {
            return Root.Math.approx_greater_than_or_equal_to(T, self.x_max, other.x_min) and Root.Math.approx_greater_than_or_equal_to(T, other.x_max, self.x_min) and Root.Math.approx_greater_than_or_equal_to(T, self.y_max, other.y_min) and Root.Math.approx_greater_than_or_equal_to(T, other.y_max, self.y_min);
        }

        pub fn point_within(self: T_AABB2, point: T_Vec2) bool {
            return self.x_max >= point.x and point.x >= self.x_min and self.y_max >= point.y and point.y >= self.y_min;
        }

        pub fn point_approx_within(self: T_AABB2, point: T_Vec2) bool {
            return Root.Math.approx_greater_than_or_equal_to(T, self.x_max, point.x) and Root.Math.approx_greater_than_or_equal_to(T, point.x, self.x_min) and Root.Math.approx_greater_than_or_equal_to(T, self.y_max, point.y) and Root.Math.approx_greater_than_or_equal_to(T, point.y, self.y_min);
        }
    };
}
