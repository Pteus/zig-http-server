const std = @import("std");
const SocketConf = @import("config.zig");
const stdout = std.io.getStdOut().writer();
const Request = @import("request.zig");
const Method = Request.Method;
const Response = @import("response.zig");

pub fn main() !void {
    const socket = try SocketConf.Socket.init();
    try stdout.print("Server addr: {any} \n", .{socket._address});

    var server = try socket._address.listen(.{});
    const connection = try server.accept();

    var buffer: [1000]u8 = [_]u8{0} ** 1000;
    try Request.read_request(connection, &buffer);

    const request = Request.parse_request(&buffer);
    if (request.method == Method.GET) {
        if (std.mem.eql(u8, request.uri, "/")) {
            try Response.send_200(connection);
        } else {
            try Response.send_404(connection);
        }
    }
}
