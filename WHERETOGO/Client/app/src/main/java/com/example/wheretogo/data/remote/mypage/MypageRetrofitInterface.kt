package com.example.wheretogo.data.remote.mypage

import com.example.wheretogo.data.remote.detail.DetailIsSavedResponse
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Path

interface MypageRetrofitInterface {
    @GET("/saved/{userIdx}")
    fun getSavedEvent(@Path("userIdx") userIdx: Int): Call<SavedEventResponse>

    @GET("/visited/{userIdx}")
    fun getVisitedEvent(@Path("userIdx") userIdx: Int): Call<VisitedEventResponse>

    //이벤트 방문,저장 여부 확인
    @GET("event/{userIdx}/{eventIdx}")
    fun getEventStatus(@Path("userIdx")userIdx: Int, @Path("eventIdx")eventIdx:Int) : Call<EventStatusResponse>

    //이벤트 방문,저장 여부 확인
    @GET("event/{userIdx}/{eventIdx}")
    fun getHomeEventStatus(@Path("userIdx")userIdx: Int, @Path("eventIdx")eventIdx:Int) : Call<HomeEventStatusResponse>
}