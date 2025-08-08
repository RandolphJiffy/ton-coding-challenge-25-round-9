tolk 1.0

struct Storage {
    ctx_id: uint32
    ctx_counter: uint32
}

fun Storage.load() {
    return Storage.fromCell(contract.getData())
}

fun Storage.save(self) {
    contract.setData(self.toCell())
}

struct (0x7e8764ef) IncreaseCounter {
    queryId: uint64
    increaseBy: uint32
}


type AllowedMessage = IncreaseCounter

fun onInternalMessage(in: InMessage) {
    val msg = lazy AllowedMessage.fromSlice(in.body);

    match (msg) {
        IncreaseCounter => {
            var storage = lazy Storage.load();

            storage.ctx_counter += msg.increaseBy;
            storage.save();
        }
        else => {
            assert (in.body.isEmpty()) throw 0xFFFF
        }
    }
}

fun onBouncedMessage(in: InMessageBounced) {
}

get fun currentCounter(): int {
    val storage = lazy Storage.load();
    return storage.ctx_counter;
}

get fun initialId(): int {
    val storage = lazy Storage.load();
    return storage.ctx_id;
}
