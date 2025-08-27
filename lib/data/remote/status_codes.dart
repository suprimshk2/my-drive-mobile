enum HttpStatusCodes {
  BadRequest(400, "Bad Request"),
  Unauthorized(401, "Unauthorized"),
  Forbidden(403, "Forbidden"),
  NotFound(404, "Not Found"),
  InternalServerError(500, "Internal Server Error"),
  Ok(200, "Ok"),
  Created(201, "Created"),
  Accepted(202, "Accepted"),
  NoContent(204, "No Content");

  final int code;
  final String message;

  const HttpStatusCodes(this.code, this.message);
}
