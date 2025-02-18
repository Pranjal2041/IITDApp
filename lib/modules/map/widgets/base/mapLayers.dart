import 'package:IITDAPP/modules/dashboard/widgets/errorWidget.dart';
import 'package:IITDAPP/modules/map/data/slidePanelPosition.dart';
import 'package:IITDAPP/modules/map/widgets/customSearchBar.dart';
import 'package:IITDAPP/modules/map/widgets/marker/marker.dart';

import 'package:IITDAPP/ThemeModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

import 'package:IITDAPP/modules/map/data/mapCondition.dart';
import 'package:IITDAPP/modules/map/data/mapOffsets.dart';
import 'package:IITDAPP/modules/map/widgets/layers/mapLayer.dart';
import 'package:IITDAPP/modules/map/widgets/layers/slideUpSheet/slideUpSheet.dart';
import 'package:IITDAPP/modules/map/widgets/layers/toggleGrid/toggleGrid.dart';
import 'package:IITDAPP/modules/map/widgets/animatedButton.dart';

class MapLayers extends StatefulWidget {
  const MapLayers({
    Key key,
  }) : super(key: key);

  @override
  _MapLayersState createState() => _MapLayersState();
}

class _MapLayersState extends State<MapLayers> with TickerProviderStateMixin {
  final NW = LatLng(28.551780, 77.177935);
  final SE = LatLng(28.537345, 77.201837);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  final MapImage = AssetImage('assets/images/map-image.png');
  MapOffset mo;
  MapConditions mc;

  @override
  void initState() {
    mo = Provider.of<MapOffset>(context, listen: false);
    mc = Provider.of<MapConditions>(context, listen: false);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this, value: 0);
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    mo.NW = NW;
    mo.SE = SE;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('built layers');
    return FutureBuilder(
        future: mc.fetchData(),
        builder: (_, AsyncSnapshot<List<Marker>> markers) {
          if (markers.hasError) {
            return Center(
              child: ErrorDisplay(
                  refresh: mc.fetchData, error: markers.error.toString()),
            );
          }
          if (markers.hasData) {
            return Stack(children: [
              Container(
                color:
                    Provider.of<ThemeModel>(context).theme.MAP_BACKGROUND_COLOR,
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: MapLayer(
                  MapImage,
                  NW: NW,
                  SE: SE,
                  markers: markers.data,
                ),
              ),
              Positioned(
                  top: 87,
                  right: 10,
                  child: FilterButton(controller: _controller)),
              Consumer<SlidePanelPosition>(
                builder: (_, spp, child) {
                  print('position changed');
                  return Positioned(
                    bottom: spp.position + 10,
                    right: 10,
                    child: child,
                  );
                },
                child: LocationButton(mc: mc, mo: mo),
              ),
              Positioned(
                  top: 97,
                  right: 80,
                  child: ToggleGrid(scaleAnimation: _scaleAnimation)),
              SlideUpSheet(),
              SearchBar(duration: Duration(milliseconds: 5)),
            ]);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({
    Key key,
    @required AnimationController controller,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    var colors = <Color>[
      Provider.of<ThemeModel>(context).theme.FLOATING_BUTTON_BG,
      Provider.of<ThemeModel>(context).theme.FLOATING_BUTTON_FG,
      Provider.of<ThemeModel>(context).theme.FLOATING_BUTTON_SELECTED_BG,
      Provider.of<ThemeModel>(context).theme.FLOATING_BUTTON_SELECTED_FG
    ];
    return CustomAnimatedButton(
        controller: _controller,
        icon: Icons.layers,
        colors: colors,
        tag: 'Layers',
        onTap: () {
          return true;
        });
  }
}

class LocationButton extends StatelessWidget {
  const LocationButton({
    Key key,
    @required this.mc,
    @required this.mo,
  }) : super(key: key);

  final MapConditions mc;
  final MapOffset mo;

  @override
  Widget build(BuildContext context) {
    var colors = <Color>[
      Provider.of<ThemeModel>(context).theme.FLOATING_BUTTON_BG,
      Provider.of<ThemeModel>(context).theme.FLOATING_BUTTON_FG,
      Provider.of<ThemeModel>(context).theme.FLOATING_BUTTON_SELECTED_BG,
      Provider.of<ThemeModel>(context).theme.FLOATING_BUTTON_SELECTED_FG
    ];
    return CustomAnimatedButton(
        icon: Icons.location_searching,
        tag: 'Locate',
        colors: colors,
        onTap: () {
          if (mc.currentLocationMarker == null) {
            return mc.searchLocation().then(
              (_) {
                Future.delayed(
                  Duration(milliseconds: 100),
                  () {
                    mo.moveTo(mc.currentLocationMarker);
                  },
                );
                return mc.currentLocationCoordinates != LatLng(90, 90);
              },
            );
          } else {
            mc.removeCurrentLocation();
            return true;
          }
        });
  }
}
