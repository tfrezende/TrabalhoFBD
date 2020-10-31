const express = require('express');

const router = express.Router();

router.get('/api', (req, res) => {
  res.status(200).send({
    status: 'success',
    message: 'Acesso à API realizado com sucesso'
  });
});

module.exports = router;