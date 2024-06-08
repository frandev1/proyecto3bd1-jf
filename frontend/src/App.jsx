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

  return (
    <>
      <div className="header">
        <h1>Servicio Telefónico</h1>
        <h4>Factura y Estado de Cuenta</h4>
      </div>
      <div className="group-content">
        <card className="card" onClick={() => window.location.href = '/factura'}>
          <div className="card-body">
            <img src={facturaLogo} alt="Factura" />
            <h5 className="card-title">Facturación</h5>
          </div>
        </card>
        <card className="card" onClick={() => window.location.href = '/cuenta'}>
          <div className="card-body">
            <img src={cuentaLogo} alt="Cuenta" />
            <h5 className="card-title">Estado de Cuenta</h5>
          </div>
        </card>
      </div>
    </>
  )
}

export default App
