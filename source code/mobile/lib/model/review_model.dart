
class ReviewModel {
  String id;
  double rating;
  String reviewMsg;
  String senderName;
  String senderImage;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.reviewMsg,
    required this.senderName,
    required this.senderImage,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json["id"] ,
    rating: json["rating"] ,
    reviewMsg: json["reviewMsg"] ,
    senderName: json["senderName"] ,
    senderImage: json["senderImage"] ,
  );

  static List<Map<String,dynamic>> dummyData() {
    return [
      {
        'id': '1',
        'rating': 4.0,
        'reviewMsg': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'senderName': 'Martin',
        'senderImage':'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg'
      },
      {
        'id': '2',
        'rating': 3.5,
        'reviewMsg': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et ',
        'senderName': 'Harvy',
        'senderImage':'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg'
      },
      {
        'id': '3',
        'rating': 4.0,
        'reviewMsg': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et ',
        'senderName': 'Mike',
        'senderImage':'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg'
      },
      {
        'id': '4',
        'rating': 4.0,
        'reviewMsg': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'senderName': 'Tyson',
        'senderImage':'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg'
      },{
        'id': '5',
        'rating': 4.0,
        'reviewMsg': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et ',
        'senderName': 'Jacob',
        'senderImage':'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg'
      }
    ];
  }
}
