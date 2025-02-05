# @TEST-DOC: Tests basic successful NATS operations

# @TEST-REQUIRES: have-nats-jetstream
# @TEST-PORT: NATS_PORT

# @TEST-EXEC: cat $FILES/test-server.conf | sed "s|%NATS_PORT%|${NATS_PORT%/tcp}|g" | sed "s|%RUN_PATH%|$(pwd)|g" > ./simple-ops-fail.conf
# @TEST-EXEC: btest-bg-run nats nats-server -config ../simple-ops-fail.conf
# @TEST-EXEC-FAIL: zeek -b %INPUT > out 2>&1
# @TEST-EXEC: btest-bg-wait -k 0
# @TEST-EXEC: TEST_DIFF_CANONIFIER=$SCRIPTS/diff-remove-abspath btest-diff out

@load-plugin Storage::Nats

@load base/frameworks/storage
@load Storage/Nats

type str: string;
type port_: port;

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
	# Put with no overwrite should fail
	local put_2 = Storage::put([ $backend=b, $key="one", $value="val2",
	    $async_mode=F, $overwrite=F ]);
	print "put 2:", put_2;
	local del_1 = Storage::erase(b, "one", F);
	print "del 1:", del_1;
	# Get after deletion should fail
	local get_1 = Storage::get(b, "one", F);
	print "get 1:", get_1;

	Storage::close_backend(b);

	local strict_opts: Nats::NatsOptions;
	strict_opts$strict = T;
	strict_opts$bucket = "TEST_BUCKET";
	strict_opts$url = "nats://localhost:" + getenv("NATS_PORT");
	strict_opts$create_kv = T;
	# Strict cannot have a non-string key
	local strict_b = Storage::open_backend(Storage::NATS, opts, port_, str);
	}
