import gleeunit
import gleam/result.{try}
import gleam/io
import gleam/option.{None}
import gleam/dynamic
import gleeunit/should
import gleam/javascript/promise.{type Promise, await, resolve, try_await}
import libsql.{type Client, Config, create_client, default_config, execute, type QueryError, Returned, type
	Returned}

pub fn main() {
  gleeunit.main()
}

@external(javascript, "./libsql_test_ffi.mjs", "add_promise_rejection_handler")
pub fn add_promise_rejection_handler() -> Nil

pub fn connect(do: fn(Client) -> a) -> Promise(Result(a, QueryError)) {
	add_promise_rejection_handler()
  use conn <- await(create_client(default_config()))
	let assert Ok(conn) = conn

  use _ <- try_await(execute(
    "create table users (id integer primary key autoincrement, email text not null, name text not null)",
    with: [],
		expecting: dynamic.dynamic,
    on: conn,
  ))

	let result = do(conn)

  resolve(Ok(result))
}

// pub fn insert_test() {
//   use conn <- connect()
//   use result <- await(execute(
//     "INSERT INTO users (email, name) VALUES (?, ?) RETURNING *",
//     with: [libsql.text("b@b.com"), libsql.text("Bruno")],
//     on: conn,
// 		expecting: dynamic.tuple3(
// 			dynamic.int,
// 			dynamic.string,
// 			dynamic.string,
// 		),
//   ))
// 	let assert Ok(result) = result
//
// 	should.equal(result.rows_affected, 0)
// 	should.equal(result.last_inserted_row_id, None)
// 	should.equal(result.rows, [#(1, "b@b.com", "Bruno")])
//
//   resolve(Ok(Nil))
// }

// pub fn select_test() {
//   use conn <- connect()
//   use _ <- try_await(execute(
//     "INSERT INTO users (email, name) VALUES (?, ?) RETURNING *",
//     with: [libsql.text("b@b.com"), libsql.text("Bruno")],
//     on: conn,
// 		expecting: dynamic.dynamic
//   ))
// 	use result <- try_await(execute(
//     "select * from users",
//     with: [],
//     on: conn,
// 		expecting: dynamic.tuple3(
// 			dynamic.int,
// 			dynamic.string,
// 			dynamic.string,
// 		),
// 	))
//
// 	should.equal(result.rows_affected, 0)
// 	should.equal(result.last_inserted_row_id, None)
// 	should.equal(result.rows, [#(1, "b@b.com", "Bruno")])
//
//   resolve(Ok(Nil))
// }

pub fn invalid_sql_test() {
  use conn <- connect()
	use result <- await(execute(
	"insert into uaasers (email, name) VALUES () RETURNING *",
    with: [],
    on: conn,
		expecting: dynamic.tuple3(
			dynamic.int,
			dynamic.string,
			dynamic.string,
		),
	))

	io.debug(result)
	let assert Ok(result) = result
	io.debug(result)

	// should.equal(result.rows_affected, 0)
	// should.equal(result.last_inserted_row_id, None)
	// should.equal(result.rows, [#(1, "b@b.com", "Bruno")])

  resolve(Ok(Nil))
}
