const router = require('express-promise-router')();
const userController = require('../controllers/user.controller');

// ==> Definindo as rotas do CRUD - 'Usuario':

router
    .get('/users', userController.getAllUsers)
    .get('/users/:id', userController.getUserById)
    .post('/users', userController.createUser);
    

module.exports = router;