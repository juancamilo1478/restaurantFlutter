class Sectors {
  int x;
  int y;
  List<SectorData> data;
  Sectors(this.x, this.y, this.data);
}

class SectorData {
  int id;
  String state;
  String name;
  String categorie;

  SectorData(
    this.id,
    this.state,
    this.name,
    this.categorie,
  );
}
