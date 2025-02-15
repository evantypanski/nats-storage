# @TEST-DOC: Tests basic successful NATS operations

# @TEST-REQUIRES: have-nats-jetstream
# @TEST-PORT: NATS_PORT

# @TEST-EXEC: cat $FILES/test-server.conf | sed "s|%NATS_PORT%|${NATS_PORT%/tcp}|g" | sed "s|%RUN_PATH%|$(pwd)|g" > ./simple-ops.conf
# @TEST-EXEC: btest-bg-run nats nats-server -c ../simple-ops.conf
# @TEST-EXEC: zeek -b %INPUT > out
# @TEST-EXEC: btest-bg-wait -k 0
# @TEST-EXEC: btest-diff out

@load-plugin Storage::Nats

@load base/frameworks/storage
@load Storage/Nats

type str: string;

event zeek_init()
	{
	local opts: Nats::NatsOptions;
	opts$bucket = "TEST_BUCKET";
	opts$url = "nats://localhost:" + getenv("NATS_PORT");
	opts$create_kv = T;
	local b = Storage::open_backend(Storage::NATS, opts, str, str);

	local put_1 = Storage::put([ $backend=b, $key="one", $value="val1",
	    $async_mode=F, $overwrite=T ]);
	print "put 1:", put_1;
	local get_1 = Storage::get(b, "one", F);
	print "get 1:", get_1;
	local put_2 = Storage::put([ $backend=b, $key="one", $value="val2",
	    $async_mode=F, $overwrite=T ]);
	print "put 2:", put_2;
	local get_2 = Storage::get(b, "one", F);
	print "get 2:", get_2;
	local del_1 = Storage::erase(b, "one", F);
	print "del 1:", del_1;

	Storage::close_backend(b);

	# Now try strict mode!
	local strict_opts: Nats::NatsOptions;
	strict_opts$strict = T;
	strict_opts$bucket = "TEST_BUCKET";
	strict_opts$url = "nats://localhost:" + getenv("NATS_PORT");
	strict_opts$create_kv = T;
	local strict_b = Storage::open_backend(Storage::NATS, opts, str, str);

	local strict_put_1 = Storage::put([ $backend=strict_b, $key="strict_one",
	    $value="strict_val1", $async_mode=F, $overwrite=T ]);
	print "strict_put 1:", strict_put_1;
	local strict_get_1 = Storage::get(strict_b, "strict_one", F);
	print "strict_get 1:", strict_get_1;
	local strict_put_2 = Storage::put([ $backend=strict_b, $key="strict_one",
	    $value="strict_val2", $async_mode=F, $overwrite=T ]);
	print "strict_put 2:", strict_put_2;
	local strict_get_2 = Storage::get(strict_b, "strict_one", F);
	print "strict_get 2:", strict_get_2;
	local strict_del_1 = Storage::erase(strict_b, "strict_one", F);
	print "strict_del 1:", strict_del_1;

	Storage::close_backend(strict_b);
	}
