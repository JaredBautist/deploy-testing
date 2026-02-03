import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import spaceService from '../../services/spaceService'
import styles from './Spaces.module.css'

const Spaces = () => {
  const { t } = useTranslation()
  const [spaces, setSpaces] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    loadSpaces()
  }, [])

  const loadSpaces = async () => {
    try {
      setLoading(true)
      const data = await spaceService.getAll()
      setSpaces(data)
    } catch (err) {
      setError(t('common.error'))
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  if (loading) return <div>{t('spaces.loading')}</div>
  if (error) return <div className={styles.error}>{error}</div>

  return (
    <div className={styles.spacesPage}>
      <div className={styles.header}>
        <h1>{t('spaces.title')}</h1>
        <p>{t('spaces.subtitle')}</p>
      </div>

      {spaces.length === 0 ? (
        <p className={styles.emptyState}>{t('spaces.noSpaces')}</p>
      ) : (
        <div className={styles.spacesGrid}>
          {spaces.map((space) => (
            <div key={space.id} className={styles.spaceCard}>
              <div className={styles.spaceHeader}>
                <h2>{space.name}</h2>
                {space.is_active && (
                  <span className={styles.activeBadge}>{t('spaces.active')}</span>
                )}
              </div>
              <p className={styles.description}>{space.description}</p>
              <p className={styles.location}>
                <strong>{t('spaces.location')}:</strong> {space.location}
              </p>
              <Link to="/create-reservation" className={styles.reserveBtn}>
                {t('spaces.book')}
              </Link>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

export default Spaces
