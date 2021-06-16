ArrayList<Cell> cells;

void setup() {
  size(800, 600);
  cells = new ArrayList<Cell>();
  for(int i = 0;i<1000;i++){
    Cell cell = new Cell(random(width),random(height));
    cells.add(cell);
  }
}

void draw() {
  background(50);
  for(Cell C : cells) {
    C.run(cells);
  }
}
