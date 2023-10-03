const crypto = require('crypto');

function generateRandomIV() {
  return crypto.randomBytes(16); // Gera um vetor de inicialização de 16 bytes (128 bits)
}

function encryptAES(key, text) {
  const iv = generateRandomIV();
  const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
  let encrypted = cipher.update(text, 'utf-8', 'base64');
  encrypted += cipher.final('base64');

  return { iv: iv.toString('base64'), encryptedText: encrypted };
}

const key = 'chave de criptografia de 32 bytes';
const plaintext = 'texto a ser criptografado';

const { iv, encryptedText } = encryptAES(key, plaintext);
console.log('IV:', iv);
console.log('Texto criptografado:', encryptedText);
