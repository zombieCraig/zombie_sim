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
 
 ArrayList<Position> get_path(Position start, Position end) {
   ArrayList new_path = new ArrayList();
   if(debugging) {
     // mode = SIM_PAUSE;
   }
   return new_path;
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
