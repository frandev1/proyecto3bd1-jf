import React, { useState, useEffect } from 'react'
import axios from 'axios';
import Swal from 'sweetalert2';
import withReactContent from 'sweetalert2-react-content';
import facturaLogo from './assets/6296190.png'
import cuentaLogo from './assets/klipartz.png'
import './App.css'
import '@fortawesome/fontawesome-free/css/all.min.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle';

function App() {
  const [title, setTitle] = useState('')

  const openModal = (op, id, name) => {
    setTitle('')
    switch (op) {
      case 1:
        setTitle('Consulta de Facturas')
        break
      case 2:
        setTitle('Consulta de Cuenta')
        break
      default:
        break
    }
  }

  return (
    <>
      <div className="header">
        <h1>Servicio Telefónico</h1>
        <h4>Factura y Estado de Cuenta</h4>
      </div>
      <div className="group-content">
        <card className="card" onClick={() => openModal(1)}
          data-bs-toggle='modal' data-bs-target='#modalConsultaFacturas'>
          <div className="card-body">
            <img src={facturaLogo} alt="Factura" />
            <h5 className="card-title">Facturación</h5>
          </div>
        </card>
        <card className="card" onClick={() => openModal(2)}
          data-bs-toggle='modal' data-bs-target='#modalConsultaCuenta'>
          <div className="card-body">
            <img src={cuentaLogo} alt="Cuenta" />
            <h5 className="card-title">Estado de Cuenta</h5>
          </div>
        </card>
      </div>

      <div id='modalConsultaFacturas' className='modal fade' aria-hidden='true'>
        <div className='modal-dialog'>
          <div className='modal-content'>
            <div className='modal-header'>
              <h5 className='modal-title'>{title}</h5>
              <button type='button' className='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
            </div>
            <div className='modal-body'>
              <form>
                <div className='mb-3'>
                  <label htmlFor='inputNumero' className='form-label'>Número de Teléfono</label>
                  <input type='text' className='form-control' id='inputNumero' />
                </div>
              </form>
            </div>
            <div className='modal-footer'>
              <button type='button' className='btn btn-secondary' data-bs-dismiss='modal'>Cerrar</button>
              <button type='button' className='btn btn-primary'>Consultar</button>
            </div>
          </div>
        </div>
      </div>

      <div id='modalConsultaCuenta' className='modal fade' aria-hidden='true'>
        <div className='modal-dialog'>
          <div className='modal-content'>
            <div className='modal-header'>
              <h5 className='modal-title'>{title}</h5>
              <button type='button' className='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
            </div>
            <div className='modal-body'>
              <form>
                <div className='mb-3'>
                  <label htmlFor='inputNumero' className='form-label'>Número de Teléfono</label>
                  <input type='text' className='form-control' id='inputNumero' />
                </div>
              </form>
            </div>
            <div className='modal-footer'>
              <button type='button' className='btn btn-secondary' data-bs-dismiss='modal'>Cerrar</button>
              <button type='button' className='btn btn-primary'>Consultar</button>
            </div>
          </div>
        </div>
      </div>
    </>
  )
}

export default App
