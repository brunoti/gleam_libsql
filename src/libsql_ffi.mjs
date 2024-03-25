import { Ok, Error, List } from "./gleam.mjs";
import { Some, None } from "../gleam_stdlib/gleam/option.mjs";
import { createClient } from "@libsql/client";

export async function do_create_client(config) {
	try {
		return new Ok(createClient({
			tls: config.tls,
			url: config.url,
			authToken: config.auth_token[0],
			authority: config.authority[0],
		}));
	} catch (error) {
		return new Error(error);
	}
}

export async function do_execute(query, args, client) {
	try {
		const result = await client.execute({
			sql: query,
			args: args.toArray(),
		});
		console.log(query)
		return new Ok(
			[
				result.rowsAffected,
				result.lastInsertRowid ? new Some(result.lastInsertRowid) : new None(),
				List.fromArray(result.rows.map(Object.values)),
			]
		);
	} catch (error) {
		return new Error("aaaaaa");
	}
}

export function identity(x) {
	return x;
}

export function _null() {
	return null;
}
