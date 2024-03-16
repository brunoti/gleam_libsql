import { Ok, Error } from "./gleam.mjs";
import { createClient } from "@libsql/client";

export function do_create_client(config) {
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
		return new Ok(result);
	} catch (error) {
		console.error(error)
		return new Error(error);
	}
}
