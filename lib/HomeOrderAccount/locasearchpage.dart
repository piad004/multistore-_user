import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/bean/latlng.dart';
import 'package:http/http.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/mapbean/mapbyapi.dart';

class SearchLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchLocationState();
  }
}

class SearchLocationState extends State<SearchLocation> {
  var http = Client();
  bool isLoading = false;
  bool isDispose = false;
  GoogleMapsPlaces places;
  PlacesSearch placesSearch;
  List<PlacesSearchResult> searchPredictions = [];
  List<MapBoxPlace> placePred = [];
  PlacesSearchResult pPredictions;
  MapBoxPlace mapboxPredictions;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() async {
      if(!isDispose){
        if (searchController.text != null && searchController.text.length > 0) {
          if (places != null) {
            await places.searchByText(searchController.text).then((value) {
              if (searchController.text != null &&
                  searchController.text.length > 0 && this.mounted) {
                setState(() {
                  searchPredictions.clear();
                  searchPredictions = List.from(value.results);
                  print(value.results[0].formattedAddress);
                  print(
                      '${value.results[0].geometry.location.lat} ${value.results[0].geometry.location.lng}');
                });
              } else {
                if(this.mounted){
                  setState(() {
                    searchPredictions.clear();
                  });
                }
              }
            }).catchError((e) {
              if(this.mounted){
                setState(() {
                  searchPredictions.clear();
                });
              }
            });
          } else if (placesSearch != null) {
            placesSearch.getPlaces(searchController.text).then((value) {
              if (searchController.text != null &&
                  searchController.text.length > 0 && this.mounted) {
                setState(() {
                  placePred.clear();
                  placePred = List.from(value);
                  print(value[0].placeName);
                  print(
                      '${value[0].geometry.coordinates[0]} ${value[0].geometry.coordinates[1]}');
                });
              } else {
                if(this.mounted){
                  setState(() {
                    placePred.clear();
                  });
                }
              }
            }).catchError((e) {
              if(this.mounted){
                setState(() {
                  placePred.clear();
                });
              }
            });
          }
        }
        else {
          if (places != null && this.mounted) {
            setState(() {
              searchPredictions.clear();
            });
          } else if (placesSearch != null && this.mounted) {
            setState(() {
              placePred.clear();
            });
          }
        }
      }
    });
    hitMapby();
  }
  
  void hitMapby(){
    setState(() {
      isLoading = true;
    });
    http.get(mapByApi).then((value){
      print(value.body);
if(value.statusCode ==200){
  MapByApi mapby = MapByApi.fromJson(jsonDecode(value.body));
  if('${mapby.mapstatus}'=='1'){
    print('gmap - ${mapby.key}');
    setState(() {
      places = new GoogleMapsPlaces(apiKey:'${mapby.key}');
    });
  }else if('${mapby.mapstatus}'=='2'){
    print('mmap - ${mapby.key}');
    setState(() {
      placesSearch = PlacesSearch(apiKey: '${mapby.key}', limit: 10,);
    });
  }else{
    print('demomap');
  }
}
      if(!isDispose){
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((e){
      if(!isDispose){
        setState(() {
          isLoading = false;
        });
      }
    });
  }
  
  @override
  void dispose() {
    http.close();
    isDispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: Container(
          width: MediaQuery.of(context).size.width - 100,
          child: Text(
            locale.searchyourlocation,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: kMainTextColor.withOpacity(0.8)),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 52,
            margin: EdgeInsets.only(left: 20,right: 20),
            decoration: BoxDecoration(
                color: kWhiteColor, borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              readOnly: isLoading,
              decoration: InputDecoration(
                hintText: locale.searchyourlocation,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: kHintColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: kHintColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: kHintColor, width: 1),
                ),
              ),
              
              controller: searchController,
              // onEditingComplete: (){
              //   if(searchController.text!=null && searchController.text.length<=0){
              //     print('leg');
              //   }
              // },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              primary: true,
              child: Column(
                children: [
                  Visibility(
                    visible: (searchPredictions != null &&
                        searchPredictions.length > 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      color: kWhiteColor,
                      margin: EdgeInsets.only(top: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      child: ListView.separated(
                        itemCount: searchPredictions.length,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                pPredictions = searchPredictions[index];
                              });
                              Navigator.pop(
                                  context,
                                  BackLatLng(pPredictions.geometry.location.lat,
                                      pPredictions.geometry.location.lng,searchPredictions[index].formattedAddress));
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'images/map_pin.png',
                                  scale: 3,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: Text(
                                    '${searchPredictions[index].formattedAddress}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.caption,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 1,
                            color: kLightTextColor,
                          );
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (placePred != null && placePred.length > 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      color: kWhiteColor,
                      margin: EdgeInsets.only(top: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      child: ListView.separated(
                        itemCount: placePred.length,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                mapboxPredictions = placePred[index];
                              });
                              Navigator.pop(
                                  context,
                                  BackLatLng(
                                      mapboxPredictions.geometry.coordinates[1],
                                      mapboxPredictions.geometry.coordinates[0],placePred[index].placeName));
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'images/map_pin.png',
                                  scale: 3,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: Text(
                                    '${placePred[index].placeName}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.caption,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 1,
                            color: kLightTextColor,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
