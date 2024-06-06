import React,{ useState, useEffect } from 'react'
import axios from 'axios';
import Swal from 'sweetalert2';
import withReactContent from 'sweetalert2-react-content';
import facturaLogo from './assets/6296190.png'
import cuentaLogo from './assets/klipartz.png'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <center><h1>Servicio Telefónico</h1></center>
      <center>
        <div className="group-content">
          <div className="card-container">
            <div className="card-body">
              <img src={facturaLogo} alt="Factura" width="100" height="100" />
              <p className="card-text"></p>
              <button className="btn" onClick={() => {} }>Ver facturas</button>
            </div>
            <div className="card-body">
              <img src={cuentaLogo} alt="Factura" width="100" height="100" />
              <p className="card-text"></p>
              <button className="btn" onClick={() => {} }>Ver Estado de Cuenta</button>
            </div>
          </div>
        </div>
      </center>
    </>
  )
}

export default App
