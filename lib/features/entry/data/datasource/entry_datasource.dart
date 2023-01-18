import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezpark/core/firebase/firestore_methods.dart';
import 'package:ezpark/features/entry/data/models/entry_model.dart';

import '../../../../core/network/response/entities/response_result.dart';
import '../../domain/entities/entry.dart';

abstract class EntryDatasource {
  Future<ResponseResult<void>> saveEntry({
    required Entry entry,
    bool isNew = false,
  });
  Future<ResponseResult<List<Entry>>> getEntries();
  Future<ResponseResult> remove({
    required String entryID,
  });
}

class EntryDatasourceImpl with FireStoreMethods implements EntryDatasource {
  String get _entriesCollectionDescription => 'entries';
  CollectionReference<Map<String, dynamic>> get _entryCollectionRef =>
      getCollectionReference(
        collectionName: _entriesCollectionDescription,
      );

  @override
  Future<ResponseResult<void>> saveEntry({
    required Entry entry,
    bool isNew = false,
  }) async {
    String? docID;
    if (!isNew) {
      docID = await getDocID(
        collectionRef: _entryCollectionRef,
        fieldDescriptionToFilter: 'id',
        objectToCompare: entry.id,
      );

      if (docID == null) {
        return ResponseResult.onError(errorMessage: 'Vaga não encontrada');
      }

      await _entryCollectionRef.doc(docID).update(
        {
          'vehicleName': entry.vehicleName,
          'type': entry.spot.toJson(),
          'status': entry.vehicleColor.toJson(),
          'vehiclePlate': entry.vehiclePlate
        },
      );
    } else {
      await _entryCollectionRef.add(
        {
          'vehicleName': entry.vehicleName,
          'spot': entry.spot.toJson(),
          'vehicleColor': entry.vehicleColor.toJson(),
          'vehiclePlate': entry.vehiclePlate,
          'entryTime': DateTime.now().toString(),
        },
      );
    }
    return ResponseResult.onSuccess();
  }

  @override
  Future<ResponseResult<List<Entry>>> getEntries() async {
    final entriesSnapshot = await _entryCollectionRef.get();
    final entriessList = entriesSnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
      return EntryModel.fromJson(
        e.id,
        e.data(),
      );
    }).toList();

    return ResponseResult<List<Entry>>.onSuccess(
      data: entriessList,
    );
  }

  @override
  Future<ResponseResult> remove({
    required String entryID,
  }) async {
    bool hasError = false;
    await deleteById(
      collectionRef: _entryCollectionRef,
      id: entryID,
      onError: () => hasError = true,
    );

    return hasError
        ? ResponseResult.onError(errorMessage: 'Erro ao deletar o entry')
        : ResponseResult.onSuccess();
  }
}
