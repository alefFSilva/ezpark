import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezpark/core/firebase/firestore_methods.dart';

import '../../../../core/network/response/entities/response_result.dart';
import '../../domain/entities/entry.dart';

abstract class EntryDatasource {
  Future<ResponseResult<void>> saveEntry({
    required Entry entry,
    bool isNew = false,
  });
}

class EntryDatasourceImpl with FireStoreMethods implements EntryDatasource {
  String get _spotsCollectionDescription => 'entries';
  CollectionReference<Map<String, dynamic>> get _entryCollectionRef =>
      getCollectionReference(
        collectionName: _spotsCollectionDescription,
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
          'color': entry.vehicleColor.toJson(),
          'plate': entry.vehiclePlate,
          'entryTime': DateTime.now().toString(),
        },
      );
    }
    return ResponseResult.onSuccess();
  }
}
