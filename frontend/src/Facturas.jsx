import React, { useState, useEffect } from 'react'
import './Facturas.css'
import '@fortawesome/fontawesome-free/css/all.min.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle';

function Facturas(numero) {
    

    return (
        <>
            <div className='container-fluid'>
                    <div className='row'>
                        <div className='col-12'>
                            <h2 className='text-center mt-3'>Empleados</h2>
                        </div>
                    </div>
                    <div className='input-group mb-3'>
                        <input type='text' id='Filtro' className='form-control' placeholder='Filtro' value={filtro}
                        onChange={e => setFiltro(e.target.value)}></input>
                        <button onClick={filtrar} className='btn btn-primary'>
                            <i className='fa-solid fa-filter'></i>
                        </button>
                    </div>
                    <div className='row mt-3'>
                        <div className='col-12'>
                            <div className='table-responsive'>
                                <table className='table table-bordered'>
                                    <thead>
                                        <tr><th>NOMBRE</th><th>EDITAR</th><th>ELIMINAR</th><th>VER</th><th>HISTORIAL</th><th>MOVIMIENTOS</th></tr>
                                    </thead>
                                    <tbody className='table-group-divider'>
                                        {empleados.map( (empleado)=>(
                                            <tr key={empleado.ValorDocumentoIdentidad}>
                                                <td>{empleado.Nombre}</td>
                                                <td>
                                                    <button onClick={() => openModal(2,empleado.ValorDocumentoIdentidad,empleado.Nombre)}
                                                        className='btn btn-warning' data-bs-toggle='modal' data-bs-target='#modalUpdateEmpleados'>
                                                        <i className='fa-solid fa-edit'></i>
                                                    </button>
                                                </td>
                                                <td>
                                                    <button onClick={()=>deleteEmpleado(empleado.ValorDocumentoIdentidad,empleado.Nombre)} className='btn btn-danger'>
                                                        <i className='fa-solid fa-trash'></i>
                                                    </button>
                                                </td>
                                                <td>
                                                    <button onClick={()=>openModal(3, empleado.ValorDocumentoIdentidad,empleado.Nombre)} 
                                                    className='btn btn-info' data-bs-toggle='modal' data-bs-target='#modalVerEmpleados'>
                                                        <i className='fa-solid fa-eye'></i>
                                                    </button>
                                                </td>
                                                <td>
                                                    <button onClick={()=>openModal(4, empleado.ValorDocumentoIdentidad,empleado.Nombre)} 
                                                    className='btn btn-success' data-bs-toggle='modal' data-bs-target='#modalListarMovimientos'>
                                                        <i className='fa-solid fa-clipboard'></i>
                                                    </button>
                                                </td>
                                                <td>
                                                    <button onClick={()=>openModal(5, empleado.ValorDocumentoIdentidad,empleado.Nombre)} 
                                                    className='btn btn-secondary' data-bs-toggle='modal' data-bs-target='#modalInsertarMovimiento'>
                                                        <i className='fa-solid fa-user-plus'></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        ))
                                        }
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
        </>
    )
}

export default Facturas