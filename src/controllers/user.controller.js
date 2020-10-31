const db = require("../config/database");

exports.createUser = async (req, res) => {
  const { id, nome, email, senha, ddd, tel } = req.body;
  const { rows } = await db.query(

    "INSERT INTO Usuario (id_usuario, nome, email, senha, telefone_ddd, telefone_nro) VALUES ($1, $2, $3, $4, $5, $6)",
    [id, nome, email, senha, ddd, tel]
);

  res.status(201).send({
    message: "Usuário adicionado com sucesso!",
    body: {
      usuario: { id, nome, email, senha, ddd, tel }
    },
  });
};

exports.getAllUsers = async (req, res) => {
    const response = await db.query("SELECT * FROM Usuario");
  
    res.status(200).send(response.rows);
};

exports.getUserById = async (req, res) => {
    const userId = parseInt(req.params.id)
    const response = await db.query(`SELECT * FROM Usuario WHERE id_usuario=${userId}`);

    res.status(200).send(response.rows);
}