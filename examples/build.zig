const std = @import("std");
const lexbor_build = @import("lexbor");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lexbor_dep = b.dependency("lexbor", .{
        .target = target,
        .optimize = optimize,
    });

    for (examples) |example| {
        const exe = b.addExecutable(.{
            .target = target,
            .optimize = optimize,
            .name = example.name,
            .link_libc = true,
        });
        exe.entry = .disabled;
        exe.addCSourceFiles(.{
            .files = example.files,
            .flags = &lexbor_build.flags,
        });
        exe.addIncludePath(lexbor_dep.path(""));
        exe.linkLibrary(lexbor_dep.artifact("lexbor"));

        b.installArtifact(exe);
    }
}

pub const Example = struct {
    name: []const u8,
    files: []const []const u8,
};

pub const examples = [_]Example{
    .{ .name = "StyleSheet", .files = &.{"lexbor/css/StyleSheet.c"} },
    .{ .name = "list_easy_way", .files = &.{"lexbor/css/selectors/list_easy_way.c"} },
    .{ .name = "list_fast_way", .files = &.{"lexbor/css/selectors/list_fast_way.c"} },
    .{ .name = "simple_colorize", .files = &.{"lexbor/css/syntax/simple_colorize.c"} },
    .{ .name = "structure_parse_file", .files = &.{"lexbor/css/syntax/structure_parse_file.c"} },
    .{ .name = "chunks_stdin", .files = &.{"lexbor/css/syntax/tokenizer/chunks_stdin.c"} },
    .{ .name = "from_file", .files = &.{"lexbor/css/syntax/tokenizer/from_file.c"} },
    .{ .name = "print_raw", .files = &.{"lexbor/css/syntax/tokenizer/print_raw.c"} },
    .{ .name = "buffer_decode", .files = &.{"lexbor/encoding/buffer/decode/decode.c"} },
    .{ .name = "buffer_decoder", .files = &.{"lexbor/encoding/buffer/decode/decoder.c"} },
    .{ .name = "buffer_decode_validate", .files = &.{"lexbor/encoding/buffer/decode/validate.c"} },
    .{ .name = "buffer_encode", .files = &.{"lexbor/encoding/buffer/encode/encode.c"} },
    .{ .name = "buffer_encoder", .files = &.{"lexbor/encoding/buffer/encode/encoder.c"} },
    .{ .name = "buffer_encode_validate", .files = &.{"lexbor/encoding/buffer/encode/validate.c"} },
    .{ .name = "buffer_from_to", .files = &.{"lexbor/encoding/buffer/from_to.c"} },
    .{ .name = "data_by_name", .files = &.{"lexbor/encoding/data_by_name.c"} },
    .{ .name = "single_decode", .files = &.{"lexbor/encoding/single/decode/decode.c"} },
    .{ .name = "single_decoder", .files = &.{"lexbor/encoding/single/decode/decoder.c"} },
    .{ .name = "single_decode_validate", .files = &.{"lexbor/encoding/single/decode/validate.c"} },
    .{ .name = "single_encode", .files = &.{"lexbor/encoding/single/encode/encode.c"} },
    .{ .name = "single_encoder", .files = &.{"lexbor/encoding/single/encode/encoder.c"} },
    .{ .name = "single_encode_validate", .files = &.{"lexbor/encoding/single/encode/validate.c"} },
    .{ .name = "single_from_to", .files = &.{"lexbor/encoding/single/from_to.c"} },
    .{ .name = "document_parse", .files = &.{"lexbor/html/document_parse.c"} },
    .{ .name = "document_parse_chunk", .files = &.{"lexbor/html/document_parse_chunk.c"} },
    .{ .name = "document_title", .files = &.{"lexbor/html/document_title.c"} },
    .{ .name = "element_attributes", .files = &.{"lexbor/html/element_attributes.c"} },
    .{ .name = "element_create", .files = &.{"lexbor/html/element_create.c"} },
    .{ .name = "element_innerHTML", .files = &.{"lexbor/html/element_innerHTML.c"} },
    .{ .name = "elements_by_attr", .files = &.{"lexbor/html/elements_by_attr.c"} },
    .{ .name = "elements_by_class_name", .files = &.{"lexbor/html/elements_by_class_name.c"} },
    .{ .name = "elements_by_tag_name", .files = &.{"lexbor/html/elements_by_tag_name.c"} },
    .{ .name = "encoding", .files = &.{"lexbor/html/encoding.c"} },
    .{ .name = "html2sexpr", .files = &.{"lexbor/html/html2sexpr.c"} },
    .{ .name = "html_parse", .files = &.{"lexbor/html/parse.c"} },
    .{ .name = "parse_chunk", .files = &.{"lexbor/html/parse_chunk.c"} },
    .{ .name = "callback", .files = &.{"lexbor/html/tokenizer/callback.c"} },
    .{ .name = "simple", .files = &.{"lexbor/html/tokenizer/simple.c"} },
    .{ .name = "tag_attributes", .files = &.{"lexbor/html/tokenizer/tag_attributes.c"} },
    .{ .name = "text", .files = &.{"lexbor/html/tokenizer/text.c"} },
    .{ .name = "punycode_decode", .files = &.{"lexbor/punycode/decode.c"} },
    .{ .name = "punycode_encode", .files = &.{"lexbor/punycode/encode.c"} },
    .{ .name = "easy_way", .files = &.{"lexbor/selectors/easy_way.c"} },
    .{ .name = "normal_way", .files = &.{"lexbor/selectors/normal_way.c"} },
    .{ .name = "unique_nodes", .files = &.{"lexbor/selectors/unique_nodes.c"} },
    .{ .name = "attribute_style", .files = &.{"lexbor/styles/attribute_style.c"} },
    .{ .name = "events_insert", .files = &.{"lexbor/styles/events_insert.c"} },
    .{ .name = "stylesheet", .files = &.{"lexbor/styles/stylesheet.c"} },
    .{ .name = "walk", .files = &.{"lexbor/styles/walk.c"} },
    .{ .name = "idna_to_ascii", .files = &.{"lexbor/unicode/idna_to_ascii.c"} },
    .{ .name = "normalization_form", .files = &.{"lexbor/unicode/normalization_form.c"} },
    .{ .name = "normalization_form_stdin", .files = &.{"lexbor/unicode/normalization_form_stdin.c"} },
    .{ .name = "url_parse", .files = &.{"lexbor/url/parse.c"} },
    .{ .name = "relative", .files = &.{"lexbor/url/relative.c"} },
};
