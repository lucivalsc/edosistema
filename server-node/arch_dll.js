const ffi = require('ffi-napi');

// Defina o caminho para a DLL e sua definição
const dllPath = 'D:/Projetos/Delphi/Freelancer/Lucival/LoginDLL/Win64/Release/LoginDLL.dll';

// Carregue a DLL com ffi.Library
const minhaDLL = ffi.Library(dllPath, {
  Login: ['string', ['string']]
});

// Use a função da DLL
const username = 'hsfa3343';
const resultado = minhaDLL.Login(username);

console.log('Resultado:', resultado);

// const ffi = require('ffi-napi');
// const ref = require('ref');
// const iconv = require('iconv-lite');

// // Defina o caminho para a DLL e sua definição
// const dllPath = 'D:/Projetos/Delphi/Freelancer/Lucival/LoginDLL/Win64/Release/LoginDLL.dll';

// // Carregue a DLL com ffi.Library
// const minhaDLL = ffi.Library(dllPath, {
//   Login: ['void', ['string', ref.refType('char')]]
// });

// // Função para converter de UTF-8 para ShortString
// function utf8ToShortString(utf8String) {
//   const buffer = iconv.encode(utf8String, 'win1252');
//   return buffer.slice(0, 255);
// }

// // Função para converter de ShortString para UTF-8
// function shortStringToUtf8(shortString) {
//   const buffer = Buffer.from(shortString);
//   return iconv.decode(buffer, 'win1252').trim();
// }

// // Use a função da DLL
// const username = 'hsfa3343';
// const utf8Username = iconv.encode(username, 'utf8').toString();
// const resultadoShortString = Buffer.alloc(256); // Aloca um buffer de 256 bytes para armazenar o resultado
// minhaDLL.Login(utf8ToShortString(utf8Username), resultadoShortString);

// const resultadoUtf8 = shortStringToUtf8(resultadoShortString);

// console.log('Resultado:', resultadoUtf8);

