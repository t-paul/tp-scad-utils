eps = 0.01;

function pcb_std_size_2x8() = pcb_size_2x8;
function pcb_std_size_3x7() = pcb_size_3x7;
function pcb_std_size_4x6() = pcb_size_4x6;
function pcb_std_size_5x7() = pcb_size_5x7;
function pcb_breadboard_mini() = pcb_breadboard_mini;
function pcb_breadboard_tiny() = pcb_breadboard_tiny;
function pcb_breadboard_quarter() = pcb_breadboard_quarter;

pcb_generate_default = function(spec, pin_spec)
	let (
		size = spec[0].xy,
		raster = spec[1].z,
		pcb_holes_x = spec[1].x,
		pcb_holes_y = spec[1].y,
		xo = (size.x - raster * (pcb_holes_x - 1)) / 2,
		yo = (size.y - raster * (pcb_holes_y - 1)) / 2
	)
	[
		for (x = [0:pcb_holes_x - 1], y = [0:pcb_holes_y - 1])
			[-size.x / 2 + xo, yo] + raster * [x, y]
	];

pcb_generate_pin_breadboard_main = function(spec, pin_spec)
	let (
		size = spec[0].xy,
		raster = spec[1].z,
		pcb_holes_y = spec[1].y
	)
	[
		for (x = [0:4], y = [1:pcb_holes_y])
			[1.5 * raster, size.y / 2 - (pcb_holes_y + 1) * raster / 2] + raster * [x, y],
		for (x = [-4:0], y = [1:pcb_holes_y])
			[-1.5 * raster, size.y / 2 - (pcb_holes_y + 1) * raster / 2] + raster * [x, y],
	];

pcb_generate_pin_breadboard_power = function(spec, pin_spec)
	let (
		size = spec[0].xy,
		raster = spec[1].z,
		pcb_holes_y = spec[1].y
	)
	[
		for (x = [0:1], y = [1:pcb_holes_y])
			[8.5 * raster - 0.6, size.y / 2 - (pcb_holes_y + 1) * raster / 2] + raster * [x, y],
		for (x = [-1:0], y = [1:pcb_holes_y])
			[-8.25 * raster, size.y / 2 - (pcb_holes_y + 1) * raster / 2] + raster * [x, y],
	];

pcb_generate_drill_corner = function(spec, drill_spec)
	let (
		size = spec[0],
		pcb_width = size.x,
		pcb_length = size.y,
		w2 = pcb_width / 2,
		ox = drill_spec[2],
		oy = drill_spec[2],
	)
	[
		[w2 - ox, oy], [-w2 + ox, oy], [w2 - ox, pcb_length - oy], [-w2 + ox, pcb_length - oy]
	];

pcb_generate_drill_breadboard = function(spec, drill_spec)
	let (
		size = spec[0],
		raster = spec[1].z,
		pcb_holes_y = spec[1].y,
		range = drill_spec[2],
		pos_y = drill_spec[3],
		y1 = size.y / 2 - (pcb_holes_y - 1) * raster / 2
	)
	[
		//for (x = range) each [[ 7 * x * raster, y1 + ], [-7 * x * raster, pcb_length - raster]]
		for (x = range) for (y = pos_y) [ 7 * x * raster, y1 + y * raster]
	];


// https://www.amazon.de/dp/B078HV79XX
pcb_size_2x8 = [
	[18.8, 80.2, 1.6, 0], [ 6, 28, 2.54],
	[[pcb_generate_default, 1, 2]],
	[[pcb_generate_drill_corner, 2.3, 2]]
];
pcb_size_3x7 = [
	[29.9, 70.2, 1.6, 0], [10, 24, 2.54],
	[[pcb_generate_default, 1, 2]],
	[[pcb_generate_drill_corner, 2.3, 2]]
];
pcb_size_4x6 = [
	[40.0, 60.0, 1.6, 0], [14, 20, 2.54],
	[[pcb_generate_default, 1, 2]],
	[[pcb_generate_drill_corner, 2.3, 2]]
];
pcb_size_5x7 = [
	[50.2, 70.2, 1.6, 0], [18, 24, 2.54],
	[[pcb_generate_default, 1, 2]],
	[[pcb_generate_drill_corner, 2.3, 2]]
];
pcb_breadboard_mini = [
	[38.1,50.8,1.6, 2], [undef, 17, 2.54],
	[[pcb_generate_pin_breadboard_main, 1, 1.6]],
	[[pcb_generate_drill_breadboard, 3.4, [0], [0, 16]], [pcb_generate_drill_corner, 2.3, 3]]
];
pcb_breadboard_tiny = [
	[32.5,38.2,1.6, 0], [undef, 15, 2.54],
	[[pcb_generate_pin_breadboard_main, 1, 2]],
	[[pcb_generate_drill_breadboard, 3.4, [0], [0.5, 13.5]]]
];
pcb_breadboard_quarter = [
	[50.5,38.2,1.6, 0], [undef, 15, 2.54],
	[[pcb_generate_pin_breadboard_main, 1, 2], [pcb_generate_pin_breadboard_power, 1, 2]],
	[[pcb_generate_drill_breadboard, 3.4, [-1:1], [0.5, 13.5]]]
];

module pin() {
	difference() {
		circle(d = $spec[2]);
		circle(d = $spec[1] - eps);
	}
}

module pcb_pin_pos(spec) {
	for (pin_spec = spec[2]) {
		for (pos = pin_spec[0](spec, pin_spec))
			translate(pos)
				children($spec = pin_spec);
	}
}

module pcb_drill_pos(spec) {
	for (drill_spec = spec[3])
		for (pos = drill_spec[0](spec, drill_spec))
			translate(pos)
				children($spec = drill_spec);
}

module pcb(spec = pcb_size_2x8, pcb_color = "green", pin_color = "silver") {
	pcb_width = spec[0].x;
	pcb_length = spec[0].y;
	pcb_thickness = spec[0].z;
	pcb_rounding = spec[0].w;

	if ($preview) {
		$fa = 5; $fs = 0.25;
		color(pcb_color) linear_extrude(pcb_thickness, convexity = 3) difference() {
			translate([-pcb_width / 2, 0])
				offset(pcb_rounding) offset(-pcb_rounding)
					square([pcb_width, pcb_length]);
			pcb_pin_pos(spec)
				circle(d = $spec[1]);
			pcb_drill_pos(spec)
				circle(d = $spec[1]);
		}
		color(pin_color)
			translate([0, 0, -eps])
				linear_extrude(pcb_thickness + 2 * eps, convexity = 3)
					pcb_pin_pos(spec)
						pin();
	}
}

module pcb_holder(width, length, height, thickness = 1.6, wall = 2, tolerance = 0.2, chamfer = undef, support = false) {
	translate([0, width / 2 + tolerance, 0])
		rotate(-90)
			pcb_clip(length, height, thickness, wall, tolerance, chamfer, support = support ? "back" : undef);
	mirror([0, 1, 0])
		translate([0, width / 2 + tolerance, 0])
			rotate(-90)
				pcb_clip(length, height, thickness, wall, tolerance, chamfer, support = support ? "back" : undef);
	translate([length + tolerance, width / 4, 0])
		rotate(180)
			pcb_clip(width / 2, height, thickness, wall, tolerance, chamfer, support = support ? "side" : undef);
}

module pcb_clip(length, height, thickness = 2, wall = 2, tolerance = 0.2, chamfer = undef, support = undef) {
    if (!is_undef($neg) && $neg) {
        pcb_clip_neg(length, height, thickness, wall, tolerance, chamfer);
    } else {
		pcb_clip_pos(length, height, thickness, wall, tolerance, chamfer, support = support);
    }
}

module pcb_clip_pos(length, height, thickness = 2, wall = 2, tolerance = 0.2, chamfer = undef, support = undef) {
	chamfer_size = is_undef(chamfer) ? wall : chamfer;
	assert(chamfer_size <= wall);

    h_total = thickness + height + wall / 2 + tolerance + 1;
    module clip(support) {
        difference() {
            union() {
                translate([-wall, 0])
                    square([1.5 * wall, h_total]);
                translate([-chamfer_size-wall, 0])
                    square([2 * chamfer_size + 1.5 * wall, chamfer_size]);
                if (support)
                    polygon([[-wall, 0], [-wall, h_total], [-wall - h_total, 0]]);
            }
            translate([chamfer_size + wall/2, chamfer_size])
                circle(chamfer_size);
            if (!support)
                translate([-chamfer_size - wall, chamfer_size])
                    circle(chamfer_size);
            hull() {
                translate([0, height])
                    square([wall + chamfer_size, thickness + tolerance]);
                translate([wall/2, height + wall / 2])
                    square([wall + chamfer_size, thickness + tolerance]);
            }
        }
    }

    translate([0, length, 0])
        rotate([90, 0, 0])
            linear_extrude(length, convexity = 4)
                clip(support == "side");

    if (support == "back")
        translate([0, length - eps, 0])
            mirror([0, 1, 0])
                rotate([90, 0, 0])
                    linear_extrude(h_total, scale = 0, convexity = 3)
                        clip();
}

module pcb_clip_neg(length, height, thickness = 2, wall = 2, tolerance = 0.2, chamfer = undef) {
	chamfer_size = is_undef(chamfer) ? wall : chamfer;
	assert(chamfer_size <= wall);
    translate([0, 0, thickness])
        cube([wall, length, height + tolerance]);
    translate([wall, 0, thickness + height + tolerance])
        linear_extrude(wall / 2, scale = [0.5,1])
            translate([-wall, 0])
            square([wall, length]);
}

module pcb_clip_chamfer(length, height, thickness = 2, wall = 2, tolerance = 0.2, chamfer = undef, support = undef) {
	chamfer_size = is_undef(chamfer) ? wall : chamfer;
	assert(chamfer_size <= wall);
    extra_length = support == "back" ? thickness + height + wall / 2 + tolerance + 1 : 0;
    if (support != "side")
        translate([-wall - chamfer_size, -eps - extra_length, chamfer_size])
            rotate([-90, 0, 0])
                cylinder(h = extra_length + length + 2 * eps, r = chamfer_size);
    translate([0.5 * wall + chamfer_size, -eps - extra_length, chamfer_size])
        rotate([-90, 0, 0])
            cylinder(h = extra_length + length + 2 * eps, r = chamfer_size);
}

m3_head_length = 2.2;
use<captive-nut.scad>
module pcb_bar(h, w, d = 3.4, head_h = m3_head_length, tolerance = 0.2) {
	d2 = d + 2 * (0.8 + tolerance);
	d1 = 2 * d2;
	h1 = head_h + tolerance + 1;
	h2 = (d1 - d2) / 2;
	h3 = h - h1 - h2;
	assert(h3 >= 0);
	difference() {
		union() {
			hull() {
				cylinder(d = d1, h = h1);
				translate([0, w, 0]) cylinder(d = d1, h = h1 + eps);
			}
			translate([0, 0, h1]) hull() {
				cylinder(d1 = d1, d2 = d2, h = h2);
				translate([0, w, 0]) cylinder(d1 = d1, d2 = d2, h = h2 + eps);
			}
			translate([0, 0, h1 + h2]) hull() {
				cylinder(d = d2, h = h3);
				translate([0, w, 0]) cylinder(d = d2, h = h3);
			}
		}
		children($h = h);
		translate([0, w, 0]) children($h = h);
	}
}

*!difference() {
tolerance = 0.2;
screw_length = 10;
h = screw_length - 1.6 - tolerance;
translate([0, 2 * 2.54, 0]) pcb_bar(h, 16 * 2.54) #translate([0, 0, -eps]) captive_nut_m3($h, 1);
translate([0, -11, -2]) cube([10, 10, 16]);
}

translate([-60, -90, 0]) pcb(pcb_size_5x7);
translate([0, -90, 0]) pcb(pcb_size_4x6);
translate([45, -90, 0]) pcb(pcb_size_3x7);
translate([80, -90, 0]) pcb(pcb_size_2x8);
translate([-50, 0, 0]) pcb(pcb_breadboard_tiny, pcb_color = "black", pin_color = "gold");
pcb(pcb_breadboard_mini, pcb_color = "white", pin_color = "gold");
translate([50, 0, 0]) pcb(pcb_breadboard_quarter);

$fa = 2; $fs = 0.2;
*translate([-50/2, 0, 0]) pcb_clip(70, 3, 1.6, support = "back");
*mirror([1, 0, 0]) translate([-50/2, 0, 0]) pcb_clip(70, 3, 1.6, support = "back");
*translate([-20/2, 70, 0])
    rotate(-90)
        pcb_clip(20, 3, 1.6, support = "side");
*translate([0, 0, 3]) pcb();
