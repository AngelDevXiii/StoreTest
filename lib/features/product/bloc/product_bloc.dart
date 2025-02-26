import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:store_app/config/firestore_service_error.dart';
import 'package:store_app/features/product/models/product/product_model.dart';
import 'package:store_app/features/product/repository/product_repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._productsRepository) : super(const ProductState()) {
    on<GetProducts>(getProducts);
    on<GetProductDetail>(getProduct);
  }

  final ProductRepository _productsRepository;

  Future<void> getProducts(
    GetProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(state.copyWith(productsLoading: true));

      final products = await _productsRepository.getProducts();

      emit(
        state.copyWith(
          products: products,
          productsLoading: false,
          productsHasError: false,
        ),
      );
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
    try {
      emit(state.copyWith(productDetailLoading: true));

      final productDetail = await _productsRepository.getProduct(
        event.productId,
      );

      if (productDetail == null) {
        throw FirestoreServiceFailure("Product doesn't exists");
      }

      emit(
        state.copyWith(
          productDetail: productDetail,
          productDetailLoading: false,
          productDetailHasError: false,
        ),
      );
    } on FirestoreServiceFailure catch (e) {
      emit(
        state.copyWith(
          products: [],
          productDetailLoading: false,
          productDetailHasError: true,
          productDetailErrorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          products: [],
          productDetailLoading: false,
          productDetailHasError: true,
          productDetailErrorMessage: "An unknown exception occurred.",
        ),
      );
    }
  }
}
