local M = {}

--Decrypts using a base64 encoded body and iv(nounce)
local function p_decrypt(body, key, iv)
    return crypto.decrypt("AES-CBC", key, encoder.fromBase64(body), encoder.fromBase64(iv))
end

--Encrypts using a generated iv
local function p_encrypt(body, key)
    return crypto.encrypt("AES-CBC", key, body, generate_iv())
end

--Generate iv for encryption
function generate_iv()
    return "ivivivivivivivi"
end

--Assign functions to M for external usage
M.p_encrypt = p_encrypt
M.p_decrypt = p_decrypt

return M
