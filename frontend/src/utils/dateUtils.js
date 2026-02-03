import { format, parseISO } from 'date-fns'

export const formatDateTime = (dateString) => {
  if (!dateString) return ''
  try {
    return format(parseISO(dateString), 'dd/MM/yyyy HH:mm')
  } catch {
    return dateString
  }
}

export const formatDate = (dateString) => {
  if (!dateString) return ''
  try {
    return format(parseISO(dateString), 'dd/MM/yyyy')
  } catch {
    return dateString
  }
}

export const formatTime = (dateString) => {
  if (!dateString) return ''
  try {
    return format(parseISO(dateString), 'HH:mm')
  } catch {
    return dateString
  }
}

export const toISOString = (date) => {
  if (!date) return ''
  return date instanceof Date ? date.toISOString() : new Date(date).toISOString()
}

export const formatDateTimeLocal = (dateString) => {
  if (!dateString) return ''
  try {
    const date = parseISO(dateString)
    return format(date, "yyyy-MM-dd'T'HH:mm")
  } catch {
    return ''
  }
}
