import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class Googleplacesautocomplete
    extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  Function(Prediction prediction) onPlaceSelected;

  Googleplacesautocomplete(this.controller,
      this.hintText, this.onPlaceSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding:
          EdgeInsets.symmetric(horizontal: 29),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        boxDecoration:
            BoxDecoration(color: Colors.white),
        inputDecoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.black),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["cl"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: onPlaceSelected,

        itemClick: (Prediction prediction) {
          controller.text =
              prediction.description ?? "";
          controller.selection =
              TextSelection.fromPosition(
                  TextPosition(
                      offset: prediction
                              .description
                              ?.length ??
                          0));
        },
        seperatedBuilder: Divider(),
        containerHorizontalPadding: 10,
        googleAPIKey:
            "AIzaSyAgC56SaQ2zm8B2g-xc6lo62r5kk7Zrbh4",
        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index,
            Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                    child: Text(
                        "${prediction.description ?? ""}"))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }
}
