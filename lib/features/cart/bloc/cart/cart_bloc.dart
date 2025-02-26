import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/config/firestore_service_error.dart';
import 'package:store_app/features/cart/models/cart_item/cart_item_model.dart';
import 'package:store_app/features/cart/repository/cart_repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._cartRepository) : super(CartState.initial()) {
    on<GetCart>(_onLoadCart);
    on<AddToCart>(_onAddOrUpdateCartProduct);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  final CartRepository _cartRepository;

  Future<void> _onLoadCart(GetCart event, Emitter<CartState> emit) {
    return emit.onEach(
      _cartRepository.streamCartProducts(event.userId),
      onData: (cartItems) {
        emit(
          state.copyWith(
            products: cartItems,
            loading: false,
            errorMessage: '',
            hasError: false,
          ),
        );
      },
      onError: addError,
    );
  }

  Future<void> _onAddOrUpdateCartProduct(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true));

      await _cartRepository.addOrUpdateCartProduct(event.userId, event.product);
    } on FirestoreServiceFailure catch (e) {
      emit(
        state.copyWith(
          products: state.products,
          loading: false,
          hasError: true,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          products: state.products,
          loading: false,
          hasError: true,
          errorMessage: "An unknown exception occurred.",
        ),
      );
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true));

      await _cartRepository.deleteProductFromCart(
        event.userId,
        event.productId,
      );
    } on FirestoreServiceFailure catch (e) {
      emit(
        state.copyWith(
          products: state.products,
          loading: false,
          hasError: true,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          products: state.products,
          loading: false,
          hasError: true,
          errorMessage: "An unknown exception occurred.",
        ),
      );
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(loading: true));

      await _cartRepository.clearCart(event.userId);
    } on FirestoreServiceFailure catch (e) {
      emit(
        state.copyWith(
          products: state.products,
          loading: false,
          hasError: true,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          products: state.products,
          loading: false,
          hasError: true,
          errorMessage: "An unknown exception occurred.",
        ),
      );
    }
  }
}
