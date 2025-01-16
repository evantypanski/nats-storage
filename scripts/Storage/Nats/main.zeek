module Nats;

export {
	## Options record for the NATS Storage backend
	type NatsOptions: record {
		## Path to the database's URL
		url: string &default="nats://localhost:4222";
		## Whether this is "strict" mode or not. Strict mode will force keys to be strings
		## and disallow other characters, which allows keys to more closely resemble what
		## NATS users may expect for subject names.
		strict: bool &default=F;
		## The prefix for the Jetstream
		jetstream_prefix: string &optional;
		## The domain for the Jetstream. Cannot be set if prefix is.
		domain_prefix: string &optional;
		## Amount of time (in milliseconds) to wait for Jetstream API requests
		wait: int &optional;
		## The bucket to use for key-value operations
		bucket: string;
		## The max size of the bucket
		bucket_max_size: count &optional;
		## The max size of a value within the bucket
		value_max_size: count &optional;
		## TODO: Probably necessary to move this in to the framework's expiration
		ttl: count &optional;
	};

    global get_history: function(backend: opaque of Storage::BackendHandle, key: any): any;
}
