const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const include_name = b.option([]const u8, "include_name", "name for the include folder (e.g. \"dear-imgui/imgui.h\"/\"imgui/imgui.h\"") orelse "imgui";

    const imgui_lib = b.addStaticLibrary(.{
        .name = "imgui",
        .target = target,
        .optimize = optimize,
    });
    imgui_lib.verbose_cc = true;
    const imgui_mod = imgui_lib.root_module;
    imgui_mod.addCSourceFiles(.{
        .flags = &.{"-std=c++23"},
        .files = &src_files,
    });
    imgui_mod.link_libcpp = true;

    imgui_lib.installHeadersDirectory(b.path("."), include_name, .{
        .include_extensions = &.{
            "imgui.h",
            "imconfig.h",
            "imgui_internal.h",
            "imstb_rectpack.h",
            "imstb_textedit.h",
            "imstb_truetype.h",
        },
    });
    b.installArtifact(imgui_lib);
}

const src_files = [_][]const u8{
    "imgui.cpp",
    "imgui_demo.cpp",
    "imgui_tables.cpp",
    "imgui_widgets.cpp",
    "imgui_draw.cpp",
};
