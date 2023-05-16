package com.sjdev.wheretogo.data.remote.detail

import retrofit2.Call
import retrofit2.http.*

interface DetailRetrofitInterface {
    @GET("event/{userIdx}")
    fun getUserStat(@Path("userIdx") userIdx: Int): Call<DetailInfoResponse>

    @GET("visited/check/{userIdx}/{eventIdx}")
    fun getVisitedInfo(@Path("userIdx")userIdx: Int, @Path("eventIdx")eventIdx:Int) : Call<DetailIsVisitedResponse>

    @GET("saved/check/{userIdx}/{eventIdx}")
    fun getSavedInfo(@Path("userIdx")userIdx: Int, @Path("eventIdx")eventIdx:Int) : Call<DetailIsSavedResponse>

    //savedTBL에 저장
    @POST("/saved/{userID}/{eventID}")
    fun saveEvent(@Path ("userID") userID: Int, @Path("eventID")eventID: Int): Call<DetailSaveEventResponse>

    //visitTBL에 저장
    @POST("/visited/{userID}/{eventID}/{assess}")
    fun visitEvent(@Path ("userID") userID: Int, @Path("eventID")eventID: Int, @Path("assess") assess : String): Call<DetailVisitEventResponse>

    //savedTBL에서 삭제
    @DELETE("/saved/{userID}/{eventID}")
    fun deleteSavedEvent(@Path("userID") userID: Int,
                         @Path("eventID") eventID: Int): Call<DetailDeleteSavedResponse>

    //savedTBL에서 삭제
    @DELETE("/visited/{userID}/{eventID}")
    fun deleteVisitedEvent(@Path("userID") userID: Int,
                         @Path("eventID") eventID: Int): Call<DetailDeleteVisitedResponse>


    @GET("/v1/search/blog")
    fun getSearchBlog(@Header("X-Naver-Client-Id") clientId:String,@Header("X-Naver-Client-Secret") clientSecret:String,
                      @Query("query") query:String?, @Query("display") display: Int): Call<SearchBlogResponse>
}