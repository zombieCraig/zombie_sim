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
  Position[] exit_position = new Position[4];
  
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
    update_exit_locations();
  }
  
  // Used when initializing a building to populate the building with people.
  ArrayList<Person> populate_building() {
    int num_occupants = int(random(max_occupants));
    ArrayList people = new ArrayList();
    for(int i = 0; i < num_occupants; i++) {
       people.add(new Person(get_random_x(), get_random_y()));
    }
    return people;
  }
  
  // Return the position of the nearest exit
  Position nearest_exit(Position pos) {
    float x_pos = pos.get_x();
    float y_pos = pos.get_y();
    int closest_exit = -1;
    int min_diff = 9001; // Initial diff is over 9000!
    for(int x=0; x < 4; x++) {
      if(exit_locations[x]) {
        if((int(abs(x_pos - exit_position[x].get_x()) + abs(y_pos - exit_position[x].get_y()))) < min_diff) {
         closest_exit = x;
         min_diff = int(abs(x_pos - exit_position[x].get_x()) + abs(y_pos - exit_position[x].get_y()));
        }
      }
    }
    return exit_position[closest_exit];
  }
  
  // Updates the location of the exits.  Done during init
  void update_exit_locations() {
    if(exit_locations[NORTH]) {
      exit_position[NORTH] = new Position(xpos, ypos - building_height/2);
    }
    if(exit_locations[EAST]) {
      exit_position[EAST] = new Position(xpos + building_width/2, ypos);
    }
    if(exit_locations[SOUTH]) {
      exit_position[SOUTH] = new Position(xpos, ypos + building_height/2);
    }
    if(exit_locations[WEST]) {
      exit_position[WEST] = new Position(xpos - building_width/2, ypos);
    }
  }
  
  // Returns a random X location inside of the building
  float get_random_x() {
    return random(min_x+4, max_x-4);
  }
  
  // Returns a random Y location inside of the building
  float get_random_y() {
    return random(min_y+4, max_y-4);
  }
  
  Position get_random_position() {
    Position pos = new Position(get_random_x(), get_random_y());
    return pos; 
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
    int leftx = centerx - obj_w/2;
    int rightx = centerx + obj_w/2;
    int topy = centery - obj_h/2;
    int bottomy = centery + obj_h/2;
    boolean overlap_x = false;
    boolean overlap_y = false;
    if(leftx > min_x && leftx < max_x)
      overlap_x = true;
    if(rightx > min_x && rightx < max_x)
      overlap_x = true;
    if(topy > min_y && topy < max_y)
      overlap_y = true;
    if(bottomy > min_y && bottomy < max_y)
      overlap_y = true;
    return overlap_x && overlap_y;
  }
  
  void set_posx(int x) {
    xpos = x;
    min_x = x - building_width/2;
    max_x = x + building_width/2;
    update_exit_locations();
  }
  
  void set_posy(int y) {
    ypos = y;
    min_y = y - building_height/2;
    max_y = y + building_height/2;
    update_exit_locations();
  }
  
  int get_xpos() {
    return int(xpos);
  }
  
  int get_ypos() {
    return int(ypos);
  }
  
}

