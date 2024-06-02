import express from 'express';
import config from './config';
import clientesRoutes from '../routes/clientes.routes';

const cors = require('cors');
const app = express();

//settings
app.set('port', config.port);

//middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended: false}));

//routes
app.use('/api', clientesRoutes)

export default app;