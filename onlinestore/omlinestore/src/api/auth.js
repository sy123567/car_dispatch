import axios from 'axios'

const API_BASE_URL = 'http://localhost:3000/api'

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

api.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

export const authAPI = {
  sendCode(phone, type) {
    return api.post('/auth/send-code', { phone, type })
  },

  register(data) {
    return api.post('/auth/register', data)
  },

  loginWithPassword(data) {
    return api.post('/auth/login', data)
  },

  loginWithCode(data) {
    return api.post('/auth/login/code', data)
  }
}

export default api
