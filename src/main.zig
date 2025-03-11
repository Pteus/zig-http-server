const std = @import("std");
const SocketConf = @import("config.zig");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const socket = try SocketConf.Socket.init();
    try stdout.print("Server addr: {any} \n", .{socket._address});

    var server = try socket._address.listen(.{});
    const connection = server.accept();
    _ = connection;
}
