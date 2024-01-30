class ApiPaths {
  static const String serverLink = 'http://klnakhadm.online:8000';

  static const String buyerSignUp = '$serverLink/api/v1/auth/user/signup';
  static const String buyerLogIn = '$serverLink/api/v1/auth/user/login';
  static const String buyerLogInByPhone =
      '$serverLink/api/v1/auth/user/loginByPhone';

  static const String sellerSignUp = '$serverLink/api/v1/auth/seller/signup';
  static const String sellerLogIn = '$serverLink/api/v1/auth/seller/login';
  static const String sellerLogInByPhone =
      '$serverLink/api/v1/auth/seller/loginByPhone';

  static const String sendBuyerOTP = '$serverLink/api/v1/auth/user/getOTP';
  static const String sendSellerOTP = '$serverLink/api/v1/auth/seller/getOTP';
  static const String requestNewSellerOTP =
      '$serverLink/api/v1/auth/seller/sendOTP/';
  static const String requestNewBuyerOTP =
      '$serverLink/api/v1/auth/user/sendOTP/';

  static const String getCategories = '$serverLink/api/v1/categories?page=';
  static const String getAllCategories = '$serverLink/api/v1/categories/all/name';

  static const String getAllSubCategories = '$serverLink/api/v2/subCategory/all/name/';
  static const String getSubCategoryInCategory =
      '$serverLink/api/v2/subCategory/category/';

  static const String getProducts = '$serverLink/api/v1/products?page=';
  static const String getProductDetails = '$serverLink/api/v1/products/';
  static const String getProductsFast = '$serverLink/api/v1/products/speed/speed/speed?page=';
  static const String addProducts = '$serverLink/api/v1/products';
  static const String editProduct = '$serverLink/api/v1/products/';
  static const String getProductBySubCategory =
      '$serverLink/api/v1/products/subCategory/';
  static const String getProductBySubCategoryFast =
      '$serverLink/api/v1/products/subCategory/speed/';
  static const String getProductBySeller =
      '$serverLink/api/v1/products/seller/';
  static const String getProductBySellerFast =
      '$serverLink/api/v1/products/seller/speed/';

  static const String getComment = '$serverLink/api/v1/products/comment/';
  static const String addComment = '$serverLink/api/v1/products/comment';

  static const String getAuction = '$serverLink/api/v1/auction/?page=';
  static const String addAuction = '$serverLink/api/v1/auction';
  static const String getAuctionBySeller =
      '$serverLink/api/v1/auction/seller/';

  static const String getSellers = '$serverLink/api/v1/sellers?page=';

  static const String deleteSellerAccount = '$serverLink/api/v1/sellers/';

  static const String deleteBuyerAccount = '$serverLink/api/v1/users/';

  static const String createMarket = '$serverLink/api/v1/markets';
  static const String getMarketData = '$serverLink/api/v1/markets/';
  static const String editMarketData = '$serverLink/api/v1/markets/';

  static const String shoppingCart = '$serverLink/api/v1/cart';
  static const String getShoppingCartNumber = '$serverLink/api/v1/cart/number/';
  static const String getShoppingCartForBuyer = '$serverLink/api/v1/cart/';
  static const String deleteProductFromShoppingCart =
      '$serverLink/api/v1/cart/';

  static const String plusAndMinusProductQuantityInShoppingCart =
      '$serverLink/api/v1/cart/changeQuabtity';

  static const String addFavoriteProduct = '$serverLink/api/v1/favourite';
  static const String getFavoriteProducts = '$serverLink/api/v1/favourite/';
  static const String deleteFavoriteProducts = '$serverLink/api/v1/favourite/';

  static const String addAddress = '$serverLink/api/v1/address';
  static const String getAddress = '$serverLink/api/v1/address/';
  static const String editAddress = '$serverLink/api/v1/address/';

  static const String payOrder = '$serverLink/api/v1/order';
  static const String getOrders = '$serverLink/api/v1/order/user/';
  static const String getProductOfOrder = '$serverLink/api/v1/order/details/';

  static const String getSellerHomeNumbers = '$serverLink/api/v1/order/numbers/';

  static const String getSellerDeliveredSellerOrders = '$serverLink/api/v1/order/dilveredSeller/';

  static const String getSellerDeliveredUserOrders = '$serverLink/api/v1/order/dilveredUser/';

  static const String getSellerDoneOrders = '$serverLink/api/v1/order/done/';

  static const String getSellerReturnProductOrders = '$serverLink/api/v1/returnOrder/seller/';

  static const String getBuyerReturnProductOrders = '$serverLink/api/v1/returnOrder/user/';

  static const String addReturnOrder = '$serverLink/api/v1/returnOrder/';

  static const String getProductsOfReturnProductOrders = '$serverLink/api/v1/returnOrder/details/';

  static const String getProductsOfOrders = '$serverLink/api/v1/order/details/';

  static const String changeOrderState = '$serverLink/api/v1/order/change';

  static const String getBanks = '$serverLink/api/v1/banks';

  static const String getBuyerWalletAmount = '$serverLink/api/v1/credit/user/';
  static const String addBuyerWalletAmount = '$serverLink/api/v1/credit/user/';

  static const String getSellerWalletAmount = '$serverLink/api/v1/credit/seller/';
  static const String addSellerWalletAmount = '$serverLink/api/v1/credit/seller/';
  static const String pullSellerWalletAmount = '$serverLink/api/v1/payment/pull';

  static const String getSellerWallet = '$serverLink/api/v1/mony/';
  static const String getBuyerWallet = '$serverLink/api/v1/mony/user/';

  static const String addMoneyTransformationInBuyerWallet =
      '$serverLink/api/v1/credit/user/';
  static const String addMoneyTransformationInSellerWallet =
      '$serverLink/api/v1/credit/seller/';

  static const String sendProblemToTechnicalSupport =
      '$serverLink/api/v1/support';

  static const String payment =
      '$serverLink/api/v1/payment/';

  static const String getOtpToResetPasswordForBuyer = '$serverLink/api/v1/auth/user/forgotPassword';
  static const String verifyResetCodeForBuyer = '$serverLink/api/v1/auth/user/verifyResetCode';
  static const String resetPasswordForBuyer = '$serverLink/api/v1/auth/user/resetPassword';

  static const String getOtpToResetPasswordForSeller = '$serverLink/api/v1/auth/user/forgotPassword';
  static const String verifyResetCodeForSeller = '$serverLink/api/v1/auth/user/verifyResetCode';
  static const String resetPasswordForSeller = '$serverLink/api/v1/auth/user/resetPassword';

  static const String getSellerBills = '$serverLink/api/v1/order/bill/seller/';
  static const String getBuyerBills = '$serverLink/api/v1/order/bill/user/';

  static const String getBuyerTerms = '$serverLink/api/v1/controller/terms/user';
  static const String getSellerTerms = '$serverLink/api/v1/controller/terms/seller';

  static const String getBuyerPolicy = '$serverLink/api/v1/controller/privacy/user';
  static const String getSellerPolicy = '$serverLink/api/v1/controller/privacy/seller';

  static const String getVatAndZekaAndAmolaValues = '$serverLink/api/v1/controller/Vat/vat';

  static const String productSearch = '$serverLink/api/v1/products/search?page=';
  static const String sellerSearch = '$serverLink/api/v1/sellers/search?page=';
  static const String categorySearch = '$serverLink/api/v1/categories/search?page=';
}
