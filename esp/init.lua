dofile("p_crypto.lua")

test= p_crypto.p_encrypt("Hi, I'm secret!", "1234567890abcdef")

dtest = p_crypto.p_decrypt(encoder.toBase64(test), "1234567890abcdef", encoder.toBase64(p_crypto.generate_iv()))

print(dtest)