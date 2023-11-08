class Notes{

 final String title;
 final String description;
 final String date;

  Notes({required this.title, required this.description,required this.date});

  factory Notes.json(Map notes){
    return Notes(title: notes["title"], description: notes["description"], date: notes["date"]);
  }
}