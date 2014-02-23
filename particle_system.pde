class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan, particleWidth;

  Particle(PVector l, float s) {
    acceleration = new PVector(0,0.05);
    velocity = new PVector(random(-5,5),0.5);
    location = l.get();
    particleWidth = s;
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  void setParticleWidth(float w)
  {
    particleWidth = w;
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
            particleWidth, particleWidth);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0 || location.y > mainCharacter.y) {
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
  float particleWidth;
  boolean shouldDraw;

  ParticleSystem(PVector location, float s, boolean b) {
    origin = location.get();
    particles = new ArrayList<Particle>();
    particleWidth = s;
    shouldDraw = b;
  }

  void addParticle() {
    particles.add(new Particle(origin, particleWidth));
  }

  void setShouldDraw(boolean b)
  {
    shouldDraw = b;
  }

  void setParticleWidth(float s)
  {
    particleWidth = s;
  }


  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.setParticleWidth(particleWidth);

      p.update();
      if(shouldDraw)
        p.display();

      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
