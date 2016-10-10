p_crypto = require("p_crypto")

print(crypto.encrypt("AES-CBC", "1234567890abcdef", "Hi, I'm secret!", "ivivivivi"))
print(p_crypto.p_encrypt("1234567890abcdef", "Hi, I'm secret!"))