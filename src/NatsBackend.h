// See the file "COPYING" in the main distribution directory for copyright.

#pragma once

#include <nats/nats.h>
#include <zeek/storage/Backend.h>

namespace zeek::storage::backends::nats {

class NatsBackend : public zeek::storage::Backend {
public:
    NatsBackend() : Backend(true) {}

    static Backend* Instantiate() { return new NatsBackend(); }
    const char* Tag() override { return "NatsStorage"; }
    bool IsOpen() override { return conn != nullptr; }
    void Done() override;
    ErrorResult DoOpen(RecordValPtr config) override;
    ErrorResult DoPut(ValPtr key, ValPtr value, bool overwrite = true, double expiration_time = 0,
                      ErrorResultCallback* cb = nullptr) override;
    ValResult DoGet(ValPtr key, ValResultCallback* cb = nullptr) override;
    ErrorResult DoErase(ValPtr key, ErrorResultCallback* cb = nullptr) override;

    // NATS-specific methods
    ValResult GetHistory(ValPtr key);

private:
    natsConnection* conn = nullptr;
    jsCtx* jetstream = nullptr;
    kvStore* keyVal = nullptr;
    bool strict = false;
};
} // namespace zeek::storage::backends::nats
