dofile("commun.lua")
dofile("p_crypto.lua")

commun.setup("pineapple", "notanapple")

base64_key = encoder.fromBase64("MJ4h1Le2SpWtbr93CuyrwQ==")

test = encoder.toBase64(p_crypto.p_encrypt("Hi, I'm secret!", base64_key))

--dtest = p_crypto.p_decrypt(encoder.toBase64(test), "1234567890abcdef", encoder.toBase64(p_crypto.generate_iv()))

print("Encrypte encode data: " .. test)
print("Encrypte decode data: ".. encoder.fromBase64(test))
print(" ")
print("Encode key: " .. encoder.toBase64(base64_key))
print("Decode key: ".. base64_key)

