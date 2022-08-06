package com.example.wheretogo.ui.setting

import android.content.Intent
import android.view.View
import com.example.wheretogo.R
import com.example.wheretogo.databinding.ActivityChangeInfoBinding
import com.example.wheretogo.ui.BaseActivity

class ChangeInfoActivity : BaseActivity<ActivityChangeInfoBinding>(ActivityChangeInfoBinding::inflate){

    companion object {
        const val IMAGE_REQUEST_CODE = 100
    }

    override fun initAfterBinding() {
        binding.changeInfoCancelTv.setOnClickListener {
            finish()
        }
        binding.changeInfoSetProfile.setOnClickListener {
            binding.imgOptionBanner.visibility = View.VISIBLE
        }
        binding.imgOptionDefaultTv.setOnClickListener {
            binding.imgOptionBanner.visibility = View.INVISIBLE
            binding.changeInfoProfileIv.setImageResource(R.drawable.img_change_info_profile)
        }
        binding.imgOptionAlbumTv.setOnClickListener {
            pickImageGallery()
            binding.imgOptionBanner.visibility = View.INVISIBLE
        }
    }

    private fun pickImageGallery() {
        val intent = Intent(Intent.ACTION_PICK)
        intent.type = "image/*"
        startActivityForResult(intent, IMAGE_REQUEST_CODE) //인텐트를 통해 갤러리에 요청 코드 보냄
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data) //URI 객체로 이미지 전달받음
        if (requestCode == IMAGE_REQUEST_CODE && resultCode == RESULT_OK){
            binding.changeInfoProfileIv.setImageURI(data?.data)
            showToast(data?.data.toString())
        }
    }
}