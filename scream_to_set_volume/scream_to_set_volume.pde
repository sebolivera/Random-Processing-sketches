import processing.sound.*;

AudioIn input;
Amplitude analyzer;
PImage img;
int rectx, recty, rectw, recth;
float updtvol = 0.01;
SoundFile song;
boolean playPause = true;

void setup() {
    size(500, 500);
    song = new SoundFile(this, "song.mp3");
    img = loadImage("speaker.png");
    input = new AudioIn(this, 0);
    input.start();
    analyzer = new Amplitude(this);
    analyzer.input(input);
    rectx = (width / 2) - 30;
    recty = (height / 2) + 25;
    rectw = 50;
    recth = 25;
        song.play();
}

void draw() {
    background(255);
      stroke(220, 220, 200, 1);
      fill(0, 408, 612);
      text("Press 'p' to play", (width / 2),height+ height / 2);
    if (playPause) {
        float vol = analyzer.analyze();
        fill(127);
        stroke(0);
        image(img, (width / 2) - 50, (height / 2) - 7);
        line((width / 2) - 25, (height / 2), (width / 2) + 25, (height / 2));
        img.resize(15, 15);

        if (mouseX > rectx && mouseX < rectx + rectw && mouseY > recty && mouseY < recty + recth && mousePressed) {
            fill(255, 255, 255);
            rect(rectx, recty, rectw, recth, 5, 5, 5, 5);
            fill(0, 0, 0);
            updtvol = vol;
        } else {
            fill(220, 220, 220);
            rect(rectx, recty, rectw, recth, 5, 5, 5, 5);
            fill(100, 100, 100);
        }
        song.amp(updtvol);
        text("Set", (width / 2) - 15, (height / 2) + 43);
        ellipse((width / 2) - 25 + updtvol * 100, height / 2, 10, 10);
        fill(220, 220, 200, 0.2);
        ellipse((width / 2) - 25 + vol * 100, height / 2, 10, 10);
        fill(220, 220, 200, 0.2);
    }
    else
    {
      stroke(220, 220, 200, 1);
      textSize(128);
      fill(0, 408, 612);
      text("Press 'p' to play", (width / 2), height / 2, 10, 10);
  }
}
