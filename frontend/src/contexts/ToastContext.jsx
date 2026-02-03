import { createContext, useContext, useState } from 'react'
import ToastContainer from '../components/Toast/ToastContainer'

const ToastContext = createContext(null)

export const useToast = () => {
  const context = useContext(ToastContext)
  if (!context) {
    throw new Error('useToast must be used within ToastProvider')
  }
  return context
}

export const ToastProvider = ({ children }) => {
  const [toasts, setToasts] = useState([])

  const addToast = (message, type = 'error', duration = 5000) => {
    const id = Date.now()
    setToasts((prev) => [...prev, { id, message, type, duration }])
  }

  const removeToast = (id) => {
    setToasts((prev) => prev.filter((toast) => toast.id !== id))
  }

  const showError = (message, duration = 5000) => {
    addToast(message, 'error', duration)
  }

  const showSuccess = (message, duration = 5000) => {
    addToast(message, 'success', duration)
  }

  const showWarning = (message, duration = 5000) => {
    addToast(message, 'warning', duration)
  }

  const showInfo = (message, duration = 5000) => {
    addToast(message, 'info', duration)
  }

  const value = {
    addToast,
    showError,
    showSuccess,
    showWarning,
    showInfo,
  }

  return (
    <ToastContext.Provider value={value}>
      {children}
      <ToastContainer toasts={toasts} removeToast={removeToast} />
    </ToastContext.Provider>
  )
}
