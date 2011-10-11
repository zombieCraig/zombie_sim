// Simple class to hold position information

class Position {
 float x;
 float y;
 Position(float setx, float sety) {
   x = setx;
   y = sety;
 }
 
 float get_x() {
   return x;
 }
 
 float get_y() {
   return y;
 }
 
 void set_x(float setx) {
   x = setx;
 }
 
 void set_y(float sety) {
   y = sety;
 }
}
