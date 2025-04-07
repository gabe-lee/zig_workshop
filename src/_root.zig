const std = @import("std");

pub const Allocators = struct {
    pub const BucketAllocator = @import("./BucketAllocator.zig");
};
pub const CollectionTypes = struct {
    pub const StaticAllocList = @import("./StaticAllocList.zig");
};
pub const Algorithms = struct {
    pub const Quicksort = @import("./Quicksort.zig");
    pub const BinarySearch = @import("./BinarySearch.zig");
};
pub const Geometry = struct {
    pub const Vec2 = @import("./Vec2.zig");
    pub const AABB2 = @import("./AABB2.zig");
};
pub const Utils = @import("./Utils.zig");
pub const Math = @import("./Math.zig");
pub const CommonTypes = @import("./CommonTypes.zig");

comptime {
    _ = @import("./BucketAllocator.zig");
    _ = @import("./StaticAllocList.zig");
    _ = @import("./Quicksort.zig");
    _ = @import("./BinarySearch.zig");
    _ = @import("./Vec2.zig");
    _ = @import("./AABB2.zig");
    _ = @import("./Utils.zig");
    _ = @import("./Math.zig");
    _ = @import("./CommonTypes.zig");
}
