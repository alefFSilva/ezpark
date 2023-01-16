import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ezpark/features/spots/new_spot/data/models/spot_model.dart';
import 'package:ezpark/features/spots/new_spot/domain/entities/add_spot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/erros/failure.dart';

final spotDatasourceProvider = Provider<SpotDatasource>((ref) {
  return SpotDatasourceImpl();
});

abstract class SpotDatasource {
  Future<Either<Failure, SpotModel>> add(AddSpot addSpot);
}

class SpotDatasourceImpl implements SpotDatasource {
  @override
  Future<Either<Failure, SpotModel>> add(AddSpot addSpot) async {
    final firestoreInstance = FirebaseFirestore.instance;
    final spotCollectionRef = firestoreInstance.collection('spots');

    final newSpot = <String, dynamic>{
      'number': addSpot.spotNumber,
      'spotType': addSpot.spotType.toJson(),
    };

    final querySnapshot = await spotCollectionRef
        .where('number', isEqualTo: addSpot.spotNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return const Left<Failure, SpotModel>(
        Failure(
          errorMessage: 'Este número de vaga já existe',
        ),
      );
    }

    final addedSpotRef = await spotCollectionRef.add(newSpot);
    final addedSpot = await addedSpotRef.get();
    return Right<Failure, SpotModel>(
      SpotModel.fromJson(
        data: addedSpot.data() as Map<String, dynamic>,
      ),
    );
  }
}
