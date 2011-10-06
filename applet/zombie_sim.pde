/* Zombie Simulator
 (cc) 2011 Craig Smith
 */

/* Settings */


int number_of_buildings = 4;

final int NORTH = 0;
final int EAST = 1;
final int SOUTH = 2;
final int WEST = 3;

final int SIM_PAUSE = 0;
final int SIM_PLAY = 1;

final int map_area_w = 500;
final int map_area_h = 500;
final int dashboard_w = 200;
final int screen_width = map_area_w + dashboard_w;
final int screen_height = map_area_h;
final int building_width = 36;
final int building_height = 36;

ArrayList homes;
ArrayList people;

int next_player_id = 1;
int next_building_id = 1;
Person person_selected = null;
int mode = SIM_PAUSE;
PFont dashboard_font;

void setup() {
  size(700, 500); // Needs to be hardcoded to make an applet
  dashboard_font = loadFont("DejaVuSerifCondensed-Bold-16.vlw");
  
  homes = new ArrayList();
  people = new ArrayList();
  for(int i = 0; i < number_of_buildings; i++) {
    homes.add(new Building());
  }
  place_randomly();
  ArrayList household = new ArrayList();
  Iterator h = homes.iterator();
  while(h.hasNext()) {
    Building newHome = (Building)h.next();
    household = newHome.populate_building();
    println("Building " + newHome.id + " ppl = " + household.size());
    Iterator p = household.iterator();
    while(p.hasNext()) {
      Person occupant = (Person)p.next();
      occupant.set_home(newHome); 
    }
    people.addAll(household);
  }
}

void place_randomly() {
 for(int h = 0; h < number_of_buildings; h++) {
   for(int i = 0; i < 100; i++) {
    int tryx = int(random(building_width/2, map_area_w-building_width/2));
    int tryy = int(random(building_height/2, map_area_h-building_height/2));    
    if(i != h) { // Don't look at yourself
      Building home = (Building)homes.get(h);
      if(!home.overlapping(tryx, tryy, building_width, building_height)) {
        i = 100;
        home.set_posx(tryx);
        home.set_posy(tryy);
       }
    } 
   }
 }
}

void update_map() {
  background(255);
    // Map
  fill(color(#008000));
  rect(0, 0, map_area_w, map_area_h);
  fill(color(204));
  rect(map_area_w, 0, map_area_w + dashboard_w, map_area_h);
  for(int h = 0; h < number_of_buildings; h++) {
    Building home = (Building)homes.get(h);
     home.draw(); 
  }
}

void update_dashboard() {
  int d_w = map_area_w + 10;
  textFont(dashboard_font, 16);
  if(person_selected != null) {
    fill(0);
    textAlign(LEFT);
    text("Person #" + person_selected.get_id(), d_w, 20);
  }
  draw_controls();
}

void update_people() {
  Iterator p = people.iterator();
  while(p.hasNext()) {
    Person person = (Person)p.next();
    if(mode == SIM_PLAY) {
      person.act();
    }
    person.draw(); 
  }
}

void mouseClicked() {
  if (mouseX < map_area_w) { // Map Click
  boolean found_item = false;
    Iterator p = people.iterator();
    while(p.hasNext()) {
      Person check_person = (Person)p.next();
      if(mouseX > check_person.get_posx()-3 && mouseX < check_person.get_posx()+3 &&
         mouseY > check_person.get_posy()-3 && mouseY < check_person.get_posy()+3) {
           if(person_selected != null) {
             person_selected.set_selected(false);
             person_selected.set_logging(false);
           }
           person_selected = check_person;
           check_person.set_selected(true);
           check_person.set_logging(true);
           found_item = true;
         } 
    }
    if(!found_item) {
      if(person_selected != null) {
        person_selected.set_selected(false);
        person_selected = null;
      } 
    }
  } else { // Dashboard click
    // Play/Pause control
    if(mouseX > screen_width - 30 && mouseX < screen_width-5 &&
       mouseY > screen_height - 25 && mouseY < screen_height- 5) {
         if(mode == SIM_PAUSE) {
           mode = SIM_PLAY;
         } else {
           mode = SIM_PAUSE;
         }
       }
  }
   
}

void draw_controls() {
  if(mode == SIM_PAUSE) {
    fill(0);
    rect(screen_width - 30, screen_height - 25, 10, 20);
    rect(screen_width - 15, screen_height - 25, 10, 20);
  } else {
    fill(0);
    triangle(screen_width -30, screen_height -25, screen_width-30, screen_height-5, screen_width-5, screen_height-12.5);
  }
}

void draw() {
  update_map();
  update_dashboard();
  update_people();
}
