import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useAuth } from '../../contexts/AuthContext'
import { useToast } from '../../contexts/ToastContext'
import ThemeToggle from '../../components/ThemeToggle/ThemeToggle'
import LanguageToggle from '../../components/LanguageToggle/LanguageToggle'
import styles from './Login.module.css'

const Login = () => {
  const { t } = useTranslation()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [errors, setErrors] = useState({ email: '', password: '' })
  const { login } = useAuth()
  const { showError, showSuccess } = useToast()
  const navigate = useNavigate()

  const validateEmail = (value) => {
    if (!value.trim()) {
      return t('login.errorEmail')
    }
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(value)) {
      return t('login.errorEmailInvalid')
    }
    return ''
  }

  const validatePassword = (value) => {
    if (!value.trim()) {
      return t('login.errorPassword')
    }
    return ''
  }

  // Clear error when user starts typing
  const handleEmailChange = (e) => {
    const value = e.target.value
    setEmail(value)
    if (errors.email) {
      setErrors(prev => ({ ...prev, email: '' }))
    }
  }
  const handlePasswordChange = (e) => {
    const value = e.target.value
    setPassword(value)
    if (errors.password) {
      setErrors(prev => ({ ...prev, password: '' }))
    }
  }

  const handleEmailBlur = () => {
    const error = validateEmail(email)
    setErrors(prev => ({ ...prev, email: error }))
  }

  const handlePasswordBlur = () => {
    const error = validatePassword(password)
    setErrors(prev => ({ ...prev, password: error }))
  }

  const handleSubmit = async (e) => {
    e.preventDefault()

    const emailError = validateEmail(email)
    const passwordError = validatePassword(password)

    setErrors({
      email: emailError,
      password: passwordError
    })

    // Error = no submit
    if (emailError || passwordError) {
      return
    }

    setLoading(true)

    try {
      await login(email, password)
      showSuccess(t('login.successRedirect'), 3000)

      setTimeout(() => {
        navigate('/')
      }, 1500)
    } catch (err) {
      if (!err.response) {
        showError(t('login.errorServer'), 3000)
      } else if (err.response?.status === 401) {
        showError(t('login.errorCredentials'), 3000)
        setEmail('')
        setPassword('')
      } else {
        showError(t('login.errorServer'), 3000)
      }
      setLoading(false)
    }
  }

  return (
    <div className={styles.container}>
      <div className={styles.leftSide}>
        <div className={styles.imageOverlay}>
          <h1>{t('login.title')}</h1>
          <p className={styles.subtitleLoginPage}>{t('login.subtitle')}</p>
          <p className={styles.subtitleLoginPageMinorSubtitle}>{t('login.minorSubtitle')}</p>
        </div>
      </div>

      <div className={styles.rightSide}>
        <div className={styles.togglesWrapper}>
          <LanguageToggle />
          <ThemeToggle />
        </div>
        <div className={styles.loginBox}>
          <div className={styles.header}>
            <h2>{t('login.welcome')}</h2>
            <p>{t('login.credentials')}</p>
          </div>

          <form onSubmit={handleSubmit} className={styles.form} noValidate>
            <div className={styles.formGroup}>
              <label htmlFor="email">{t('login.email')}</label>
              <div className={styles.inputWrapper}>
                <input
                  type="email"
                  id="email"
                  value={email}
                  onChange={handleEmailChange}
                  onBlur={handleEmailBlur}
                  placeholder={t('login.emailPlaceholder')}
                  autoComplete="email"
                  className={errors.email ? styles.inputError : ''}
                />
                {errors.email && (
                  <div className={styles.errorPopup}>
                    {errors.email}
                  </div>
                )}
              </div>
            </div>

            <div className={styles.formGroup}>
              <label htmlFor="password">{t('login.password')}</label>
              <div className={styles.inputWrapper}>
                <input
                  type="password"
                  id="password"
                  value={password}
                  onChange={handlePasswordChange}
                  onBlur={handlePasswordBlur}
                  placeholder={t('login.passwordPlaceholder')}
                  autoComplete="current-password"
                  className={errors.password ? styles.inputError : ''}
                />
                {errors.password && (
                  <div className={styles.errorPopup}>
                    {errors.password}
                  </div>
                )}
              </div>
            </div>

            <div className={styles.forgotPassword}>
              <a href="https://wa.me/573028530092" target='_blank'>{t('login.forgotPassword')}</a>
            </div>

            <button type="submit" className={styles.submitBtn} disabled={loading}>
              {loading ? t('login.loggingIn') : t('login.loginButton')}
            </button>
          </form>
        </div>
            <div className={styles.infoPartnerApp}>
              {t('login.integratedSystem')} &copy;
              <img src="/logo-fesc.png" alt="FESC Logo" />
            </div>
      </div>
    </div>
  )
}

export default Login