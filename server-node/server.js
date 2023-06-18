/*
    iniciar servidor: node server.js
*/

// const ffi = require('ffi');
const { attach, ISOLATION_READ_COMMITED } = require('node-firebird');
const { readFileSync } = require('fs');
const { parse } = require('ini');
const path = require('path');
const express = require('express');
const { Console } = require('console');
const moment = require('moment'); //Lida com campos datas

// Caminho relativo da DLL
const dllPath = path.join(__dirname, 'functions.dll');

// Carregar a DLL
// const ReadDll = ffi.Library(dllPath, {
//   Encriptar: ['retorno', ['String']]
//   // Outras funções da DLL, se houver
// });

// const resultado = ReadDll.Encriptar('');

// Substitua pelo caminho correto do arquivo config.ini
// const configPath = 'D:/Projetos/Flutter/Freelancer/RicardoJurado/edosistema/server-node/arquivo.ini'; 
const configPath = path.join(__dirname, 'arquivo.ini');

const configData = readFileSync(configPath, 'utf-8');
const config = parse(configData).firebird;
console.log(configPath);
const options = {
  host: config.host,
  port: config.port,
  database: config.database,
  user: config.user,
  password: config.password,
  lowercase_keys: false // opcional, define se as chaves do resultado serão em minúsculas (padrão: false)
};

const app = express();
app.use(express.json({ limit: '500mb' })); // Define o limite do payload para 5mb (ajuste conforme necessário)

const port = 3000;
const ip = '192.168.1.4';
app.listen(port, ip, () => {
  console.log(`Servidor rodando em http://${ip}:${port}`);
});

//LOGIN
app.get('/login', async (req, res) => {
  try {
    attach(options, async (err, db) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
      }

      const usuario = req.headers['usuario'];

      if (!usuario) {
        return res.status(400).json({ error: 'Usuário é obrigatório' });
      }

      const query = `
          SELECT U.UCIDUSER, U.UCUSERNAME, U.UCEMAIL, U.UCLOGIN, U.UCPASSWORD, U.COD_LOJA
          FROM UCTABUSERS U 
          WHERE U.UCTYPEREC = 'U' AND UPPER(U.UCLOGIN) = ?
        `;

      db.query(query, [usuario], (err, result) => {
        db.detach(); // Encerrar a conexão com o banco de dados

        if (err) {
          console.error(err);
          return res.status(500).json({ error: 'Erro ao executar consulta SQL' });
        }

        if (Array.isArray(result)) {
          res.json(result);
        } else {
          res.json([result]);
        }
      });

    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao processar a solicitação' });
  }
});

//PRODUTOS
app.get('/produtos', async (req, res) => {
  try {
    attach(options, async (err, db) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
      }

      const pesquisar = req.headers['pesquisar'];

      if (!pesquisar) {
        return res.status(400).json({ error: 'Descrição do produto é obrigatório' });
      }

      const query = `
                    SELECT 
                          S.*, 
                          C.DATEUSER FROM SUPERCONS S 
                    LEFT JOIN CAPTBPRD C ON C.COD_PROD = S.COD_PROD       
                    WHERE MASTER LIKE '%' || ? || '%'
      `;

      db.query(query, [pesquisar], (err, result) => {
        db.detach(); // Encerrar a conexão com o banco de dados

        if (err) {
          console.error(err);
          return res.status(500).json({ error: 'Erro ao executar consulta SQL' });
        }

        if (Array.isArray(result)) {
          res.json(result);
        } else {
          res.json([result]);
        }
      });

    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao processar a solicitação' });
  }
});


//CONFERENCIA DE PEDIDOS
app.get('/conferenciaPedido', async (req, res) => {
  try {
    attach(options, async (err, db) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
      }

      const num_pedi = req.headers['num_pedi'];
      const cod_loja = req.headers['cod_loja'];

      let filtro = '';

      if (parseInt(num_pedi) > 0) {
        filtro = ' and hpd.num_pedi = ? and hpd.cod_loja = ? ';
      } else {
        filtro = ' and hpd.num_pedi = ? ';
      }

      const query = `
        select 
          hpd.dat_pedi, 
          hpd.cod_ven, 
          hpd.cod_cli, 
          hpd.vlr_tota, 
          hpd.num_pedi, 
          hpd.localvenda, 
          cli.nom_cli, 
          ca.cod_prod, 
          ca.qtd_prod, 
          su.des_prod 
        from captbhpd hpd 
        left join captbcli cli on cli.cod_cli = hpd.cod_cli 
        left join captbipd ca on ca.num_pedi = hpd.num_pedi 
        left join supercons su on su.cod_prod = ca.cod_prod 
        where hpd.cod_cli = cli.cod_cli 
          and flg_caixa in ('S', 'B') and flg_conf = 'A' 
          ${filtro}
        order by num_pedi desc
      `;

      const params = [];

      if (num_pedi > 0) {
        params.push(num_pedi);
        params.push(cod_loja); // Substitua pelo valor correto para "cod_loja"
      } else {
        params.push(num_pedi);
      }

      db.query(query, params, (err, result) => {
        db.detach(); // Encerrar a conexão com o banco de dados

        if (err) {
          console.error(err);
          return res.status(500).json({ error: 'Erro ao executar consulta SQL' });
        }

        if (Array.isArray(result)) {
          res.json(result);
        } else {
          res.json([result]);
        }
      });

    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao processar a solicitação' });
  }
});


// PRODUTOS CONTAGEM
app.get('/produtosContagem', async (req, res) => {
  try {
    const pesquisar = req.headers['pesquisar'];

    if (!pesquisar) {
      return res.status(400).json({ error: 'Descrição do produto é obrigatório' });
    }

    attach(options, async (err, db) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
      }

      const query = `
                  SELECT 
                    S.*, 
                    C.DATEUSER 
                  FROM SUPERCONS S
                  LEFT JOIN CAPTBPRD C ON C.COD_PROD = S.COD_PROD
                  WHERE S.COD_BARR = ? OR S.COD_PROD = ?
                `;

      db.query(query, [pesquisar, pesquisar], (err, result) => {
        db.detach(); // Encerrar a conexão com o banco de dados

        if (err) {
          console.error(err);
          return res.status(500).json({ error: 'Erro ao executar consulta SQL' });
        }

        res.json(result);
      });
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao processar a solicitação' });
  }
});



// SEPARAR
app.get('/separar', async (req, res) => {
  try {
    const num_pedi = parseInt(req.headers['num_pedi']);
    const uclogin = req.headers['uclogin'];
    const data_conf = new Date();
    console.log(uclogin);
    attach(options, async (err, db) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
      }
      // :uclogin, 
      // :data_conf 
      // :num_pedi 
      const query = `
                    update captbhpd set 
                    flg_conf = 'S', user_separ = ?, data_separ = ?     
                    WHERE num_pedi = ? 
                `;



      db.query(query, [uclogin, data_conf, num_pedi], (err, result) => {
        db.detach(); // Encerrar a conexão com o banco de dados

        if (err) {
          console.error(err);
          return res.status(500).json({ error: 'Erro ao executar consulta SQL' });
        }

        res.json(result);
      });
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao processar a solicitação' });
  }
});

// Conferência - SEPARAR
app.post('/conferencia', async (req, res) => {
  const itens = req.body;
  if (!itens || !Array.isArray(itens)) {
    return res.status(400).json({ error: 'Formato de dados inválido. Espera-se uma lista de objetos JSON.' });
  }

  try {
    const db = await new Promise((resolve, reject) => {
      attach(options, (err, db) => {
        if (err) {
          console.error(err);
          reject(err);
        } else {
          resolve(db);
        }
      });
    });

    const insertQuery = `update captbhpd set flg_conf = 'C', user_conf = ?, data_conf = ? `;

    const transaction = await new Promise((resolve, reject) => {
      db.transaction(ISOLATION_READ_COMMITED, (err, transaction) => {
        if (err) {
          console.error(err);
          reject(err);
        } else {
          resolve(transaction);
        }
      });
    });

    for (const item of itens) {
      const params = [
        item.uclogin, // Valor da propriedade uclogin do objeto JSON
        new Date() // Data atual do sistema
      ];

      try {
        await new Promise((resolve, reject) => {
          transaction.query(insertQuery, params, (err, result) => {
            if (err) {
              console.error(err);
              transaction.rollback(() => {
                reject(err);
              });
            } else {
              resolve(result);
            }
          });
        });
      } catch (err) {
        throw err;
      }
    }

    await new Promise((resolve, reject) => {
      transaction.commit(err => {
        if (err) {
          console.error(err);
          reject(err);
        } else {
          resolve();
        }
      });
    });

    res.json({ message: 'Itens inseridos com sucesso' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao executar a inserção dos itens' });
  }
});

//INVENTARIO
app.post('/inventario', async (req, res) => {
  const itens = req.body;
  if (!itens || !Array.isArray(itens)) {
    return res.status(400).json({ error: 'Formato de dados inválido. Espera-se uma lista de objetos JSON.' });
  }

  try {
    const db = await new Promise((resolve, reject) => {
      attach(options, (err, db) => {
        if (err) {
          console.error(err);
          reject(err);
        } else {
          resolve(db);
        }
      });
    });

    const insertQuery = `
        INSERT INTO SIGTBPRDHIST(NUM_LANC, DATA, COD_PROD, QTDE_ANT, QTDE_NOVA, TIPO, UCLOGIN, VLR_CUSTO, VLR_VENDA, COD_LOJA)
        VALUES(GEN_ID(GEN_NUM_PRDHIST, 1), ?, ?, ?, ?, ?, ?, ?, ?, ?)
     `;

     const updateCAPTBPRD  = ` UPDATE CAPTBPRD SET COD_BARR = ?, DATEUSER = ?, UCLOGIN = ? WHERE COD_PROD = ? `;
     const updateCAPTBEST  = `UPDATE CAPTBEST SET LOC_ESTO = ?, QTD_ATUAL = ? WHERE COD_PROD = ? `;

    const transaction = await new Promise((resolve, reject) => {
      db.transaction(ISOLATION_READ_COMMITED, (err, transaction) => {
        if (err) {
          console.error(err);
          reject(err);
        } else {
          resolve(transaction);
        }
      });
    });
    console.log(itens.length);
    for (const item of itens) {      
      const formattedDate = moment(item.DATA, 'DD/MM/YYYY HH:mm:ss').format('YYYY-MM-DD HH:mm:ss');
      const params = [
        formattedDate,
        item.COD_PROD,
        item.QTDE_ANT,
        item.QTDE_NOVA,
        item.TIPO,
        item.UCLOGIN,
        item.VLR_CUSTO,
        item.VLR_VENDA,
        item.COD_LOJA,
      ];
      
      const dateUser = new Date();
      const paramsCAPTBPRD = [
        item.COD_BARR,
        dateUser,
        item.UCLOGIN,
        item.COD_PROD,
      ];
      
      const paramsCAPTBEST = [
        item.LOC_ESTO,
        parseInt(item.QTDE_NOVA),
        item.COD_PROD,
      ];



      try {
        await new Promise((resolve, reject) => {
          transaction.query(insertQuery, params, (err, result) => {
            if (err) {
              console.error(err);
              transaction.rollback(() => {
                reject(err);
              });
            } else {
              resolve(result);
            }
          });

          transaction.query(updateCAPTBPRD, paramsCAPTBPRD, (err, result) => {
            if (err) {
              console.error(err);
              transaction.rollback(() => {
                reject(err);
              });
            } else {
              resolve(result);
            }
          });

          transaction.query(updateCAPTBEST, paramsCAPTBEST, (err, result) => {
            if (err) {
              console.error(err);
              transaction.rollback(() => {
                reject(err);
              });
            } else {
              resolve(result);
            }
          });
        });
      } catch (err) {
        throw err;
      }
    }

    await new Promise((resolve, reject) => {
      transaction.commit(err => {
        if (err) {
          console.error(err);
          reject(err);
        } else {
          resolve();
        }
      });
    });

    res.json({ message: 'Itens inseridos com sucesso' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao executar a inserção dos itens' });
  }
});

// Rota POST para inserir itens na tabela
app.post('/itens', async (req, res) => {
  const itens = req.body;
  if (!itens || !Array.isArray(itens)) {
    return res.status(400).json({ error: 'Formato de dados inválido. Espera-se uma lista de objetos JSON.' });
  }

  try {
    const db = await new Promise((resolve, reject) => {
      attach(options, (err, db) => {
        if (err) {
          console.error(err);
          reject(err);
        } else {
          resolve(db);
        }
      });
    });

    const insertQuery = `
      INSERT INTO CAPTBEST 
      (COD_PROD, COD_LOJA, LOC_ESTO, QTD_MIN, QTD_MAX, QTD_ATUAL, QTD_GAR, QTD_NET, MEDIATRIMESTRAL, MEDIAMENSAL) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    const transaction = await new Promise((resolve, reject) => {
      db.transaction(ISOLATION_READ_COMMITED, (err, transaction) => {
        if (err) {
          console.error(err);
          reject(err);
        } else {
          resolve(transaction);
        }
      });
    });

    for (const item of itens) {
      const params = [
        item.COD_PROD,
        item.COD_LOJA,
        item.LOC_ESTO,
        item.QTD_MIN,
        item.QTD_MAX,
        item.QTD_ATUAL,
        item.QTD_GAR,
        item.QTD_NET,
        item.MEDIATRIMESTRAL,
        item.MEDIAMENSAL
      ];

      try {
        await new Promise((resolve, reject) => {
          transaction.query(insertQuery, params, (err, result) => {
            if (err) {
              console.error(err);
              transaction.rollback(() => {
                reject(err);
              });
            } else {
              resolve(result);
            }
          });
        });
      } catch (err) {
        throw err;
      }
    }

    await new Promise((resolve, reject) => {
      transaction.commit(err => {
        if (err) {
          console.error(err);
          reject(err);
        } else {
          resolve();
        }
      });
    });

    res.json({ message: 'Itens inseridos com sucesso' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao executar a inserção dos itens' });
  }
});
