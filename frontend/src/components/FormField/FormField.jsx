import styles from './FormField.module.css'

const FormField = ({
  label,
  name,
  type = 'text',
  value,
  onChange,
  onBlur,
  error,
  required = false,
  placeholder = '',
  children,
  as = 'input',
  rows = 3,
  options = [],
  checked,
  className = '',
}) => {
  const hasError = Boolean(error)
  const inputId = `field-${name}`

  const renderInput = () => {
    const commonProps = {
      id: inputId,
      name,
      value,
      onChange,
      onBlur,
      placeholder,
      className: `${styles.input} ${hasError ? styles.inputError : ''}`,
    }

    if (as === 'textarea') {
      return <textarea {...commonProps} rows={rows} />
    }

    if (as === 'select') {
      return (
        <select {...commonProps}>
          {children || options.map(opt => (
            <option key={opt.value} value={opt.value}>
              {opt.label}
            </option>
          ))}
        </select>
      )
    }

    if (type === 'checkbox') {
      return (
        <label className={styles.checkboxLabel}>
          <input
            type="checkbox"
            id={inputId}
            name={name}
            checked={checked}
            onChange={onChange}
            className={styles.checkbox}
          />
          <span className={styles.checkboxText}>{label}</span>
        </label>
      )
    }

    return <input type={type} {...commonProps} />
  }

  if (type === 'checkbox') {
    return (
      <div className={`${styles.formField} ${className}`}>
        {renderInput()}
        {hasError && (
          <div className={styles.errorContainer}>
            <svg className={styles.errorIcon} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="12" cy="12" r="10" />
              <line x1="12" y1="8" x2="12" y2="12" />
              <line x1="12" y1="16" x2="12.01" y2="16" />
            </svg>
            <span className={styles.errorText}>{error}</span>
          </div>
        )}
      </div>
    )
  }

  return (
    <div className={`${styles.formField} ${className}`}>
      {label && (
        <label htmlFor={inputId} className={styles.label}>
          {label}
          {required && <span className={styles.required}>*</span>}
        </label>
      )}
      <div className={styles.inputWrapper}>
        {renderInput()}
        {hasError && (
          <div className={styles.errorContainer}>
            <svg className={styles.errorIcon} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="12" cy="12" r="10" />
              <line x1="12" y1="8" x2="12" y2="12" />
              <line x1="12" y1="16" x2="12.01" y2="16" />
            </svg>
            <span className={styles.errorText}>{error}</span>
          </div>
        )}
      </div>
    </div>
  )
}

export default FormField
