import android.content.Context
import io.flutter.plugin.common.MethodChannel
import tech.shmy.headless_webview.HeadlessWebview

class HeadlessWebviewManager {
    companion object {
        var webViews: HashMap<Int, HeadlessWebview> = HashMap()
        var id: Int = -2022
        fun run(url: String, channel: MethodChannel, context: Context): Int {
            id += 1
            if (id > 2022) {
                id = -2022
            }
            val headlessWebview = HeadlessWebview(id, url, channel, context)
            webViews[id] = headlessWebview
            return id
        }
    }
}