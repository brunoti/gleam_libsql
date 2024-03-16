import gleeunit
import gleam/result.{try}
import gleam/io
import gleeunit/should
import gleam/javascript/promise.{await, resolve}
import gleam/dynamic as d
import libsql.{create_client, execute, default_config, Config}

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
	use conn <- await(resolve(create_client(default_config())))
	let assert Ok(conn) = conn
	use result <- await(execute("SELECT 'hello world'", with: [], on: conn))
	io.debug(result)
	// let assert Ok(a) = result
	// let assert Ok(a) = d.string(a)
	// should.equal("hello world", a)
	resolve(Nil)
}
