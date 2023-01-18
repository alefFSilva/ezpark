import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezpark/core/network/response/entities/response_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/firebase/firestore_methods.dart';
import '../../domain/entities/spot.dart';
import '../../enums/spot_status.dart';
import '../models/spot_model.dart';

final spotDatasourceProvider = Provider<SpotDatasource>(
  (ref) => SpotDatasourceImpl(),
);

abstract class SpotDatasource {
  Future<ResponseResult<SpotModel>> addNew(Spot addSpot);
  Future<ResponseResult<SpotModel>> saveSpot({
    required Spot spot,
  });
  Future<ResponseResult<List<SpotModel>>> getSpots({
    SpotStatus? spotStatus,
  });
  Future<ResponseResult> remove({required int spotNumber});
  Future<ResponseResult> setStatus({
    required int spotNumber,
    required SpotStatus spotStatus,
  });
}

class SpotDatasourceImpl with FireStoreMethods implements SpotDatasource {
  String get _spotsCollectionDescription => 'spots';
  CollectionReference<Map<String, dynamic>> get _spotCollectionRef =>
      getCollectionReference(
        collectionName: _spotsCollectionDescription,
      );

  @override
  Future<ResponseResult<SpotModel>> addNew(Spot addSpot) async {
    final bool documentAlreadyExists = await checkIfDocumentExists(
      collectionRef: _spotCollectionRef,
      fieldDescriptionToFilter: 'number',
      objectToCompare: addSpot.number,
    );

    if (documentAlreadyExists) {
      return ResponseResult.onError(
          errorMessage: 'Este número de vaga já existe');
    }

    final addedSpotMap = await add(
      collectionRef: _spotCollectionRef,
      documentToAdd: <String, dynamic>{
        'number': addSpot.number,
        'type': addSpot.spotType.toJson(),
        'status': addSpot.spotStatus.toJson(),
      },
    );

    return ResponseResult<SpotModel>.onSuccess(
      data: SpotModel.fromJson(data: addedSpotMap),
    );
  }

  @override
  Future<ResponseResult<List<SpotModel>>> getSpots({
    SpotStatus? spotStatus,
  }) async {
    final spotsSnapshot = spotStatus != null
        ? await _spotCollectionRef
            .where(
              'status',
              isEqualTo: spotStatus.toJson(),
            )
            .get()
        : await _spotCollectionRef.get();
    final spotsList = spotsSnapshot.docs.map((e) {
      return SpotModel.fromJson(
        data: e.data(),
      );
    }).toList();

    return ResponseResult<List<SpotModel>>.onSuccess(
      data: spotsList,
    );
  }

  @override
  Future<ResponseResult> remove({
    required int spotNumber,
  }) async {
    bool hasError = false;
    await delete(
      collectionRef: _spotCollectionRef,
      fieldDescriptionToFilter: 'number',
      objectToCompare: spotNumber,
      onError: () => hasError = true,
    );

    return hasError
        ? ResponseResult.onError(errorMessage: 'Erro ao deletar o spot')
        : ResponseResult.onSuccess();
  }

  @override
  Future<ResponseResult<SpotModel>> saveSpot({
    required Spot spot,
  }) async {
    String? docID = await getDocID(
      collectionRef: _spotCollectionRef,
      fieldDescriptionToFilter: 'number',
      objectToCompare: spot.number,
    );

    if (docID == null) {
      return ResponseResult.onError(errorMessage: 'Vaga não encontrada');
    }

    await _spotCollectionRef.doc(docID).update(
      {
        'number': spot.number,
        'type': spot.spotType.toJson(),
        'status': spot.spotStatus.toJson(),
      },
    );

    return ResponseResult.onSuccess();
  }

  @override
  Future<ResponseResult<void>> setStatus({
    required int spotNumber,
    required SpotStatus spotStatus,
  }) async {
    String? docID = await getDocID(
      collectionRef: _spotCollectionRef,
      fieldDescriptionToFilter: 'number',
      objectToCompare: spotNumber,
    );

    if (docID == null) {
      return ResponseResult.onError(errorMessage: 'Vaga não encontrada');
    }

    return await _spotCollectionRef.doc(docID).update(
      {
        'status': spotStatus.toJson(),
      },
    ).then(
      (value) => ResponseResult<void>.onSuccess(),
    );
  }
}
