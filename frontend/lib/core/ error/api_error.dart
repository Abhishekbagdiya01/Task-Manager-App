enum ApiError { 
    networkError, 
    serverError, 
    unauthorized, 
    notFound, 
    badRequest, 
    internalServerError, 
    timeout,
    // Add more specific errors as needed (e.g., validationError, databaseError)
}

ApiError mapStatusCodeToApiError(int statusCode) {
  switch (statusCode) {
    case 401: 
      return ApiError.unauthorized;
    case 404: 
      return ApiError.notFound;
    case 500: 
      return ApiError.internalServerError;
    default: 
      return ApiError.serverError;
  }
}