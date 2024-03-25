import gleam/option.{type Option, None, Some}
import gleam/list
import gleam/io
import gleam/result
import gleam/javascript/promise.{type Promise}
import gleam/dynamic.{type DecodeErrors, type Decoder, type Dynamic}

pub type Client

pub type Value

pub type Authority {
  Authority(host: String, port: Option(Int), user_info: Option(UserInfo))
}

pub type UserInfo {
  UserInfo(username: String, password: Option(String))
}

pub type QueryError {
  /// The rows returned by the database could not be decoded using the supplied
  /// dynamic decoder.
  UnexpectedResultType(DecodeErrors)
}

pub type Returned(t) {
  Returned(
    // columns: List(String),
    // column_types: List(String),
    rows: List(t),
    rows_affected: Int,
    last_inserted_row_id: Option(Dynamic),
  )
}

pub type Config {
  Config(
    tls: Bool,
    url: String,
    auth_token: Option(String),
    authority: Option(Authority),
  )
  // scheme: ExpandedScheme;
  //  tls: boolean;
  //  authority: Authority | undefined;
  //  path: string;
  //  authToken: string | undefined;
  //  encryptionKey: string | undefined;
  //  syncUrl: string | undefined;
  //  syncInterval: number | undefined;
  //  intMode: IntMode;
  //  fetch: Function | undefined;
  // scheme: Nil,
  // authority:
}

/// intMode: IntMode,
pub fn default_config() -> Config {
  Config(tls: True, url: ":memory:", auth_token: None, authority: None)
}

pub fn create_client(config: Config) -> Promise(Result(Client, QueryError)) {
  do_create_client(config)
}

pub fn execute(
  sql: String,
  with args: List(Value),
  on client: Client,
  expecting decoder: Decoder(t),
) -> Promise(Result(Returned(t), QueryError)) {
  use #(rows_affected, last_inserted_row_id, rows) <- promise.try_await(
    do_execute(sql, args, client),
  )
  list.try_map(with: decoder, over: rows)
  |> result.map_error(UnexpectedResultType)
  |> result.map(fn(rows) {
		Returned(rows, rows_affected, last_inserted_row_id)
	})
  |> promise.resolve
}

@external(javascript, "./libsql_ffi.mjs", "do_create_client")
fn do_create_client(config: Config) -> Promise(Result(Client, QueryError))

@external(javascript, "./libsql_ffi.mjs", "do_execute")
fn do_execute(
  sql: String,
  with args: List(Value),
  on client: Client,
) -> Promise(Result(#(Int, Option(Dynamic), List(Dynamic)), QueryError))

@external(javascript, "./libsql_ffi.mjs", "identity")
pub fn int(value: Int) -> Value

@external(javascript, "./libsql_ffi.mjs", "identity")
pub fn bool(value: Bool) -> Value

@external(javascript, "./libsql_ffi.mjs", "identity")
pub fn text(value: String) -> Value

@external(javascript, "./libsql_ffi.mjs", "identity")
pub fn float(value: Float) -> Value

@external(javascript, "./libsql_ffi.mjs", "_null")
pub fn null() -> Value
