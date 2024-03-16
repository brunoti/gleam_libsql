import gleam/option.{type Option, Some, None}
import gleam/javascript/promise.{type Promise}
import gleam/dynamic.{type Dynamic}

pub type Client

pub type Authority {
  Authority(host: String, port: Option(Int), user_info: Option(UserInfo))
}

pub type UserInfo {
  UserInfo(username: String, password: Option(String))
}

pub type Config {
  Config(
    tls: Bool,
    url: String,
    auth_token: Option(String),
		authority: Option(Authority)
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
/// intMode: IntMode,
}

pub fn default_config() -> Config {
	Config(
		tls: True,
		url: ":memory:",
		auth_token: None,
		authority: None
	)
}

pub fn create_client(config: Config) -> Result(Client, Nil) {
	do_create_client(config)
}

pub fn execute(sql: String, with args: List(String), on client: Client) -> Promise(Result(Dynamic, Nil)) {
	do_execute(sql, on: client, with: args)
}

@external(javascript, "./libsql_ffi.mjs", "do_create_client")
fn do_create_client(config: Config) -> Result(Client, Nil)

@external(javascript, "./libsql_ffi.mjs", "do_execute")
fn do_execute(sql: String, with args: List(String), on client: Client) -> Promise(Result(Dynamic, Nil))
