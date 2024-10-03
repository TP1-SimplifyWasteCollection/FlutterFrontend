import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geotypes/src/geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:testmap/mapbox_map_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RecyclingCardData {
  late final String name;
  late final String address;
  late final String phone;
  final DateTime openingHour;
  final DateTime closingHour;
  final List<String> recyclingItems;
  final LatLng position;
  String id2;
  final int id;


  RecyclingCardData({
    required this.name,
    required this.address,
    required this.phone,
    required this.openingHour,
    required this.closingHour,
    required this.recyclingItems,
    required this.position,
    required this.id,
    this.id2 = "",
  });

  factory RecyclingCardData.fromJson(Map<String, dynamic> json) {
    return RecyclingCardData(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      openingHour: DateTime.parse(json['openingHour']),
      closingHour: DateTime.parse(json['closingHour']),
      recyclingItems: List<String>.from(json['recyclingItems']),
      position: LatLng(json['latitude'], json['longitude']),
      id: json['id'],
    );
  }
}

class SlidingPanelContent extends StatefulWidget {
  final ValueNotifier<List<RecyclingCardData>> cardsData;
  final Function addCard;
  final PanelController panelController;

  SlidingPanelContent(
      {super.key, required this.cardsData, required this.addCard,required this.panelController,});

  @override
  State<SlidingPanelContent> createState() => _SlidingPanelContentState();
}

class _SlidingPanelContentState extends State<SlidingPanelContent> {
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.cardsData.addListener(_onCardsDataChanged); // Listen for changes
  }

  void _onCardsDataChanged() {
    setState(() {
      buildRecyclingCards(context, widget.cardsData.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/arrowUp.svg'),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Что вы хотите сдать?",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                color: Color(0xFFF5F7FA),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // Prevent scrolling
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
          ),
          itemBuilder: (context, index) {
            List<String> icons = [
              'assets/recycleItems/paper.svg',
              'assets/recycleItems/clothes.svg',
              'assets/recycleItems/plastic.svg',
              'assets/recycleItems/lights.svg',
              'assets/recycleItems/danger.svg',
              'assets/recycleItems/glass.svg',
              'assets/recycleItems/metal.svg',
              'assets/recycleItems/battery.svg',
              'assets/recycleItems/other.svg',
              'assets/recycleItems/tyres.svg',
            ];

            return _button(icons[index]);
          },
        ),
        SizedBox(height: 20.0),
        Column(
          children: buildRecyclingCards(context, widget.cardsData.value),
        ),
        SizedBox(height: 15.0),
        IconButton(
          onPressed: () {
            RecyclingCardData newCard = RecyclingCardData(
              name: '',
              address: '',
              phone: '',
              openingHour: DateTime.now(),
              closingHour: DateTime.now(),
              recyclingItems: [],
              position: LatLng(0, 0),
              id: widget.cardsData.value.length + 1,
            );

            TextEditingController nameController = TextEditingController();
            TextEditingController addressController = TextEditingController();
            TextEditingController phoneController = TextEditingController();

            List<bool> selectedItems = List<bool>.filled(10, false);

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add New Card'),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(hintText: 'Name'),
                            onChanged: (value) {
                              newCard.name = value;
                            },
                          ),
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(hintText: 'Address'),
                            onChanged: (value) {
                              newCard.address = value;
                            },
                          ),
                          TextField(
                            controller: phoneController,
                            decoration: InputDecoration(hintText: 'Phone'),
                            onChanged: (value) {
                              newCard.phone = value;
                            },
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 1.0,
                              mainAxisSpacing: 1.0,
                            ),
                            itemBuilder: (context, index) {
                              List<String> icons = [
                                'assets/recycleItems/paper.svg',
                                'assets/recycleItems/clothes.svg',
                                'assets/recycleItems/plastic.svg',
                                'assets/recycleItems/lights.svg',
                                'assets/recycleItems/danger.svg',
                                'assets/recycleItems/glass.svg',
                                'assets/recycleItems/metal.svg',
                                'assets/recycleItems/battery.svg',
                                'assets/recycleItems/other.svg',
                                'assets/recycleItems/tyres.svg',
                              ];

                              return IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedItems[index] =
                                        !selectedItems[index];
                                    if (selectedItems[index]) {
                                      newCard.recyclingItems.add(icons[index]);
                                    } else {
                                      newCard.recyclingItems
                                          .remove(icons[index]);
                                    }
                                  });
                                },
                                icon: SvgPicture.asset(
                                  icons[index],
                                  color: selectedItems[index]
                                      ? Colors.green
                                      : null,
                                ),
                                padding: EdgeInsets.zero,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Add'),
                      onPressed: () {
                        widget.addCard(newCard);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: SvgPicture.asset('assets/recycleItems/add.svg'),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }

  Widget _button(String iconPath) {
    return IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(iconPath),
      padding: EdgeInsets.zero,
    );
  }

  List<Widget> buildRecyclingCards(
      BuildContext context, List<RecyclingCardData> cardsData) {
    return cardsData.map((data) {
      int extraItemsCount =
          data.recyclingItems.length > 3 ? data.recyclingItems.length - 2 : 0;

      return Container(
        width: MediaQuery.of(context).size.width - 20,
        child: Card(
          color: Color(0xFF2F3135),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Provider.of<MapboxMapProvider>(context, listen: false).easeCamera(data.position);
                        widget.panelController.close();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: SizedBox(
                                width: 600,
                                height: 170,
                                child: Card(
                                  color: Color(0xFF2F3135),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              data.name,
                                              style: TextStyle(
                                                fontFamily: 'MontserratBold',
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(height: 2.0),
                                            Text(
                                              '${data.address}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(height: 2.0),
                                            Text(
                                              '${data.phone}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(height: 2.0),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  isPointOpen(data.openingHour, data.closingHour)
                                                      ? 'assets/open.svg'
                                                      : 'assets/close.svg',
                                                  height: 25,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  '${data.openingHour.hour}:00 - ${data.closingHour.hour}:00',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.0),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              height: 30,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0, vertical: 2.0),
                                                  backgroundColor: Color(
                                                      0xFF005BFF),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(
                                                        8.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  double latitude = data.position.latitude;
                                                  double longitude = data.position.longitude;
                                                  _openMaps(latitude, longitude);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Открыть в "Картах?"',
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        fontSize: 15,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 16,
                                        right: 16,
                                        child: Column(
                                          children: _buildRecyclingIcons(
                                              data.recyclingItems, extraItemsCount),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.zero, // Remove default padding if needed
                      ),
                      child: Text(
                        data.name,
                        style: TextStyle(
                          fontFamily: 'MontserratBold',
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '${data.address} ${data.phone}',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        SvgPicture.asset(
                          isPointOpen(data.openingHour, data.closingHour)
                              ? 'assets/open.svg'
                              : 'assets/close.svg',
                          height: 25,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          '${data.openingHour.hour}:00 - ${data.closingHour.hour}:00',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: _buildRecyclingIcons(
                      data.recyclingItems, extraItemsCount),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  bool isPointOpen(DateTime openingTime, DateTime closingTime) {
    final now = DateTime.now();
    final currentTime = DateTime(0, 1, 1, now.hour, now.minute);
    return currentTime.isAfter(openingTime) &&
        currentTime.isBefore(closingTime);
  }

  void _openMaps(double latitude, double longitude) async {
    MapsLauncher.launchCoordinates(latitude, longitude);
  }

  List<Widget> _buildRecyclingIcons(List<String> items, int extraItemsCount) {
    List<Widget> recyclingWidgets = [];
    recyclingWidgets.add(SizedBox(height: 8.0));

    for (int i = 0; i < (items.length > 3 ? 2 : items.length); i++) {
      recyclingWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Container(
            width: 94,
            height: 25,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: Color(0xFF20402B),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              items[i],
              style: TextStyle(
                color: Color(0xFF11C44C),
                fontFamily: 'Montserrat',
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }

    if (items.length > 3) {
      recyclingWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: SizedBox(
            width: 94,
            height: 25,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF20402B),
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: items.map((item) {
                            return Container(
                              width: 94,
                              height: 25,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              margin: EdgeInsets.symmetric(vertical: 2.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF20402B),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: Color(0xFF11C44C),
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                '+ ещё $extraItemsCount',
                style: TextStyle(
                  color: Color(0xFF11C44C),
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
    }

    return recyclingWidgets;
  }
}
