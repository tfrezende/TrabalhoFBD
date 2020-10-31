const router = require('express-promise-router')();
const userController = require('../controllers/user.controller');

// ==> Definindo as rotas do CRUD - 'Usuario':

router.post('/users', userController.createUser);
router.get('/users', userController.getAllUsers);

module.exports = router;