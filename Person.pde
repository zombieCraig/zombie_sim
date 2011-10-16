class Person {
  float xpos;
  float ypos;
  int infection_level;
  int max_health;
  int health;
  int max_stamina;
  int stamina;
  int fear;
  int goal;
  color c;
  Building home;
  int id;
  int steps_taken; // for walking
  int resting_time;
  Building target_building;
  boolean logging;
  boolean selected;
  int last_goal;
  Position goal_position;
  Position walkto_position;
  ArrayList<Position> walk_path;
  
  final int GOAL_REST = 0;
  final int GOAL_GOTO_BUILDING = 1;
  final int GOAL_STAY_WITH_PERSON = 2;
  
  Person(float startx, float starty) {
    xpos = startx;
    ypos = starty;
    c = color(127);
    max_health = 100;
    max_stamina = 250;
    health = max_health;
    stamina = max_stamina;
    goal = GOAL_REST;
    last_goal = goal;
    id = next_player_id;
    next_player_id++;
    logging = false;
    selected = false;
    steps_taken = 0;
    resting_time = 0;
  }

  // Returns a building if the person is in one else null
  Building in_building() {
    Iterator n = homes.iterator();
    while(n.hasNext()) {
      Building home = (Building)n.next();
      if(home.overlapping(int(xpos), int(ypos), 2, 2)) {
        return home;
      } 
    }
    return null; 
  }

  // Main decision making function for the person.
  void act() {
    if(fear == 0) {
       switch(goal) {
        case GOAL_REST:
          if(stamina < max_stamina) {
            if(in_building() != null) {
              resting_time++;
              if(resting_time > recovery_ticks) {
                stamina++;
                health++;
                if(stamina > max_stamina) {
                  stamina = max_stamina;
                }
                if(health > max_health) {
                  health = max_health;
                }
                resting_time = 0;
              }
            } else {
              // Since not afraid, head home to rest.
              target_building = home;
              goal = GOAL_GOTO_BUILDING;
            }
          } else {
            if(int(random(100)) == 1) { // 1 in a 100 chance
              switch(int(random(3))) {
                case GOAL_REST:
                  goal = GOAL_REST;
                  break;
                 case GOAL_GOTO_BUILDING:
                  if(homes.size() > 0) {
                    target_building = (Building)homes.get(int(random(homes.size())));
                    goal_position = target_building.get_random_position();
                    walk_path = path.get_path(this, target_building, goal_position);
                    goal = GOAL_GOTO_BUILDING;
                  } else {
                   println(id + "ERROR: No known neighborhood"); 
                  }
                  break;
                 case GOAL_STAY_WITH_PERSON:
                  break;
                 default:
                  goal = GOAL_REST;
                  break;
              }
            }
            break;
          }
        case GOAL_GOTO_BUILDING:
          Building in_home = in_building();
          if(in_home != null) {
            if(in_home == target_building) {
             if((int)goal_position.get_x() == (int)xpos && (int)goal_position.get_y() == (int)ypos) {
               if(logging) log("Arrived at my destination, resting");
               goal = GOAL_REST;
             } else {
               walk();
             }
            } else {
              walk();
            }
          } else {
            // Outside heading towards building
            walk();
          }
          break;
        default:
          break;
       }
    } else {  // When fear > 0
      
    }
    if(goal != last_goal && logging) {
      switch(goal) {
      case GOAL_REST:
        log("I want to rest");
        break;
      case GOAL_GOTO_BUILDING:
        if(home.id == target_building.id) {
          log("I want to go home (Building #"+home.id+")");
        } else {
          log("I want to visit Building #" + target_building.id);
        }
        break;
      default:
        log("I don't know what I want");
      } 
    }
    last_goal = goal;
  }
  
  void walk() {
    if(target_building == null) {
       println("ERROR: " +id+" Null target building");
       goal = GOAL_REST;
    } else if(stamina < 1) {
       log("I'm too exhausted");
       goal = GOAL_REST;
     } else {
       if(goal_position == null) {
         println("ERROR: " +id+ " No goal position set");
         goal = GOAL_REST;
       } else {
         if ((int)goal_position.get_x() > (int)xpos) {
           xpos++;
         } else if((int)goal_position.get_x() < (int)xpos) {
           xpos--;
         }
         if ((int)goal_position.get_y() > (int)ypos) {
           ypos++;
         } else if((int)goal_position.get_y() < (int)ypos) {
           ypos--;
         }
         steps_taken++;
         if(steps_taken > steps_per_stamina) {
           steps_taken = 0;
           stamina--;
         }
       }
     } 
  }
  
  void draw() {
    if (is_selected()) {
      fill(#ffff00);
    } else {
      fill(c);
    }
    ellipse(xpos, ypos, 3, 3);
  }
  
  void set_home(Building h) {
    home = h; 
  }
  
  void set_logging(boolean state) {
    logging = state;
  }
  
  void set_selected(boolean s) {
    selected = s;
  }
  
  boolean is_selected() {
    return selected;
  }
  
  void log(String msg) {
    println(id + "> " + msg); 
  }
  
  int get_id() { 
    return id;
  }
  
  float get_posx() {
    return xpos;
  }
  
  float get_posy() {
    return ypos;
  }
  
  Position get_position() {
    return new Position(xpos, ypos);
  }
  
  int get_health() {
    return health;
  }
  
  int get_max_health() {
    return max_health;
  }
  
  int get_stamina() {
    return stamina;
  }
  
  int get_max_stamina() {
    return max_stamina;
  }
  
  int get_infection_level() {
    return infection_level;
  }
  
  int get_fear() {
    return fear;
  }
}

