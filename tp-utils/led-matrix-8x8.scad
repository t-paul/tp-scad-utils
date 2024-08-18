use <led.scad>
use <resistor.scad>

$fa = 2; $fs = 0.2;

eps = 0.01;

raster_i = 2.54;
raster_i2 = 1.27;

led_matrix_length = 67;
led_matrix_width = 65.5;
led_matrix_thickness = 1.6;
led_matrix_hole_dia = 3.3;
led_matrix_hole_offset = 8;

led_matrix_x_offset = 1.3;
led_matrix_y_offset = 0.9;
led_matrix_x_spacing = 8.47;
led_matrix_y_spacing = 8.14;

pins = ["V+", "IN", "V-", "V-", "OUT", "V+"];

module pin_pos(count) {
    for (a = [0:2])
        translate([-led_matrix_length / 2 + 2 * raster_i, -led_matrix_width / 2 + (a + 1) * raster_i])
            rotate(180)
                children($pin = a + 1);
    for (a = [0:2])
        translate([led_matrix_length / 2 - 2 * raster_i, led_matrix_width / 2 - (a + 1) * raster_i])
            rotate(0)
                children($pin = a + 4);
}

module pin() {
    color("silver")
        linear_extrude(2 * eps, center = true) {
            translate([0, -raster_i2 / 2]) square([3 * raster_i2, raster_i2]);
            translate([0, 0]) circle(d = raster_i2);
        }
    color("white")
        translate([-raster_i2 / 2, 0, 0])
            rotate([0, 180, 0])
                linear_extrude(2 * eps, center = true)
                    resize([-1, raster_i2], auto = true)
                        text(pins[$pin - 1], valign = "center");
}

module led_matrix_8x8_offset() {
    translate([-led_matrix_x_offset, led_matrix_y_offset, 0])
        children();
}

module led_matrix_8x8() {
    l = led_matrix_length;
    w = led_matrix_width;
    o = led_matrix_hole_offset;
    xs = led_matrix_x_spacing;
    ys = led_matrix_y_spacing;
    difference() {
        union() {
            color("#303030")
                linear_extrude(led_matrix_thickness, convexity = 3)
                    difference() {
                        square([l, w], center = true);
                        for (y = [-1, 1], x = [-1:1])
                            translate([x * (l / 2 - o), y * (w / 2 - o)])
                                circle(d = led_matrix_hole_dia);
                    }
            led_matrix_8x8_offset()
                for (y = [0:7], x = [0:6])
                    translate([xs * (x + 1) - w / 2, ys * (y + 0.5) - l / 2, 1.6 - eps])
                        rotate(90) resistor_0603();
            led_matrix_8x8_offset()
                pin_pos()
                    pin();
        }
        led_matrix_8x8_offset()
            pin_pos()
                cylinder(d = 0.8, h = 3 * led_matrix_thickness, center = true);
    }
    led_matrix_8x8_offset()
        for (y = [0:7], x = [0:7])
            translate([xs * (x + 0.5) - w / 2, ys * (y + 0.5) - l / 2, 1.6 - eps])
                rotate(90) ws2812();
}

led_matrix_8x8();