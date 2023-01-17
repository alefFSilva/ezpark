import 'package:cloud_firestore/cloud_firestore.dart';

mixin FireStoreMethods {
  CollectionReference<Map<String, dynamic>> getCollectionReference({
    required String collectionName,
  }) =>
      FirebaseFirestore.instance.collection(collectionName);

  Future<bool> checkIfDocumentExists({
    required CollectionReference<Map<String, dynamic>> collectionRef,
    required String fieldDescriptionToFilter,
    required Object objectToCompare,
  }) async {
    final querySnapShot = await collectionRef
        .where(
          fieldDescriptionToFilter,
          isEqualTo: objectToCompare,
        )
        .get();
    return querySnapShot.docs.isNotEmpty;
  }

  Future<String?> getDocID({
    required CollectionReference<Map<String, dynamic>> collectionRef,
    required String fieldDescriptionToFilter,
    required Object objectToCompare,
  }) async {
    final querySnapShot = await collectionRef
        .where(
          fieldDescriptionToFilter,
          isEqualTo: objectToCompare,
        )
        .get();
    final docs = querySnapShot.docs;
    if (docs.isNotEmpty) {
      return docs.first.id;
    }
    return null;
  }

  Future<Map<String, dynamic>> add({
    required CollectionReference<Map<String, dynamic>> collectionRef,
    required Map<String, dynamic> documentToAdd,
  }) async {
    final documentRef = await collectionRef.add(documentToAdd);
    final documentSnapShot = await documentRef.get();
    return documentSnapShot.data() as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> save({
    required CollectionReference<Map<String, dynamic>> collectionRef,
    required Map<String, dynamic> documentToAdd,
  }) async {
    final documentRef = await collectionRef.add(documentToAdd);
    final documentSnapShot = await documentRef.get();
    return documentSnapShot.data() as Map<String, dynamic>;
  }

  Future<void> delete({
    required CollectionReference<Map<String, dynamic>> collectionRef,
    required String fieldDescriptionToFilter,
    required Object objectToCompare,
    Function? onError,
  }) async {
    await collectionRef
        .where(
          fieldDescriptionToFilter,
          isEqualTo: objectToCompare,
        )
        .get()
        .then(
      (querySnapShot) async {
        final String documentID = querySnapShot.docs.first.id;
        await collectionRef.doc(documentID).delete();
      },
    );
  }
}
