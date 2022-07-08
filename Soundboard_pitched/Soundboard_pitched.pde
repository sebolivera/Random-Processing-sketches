// Click on the image to give it focus,
// and then press any key.
import processing.sound.*;
SoundFile[] sounds;
SoundFile kick, snare, hat1, hat2;
int KICK_SPEED = 120;//vitesse du son de la grosse caisse => 30 = 2x par seconde, 60x = 1x par seconde, 15 = 4x par seconde
int SNARE_SPEED = 60;//idem pour la caisse claire
int HAT_1_SPEED = 30;//vitesse cymbale 1
int HAT_2_SPEED = 45;//vitesse cymbale 2
int HAUTEUR = 600;
int LARGEUR = 200;
//sons à remplacer dans la liste ci-dessous
String[] LISTE_DES_SONS = {"M Piano-48.wav", "M Piano-49.wav", "M Piano-50.wav", "M Piano-51.wav", "M Piano-52.wav", "M Piano-53.wav", "M Piano-54.wav", "M Piano-55.wav", "M Piano-56.wav", "M Piano-57.wav", "M Piano-58.wav", "M Piano-59.wav", "M Piano-60.wav", "M Piano-61.wav", "M Piano-62.wav", "M Piano-63.wav", "M Piano-64.wav", "M Piano-65.wav", "M Piano-66.wav", "M Piano-67.wav", "M Piano-68.wav", "M Piano-69.wav", "M Piano-70.wav", "M Piano-71.wav", "M Piano-72.wav", "M Piano-73.wav", "M Piano-74.wav", "M Piano-75.wav", "M Piano-76.wav", "M Piano-77.wav", "M Piano-78.wav"};//SONS A AJOUTER ICI !!
Boolean battery_on = false;
color red = color(255, 0, 0);
color blue = color(0, 0, 255);
color green = color(0, 255, 0);
color yellow = color(255, 255, 0);
color grey = color(128, 128, 128);
color black = color(0, 0, 0);
color white = color(255, 255, 255);


SoundFile[] loadSoundFiles(String[] fileList) {//charge une liste de noms de fichier, et ouvre tout le contenu 1 à 1 en tant que fichier de son
  SoundFile[] soundFile = new SoundFile[fileList.length];
  for (int i=0; i<fileList.length; i++) {
    soundFile[i] = new SoundFile (this, fileList[i]);
  }
  return soundFile;
}

void draw() {
  //fond de l'app
  fill(black);//couleur du fond$
  noStroke();//pas de contour pour le fond
  rect(0, 0, HAUTEUR, LARGEUR);//fond d'écran noir
  stroke(black);//le contour des cases est noir
  
  //Dessine les cases pour la batterie/automatique
  if (battery_on)
    fill(green);
  else
    fill(red);
  rect(25, 0, 50, 50, 5);
  fill(blue);
  text("Auto-", 50, 10);
  text("battery", 50, 20);
  if (battery_on)
    text("on", 50, 30);
  else
    text("off", 50, 30);
  text("(1)", 50, 40);
  //affichage 'Kick'
  fill(white);//le fond des cases est blanc par défaut
  if (kick.isPlaying())//si le kick est en train d'être joué
    fill(yellow);
  rect(75, 0, 50, 50, 5);
  fill(blue);
  text("Kick", 100, 25);
  text("(2)", 100, 35);
  
  //affichage 'Snare'
  fill(white);//le fond des cases est blanc par défaut
  if (snare.isPlaying())
    fill(yellow);
  rect(125, 0, 50, 50, 5);
  fill(blue);
  text("Snare", 150, 25);
  text("(3)",150, 35);
  
  //affichage 'hat 1'
  fill(white);//le fond des cases est blanc par défaut
  if (hat1.isPlaying())
    fill(yellow);
  rect(175, 0, 50, 50, 5);
  fill(blue);
  text("Hat 1", 200, 25);
  text("(4)",200, 35);
  
  //affichage 'hat 2'
  fill(white);//le fond des cases est blanc par défaut
  if (hat2.isPlaying())
    fill(yellow);
  rect(225, 0, 50, 50, 5);
  fill(blue);
  text("Hat 2", 250, 25);
  text("(5)",250, 35);
  
  
  //Dessine la board principale
  int boardIndex = 0;//index global des cases
  int offsetLeft = 50; //décalage des touches pour faire un peu plus joli...
  char[] lettres_du_clavier= "AZERTYUIOPQSDFGHJKLMWXCVBN,;:!".toCharArray();
  for (int i = 0; i<3; i++)//trois rangées de touches
  {
    for (int j = 0; j<10; j++)
    {
      fill(white);//le fond des cases est blanc par défaut
      stroke(black);//le contour des cases est noir
      if (sounds.length > boardIndex)//si un son est alloué à la case donnée
        if (sounds[boardIndex].isPlaying())//si un son est en train de jouer, la case correspondante devient rouge
          fill(yellow);
        else
          fill(white);
      else
        fill(grey);
      rect(offsetLeft+50*j, 50+50*i, 50,  50, 5);//on dessine la case, avec un petit décalage à chaque ligne pour simuler un clavier
      fill(blue);//on se prépare à écrire le nom de la touche en bleu
      if (boardIndex<lettres_du_clavier.length)//touche en bleu
        text(lettres_du_clavier[boardIndex], offsetLeft+25+50*j, 75+50*i);
      boardIndex++;
    }
    offsetLeft+=15;//le décalage à gauche du clavier
  }
  
  if (battery_on){//possible de le désactiver complètement en passant le booléen battery_on a false
    if (frameCount % KICK_SPEED == 0)
      kick.play();
    if (frameCount % SNARE_SPEED == 30)
      snare.play();
    if (frameCount % HAT_1_SPEED == 15)
      hat1.play();
    if (frameCount % HAT_2_SPEED == 0 ||frameCount % HAT_2_SPEED == 30)
      hat2.play();
  }
}

void settings() {//initialise la fenêtre
  size(HAUTEUR, LARGEUR);
}


void setup()//déclare les variables (sons, notamment
{
  //la ligne suivante est la ligne à modifier :
  sounds = loadSoundFiles(LISTE_DES_SONS);
  kick = new SoundFile (this, "kick.wav");//son de la grosse caisse
  snare = new SoundFile (this, "snare.wav");//son de la caisse claire
  hat1 = new SoundFile(this, "hat1.wav");//son de la cymbale 1
  hat2 = new SoundFile(this, "hat2.wav");//son de la cymbale 2
  textAlign(CENTER, CENTER);
}

void keyPressed() {//détecte l'appui sur un bouton du clavier
  switch (keyCode)//pour un code de touche donnée (référence ici : https://itecnote.com/tecnote/java-keyboard-keycodes-list/)
  {
    //chiffres (seuls 1 à 5 sont pris en compte pour la batterie)
    case 49://touche '1' (ou "&")
      battery_on = !battery_on;//inverse la batterie auto (si on => off, si off => on)
      break;
    case 50://touche '2' (ou "é")
      if (kick!=null && !battery_on)
        kick.play();
      break;
    case 51://touche '3' (ou '"')
      if (snare!=null && !battery_on)
        snare.play();
      break;
    case 52://touche '4' (ou "'")
      if (hat1!=null && !battery_on)
        hat1.play();
      break;
    case 53://touche '5' (ou "(")
      if (kick!=null && !battery_on)
        hat2.play();
      break;
      
      
    //1ère rangée de lettres
    case 65://touche 'A'
      if (sounds.length>0)//vérifie qu'il y a AU MOINS 1 son à disposition
        sounds[0].play();//joue le son
      break;//sort du switch (syntaxe standard d'un switch/case)
    case 90://touche 'Z'
      if (sounds.length>1)
        sounds[1].play();
      break;
    case 69://touche 'E'
      if (sounds.length>2)
        sounds[2].play();
      break;
    case 82://touche 'R'
      if (sounds.length>3)
        sounds[3].play();
      break;
    case 84://touche 'T'
      if (sounds.length>4)
        sounds[4].play();
      break;
    case 89://touche 'Y'
      if (sounds.length>5)
        sounds[5].play();
      break;
    case 85://touche 'U'
      if (sounds.length>6)
        sounds[6].play();
      break;
    case 73://touche 'I'
      if (sounds.length>7)
        sounds[7].play();
      break;
    case 79://touche 'O'
      if (sounds.length>8)
        sounds[8].play();
      break;
    case 80://touche 'P'
      if (sounds.length>9)
        sounds[9].play();
      break;
      
    //2nde rangée
    case 81://touche 'Q'
      if (sounds.length>10)
        sounds[10].play();
      break;
    case 83://touche 'S'
      if (sounds.length>11)
        sounds[11].play();
      break;
    case 68://touche 'D'
      if (sounds.length>12)
        sounds[12].play();
      break;
    case 70://touche 'F'
      if (sounds.length>13)
        sounds[13].play();
      break;
    case 71://touche 'G'
      if (sounds.length>14)
        sounds[14].play();
      break;
    case 72://touche 'H'
      if (sounds.length>15)
        sounds[15].play();
      break;
    case 74://touche 'J'
      if (sounds.length>16)
        sounds[16].play();
      break;
    case 75://touche 'K'
      if (sounds.length>17)
        sounds[17].play();
      break;
    case 76://touche 'L'
      if (sounds.length>18)
        sounds[18].play();
      break;
    case 77://touche 'M'
      if (sounds.length>19)
        sounds[19].play();
      break;
      
      
    //3ème rangée
    case 87://touche 'W'
      if (sounds.length>20)
        sounds[20].play();
      break;
    case 88://touche 'X'
      if (sounds.length>21)
        sounds[21].play();
      break;
    case 67://touche 'C'
      if (sounds.length>22)
        sounds[22].play();
      break;
    case 86://touche 'V'
      if (sounds.length>23)
        sounds[23].play();
      break;
    case 66://touche 'B'
      if (sounds.length>24)
        sounds[24].play();
      break;
    case 78://touche 'N'
      if (sounds.length>25)
        sounds[25].play();
      break;
    case 44://touche ','
      if (sounds.length>26)
        sounds[26].play();
      break;
    case 59://touche ';'
      if (sounds.length>27)
        sounds[27].play();
      break;
    case 513://touche ';'
      if (sounds.length>28)
        sounds[28].play();
      break;
    case 517://touche '!'
      if (sounds.length>29)
        sounds[29].play();
      break;
      
    default://on imprime le n° de la touche pressée si elle n'est pas présente dans un des switch/case
      System.out.println("Code de la touche pressée : "+keyCode); //affiche le code d'une touche pressée (utile si vous voulez ajouter des touches à la soundboard)
      break;
  }
}


void mouseClicked() {
  if (mouseY<50){//si clic sur la 1ère ligne
    if (mouseX<25)//clic à gauche de la 1ère case
      System.out.println("pas de case ici...");
    else if(mouseX <75)//clic sur la case battery on/battery off
      battery_on = !battery_on;
    else if (mouseX < 125)//clic sur la case 2
      kick.play();
    else if (mouseX < 175)// clic sur la case 3
      snare.play();
    else if (mouseX < 225)//clic sur la case 4
      hat1.play();
    else if (mouseX < 275)//clic sur la case 5
      hat2.play();
  }
  else if (mouseY<100)//clic sur la 2nde ligne
  {
    if (mouseX>=50 && mouseX<550)//clic après la 1ère case, avant l'espace vide à la fin
      if (sounds.length>((mouseX-50)/50))//détection approximative d'un clic dans une case
        sounds[((mouseX-50)/50)].play();
  }
  else if (mouseY<150)//3ème ligne
  {
    if (mouseX>=65 && mouseX<565)
      if (sounds.length>((mouseX-65)/50)+10)//détection approximative d'un clic dans une case
        sounds[((mouseX-65)/50)+10].play();
    
  }
  else
  {
    if (mouseX>=80 && mouseX<580)
      if (sounds.length>((mouseX-80)/50)+20)//détection approximative d'un clic dans une case
        sounds[((mouseX-80)/50)+20].play();
  }
  
}
