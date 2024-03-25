export function add_promise_rejection_handler() {
	process.on('unhandledrejection', function(event) {
		console.error('Unhandled rejection (promise: ', event.promise, ', reason: ', event.reason, ').');
		throw event.reason
	});
}
