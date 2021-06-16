import megamu.mesh.*;

ArrayList<Cell> cells;
boolean pull = false;
float pullmag = 100;
int ncells = 200;

Voronoi vor;
float[][] vorpoints = new float[ncells][2];

void setup() {
  size(500, 500);
  cells = new ArrayList<Cell>();
  for(int i = 0;i<ncells;i++){
    Cell cell = new Cell(random(width),random(height));
    cells.add(cell);
  }
  textSize(10);
}

void draw() {
  background(50);
  
  text(frameRate, 10, 10); 
  
  if (mousePressed) {
    pull = true;
    if (mouseButton == LEFT) {
      pullmag = Math.abs(pullmag);
    } else if (mouseButton == RIGHT) {
      pullmag = -Math.abs(pullmag); 
    }
  } else {
    pull = false;
  }
  if(pull) {
      cells.get(0).pull(new PVector(mouseX, mouseY), pullmag);
    }
    
  voronoi();
    
    
  for(Cell C : cells) {
    C.run(cells);
    
    C.render();
  }
  
  
}

void voronoi() {
  for(int i = 0;i<ncells;i++) {
    Cell c = cells.get(i);
    vorpoints[i][0] = c.position.x;
    vorpoints[i][1] = c.position.y;
  }
  vor = new Voronoi(vorpoints);
  
  if(false) {
    float[][] myEdges = vor.getEdges();
  
    for(int i=0; i<myEdges.length; i++)
    {
      float startX = myEdges[i][0];
      float startY = myEdges[i][1];
      float endX = myEdges[i][2];
      float endY = myEdges[i][3];
      line( startX, startY, endX, endY );
    }
  } else {
    MPolygon[] myRegions = vor.getRegions();
    strokeWeight(5);
    for(int i=0; i<myRegions.length; i++)
    {
      // an array of points
      float[][] regionCoordinates = myRegions[i].getCoords();
    
      fill(255,0,0);
      myRegions[i].draw(this); // draw this shape
    } 
  }
  
}
