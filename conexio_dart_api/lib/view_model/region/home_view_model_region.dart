import 'package:conexio_dart_api/data/response/api_response.dart';
import 'package:conexio_dart_api/model/region/region_list_model.dart';
import 'package:conexio_dart_api/repository/region/home_repository_region.dart';
import 'package:conexio_dart_api/utils/routes/routes_name.dart';
import 'package:conexio_dart_api/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeViewModelRegion with ChangeNotifier {
  final _myRepo = HomeRepositoryRegion();

  bool _addLoading = false;
  bool get addLoading => _addLoading;

  setAddLoading(bool value) {
    _addLoading = value;
    notifyListeners();
  }

/* metodos get y gets */
  ApiResponse<RegionModelGet> regionList = ApiResponse.loading();

  setRegionList(ApiResponse<RegionModelGet> response) {
    regionList = response;
    notifyListeners();
  }

  Future<void> fechtRegionListApi() async {
    setRegionList(ApiResponse.loading());

    _myRepo.fechtRegionList().then((value) {
      setRegionList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setRegionList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> addRegionApi(dynamic data, BuildContext context) async {
    setAddLoading(true);

    _myRepo.addRegionApi(data).then((value) {
      setAddLoading(false);

      Utils.flushBarErrorMessage('Region Creada', context);

      Navigator.pushNamed(context, RoutesName.region);

      if (kDebugMode) {
        print(value.toString());
      }
    }).onError((error, stackTrace) {
      setAddLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
