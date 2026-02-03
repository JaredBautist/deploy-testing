import { useEffect, useState } from 'react'
import styles from './Toast.module.css'

const icons = {
  success: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
      <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
      <polyline points="22 4 12 14.01 9 11.01" />
    </svg>
  ),
  error: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="10" />
      <line x1="15" y1="9" x2="9" y2="15" />
      <line x1="9" y1="9" x2="15" y2="15" />
    </svg>
  ),
  warning: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
      <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
      <line x1="12" y1="9" x2="12" y2="13" />
      <line x1="12" y1="17" x2="12.01" y2="17" />
    </svg>
  ),
  info: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="10" />
      <line x1="12" y1="16" x2="12" y2="12" />
      <line x1="12" y1="8" x2="12.01" y2="8" />
    </svg>
  ),
}

const titles = {
  success: 'Success',
  error: 'Error',
  warning: 'Warning',
  info: 'Info',
}

const Toast = ({ id, message, type = 'error', onClose, duration = 5000 }) => {
  const [isExiting, setIsExiting] = useState(false)
  const [progress, setProgress] = useState(100)

  useEffect(() => {
    const startTime = Date.now()
    const endTime = startTime + duration

    const progressInterval = setInterval(() => {
      const now = Date.now()
      const remaining = Math.max(0, endTime - now)
      const newProgress = (remaining / duration) * 100
      setProgress(newProgress)

      if (remaining <= 0) {
        clearInterval(progressInterval)
      }
    }, 50)

    const exitTimer = setTimeout(() => {
      setIsExiting(true)
    }, duration - 300)

    const closeTimer = setTimeout(() => {
      onClose(id)
    }, duration)

    return () => {
      clearInterval(progressInterval)
      clearTimeout(exitTimer)
      clearTimeout(closeTimer)
    }
  }, [duration, onClose, id])

  const handleClose = () => {
    setIsExiting(true)
    setTimeout(() => onClose(id), 300)
  }

  return (
    <div className={`${styles.toast} ${styles[type]} ${isExiting ? styles.exit : ''}`}>
      <div className={styles.iconWrapper}>
        {icons[type]}
      </div>
      <div className={styles.content}>
        <span className={styles.title}>{titles[type]}</span>
        <span className={styles.message}>{message}</span>
      </div>
      <button onClick={handleClose} className={styles.closeBtn} aria-label="Close">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <line x1="18" y1="6" x2="6" y2="18" />
          <line x1="6" y1="6" x2="18" y2="18" />
        </svg>
      </button>
      <div className={styles.progressBar}>
        <div
          className={styles.progressFill}
          style={{ width: `${progress}%` }}
        />
      </div>
    </div>
  )
}

export default Toast
