package com.example.wheretogo.data.remote

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory


const val BASE_URL = "http://10.0.2.2:3000"
fun getRetrofit(): Retrofit {
    val retrofit = Retrofit.Builder().baseUrl(BASE_URL)
        .addConverterFactory(GsonConverterFactory.create()).build()

    return retrofit
}

