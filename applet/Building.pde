class Building {
  float xpos;
  float ypos;
  int wall_width;
  color c;
  color floor_color;
  boolean[] exit_locations = new boolean[4];
  int max_occupants;
  float min_x;
  float max_x;
  float min_y;
  float max_y;
  int id;
  
  Building() {
    max_occupants = 5;
    int number_of_exits = int(random(3))+1;
    ArrayList exits = new ArrayList();
    exits.add(new Integer(NORTH));
    exits.add(new Integer(EAST));
    exits.add(new Integer(SOUTH));
    exits.add(new Integer(WEST));
    Collections.shuffle(exits);
    for(int i=0; i<4; i++) {
      Integer next_exit = (Integer)exits.get(i);
       if(i < number_of_exits) {
         exit_locations[next_exit] = true;
       } else {
         exit_locations[next_exit] = false;
       }
    }
    wall_width = 3;
    xpos = width/2;
    ypos = height/2;
    min_x = xpos - building_width/2;
    max_x = xpos + building_width/2;
    min_y = ypos - building_height/2;
    max_y = ypos + building_height/2;
    c = color(0);
    floor_color= color(#cccccc);
    id = next_building_id;
    next_building_id++;
  }
  
  ArrayList<Person> populate_building() {
    int num_occupants = int(random(max_occupants));
    ArrayList people = new ArrayList();
    for(int i = 0; i < num_occupants; i++) {
       float startx = random(min_x+4, max_x-4);
       float starty = random(min_y+4, max_y-4);
       people.add(new Person(startx, starty));
    }
    return people;
  }
  
  void draw() {
    fill(floor_color);
    noStroke();
    rect(xpos-building_width/2+2, ypos-building_width/2+2, building_width-3, building_height);
    stroke(0);
    fill(#a2a2a2);
    textAlign(CENTER);
    textFont(dashboard_font, 16);
    text(id, xpos, ypos+building_width/4);
    fill(c);
    // North
    if(exit_locations[NORTH]) {
      rect(xpos-(building_width/2), ypos-(building_height/2), building_width/3, wall_width);
      rect(xpos+(building_width/2)-(building_width/3), ypos-(building_height/2), building_width/3, wall_width);
    } else {
      rect(xpos-(building_width/2), ypos-(building_height/2), building_width, wall_width);
    }
    // East
    if(exit_locations[EAST]) {
      rect(xpos+(building_width/2)-wall_width, ypos-(building_height/2), wall_width, (building_height/3));
      rect(xpos+(building_width/2)-wall_width, ypos+(building_height/2)-(building_height/3), wall_width, (building_height/3));
    } else {
      rect(xpos+(building_width/2)-wall_width, ypos-(building_height/2), wall_width, building_height);
    }
    // South
    if(exit_locations[SOUTH]) {
      rect(xpos-(building_width/2), ypos+(building_height/2), building_width/3, wall_width);
      rect(xpos+(building_width/2)-(building_width/3), ypos+(building_height/2), building_width/3, wall_width);
    } else {
      rect(xpos-(building_width/2), ypos+(building_height/2), building_width, wall_width);
    }
    // West
    if(exit_locations[WEST]) {
      rect(xpos-(building_width/2), ypos-(building_height/2), wall_width, building_height/3);
      rect(xpos-(building_width/2), ypos+(building_height/2)-(building_height/3), wall_width, building_height/3);
    } else {
      rect(xpos-(building_width/2), ypos-(building_height/2), wall_width, building_height);
    }    
  }  /* End of Draw */
  
  boolean overlapping(int centerx, int centery, int obj_w, int obj_h) {
    if((centerx - obj_w/2 > min_x && centerx + obj_w/2 < max_x) &&
       (centery - obj_h/2 > min_y && centery + obj_h/2 < max_y))
         return true;
    return false;
  }
  
  void set_posx(int x) {
    xpos = x;
    min_x = x - building_width/2;
    max_x = x + building_width/2;
  }
  
  void set_posy(int y) {
    ypos = y;
    min_y = y - building_width/2;
    max_y = y + building_width/2;
  }
  
  int get_xpos() {
    return int(xpos);
  }
  
  int get_ypos() {
    return int(ypos);
  }
  
}

