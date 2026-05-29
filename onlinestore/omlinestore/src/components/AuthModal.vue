
<!--使用 authAPI 调用后端接口-->
<!--本地存储 token 和用户信息-->
<!--表单重置和状态管理-->
<!--加载状态提示-->
<template>
  <div v-if="visible" class="modal-overlay" @click.self="closeModal">
    <div class="modal-content">
      <button class="close-btn" @click="closeModal">×</button>

      <div class="tabs">
        <button
          :class="['tab', { active: isLogin }]"
          @click="isLogin = true"
        >
          登录
        </button>
        <button
          :class="['tab', { active: !isLogin }]"
          @click="isLogin = false"
        >
          注册
        </button>
      </div>

      <form v-if="isLogin" class="auth-form" @submit.prevent="handleLogin">
        <h2>欢迎回来</h2>

        <div class="login-method">
          <button
            type="button"
            :class="['method-btn', { active: loginMethod === 'password' }]"
            @click="loginMethod = 'password'"
          >
            密码登录
          </button>
          <button
            type="button"
            :class="['method-btn', { active: loginMethod === 'code' }]"
            @click="loginMethod = 'code'"
          >
            验证码登录
          </button>
        </div>

        <div class="form-group">
          <label>手机号</label>
          <input
            type="tel"
            v-model="loginForm.phone"
            placeholder="请输入手机号"
            pattern="^1[3-9]\d{9}$"
            required
          />
        </div>

        <div v-if="loginMethod === 'password'" class="form-group">
          <label>密码</label>
          <input
            type="password"
            v-model="loginForm.password"
            placeholder="请输入密码"
            required
          />
        </div>

        <div v-else class="form-group">
          <label>验证码</label>
          <div class="code-input-group">
            <input
              type="text"
              v-model="loginForm.code"
              placeholder="请输入验证码"
              maxlength="6"
              required
            />
            <button
              type="button"
              class="send-code-btn"
              @click="sendLoginCode"
              :disabled="codeCountdown > 0"
            >
              {{ codeCountdown > 0 ? `${codeCountdown}s 后重发` : '获取验证码' }}
            </button>
          </div>
        </div>

        <button type="submit" class="submit-btn" :disabled="isLoading">
          {{ isLoading ? '登录中...' : '登录' }}
        </button>

        <div class="form-footer">
          <a href="#">忘记密码？</a>
        </div>
      </form>

      <form v-else class="auth-form" @submit.prevent="handleRegister">
        <h2>创建账号</h2>

        <div class="form-group">
          <label>手机号</label>
          <div class="code-input-group">
            <input
              type="tel"
              v-model="registerForm.phone"
              placeholder="请输入手机号"
              pattern="^1[3-9]\d{9}$"
              required
            />
            <button
              type="button"
              class="send-code-btn"
              @click="sendRegisterCode"
              :disabled="codeCountdown > 0"
            >
              {{ codeCountdown > 0 ? `${codeCountdown}s 后重发` : '获取验证码' }}
            </button>
          </div>
        </div>

        <div class="form-group">
          <label>验证码</label>
          <input
            type="text"
            v-model="registerForm.code"
            placeholder="请输入验证码"
            maxlength="6"
            required
          />
        </div>

        <div class="form-group">
          <label>用户名</label>
          <input
            type="text"
            v-model="registerForm.username"
            placeholder="请设置用户名（2-50 个字符）"
            minlength="2"
            maxlength="50"
            required
          />
        </div>

        <div class="form-group">
          <label>密码</label>
          <input
            type="password"
            v-model="registerForm.password"
            placeholder="请设置密码（至少 6 位）"
            minlength="6"
            required
          />
        </div>

        <div class="form-group">
          <label>确认密码</label>
          <input
            type="password"
            v-model="registerForm.confirmPassword"
            placeholder="请再次输入密码"
            required
          />
        </div>

        <button type="submit" class="submit-btn" :disabled="isLoading">
          {{ isLoading ? '注册中...' : '注册' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { authAPI } from '../api/auth'
import '../resource/css/login.css'
const props = defineProps({
  visible: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:visible', 'login', 'register'])

const isLogin = ref(true)
const loginMethod = ref('password')
const codeCountdown = ref(0)
const isLoading = ref(false)

const loginForm = ref({
  phone: '',
  password: '',
  code: ''
})

const registerForm = ref({
  phone: '',
  code: '',
  username: '',
  password: '',
  confirmPassword: ''
})

let countdownTimer = null

const startCountdown = () => {
  codeCountdown.value = 60
  countdownTimer = setInterval(() => {
    if (codeCountdown.value > 0) {
      codeCountdown.value--
    } else {
      clearInterval(countdownTimer)
    }
  }, 1000)
}

const closeModal = () => {
  emit('update:visible', false)
  resetForms()
  if (countdownTimer) {
    clearInterval(countdownTimer)
  }
}

const resetForms = () => {
  loginForm.value = { phone: '', password: '', code: '' }
  registerForm.value = { phone: '', code: '', username: '', password: '', confirmPassword: '' }
  codeCountdown.value = 0
  loginMethod.value = 'password'
}

const sendLoginCode = async () => {
  if (!loginForm.value.phone || !/^1[3-9]\d{9}$/.test(loginForm.value.phone)) {
    alert('请输入有效的手机号')
    return
  }

  try {
    await authAPI.sendCode(loginForm.value.phone, 'login')
    alert('验证码已发送，请在 IDEA 后端控制台查看')
    startCountdown()
  } catch (error) {
    alert(error.response?.data?.error || '发送失败')
  }
}

const sendRegisterCode = async () => {
  if (!registerForm.value.phone || !/^1[3-9]\d{9}$/.test(registerForm.value.phone)) {
    alert('请输入有效的手机号')
    return
  }

  try {
    await authAPI.sendCode(registerForm.value.phone, 'register')
    alert('验证码已发送，请在 IDEA 后端控制台查看')
    startCountdown()
  } catch (error) {
    alert(error.response?.data?.error || '发送失败')
  }
}

const handleLogin = async () => {
  if (!loginForm.value.phone || !/^1[3-9]\d{9}$/.test(loginForm.value.phone)) {
    alert('请输入有效的手机号')
    return
  }

  if (loginMethod.value === 'password') {
    if (!loginForm.value.password) {
      alert('请输入密码')
      return
    }
  } else {
    if (!loginForm.value.code) {
      alert('请输入验证码')
      return
    }
  }

  isLoading.value = true

  try {
    let result
    if (loginMethod.value === 'password') {
      result = await authAPI.loginWithPassword({
        phone: loginForm.value.phone,
        password: loginForm.value.password
      })
    } else {
      result = await authAPI.loginWithCode({
        phone: loginForm.value.phone,
        code: loginForm.value.code
      })
    }

    const { token, user } = result.data
    localStorage.setItem('token', token)
    localStorage.setItem('user', JSON.stringify(user))

    emit('login', user)
    closeModal()

  } catch (error) {
    alert(error.response?.data?.error || '登录失败')
  } finally {
    isLoading.value = false
  }
}

const handleRegister = async () => {
  if (!registerForm.value.phone || !/^1[3-9]\d{9}$/.test(registerForm.value.phone)) {
    alert('请输入有效的手机号')
    return
  }

  if (!registerForm.value.code) {
    alert('请输入验证码')
    return
  }

  if (registerForm.value.password !== registerForm.value.confirmPassword) {
    alert('两次输入的密码不一致')
    return
  }

  isLoading.value = true

  try {
    const result = await authAPI.register({
      phone: registerForm.value.phone,
      code: registerForm.value.code,
      username: registerForm.value.username,
      password: registerForm.value.password
    })

    const { token, user } = result.data
    localStorage.setItem('token', token)
    localStorage.setItem('user', JSON.stringify(user))

    emit('register', user)
    closeModal()
    alert(`注册成功！欢迎 ${user.username}`)
  } catch (error) {
    alert(error.response?.data?.error || '注册失')
  } finally {
    isLoading.value = false
  }
}

watch(() => props.visible, (newVal) => {
  if (!newVal) {
    resetForms()
  }
})
</script>

<style scoped>

</style>
