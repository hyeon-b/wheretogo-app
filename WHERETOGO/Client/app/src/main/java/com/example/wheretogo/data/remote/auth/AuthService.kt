package com.example.wheretogo.data.remote.auth

import android.util.Log
import com.example.wheretogo.data.remote.getRetrofit
import com.example.wheretogo.ui.login.LoginActivity
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class AuthService { //signupview 변수 받음
    private lateinit var signUpView: SignUpView
    private lateinit var loginView: LoginView

    val authService = getRetrofit().create(AuthRetrofitInterface::class.java)

    fun setSignUpView(signUpView: SignUpView){
        this.signUpView = signUpView
    }

    fun setLoginView(loginView: LoginActivity){
        this.loginView = loginView
    }
    fun signUp(signUpInfo: SignUpInfo){
        authService.signUp(signUpInfo).enqueue(object: Callback<SignUpResponse> {
            override fun onResponse(call: Call<SignUpResponse>, response: Response<SignUpResponse>) {
                Log.d("sign/Response/response.code",response.code().toString())
                val resp: SignUpResponse = response.body()!!
                Log.d("sign/Response/resp.code",resp.code.toString())
                when(resp.code){
                    2010 ->signUpView.onSignUpSuccess(resp.msg)
                    else ->{
                        signUpView.onSignUpFailure(resp.msg)
                    }
                }
                Log.d("resp",resp.msg)
            }

            override fun onFailure(call: Call<SignUpResponse>, t: Throwable) {
                Log.d("SIGNUP/FAILURE", t.message.toString())
            }

        })
        Log.d("SIGNUP","HELLO")
    }

    fun login(appLoginInfo: LoginInfo){
        authService.login(appLoginInfo).enqueue(object: Callback<LoginResponse>{

            override fun onResponse(call: Call<LoginResponse>, response: Response<LoginResponse>) {
                Log.d("login/Response/response.message",response.code().toString())
                val resp: LoginResponse = response.body()!!
                Log.d("login/Response/resp.message",resp.code.toString())
                when(resp.code){
                    200->{
                        Log.d("login/S", resp.msg)
                        loginView.onLoginSuccess(resp.user!!)}
                    else ->{
                        Log.d("login/F", resp.msg)
                        loginView.onLoginFailure(resp.msg)
                    }
                }
            }
            override fun onFailure(call: Call<LoginResponse>, t: Throwable) {
                Log.d("login/Failure", "fail")
            }
        })
    }


}