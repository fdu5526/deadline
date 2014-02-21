/*
 * thanks to Daniel Shiffman for his example code
 */

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0,random(0.1, 0.6));
    float x = random(-8,8);
    float y = random(-10,2);
    velocity = new PVector(x,y);
    location = l.get();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.0;
  }

  // Method to display
  void display() {
    stroke(255,0, 0, lifespan);
    fill(255, 0, 0, lifespan);
    ellipse(location.x,location.y,8,8);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}




// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  Particle[] particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new Particle[400];
  }

  void explode() {
    for(int i = 0; i < 400; i++)
      particles[i] = new Particle(origin);
  }

  void run() {
    for (int i = particles.length-1; i >= 0; i--)
      particles[i].run();
  }
}