import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ezpark/core/network/response/entities/response_result.dart';
import 'package:ezpark/features/spots/new_spot/data/models/spot_model.dart';
import 'package:ezpark/features/spots/new_spot/domain/entities/add_spot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/erros/failure.dart';
import '../../../../../core/firebase/firestore_methods.dart';

final spotDatasourceProvider = Provider<SpotDatasource>((ref) {
  return SpotDatasourceImpl();
});

abstract class SpotDatasource {
  Future<ResponseResult<SpotModel>> addNew(AddSpot addSpot);
}

class SpotDatasourceImpl with FireStoreMethods implements SpotDatasource {
  String get _spotsCollectionDescription => 'spots';

  @override
  Future<ResponseResult<SpotModel>> addNew(AddSpot addSpot) async {
    final spotCollectionRef = getCollectionReference(
      collectionName: _spotsCollectionDescription,
    );

    final bool documentAlreadyExists = await checkIfDocumentExists(
      collectionRef: spotCollectionRef,
      fieldDescriptionToFilter: 'number',
      objectToCompare: addSpot.spotNumber,
    );

    if (documentAlreadyExists) {
      return ResponseResult.onError(
          errorMessage: 'Este número de vaga já existe');
    }

    final addedSpotMap = await add(
      collectionRef: spotCollectionRef,
      documentToAdd: <String, dynamic>{
        'number': addSpot.spotNumber,
        'spotType': addSpot.spotType.toJson(),
      },
    );

    return ResponseResult<SpotModel>.onSuccess(
      data: SpotModel.fromJson(data: addedSpotMap),
    );
  }
}
