class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan, particleScale;

  Particle(PVector l, float s) {
    acceleration = new PVector(0,0.1);
    velocity = new PVector(random(-5,5),1.0);
    location = l.get();
    particleScale = s;
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
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    fill(255, lifespan);

    ellipse(location.x,location.y,
            particleScale, particleScale);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0 || location.y >= ground) {
      return true;
    } else {
      return false;
    }
  }
}




// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  float particleScale;

  ParticleSystem(PVector location, float s) {
    origin = location.get();
    particles = new ArrayList<Particle>();
    particleScale = s;
  }

  void addParticle() {
    particles.add(new Particle(origin, particleScale));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
