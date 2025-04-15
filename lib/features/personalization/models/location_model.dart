class LocationModel {
  final String? id;
  final String makerId;
  final String title;
  final String snippet;
  final String location; // Can be JSON like "lat,lng" or a readable address
  final String date;     // Should be unique, can use ISO8601 format

  LocationModel({
    this.id,
    required this.makerId,
    required this.title,
    required this.snippet,
    required this.location,
    required this.date,
  });

  /// Create object from a data (e.g., from SQLite)
  factory LocationModel.fromMap(Map<String, dynamic> data) {
    return LocationModel(
      id: data['id'].toString(), 
      makerId: data['makerId'],
      title: data['title'],
      snippet: data['snippet'],
      location: data['location'],
      date: data['date'],
    );
  }

    /// Convert object to map (e.g., for inserting/updating SQLite)
    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'makerId': makerId,
        'title': title,
        'snippet': snippet,
        'location': location,
        'date': date,
      };
  }
}
