import sys
import zlib
import hashlib

def unpack(in_path, out_path):
    with open(in_path, "rb") as f:
        data = f.read()
    
    # 检查是否为 7 字节 0x00 前缀 + zlib
    if len(data) > 7 and data[:7] == b"\x00" * 7:
        decomp = zlib.decompress(data[7:])
    elif data[:3] in (b"CWS", b"FWS", b"ZWS"):
        decomp = data
    else:
        raise ValueError(f"Unknown CoreDLL format header: {data[:16].hex()}")
    
    if decomp[:3] not in (b"CWS", b"FWS", b"ZWS"):
        raise ValueError(f"Decompressed payload is not a valid SWF: {decomp[:8].hex()}")
        
    with open(out_path, "wb") as f:
        f.write(decomp)
    print(f"[CoreDLL-Codec] Unpacked {len(data)} -> {len(decomp)} bytes (SWF: {decomp[:3].decode('latin1', 'ignore')})")

def pack(in_path, out_path):
    with open(in_path, "rb") as f:
        plain = f.read()
        
    if plain[:3] not in (b"CWS", b"FWS", b"ZWS"):
        raise ValueError(f"Input is not a valid SWF: {plain[:8].hex()}")
        
    wrapped = b"\x00" * 7 + zlib.compress(plain, level=9)
    
    # 双向安全回环校验
    roundtrip = zlib.decompress(wrapped[7:])
    if hashlib.sha256(roundtrip).digest() != hashlib.sha256(plain).digest():
        raise RuntimeError("CoreDLL roundtrip hash verification failed!")
        
    with open(out_path, "wb") as f:
        f.write(wrapped)
    print(f"[CoreDLL-Codec] Packed {len(plain)} -> {len(wrapped)} bytes (7-null + zlib verified)")

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python coredll_codec.py <unpack|pack> <input_file> <output_file>")
        sys.exit(1)
        
    mode = sys.argv[1].lower()
    src = sys.argv[2]
    dst = sys.argv[3]
    
    if mode == "unpack":
        unpack(src, dst)
    elif mode == "pack":
        pack(src, dst)
    else:
        print(f"Unknown mode: {mode}")
        sys.exit(1)
