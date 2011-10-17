class PathFinder {
 int area_w;
 int area_h;
 int grid_sz;
 int columns;
 int rows;
 boolean debugging = false;
 
 PathFinder(int area_width, int area_height, int grid_size) {
   area_w = area_width;
   area_h = area_height;
   grid_sz = grid_size;
   columns = int(area_w/grid_sz);
   rows = int(area_h/grid_sz); 
 } 
 
 ArrayList<Position> get_path(Person p, Building end_building, Position end_position) {
   ArrayList new_path = new ArrayList();
   Position current_position = p.get_position();
   Building start_building = p.in_building();
   if(start_building != null) {
      current_position = start_building.nearest_exit(p.get_position());
      new_path.add(current_position);
   }
   // TODO use A* here
   new_path.add(end_building.nearest_exit(current_position));
   new_path.add(end_position);   
   if(debugging) {
     // mode = SIM_PAUSE;
   }
   return new_path;
 }
 
 void debug_print_path(ArrayList my_path) {
   int i=0;
   Iterator p = my_path.iterator();
   println("DEBUG PATH");
   while(p.hasNext()) {
     Position next_p = (Position)p.next();
     println(i + ") " + next_p.get_x() + "," + next_p.get_y());
     i++;
   }
 }
 
 void draw_grid() {
   for(int x = 0; x <= rows; x++) {
     line(0, x*grid_sz, area_w, x*grid_sz);
   }   
   for(int y = 0; y <= columns; y++) {
     line(y*grid_sz, 0, y*grid_sz, area_h);
   } 
 }
 
 void draw() {
   if(debugging) {
     draw_grid();
   } 
 }
 
 void set_debugging(boolean s) {
   debugging = s; 
 }
 
}
