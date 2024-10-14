import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:testmap/mapbox_map_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

class RecyclingCardData {
  String name;
  String address;
  String phone;
  DateTime openingHour;
  DateTime closingHour;
  List<String> recyclingItems;
  LatLng position;
  String id2;

  RecyclingCardData({
    required this.name,
    required this.address,
    required this.phone,
    required this.openingHour,
    required this.closingHour,
    required this.recyclingItems,
    required this.position,
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
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'openingHour': openingHour.toIso8601String(),
      'closingHour': closingHour.toIso8601String(),
      'recyclingItems': recyclingItems,
      'latitude': position.latitude.toDouble(),
      'longitude': position.longitude.toDouble(),
    };
  }
}

class SlidingPanelContent extends StatefulWidget {
  final ValueNotifier<List<RecyclingCardData>> cardsData;
  final Function addCard;
  final PanelController panelController;
  final ScrollController scrollController;
  Timer? cameraCheckTimer;


  SlidingPanelContent({
    super.key,
    required this.cardsData,
    required this.addCard,
    required this.panelController,
    required this.scrollController,
  });

  @override
  State<SlidingPanelContent> createState() => SlidingPanelContentState();
}

class SlidingPanelContentState extends State<SlidingPanelContent> {
  final now = DateTime.now();
  bool isAddingNewCard = false;
  List<bool> selectedItems = List<bool>.filled(10, false);
  RecyclingCardData newCard = RecyclingCardData(
    name: 'Мусорный бак',
    address: '',
    phone: '',
    openingHour: DateTime(0, 1, 1, 0, 0),
    closingHour: DateTime(0, 1, 2, 0, 0),
    recyclingItems: [],
    position: LatLng(0, 0),
  );
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController beginController = TextEditingController();
  TextEditingController endController = TextEditingController();
  final YandexGeocoder geocoder =
      YandexGeocoder(apiKey: '84bcf9c3-f6e3-4b70-8f1c-bc30358112e2');
  String address1 = 'null';
  bool isCustomTime = false;

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

  void scrollToTop() {
    widget.scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    MapboxMapProvider mapboxMapProvider =
        Provider.of<MapboxMapProvider>(context, listen: false);
    return isAddingNewCard
        ? _buildAddNewCardView(context, mapboxMapProvider)
        : _buildDefaultView(context, mapboxMapProvider);
  }

  @override
  Widget _buildDefaultView(
      BuildContext context, MapboxMapProvider mapboxMapProvider) {
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
            scrollToTop();
            setState(() {
              isAddingNewCard = true;
              widget.panelController.close();
            });
            Provider.of<MapboxMapProvider>(context, listen: false)
                .toggleMarkerVisibility(true);
          },
          icon: SvgPicture.asset('assets/recycleItems/add.svg'),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }

  Widget _buildAddNewCardView(
      BuildContext context, MapboxMapProvider mapboxMapProvider) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
        height:
            MediaQuery.of(context).size.height * 0.9, // Adjusted height to 70%
        decoration: BoxDecoration(
          color: Colors.transparent, // Set the background to transparent
        ),
        child: Column(
          children: [
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset('assets/arrowUp.svg'),
              ],
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Добавьте новый пункт приема",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    color: Color(0xFFF5F7FA),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xFF2F3135), // Background color for the container
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Введите название:',
                  hintStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none, // Remove the default border
                  contentPadding:
                      EdgeInsets.all(10), // Padding inside the TextField
                ),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontSize: 16,
                ),
                onChanged: (value) {
                  newCard.name = value;
                },
              ),
            ),
            SizedBox(height: 10),

            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xFF2F3135), // Background color for the container
              ),
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Введите номер(при наличии):',
                  hintStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none, // Remove the default border
                  contentPadding:
                      EdgeInsets.all(10), // Padding inside the TextField
                ),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontSize: 16,
                ),
                onChanged: (value) {
                  newCard.phone = value;
                  print(newCard.phone);
                },
              ),
            ),
            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Выберите время",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: Color(0xFFF5F7FA),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    RadioListTile<bool>(
                      title: Text(
                        "Круглосуточно",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      value: false,
                      groupValue: isCustomTime,
                      activeColor: Color(0xFF005BFF),
                      onChanged: (value) {
                        setState(() {
                          isCustomTime = value!;
                          if (!isCustomTime) {
                            newCard.openingHour = DateTime(0, 1, 1, 0, 0);
                            newCard.closingHour = DateTime(0, 1, 2, 0, 0);
                          }
                        });
                      },
                    ),
                    RadioListTile<bool>(
                      title: Text(
                        "Настроить время",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      value: true,
                      groupValue: isCustomTime,
                      activeColor: Color(0xFF005BFF),
                      onChanged: (value) {
                        setState(() {
                          isCustomTime = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),

            if (isCustomTime) ...[
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(
                            0xFF2F3135), // Background color for the container
                      ),
                      child: TextField(
                        controller: beginController,
                        decoration: InputDecoration(
                          hintText: 'Открытие(hh)',
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                          border: InputBorder.none, // Remove the default border
                          contentPadding: EdgeInsets.all(
                              10), // Padding inside the TextField
                        ),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                          newCard.openingHour =
                              DateTime(0, 1, 1, int.parse(value), 0);
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(
                            0xFF2F3135), // Background color for the container
                      ),
                      child: TextField(
                        controller: endController,
                        decoration: InputDecoration(
                          hintText: 'Закрытие(hh)',
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                          border: InputBorder.none, // Remove the default border
                          contentPadding: EdgeInsets.all(
                              10), // Padding inside the TextField
                        ),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                          newCard.closingHour =
                              DateTime(0, 1, 1, int.parse(value), 0);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 20), // Add some spacing before the GridView
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 22.0), // Adjust the horizontal padding as needed
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 3 / 1,
                ),
                itemBuilder: (context, index) {
                  List<String> names = [
                    'Бумага',
                    'Одежда',
                    'Пластик',
                    'Лампочки',
                    'Опасное',
                    'Стекло',
                    'Метал',
                    'Батарейки',
                    'Шины',
                    'Другое',
                  ];

                  return Container(
                    width: 94,
                    height: 25,
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: selectedItems[index]
                          ? Color(0xFF005BFF)
                          : Color(0xFF183347),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedItems[index] = !selectedItems[index];
                          if (selectedItems[index]) {
                            newCard.recyclingItems.add(names[index]);
                          } else {
                            newCard.recyclingItems.remove(names[index]);
                          }
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selectedItems[index]
                            ? Color(0xFF005BFF)
                            : Color(0xFF183347),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        names[index],
                        style: TextStyle(
                          color: selectedItems[index]
                              ? Color(0xFFF5F7FA)
                              : Color(0xFF005BFF),
                          fontFamily: 'MontserratBold',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 23.0), // Adjust the horizontal padding as needed
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF402933),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // Remove default padding
                      ),
                      child: Center(
                        child: Text(
                          'Отменить',
                          style: TextStyle(
                            color: Color(0xFFFE1356),
                            fontFamily: 'MontserratBold',
                            fontSize: 17,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Provider.of<MapboxMapProvider>(context, listen: false)
                            .toggleMarkerVisibility(false);
                        setState(() {
                          isAddingNewCard = false;
                        });
                        widget.panelController.close();
                      },
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF20402B),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // Remove default padding
                      ),
                      child: Center(
                        child: Text(
                          'Добавить',
                          style: TextStyle(
                            color: Color(0xFF11C44C),
                            fontFamily: 'MontserratBold',
                            fontSize: 17,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        LatLng? camPosition = await mapboxMapProvider
                            .getCurrentCameraPosition() as LatLng;
                        Provider.of<MapboxMapProvider>(context, listen: false)
                            .toggleMarkerVisibility(false);
                        final GeocodeResponse _address =
                            await geocoder.getGeocode(
                          ReverseGeocodeRequest(
                            pointGeocode: (
                              lat: camPosition.latitude,
                              lon: camPosition.longitude
                            ),
                          ),
                        );
                        String fullAddress =
                            _address.firstAddress?.formatted ?? 'null';
                        if (_address.firstAddress != null) {
                          String fullAddress =
                              _address.firstAddress?.formatted ?? 'null';

                          List<String> addressParts = fullAddress.split(',');

                          if (addressParts.length > 3) {
                            String betweenThirdAndFourth =
                                addressParts[3].trim();

                            String firstNumberAfterFourth = '';

                            if (addressParts.length > 4) {
                              String afterFourth = addressParts[4].trim();

                              RegExp regExp = RegExp(r'\d+');
                              Match? match = regExp.firstMatch(afterFourth);

                              if (match != null) {
                                firstNumberAfterFourth = match.group(0) ?? '';
                              }
                            }

                            newCard.address =
                                '$betweenThirdAndFourth $firstNumberAfterFourth';
                          } else {
                            newCard.address = 'null';
                          }
                        } else {
                          newCard.address = 'null';
                        }
                        print(newCard.address);
                        setState(() {
                          newCard.position = camPosition;
                          widget.addCard(newCard);
                          isAddingNewCard = false;
                          widget.panelController.close();
                          nameController.clear();
                          phoneController.clear();
                          beginController.clear();
                          endController.clear();
                          isCustomTime = false;
                          selectedItems = List<bool>.filled(10, false);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
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
        width: MediaQuery.of(context).size.width,
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
                        scrollToTop();
                        Provider.of<MapboxMapProvider>(context, listen: false)
                            .easeCamera(data.position);
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  isPointOpen(data.openingHour,
                                                          data.closingHour)
                                                      ? 'assets/open.svg'
                                                      : 'assets/close.svg',
                                                  height: 25,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  (data.openingHour.hour == 0 && data.closingHour.hour == 0)
                                                      ? '24/7'
                                                      : '${data.openingHour.hour} - ${data.closingHour.hour}',
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 30,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 2.0),
                                                  backgroundColor:
                                                      Color(0xFF005BFF),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  double latitude =
                                                      data.position.latitude;
                                                  double longitude =
                                                      data.position.longitude;
                                                  _openMaps(
                                                      latitude, longitude);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Открыть в "Картах?"',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
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
                                              data.recyclingItems,
                                              extraItemsCount),
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
                          (data.openingHour.hour == 0 && data.closingHour.hour == 0)
                              ? '24/7'
                              : '${data.openingHour.hour}:00 - ${data.closingHour.hour}:00',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 12,
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
