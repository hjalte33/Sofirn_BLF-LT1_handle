h_dia = 20;
h_length = 80;
diamond_size = [5,5];
r2 = 1.41421356237;
wall_th = 1.6;

hook_d1 = 40;
hook_th = 2;
hook_ledge_th = 4;

finger_gap = 20;

bar_th = 4;

$fn=80;

difference(){
    cylinder(d=h_dia, h = h_length, center = true);
    // dimond pattern
    scale([1,3,1])intersection(){
        cylinder(d=h_dia-2*wall_th, h = h_length-2*wall_th, center = true);
        translate([-h_dia*2,h_dia*2,-h_length])rotate([90,0,0])
            diamond_pattern([5,5,100],10,20,wall_th);
    }
}

*intersection(){
    cylinder(d=h_dia, h = h_length, center = true);
    cube([h_dia,wall_th,h_length],center = true);
}

translate([0.5*hook_d1 + 0.5*h_dia + finger_gap,0,0])rotate([0,90,90])hook();

translate([h_dia/2-wall_th,0])s2();

module hook(){
    module h(th){
        linear_extrude(th)difference(){
            translate([0,-0.1*hook_d1])circle(d=hook_d1);
            translate([-0.5*hook_d1,-hook_d1])square([hook_d1,hook_d1]);
        }
    }

    translate([0,0,-0.5*hook_th]){
        difference(){
            union(){
                scale_factor = (hook_d1+2*hook_ledge_th)/hook_d1;
                translate([0,0,-wall_th])scale([scale_factor,scale_factor,1])h(wall_th);
                h(hook_th);
                translate([0,0,hook_th])scale([scale_factor,scale_factor,1])h(wall_th);
            }
            translate([0.5*hook_d1,-50,-50])cube([100,100,100]);
            translate([-100-0.5*hook_d1,-50,-50])cube([100,100,100]);
        }
    }
}



module s2(d = 30,th=4, width = 9,sa = 45, ea = 110){
    translate([0,-d/2])rotate(90-sa){
        rotate_extrude(angle = sa){
            translate([0.5*d,0])resize([width,th])circle(d=1);
        }
        translate([d,0])rotate_extrude(angle = ea){
            translate([-0.5*d,0])resize([width,th])circle(d=1);
        }
    }
    
}

module diamond_pattern(size, nx,ny, gap = 1){
    dx = gap + sqrt(size[0]*size[0]+size[1]*size[1]);
    alpha = atan(size[1]/size[0]);
    //dx = size[0]*r2 + gap;
    dy = size[1]*r2 + gap;
    for (x=[0:nx], y=[0:ny*2]) {
        odd = y%2;
        shiftx = odd*dx*0.5;
        shifty = dy*y*0.5;
        translate([x*dx + shiftx, -0.5*dy + y*dy - shifty,0])rotate(alpha)cube(size);
    }
}