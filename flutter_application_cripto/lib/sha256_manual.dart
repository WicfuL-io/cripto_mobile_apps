// sha256_manual.dart
class SHA256 {
  static const List<int> _k = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
  ];

  static const List<int> _initialHashValues = [
    0x6a09e667,
    0xbb67ae85,
    0x3c6ef372,
    0xa54ff53a,
    0x510e527f,
    0x9b05688c,
    0x1f83d9ab,
    0x5be0cd19,
  ];

  static String hash(String input) {
    final bytes = _toBytes(input);
    final padded = _pad(bytes);
    final hash = _processBlocks(padded);
    return _toHex(hash);
  }

  static List<int> _toBytes(String input) {
    return input.codeUnits;
  }

  static List<int> _pad(List<int> message) {
    int originalLengthBits = message.length * 8;
    message = List.from(message);
    message.add(0x80);
    while ((message.length * 8) % 512 != 448) {
      message.add(0x00);
    }
    for (int i = 7; i >= 0; i--) {
      message.add((originalLengthBits >> (i * 8)) & 0xff);
    }
    return message;
  }

  static List<int> _processBlocks(List<int> padded) {
    List<int> hash = List.from(_initialHashValues);
    for (int i = 0; i < padded.length; i += 64) {
      List<int> w = List.filled(64, 0);
      for (int t = 0; t < 16; t++) {
        int j = i + t * 4;
        w[t] = (padded[j] << 24) |
               (padded[j + 1] << 16) |
               (padded[j + 2] << 8) |
               (padded[j + 3]);
      }

      for (int t = 16; t < 64; t++) {
        int s0 = _rotr(w[t - 15], 7) ^ _rotr(w[t - 15], 18) ^ (w[t - 15] >> 3);
        int s1 = _rotr(w[t - 2], 17) ^ _rotr(w[t - 2], 19) ^ (w[t - 2] >> 10);
        w[t] = _add(_add(_add(w[t - 16], s0), w[t - 7]), s1);
      }

      int a = hash[0];
      int b = hash[1];
      int c = hash[2];
      int d = hash[3];
      int e = hash[4];
      int f = hash[5];
      int g = hash[6];
      int h = hash[7];

      for (int t = 0; t < 64; t++) {
        int s1 = _rotr(e, 6) ^ _rotr(e, 11) ^ _rotr(e, 25);
        int ch = (e & f) ^ ((~e) & g);
        int temp1 = _add(_add(_add(_add(h, s1), ch), _k[t]), w[t]);
        int s0 = _rotr(a, 2) ^ _rotr(a, 13) ^ _rotr(a, 22);
        int maj = (a & b) ^ (a & c) ^ (b & c);
        int temp2 = _add(s0, maj);

        h = g;
        g = f;
        f = e;
        e = _add(d, temp1);
        d = c;
        c = b;
        b = a;
        a = _add(temp1, temp2);
      }

      hash[0] = _add(hash[0], a);
      hash[1] = _add(hash[1], b);
      hash[2] = _add(hash[2], c);
      hash[3] = _add(hash[3], d);
      hash[4] = _add(hash[4], e);
      hash[5] = _add(hash[5], f);
      hash[6] = _add(hash[6], g);
      hash[7] = _add(hash[7], h);
    }
    return hash;
  }

  static int _rotr(int x, int n) => ((x >> n) | (x << (32 - n))) & 0xffffffff;
  static int _add(int x, int y) => (x + y) & 0xffffffff;

  static String _toHex(List<int> hash) {
    return hash.map((e) => e.toRadixString(16).padLeft(8, '0')).join();
  }
}
