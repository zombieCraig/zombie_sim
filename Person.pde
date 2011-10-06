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
  Building target_building;
  boolean logging;
  boolean selected;
  int last_goal;
  
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
  }

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

  void act() {
    if(fear == 0) {
       switch(goal) {
        case GOAL_REST:
          if(stamina < max_stamina) {
            if(in_building() != null) {
               
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
             if(logging) log("Arrived at my destination");
             goal = GOAL_REST;
            } else {
             if(target_building == null) {
               println("ERROR: " +id+" Null target building");
               goal = GOAL_REST;
             } else {
               // TODO: Change to find nearest exit
               if(target_building.get_xpos() > xpos) {
                 xpos++;
               } else if(target_building.get_xpos() < xpos) {
                 xpos--;
               }
               if(target_building.get_ypos() > ypos) {
                 ypos++;
               } else if(target_building.get_ypos() < ypos) {
                 ypos--;
               }
             }
            }
          } else {
            // Outside heading towards building
             if(target_building == null) {
               println("ERROR: " +id+" Null target building");
               goal = GOAL_REST;
             } else {
               if(target_building.get_xpos() > xpos) {
                 xpos++;
               } else if(target_building.get_xpos() < xpos) {
                 xpos--;
               }
               if(target_building.get_ypos() > ypos) {
                 ypos++;
               } else if(target_building.get_ypos() < ypos) {
                 ypos--;
               }
             }
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
}

