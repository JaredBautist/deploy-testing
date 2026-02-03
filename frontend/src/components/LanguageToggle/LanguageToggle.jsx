import { useTranslation } from 'react-i18next'
import styles from './LanguageToggle.module.css'

const LanguageToggle = () => {
  const { i18n } = useTranslation()

  const toggleLanguage = () => {
    const newLang = i18n.language === 'en' ? 'es' : 'en'
    i18n.changeLanguage(newLang)
    localStorage.setItem('language', newLang)
  }

  return (
    <button
      onClick={toggleLanguage}
      className={styles.languageToggle}
      aria-label={`Switch to ${i18n.language === 'en' ? 'Spanish' : 'English'}`}
    >
      <span className={styles.flag}>
        {i18n.language === 'en' ? '🇪🇸' : '🇺🇸'}
      </span>
      <span className={styles.text}>
        {i18n.language === 'en' ? 'ES' : 'EN'}
      </span>
    </button>
  )
}

export default LanguageToggle
