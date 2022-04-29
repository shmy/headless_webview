package tech.shmy.headless_webview

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.view.ViewGroup
import android.webkit.WebResourceRequest
import android.webkit.WebResourceResponse
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.MethodChannel

@SuppressLint("SetJavaScriptEnabled")
class HeadlessWebview(
    id: Int,
    private val url: String,
    channel: MethodChannel,
    context: Context,
    private val activity: Activity?,
) {
    var webView: WebView = WebView(context)

    init {
        webView.settings.javaScriptEnabled = true
        webView.settings.loadWithOverviewMode = true
        webView.settings.domStorageEnabled = true
        webView.webViewClient = HeadlessWebviewClient(id, channel)
        webView.loadUrl(url)
        activity?.addContentView(
            webView,
            ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
        )
        println("HeadlessWebView: $url is started")
    }

    fun dispose() {
        if (activity != null) {
            (webView.parent as ViewGroup).removeView(webView)
        }
        webView.destroy()
        println("HeadlessWebView: $url is disposed")
    }
}

class HeadlessWebviewClient(private var id: Int, private var channel: MethodChannel) :
    WebViewClient() {
    @SuppressLint("NewApi")
    override fun shouldInterceptRequest(
        view: WebView?,
        request: WebResourceRequest?
    ): WebResourceResponse? {
        if (request != null) {
            Handler(Looper.getMainLooper()).post {
                channel.invokeMethod(
                    "intercepted",
                    mapOf("url" to request.url.toString(), "id" to id)
                )
            }
        }
        return super.shouldInterceptRequest(view, request)
    }
}