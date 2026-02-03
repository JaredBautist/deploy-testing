import apiClient from './api'

const authService = {
  async login(email, password) {
    const response = await apiClient.post('/auth/login/', { email, password })
    const { access, refresh } = response.data

    localStorage.setItem('access_token', access)
    localStorage.setItem('refresh_token', refresh)

    return response.data
  },

  async getMe() {
    const response = await apiClient.get('/auth/me/')
    return response.data
  },

  logout() {
    localStorage.removeItem('access_token')
    localStorage.removeItem('refresh_token')
  },

  isAuthenticated() {
    return !!localStorage.getItem('access_token')
  },
}

export default authService
