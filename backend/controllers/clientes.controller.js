import { getConnection } from "../database/connection";
import sql from 'mssql';

export async function getClientes(req, res) {
    try {
        const pool = await getConnection();
        const result = await pool.request().query('SELECT * FROM Clientes');
        res.json(result.recordset);
        console.log(result);
    } catch (error) {
        res.status(500);
        res.send(error.message);
    }
}