import android.content.Context
import io.flutter.plugin.common.MethodChannel
import tech.shmy.headless_webview.HeadlessWebview

class HeadlessWebviewManager {
    companion object {
        var webViews: HashMap<Int, HeadlessWebview> = HashMap()
        fun run(id: Int, url: String, channel: MethodChannel, context: Context): Int {
            val headlessWebview = HeadlessWebview(id, url, channel, context)
            webViews[id] = headlessWebview
            return id
        }
    }
}