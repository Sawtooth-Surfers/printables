// first stab at a generalized pcb holder for modular synths
// 3-clause BSD, jef@slechte.info, 2020

pcb_t = 1.5;
pcb_h = 90.1;
pcb_d = 70.1;

bolt_r = 3.1/2;
front_plate_bolt_distance = 103;
front_plate_mount_block_s = 6;
front_plate_mount_block_d = 10;

plate_pcb_offset = 20;

rounded_corners_r = 1.5;

latch = 5;

lip_w = 1;
rail_w = 3;

lip_t = lip_w;
bottom_t = 2;
top_t = 1;

$fn = 10;
/*
 *   +---------------+  \
 *   |               |   ) top_t
 *   |               |  /
 *   |              /   \
 *   |            /      ) lip_t
 *   |          /       /
 *   |         |        \
 *   |         |         ) pcb_t
 *   |         |        /
 *   |         +-----+  \
 *   |               |   ) bottom_t
 *   +---------------+  /
 *    \        /\    /
 *      rail_w  lip_w
*/
 
module pcb_cutout() {
    lip_d = pcb_d - (2*lip_w);
    lip_h = pcb_h - (2*lip_w);
	
	translate([0, 0, bottom_t + (pcb_t/2)]) {
		hull() {
			cube([pcb_d, pcb_h, pcb_t], center=true);    
			translate([0, 0, pcb_t])
				cube([lip_d, lip_h, lip_t], center=true);
		}
	}
}

module rounded_cube(coords) {
	r = rounded_corners_r;
	hull() {
		for (a = [ -1, 1 ]) {
			for (b = [ -1, 1 ]) {
				translate([a*(coords[0]/2-r), b*(coords[1]/2-r), 0])
					cylinder(r=r, h=coords[2], center=true);
			}
		}
	}
}
module rails() {
    total_t = bottom_t + pcb_t + lip_t + top_t;
    total_w = rail_w + lip_w;
    total_pcb_d = pcb_d;
    total_pcb_h = pcb_h;// + 2*latch;
	// a nudge is defined as the difference between the
	// half of a rail and the lip insection in the rail
	a_nudge = total_w/2 - lip_w;
	
	// everything up so our bottom edge is on the XY plane
	if (0) {
    translate([0, 0, total_t/2]) {
        // front
		front_length = pcb_h + rail_w*2;
        translate([-(pcb_d/2+a_nudge), 0, 0])
			rounded_cube([total_w, front_length, total_t]);
        
        // back
		back_length = latch + rail_w;
        translate([+(pcb_d/2+a_nudge), 0, 0])
			translate([0, +(pcb_h/2-(back_length)/2+rail_w), 0])
				rounded_cube([total_w, back_length, total_t]);
        
        // bottom
		bottom_length = latch + rail_w;
        translate([-(pcb_d/2-(bottom_length)/2+rail_w), -(pcb_h/2+a_nudge), 0])
			rounded_cube([bottom_length, total_w, total_t]);
    
        // top
		top_length = pcb_d + rail_w*2; //latch + rail_w;
		translate([0, (pcb_h/2+a_nudge), 0])
			rounded_cube([top_length, total_w, total_t]);
		
    }
	} else {
    translate([0, 0, total_t/2]) {
        // front
		front_length = pcb_h + rail_w*2;
        translate([-(pcb_d/2+a_nudge), 0, 0])
			rounded_cube([total_w, front_length, total_t]);
        
        // back top
		back_length = latch + rail_w;
        translate([+(pcb_d/2+a_nudge), 0, 0])
			translate([0, +(pcb_h/2-(back_length)/2+rail_w), 0])
				rounded_cube([total_w, back_length, total_t]);
		// back bottom
        translate([+(pcb_d/2+a_nudge), 0, 0])
			translate([0, -(pcb_h/2-(back_length)/2+rail_w), 0])
				rounded_cube([total_w, back_length, total_t]);   
		
        // bottom
		bottom_length = pcb_d + rail_w*2;
        translate([0, -(pcb_h/2+a_nudge), 0])
			rounded_cube([bottom_length, total_w, total_t]);
    
        // top
		top_length = pcb_d + rail_w*2; //latch + rail_w;
		translate([0, (pcb_h/2+a_nudge), 0])
			rounded_cube([top_length, total_w, total_t]);
	}
    }	
}
module rails_top() {
    total_t = bottom_t + pcb_t + lip_t + top_t;
    total_w = rail_w + lip_w;
    total_pcb_d = pcb_d;
    total_pcb_h = pcb_h;// + 2*latch;
	// a nudge is defined as the difference between the
	// half of a rail and the lip insection in the rail
	a_nudge = total_w/2 - lip_w;
	
	// everything up so our bottom edge is on the XY plane
    translate([0, 0, total_t/2]) {
		translate([-(pcb_d/2+a_nudge), -(pcb_h/2+a_nudge), 0])
			rounded_cube([total_w, total_w, total_t]);
    }
}
module rails_bottom() {
    total_t = bottom_t + pcb_t + lip_t + top_t;
    total_w = rail_w + lip_w;
    total_pcb_d = pcb_d;
    total_pcb_h = pcb_h;// + 2*latch;
	// a nudge is defined as the difference between the
	// half of a rail and the lip insection in the rail
	a_nudge = total_w/2 - lip_w;
	
	// everything up so our bottom edge is on the XY plane
    translate([0, 0, total_t/2]) {
		translate([-(pcb_d/2+a_nudge), +(pcb_h/2+a_nudge), 0])
			rounded_cube([total_w, total_w, total_t]);
    }
} 
module front_plate_mounting() {

	block_s = front_plate_mount_block_s;
	block_d = front_plate_mount_block_d;

	translate([
	 -(pcb_d/2 + plate_pcb_offset),
	 0,
	 block_s/2])
	 
	rotate([0, 90, 0])
	for (side = [-1, 1]) {
		translate([0, front_plate_bolt_distance/2*side, 0])
			difference() {
				cube([block_s, block_s, block_d], center=true);
				cylinder(r=bolt_r, h=block_d, center=true);
			}
	}
	 
}
module front_plate_mounting_slice_top() {

	block_s = front_plate_mount_block_s;
	block_d = front_plate_mount_block_d;
	slice_d = 1;

	translate([
	 -(pcb_d/2 + plate_pcb_offset),
	 0,
	 block_s/2])
	 
	rotate([0, 90, 0]) {
		side = -1;
		translate([0, front_plate_bolt_distance/2*side,
			(block_d/2-slice_d/1)])
			cube([block_s, block_s, slice_d], center=true);
	}
	 
 }
module front_plate_mounting_slice_bottom() {

	block_s = front_plate_mount_block_s;
	block_d = front_plate_mount_block_d;
	slice_d = 1;

	translate([
	 -(pcb_d/2 + plate_pcb_offset),
	 0,
	 block_s/2])
	 
	rotate([0, 90, 0]) {
		side = 1;
		translate([0, front_plate_bolt_distance/2*side,
			(block_d/2-slice_d/1)])
			cube([block_s, block_s, slice_d], center=true);
	}
	 
 }
difference() {
	union() {
		rails();
		front_plate_mounting();
		hull() {
			rails_top();
			front_plate_mounting_slice_top();
		}
		hull() {
			rails_bottom();
			front_plate_mounting_slice_bottom();
		}
	}
	pcb_cutout();
}
