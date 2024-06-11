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
import Facturas from './Facturas.jsx'
import { Link, Routes, Route, BrowserRouter } from 'react-router-dom'
import { show_alerta } from './functions.jsx'

function App() {
  const [title, setTitle] = useState('')
  const [pagina, setPagina] = useState(true)
  const [facturas, setFacturas] = useState()

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

  const goToFacturas = () => {
    const numero = document.getElementById('inputNumero').value
    if (numero === '') {
      show_alerta('Debe ingresar el número de teléfono', 'error', 'inputNumero')
      return
    }
    setPagina(false)
    setFacturas(true)
  }

  const goToCuentas = () => {
    setPagina(false)
    setFacturas(false)
  }

  const renderFacturas = (numero) => {
    return (
      <div className='container-fluid'>
          <div className='row'>
              <div className='col-12'>
                  <h2 className='text-center mt-3'>Facturas</h2>
              </div>
          </div>
          <div className='row mt-3'>
              <div className='col-12'>
                  <div className='table-responsive'>
                      <table className='table table-bordered'>
                          <thead>
                              <tr><th>NOMBRE</th><th>EDITAR</th><th>ELIMINAR</th><th>VER</th><th>HISTORIAL</th><th>MOVIMIENTOS</th></tr>
                          </thead>
                      </table>
                  </div>
              </div>
          </div>
      </div>
    )
  }

  const renderCuentas = (empresa) => {
    return (
      <div className='container-fluid'>
          <div className='row'>
              <div className='col-12'>
                  <h2 className='text-center mt-3'>Cuentas</h2>
              </div>
          </div>
          <div className='row mt-3'>
              <div className='col-12'>
                  <div className='table-responsive'>
                      <table className='table table-bordered'>
                          <thead>
                              <tr><th>NOMBRE</th><th>EDITAR</th><th>ELIMINAR</th><th>VER</th><th>HISTORIAL</th><th>MOVIMIENTOS</th></tr>
                          </thead>
                      </table>
                  </div>
              </div>
          </div>
      </div>
    )
  }

  const renderInicio = () => {
    return (
      <div className='container-fluid'>
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
              <button type='button' className='btn btn-primary' data-bs-dismiss='modal'
              onClick={() => {goToFacturas()}}>Consultar</button>
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
              <button type='button' className='btn btn-primary' data-bs-dismiss='modal'
              onClick={() => {goToCuentas()}}>Consultar</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    )
  }

  return (
    <>
      {pagina && (
        renderInicio()
      )}
      {!pagina && facturas && (
        renderFacturas()
      )}
      {!pagina && !facturas && (
        renderCuentas()
      )}
    </>
  )
}

export default App
