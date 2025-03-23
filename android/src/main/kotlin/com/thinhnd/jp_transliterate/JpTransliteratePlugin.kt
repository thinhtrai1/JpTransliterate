package com.thinhnd.jp_transliterate

import com.atilika.kuromoji.ipadic.Tokenizer
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** JpTransliteratePlugin */
class JpTransliteratePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var tokenizer: Tokenizer

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "jp_transliterate")
        channel.setMethodCallHandler(this)

        tokenizer = Tokenizer()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "transliterate" -> {
                call.argument<String>("kanji").let {
                    result.success(transliterate(it?.trim()))
                }
            }

            "transliterateWords" -> {
                call.argument<String>("kanji").let {
                    result.success(transliterateWords(it?.trim()))
                }
            }

            "katakanaToRomaji" -> {
                call.argument<String>("katakana").let {
                    result.success(katakanaToRomaji(it?.trim()))
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun transliterate(kanji: String?): HashMap<String, String>? {
        if (kanji == null) {
            return null
        }
        if (kanji.isEmpty()) {
            return hashMapOf()
        }
        val romaji = StringBuilder()
        val katakana = StringBuilder()
        tokenizer.tokenize(kanji).onEach { token ->
            val reading = token.reading
            if (reading == "*") {
                val surface = token.surface
                katakana.append(surface)
                romaji.append(surface)
                if (surface != "\n") {
                    romaji.append(" ")
                }
            } else {
                katakana.append(reading)
                var i = 0
                while (i < reading.length) {
                    if (i < reading.length - 1) {
                        val char = reading.substring(i, i + 2)
                        if (char.first() == smallTsu) {
                            val nextChar = reading[i + 1].toString()
                            if (katakanaRomajiDictionary.containsKey(nextChar)) {
                                romaji.append(katakanaRomajiDictionary[nextChar]?.first())
                                i++
                                continue
                            }
                        } else if (katakanaRomajiDictionary.containsKey(char)) {
                            romaji.append(katakanaRomajiDictionary[char])
                            i += 2
                            continue
                        }
                    }
                    val char = reading[i].toString()
                    romaji.append(katakanaRomajiDictionary[char] ?: char)
                    i++
                }
                romaji.append(" ")
            }
        }
        val hiragana = katakana.map {
            if (it.code in 0x30A1..0x30FA) (it.code - 0x60).toChar() else it
        }.joinToString("")
        return hashMapOf(
            "kanji" to kanji,
            "romaji" to romaji.toString().replace("。", ".").replace("、", ",")
                .replace(Regex(" +"), " ").replace(Regex(" (?=[.,!?;:])"), "").trim(),
            "katakana" to katakana.toString().replace(".", "。").replace(",", "、"),
            "hiragana" to hiragana.replace(".", "。").replace(",", "、"),
        )
    }

    private fun transliterateWords(kanji: String?): List<HashMap<String, String>>? {
        if (kanji == null) {
            return null
        }
        if (kanji.isEmpty()) {
            return listOf()
        }
        return tokenizer.tokenize(kanji).map { token ->
            val reading = token.reading
            if (reading == "*") {
                val surface = token.surface
                hashMapOf(
                    "kanji" to surface,
                    "romaji" to surface.replace("。", ".").replace("、", ","),
                    "katakana" to surface.replace(".", "。").replace(",", "、"),
                    "hiragana" to surface.replace(".", "。").replace(",", "、"),
                )
            } else {
                var i = 0
                val romaji = StringBuilder()
                while (i < reading.length) {
                    if (i < reading.length - 1) {
                        val char = reading.substring(i, i + 2)
                        if (char.first() == smallTsu) {
                            val nextChar = reading[i + 1].toString()
                            if (katakanaRomajiDictionary.containsKey(nextChar)) {
                                romaji.append(katakanaRomajiDictionary[nextChar]?.first())
                                i++
                                continue
                            }
                        } else if (katakanaRomajiDictionary.containsKey(char)) {
                            romaji.append(katakanaRomajiDictionary[char])
                            i += 2
                            continue
                        }
                    }
                    val char = reading[i].toString()
                    romaji.append(katakanaRomajiDictionary[char] ?: char)
                    i++
                }
                val hiragana = reading.map {
                    if (it.code in 0x30A1..0x30FA) (it.code - 0x60).toChar() else it
                }.joinToString("")
                hashMapOf(
                    "kanji" to token.surface,
                    "romaji" to romaji.toString().replace("。", ".").replace("、", ","),
                    "katakana" to reading.replace(".", "。").replace(",", "、"),
                    "hiragana" to hiragana.replace(".", "。").replace(",", "、"),
                )
            }
        }
    }

    private fun katakanaToRomaji(katakana: String?): String? {
        if (katakana == null) {
            return null
        }
        if (katakana.isEmpty()) {
            return ""
        }
        val romaji = StringBuilder()
        tokenizer.tokenize(katakana).onEach { token ->
            val reading = token.reading
            if (!reading.isNullOrEmpty()) {
                var i = 0
                while (i < reading.length) {
                    if (i < reading.length - 1) {
                        val char = reading.substring(i, i + 2)
                        if (char.first() == smallTsu) {
                            val nextChar = reading[i + 1].toString()
                            if (katakanaRomajiDictionary.containsKey(nextChar)) {
                                romaji.append(katakanaRomajiDictionary[nextChar]?.first())
                                i++
                                continue
                            }
                        } else if (katakanaRomajiDictionary.containsKey(char)) {
                            romaji.append(katakanaRomajiDictionary[char])
                            i += 2
                            continue
                        }
                    }
                    val char = reading[i].toString()
                    romaji.append(katakanaRomajiDictionary[char] ?: char)
                    i++
                }
                romaji.append(" ")
            }
        }
        return romaji.toString().replace("。", ".").replace("、", ",").trim()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private val katakanaRomajiDictionary = mapOf(
        "ア" to "a", "イ" to "i", "ウ" to "u", "エ" to "e", "オ" to "o",
        "カ" to "ka", "キ" to "ki", "ク" to "ku", "ケ" to "ke", "コ" to "ko",
        "サ" to "sa", "シ" to "shi", "ス" to "su", "セ" to "se", "ソ" to "so",
        "タ" to "ta", "チ" to "chi", "ツ" to "tsu", "テ" to "te", "ト" to "to",
        "ナ" to "na", "ニ" to "ni", "ヌ" to "nu", "ネ" to "ne", "ノ" to "no",
        "ハ" to "ha", "ヒ" to "hi", "フ" to "fu", "ヘ" to "he", "ホ" to "ho",
        "マ" to "ma", "ミ" to "mi", "ム" to "mu", "メ" to "me", "モ" to "mo",
        "ヤ" to "ya", "ユ" to "yu", "ヨ" to "yo",
        "ラ" to "ra", "リ" to "ri", "ル" to "ru", "レ" to "re", "ロ" to "ro",
        "ワ" to "wa", "ヲ" to "wo", "ン" to "n",
        "ガ" to "ga", "ギ" to "gi", "グ" to "gu", "ゲ" to "ge", "ゴ" to "go",
        "ザ" to "za", "ジ" to "ji", "ズ" to "zu", "ゼ" to "ze", "ゾ" to "zo",
        "ダ" to "da", "ヂ" to "ji", "ヅ" to "zu", "デ" to "de", "ド" to "do",
        "バ" to "ba", "ビ" to "bi", "ブ" to "bu", "ベ" to "be", "ボ" to "bo",
        "パ" to "pa", "ピ" to "pi", "プ" to "pu", "ペ" to "pe", "ポ" to "po",
        "キャ" to "kya", "キュ" to "kyu", "キョ" to "kyo",
        "シャ" to "sha", "シュ" to "shu", "ショ" to "sho",
        "チャ" to "cha", "チュ" to "chu", "チョ" to "cho",
        "ニャ" to "nya", "ニュ" to "nyu", "ニョ" to "nyo",
        "ヒャ" to "hya", "ヒュ" to "hyu", "ヒョ" to "hyo",
        "ミャ" to "mya", "ミュ" to "myu", "ミョ" to "myo",
        "リャ" to "rya", "リュ" to "ryu", "リョ" to "ryo",
        "ギャ" to "gya", "ギュ" to "gyu", "ギョ" to "gyo",
        "ジャ" to "ja", "ジュ" to "ju", "ジョ" to "jo",
        "ビャ" to "bya", "ビュ" to "byu", "ビョ" to "byo",
        "ピャ" to "pya", "ピュ" to "pyu", "ピョ" to "pyo",
        "ッ" to "~tsu"
    )

    private val smallTsu = 'ッ'
}
