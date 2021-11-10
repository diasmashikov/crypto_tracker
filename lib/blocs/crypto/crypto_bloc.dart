import 'package:bloc/bloc.dart';
import 'package:crypto_tracker/models/coin_model.dart';
import 'package:crypto_tracker/models/failure_model.dart';
import 'package:crypto_tracker/repositories/crypto_repository.dart';
import 'package:equatable/equatable.dart';

part 'crypto_event.dart';
part 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository _cryptoRepository;

  CryptoBloc({required CryptoRepository cryptoRepository})
      : _cryptoRepository = cryptoRepository,
        super(CryptoState.initial()) {
    on<AppStarted>(_mapAppStartedToState);
    on<RefreshCoins>(_mapRefreshCoinsToState);
    on<LoadMoreCoins>(_mapLoadMoreCoinsToState);
  }

  // Stream<CryptoState> mapEventToState(
  //   CryptoEvent event,
  // ) async* {
  //   if (event is AppStarted) {
  //     yield* _mapAppStartedToState();
  //   } else if (event is RefreshCoins) {
  //   } else if (event is LoadMoreCoins) {}
  // }

  void _mapRefreshCoinsToState(
      RefreshCoins event, Emitter<CryptoState> emit) async {
    await _getCoins(emit: emit);
  }

  void _mapLoadMoreCoinsToState(
      LoadMoreCoins event, Emitter<CryptoState> emit) async {
    final nextPage = state.coins.length ~/ CryptoRepository.perPage;
    await _getCoins(emit: emit, page: nextPage);
  }

  void _mapAppStartedToState(
      AppStarted event, Emitter<CryptoState> emit) async {
    emit(state.copyWith(status: CryptoStatus.loading));
    await _getCoins(emit: emit);
    emit.isDone;
  }

  Future<void> _getCoins(
      {required Emitter<CryptoState> emit, int page = 0}) async {
    try {
      final coins = [
        if (page != 0) ...state.coins,
        ...await _cryptoRepository.getTopCoins(page: page)
      ];

      emit(state.copyWith(coins: coins, status: CryptoStatus.loaded));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: CryptoStatus.error));
    }
  }
}
