import React, { useState, useEffect } from 'react'
import axios from 'axios';
import Swal from 'sweetalert2';
import withReactContent from 'sweetalert2-react-content';
import facturaLogo from './assets/6296190.png'
import cuentaLogo from './assets/klipartz.png'
import './App.css'

function App() {

  return (
    <>
      <center><h1>Servicio Telefónico</h1></center>
      <center>
        <div className="group-content">
          <div className="card-container">
            <div className="card-body">
              <img src={facturaLogo} alt="Factura" width="100" height="100" onClick={() => { }}/>
              <p className="card-text">Ver Facturas</p>
            </div>
            <div className="card-body">
              <img src={cuentaLogo} alt="Estado-Cuenta" width="100" height="100" onClick={() => { }}/>
              <p className="card-text">Ver Estado de Cuenta</p>
            </div>
          </div>
        </div>
      </center>
    </>
  )
}

export default App
