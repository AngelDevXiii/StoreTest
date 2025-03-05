import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/cart/models/cart_item/cart_item_model.dart';
import 'package:store_app/features/cart/repository/cart_repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required this.cartRepository}) : super(CartState.initial()) {
    on<GetCart>(_onLoadCart);
    on<SaveCart>(_onSaveCart);
    on<AddToCart>(_onAddOrUpdateCartProduct);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  final CartRepository cartRepository;

  Future<void> _onLoadCart(GetCart event, Emitter<CartState> emit) async {
    if (event.userId.isEmpty) return;

    try {
      final cart = await cartRepository.getCart(event.userId);

      emit(
        state.copyWith(
          products: cart,
          savedProducts: cart,
          loading: false,
          hasError: false,
          errorMessage: "",
        ),
      );
    } catch (error) {
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

  Future<void> _onSaveCart(SaveCart event, Emitter<CartState> emit) async {
    if (event.userId.isEmpty) return;

    try {
      emit(state.copyWith(loading: true));

      final products = await cartRepository.saveCart(
        event.userId,
        event.products,
      );

      emit(
        state.copyWith(
          loading: false,
          products: products,
          savedProducts: products,
        ),
      );
    } catch (error) {
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

  Future<void> _onAddOrUpdateCartProduct(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final cart = [...state.products];
    final index = cart.indexWhere(
      (product) => product.uid == event.product.uid,
    );

    if (index > -1) {
      if (event.product.quantity < 1) {
        cart.removeAt(index);
      } else {
        cart[index] = event.product;
      }

      emit(state.copyWith(products: cart, loading: false));
      return;
    }

    emit(state.copyWith(products: [...cart, event.product], loading: false));
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final cart = [...state.products];

    cart.removeWhere((element) => element.uid == event.productId);

    emit(
      state.copyWith(
        products: cart,
        loading: false,
        hasError: false,
        errorMessage: "",
      ),
    );
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    state.copyWith(
      products: [],
      loading: false,
      hasError: false,
      errorMessage: "",
    );
  }
}
