import apiClient from './api'

const spaceService = {
  async getAll() {
    const response = await apiClient.get('/spaces/')
    return response.data
  },

  async getById(id) {
    const response = await apiClient.get(`/spaces/${id}/`)
    return response.data
  },

  async getAvailability(id, start, end) {
    const response = await apiClient.get(`/spaces/${id}/availability/`, {
      params: { start, end },
    })
    return response.data
  },

  async create(data) {
    const response = await apiClient.post('/spaces/', data)
    return response.data
  },

  async update(id, data) {
    const response = await apiClient.patch(`/spaces/${id}/`, data)
    return response.data
  },

  async delete(id) {
    const response = await apiClient.delete(`/spaces/${id}/`)
    return response.data
  },
}

export default spaceService
