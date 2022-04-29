import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.MethodChannel
import tech.shmy.headless_webview.HeadlessWebview

class HeadlessWebviewManager {
    companion object {
        var webViews: HashMap<Int, HeadlessWebview> = HashMap()
        fun run(id: Int, url: String, channel: MethodChannel, context: Context, activity: Activity?): Int {
            val headlessWebview = HeadlessWebview(id, url, channel, context, activity)
            webViews[id] = headlessWebview
            return id
        }
    }
}