import 'package:ezpark/features/entry/domain/repositories/entry_repository.dart';
import 'package:ezpark/features/spots/enums/spot_form_action.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/response/entities/response_result.dart';
import '../../spots/providers/spots_list_provider.dart';
import '../domain/entities/entry.dart';
import 'entry_repository_provider.dart';

final entryNotifierProvider =
    StateNotifierProvider<SaveSpotFormNotifier, AsyncValue<ResponseResult>>(
  (ref) => SaveSpotFormNotifier(
    ref: ref,
    spotRepository: ref.read(
      entryRepositoryProvider,
    ),
  ),
);

class SaveSpotFormNotifier extends StateNotifier<AsyncValue<ResponseResult>> {
  SaveSpotFormNotifier({
    required EntryRepository spotRepository,
    required StateNotifierProviderRef ref,
  })  : _spotRepository = spotRepository,
        _ref = ref,
        super(
          AsyncValue<ResponseResult>.data(
            ResponseResult.empty(),
          ),
        );

  final EntryRepository _spotRepository;
  final StateNotifierProviderRef _ref;

  void setState(AsyncValue<ResponseResult> newState) => state = newState;

  Future<void> saveEntry({
    required Entry entryToSave,
    required RespositoryAction respositoryAction,
  }) async {
    state = const AsyncValue.loading();

    final result = await _spotRepository.saveEntry(
      entryToSave: entryToSave,
      isNew: respositoryAction == RespositoryAction.add,
    );

    _ref.invalidate(avaliableSpotsListProvider);
    // _ref.invalidate(spotsListProvider);

    state = AsyncValue<ResponseResult<void>>.data(result);

    //  ref.read(entryNotifierProvider.notifier).setState(
    //           AsyncValue.data(
    //             ResponseResult.onSuccess(
    //               data: ref.read(avaliableSpotsListProvider),
    //             ),
    //           ),
    //         );
  }
}