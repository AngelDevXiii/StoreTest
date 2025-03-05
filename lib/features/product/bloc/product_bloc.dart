import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:store_app/config/models/firestore_service_error.dart';
import 'package:store_app/features/product/models/product/product_model.dart';
import 'package:store_app/features/product/repository/product_repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required this.productsRepository})
    : super(const ProductState()) {
    on<GetProducts>(getProducts);
    on<GetProductDetail>(getProduct);
  }

  final ProductRepository productsRepository;

  Future<void> getProducts(
    GetProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(state.copyWith(productsLoading: true));

      final products = await productsRepository.getProducts();

      final newState = state.copyWith(
        products: products,
        productsLoading: false,
        productsHasError: false,
      );
      emit(newState);
    } on FirestoreServiceFailure catch (e) {
      emit(
        state.copyWith(
          products: [],
          productsLoading: false,
          productsHasError: true,
          productsErrorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          products: [],
          productsLoading: false,
          productsHasError: true,
          productsErrorMessage: "An unknown exception occurred.",
        ),
      );
    }
  }

  Future<void> getProduct(
    GetProductDetail event,
    Emitter<ProductState> emit,
  ) async {
    if (event.productId.isEmpty) return;
    final product = state.products.firstWhereOrNull(
      (pProduct) => pProduct.uid == event.productId,
    );
    emit(
      state.copyWith(
        productDetail: product,
        productDetailLoading: false,
        productDetailHasError: false,
      ),
    );
  }
}
