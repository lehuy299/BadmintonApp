package com.example.projectpe1

import android.content.Intent
import android.os.Bundle
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.facebook.*
import com.facebook.login.LoginResult
import com.facebook.login.widget.LoginButton
import de.hdodenhof.circleimageview.CircleImageView
import org.json.JSONException
import java.util.*

class MainActivity : AppCompatActivity() {
    private var loginButton: LoginButton? = null
    private var circleImageView: CircleImageView? = null
    private var txtName: TextView? = null
    private var txtEmail: TextView? = null
    private var callbackManager: CallbackManager? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        loginButton = findViewById(R.id.login_button)
        txtName = findViewById(R.id.profile_name)
        txtEmail = findViewById(R.id.profile_email)
        circleImageView = findViewById(R.id.profile_pic)
        callbackManager = CallbackManager.Factory.create()
        loginButton!!.setReadPermissions(Arrays.asList("email", "public_profile"))
        checkLoginStatus()
        loginButton!!.registerCallback(callbackManager, object : FacebookCallback<LoginResult?> {
            override fun onSuccess(loginResult: LoginResult?) {}
            override fun onCancel() {}
            override fun onError(error: FacebookException) {}
        })
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        callbackManager!!.onActivityResult(requestCode, resultCode, data)
        super.onActivityResult(requestCode, resultCode, data)
    }

    var tokenTracker: AccessTokenTracker = object : AccessTokenTracker() {
        override fun onCurrentAccessTokenChanged(oldAccessToken: AccessToken?, currentAccessToken: AccessToken?) {
            if (currentAccessToken == null) {
                txtName!!.text = ""
                txtEmail!!.text = ""
                circleImageView!!.setImageResource(0)
                Toast.makeText(this@MainActivity, "User Logged out", Toast.LENGTH_LONG).show()
            } else loadUserProfile(currentAccessToken)
        }
    }

    private fun loadUserProfile(newAccessToken: AccessToken) {
        val request = GraphRequest.newMeRequest(newAccessToken) { `object`, response ->
            try {
                val first_name = `object`.getString("first_name")
                val last_name = `object`.getString("last_name")
                val email = `object`.getString("email")
                val id = `object`.getString("id")
                val image_url = "https://graph.facebook.com/$id/picture?type=normal"
                txtEmail!!.text = email
                txtName!!.text = "$first_name $last_name"
                val requestOptions = RequestOptions()
                requestOptions.dontAnimate()
                Glide.with(this@MainActivity).load(image_url).into(circleImageView!!)
            } catch (e: JSONException) {
                e.printStackTrace()
            }
        }
        val parameters = Bundle()
        parameters.putString("fields", "first_name,last_name,email,id")
        request.parameters = parameters
        request.executeAsync()
    }

    private fun checkLoginStatus() {
        if (AccessToken.getCurrentAccessToken() != null) {
            loadUserProfile(AccessToken.getCurrentAccessToken())
        }
    }
}