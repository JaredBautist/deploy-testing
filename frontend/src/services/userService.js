import apiClient from './api'

const userService = {
  async getAll() {
    const response = await apiClient.get('/users/')
    return response.data
  },

  async getById(id) {
    const response = await apiClient.get(`/users/${id}/`)
    return response.data
  },

  async create(data) {
    const response = await apiClient.post('/users/', data)
    return response.data
  },

  async update(id, data) {
    const response = await apiClient.patch(`/users/${id}/`, data)
    return response.data
  },

  async delete(id) {
    const response = await apiClient.delete(`/users/${id}/`)
    return response.data
  },
}

export default userService
