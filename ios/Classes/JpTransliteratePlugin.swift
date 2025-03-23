import Flutter
import UIKit
import Foundation

public class JpTransliteratePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "jp_transliterate", binaryMessenger: registrar.messenger())
        let instance = JpTransliteratePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "transliterate":
            if let kanji = call.arguments as? [String: Any], let text = kanji["kanji"] as? String {
                result(transliterate(text.trimmingCharacters(in: .whitespacesAndNewlines)))
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing 'kanji' argument", details: nil))
            }

        case "transliterateWords":
            if let kanji = call.arguments as? [String: Any], let text = kanji["kanji"] as? String {
                result(transliterateWords(text.trimmingCharacters(in: .whitespacesAndNewlines)))
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing 'kanji' argument", details: nil))
            }

        case "katakanaToRomaji":
            if let katakana = call.arguments as? [String: Any], let text = katakana["katakana"] as? String {
                result(katakanaToRomaji(text.trimmingCharacters(in: .whitespacesAndNewlines)))
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing 'katakana' argument", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func transliterate(_ input: String) -> [String:Any] {
        let trimmed: String = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let tokenizer: CFStringTokenizer =
        CFStringTokenizerCreate(kCFAllocatorDefault,
                                trimmed as CFString,
                                CFRangeMake(0, trimmed.utf16.count),
                                kCFStringTokenizerUnitWordBoundary,
                                Locale(identifier: "ja") as CFLocale)
        var romaji: String = ""
        var katakana: String = ""
        var hiragana: String = ""
        while !CFStringTokenizerAdvanceToNextToken(tokenizer).isEmpty {
            let original = getCurrentToken(in: input, tokenizer: tokenizer)
            let tokenRomaji = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription) as? String
            if tokenRomaji?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                let tokenKatakana = tokenRomaji.map { $0.mutableCopy() } as? NSMutableString ?? NSMutableString()
                let tokenHiragana = tokenRomaji.map { $0.mutableCopy() } as? NSMutableString ?? NSMutableString()
                CFStringTransform(tokenKatakana, nil, kCFStringTransformLatinKatakana, false)
                CFStringTransform(tokenHiragana, nil, kCFStringTransformLatinHiragana, false)
                romaji.append(tokenRomaji ?? "")
                romaji.append(" ")
                katakana.append(tokenKatakana as String)
                hiragana.append(tokenHiragana as String)
            } else {
                romaji.append(original)
                if original != "\n" {
                    romaji.append(" ")
                }
                katakana.append(original)
                hiragana.append(original)
            }
        }
        return [
            "kanji": input,
            "romaji": romaji.replacingOccurrences(of: "｡", with: ".").replacingOccurrences(of: "､", with: ",").replacingOccurrences(of: " +", with: " ", options: .regularExpression).replacingOccurrences(of: " (?=[.,!?;:])", with: "", options: .regularExpression).trimmingCharacters(in: .whitespacesAndNewlines),
            "katakana": katakana.replacingOccurrences(of: "｡", with: "。").replacingOccurrences(of: "､", with: "、"),
            "hiragana": hiragana.replacingOccurrences(of: "｡", with: "。").replacingOccurrences(of: "､", with: "、"),
        ]
    }

    private func transliterateWords(_ input: String) -> [[String:Any]] {
        let trimmed: String = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let tokenizer: CFStringTokenizer =
        CFStringTokenizerCreate(kCFAllocatorDefault,
                                trimmed as CFString,
                                CFRangeMake(0, trimmed.utf16.count),
                                kCFStringTokenizerUnitWordBoundary,
                                Locale(identifier: "ja") as CFLocale)
        var words: [[String: Any]] = []
        while !CFStringTokenizerAdvanceToNextToken(tokenizer).isEmpty {
            let tokenRomaji = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription) as? String
            let tokenKatakana = tokenRomaji.map { $0.mutableCopy() } as? NSMutableString ?? NSMutableString()
            let tokenHiragana = tokenRomaji.map { $0.mutableCopy() } as? NSMutableString ?? NSMutableString()
            CFStringTransform(tokenKatakana, nil, kCFStringTransformLatinKatakana, false)
            CFStringTransform(tokenHiragana, nil, kCFStringTransformLatinHiragana, false)
            let kanji = getCurrentToken(in: input, tokenizer: tokenizer)
            words.append(
                [
                    "kanji": kanji,
                    "romaji": tokenRomaji?.replacingOccurrences(of: "｡", with: ".").replacingOccurrences(of: "､", with: ",") ?? "",
                    "katakana": (tokenKatakana as String).replacingOccurrences(of: "｡", with: "。").replacingOccurrences(of: "､", with: "、"),
                    "hiragana": (tokenHiragana as String).replacingOccurrences(of: "｡", with: "。").replacingOccurrences(of: "､", with: "、"),
                ]
            )
        }
        return words
    }

    private func getCurrentToken(in text: String, tokenizer: CFStringTokenizer) -> String {
        let range = CFStringTokenizerGetCurrentTokenRange(tokenizer)
        guard range.location != kCFNotFound else { return "" }

        let startIndex = text.index(text.startIndex, offsetBy: range.location)
        let endIndex = text.index(startIndex, offsetBy: range.length)

        return String(text[startIndex..<endIndex])
    }

    private func katakanaToRomaji(_ input: String) -> String {
        let trimmed: String = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let tokenizer: CFStringTokenizer =
        CFStringTokenizerCreate(kCFAllocatorDefault,
                                trimmed as CFString,
                                CFRangeMake(0, trimmed.utf16.count),
                                kCFStringTokenizerUnitWordBoundary,
                                Locale(identifier: "ja") as CFLocale)
        var romaji: String = ""
        while !CFStringTokenizerAdvanceToNextToken(tokenizer).isEmpty {
            let tokenRomaji = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription) as? String
            romaji.append(tokenRomaji ?? "")
            romaji.append(" ")
        }
        return romaji.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "｡", with: ".").replacingOccurrences(of: "､", with: ",")
    }
}
