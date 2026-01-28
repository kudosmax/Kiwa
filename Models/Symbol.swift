import Foundation

struct Symbol: Codable, Identifiable, Equatable, Sendable {
    let id: UUID
    var opening: String
    var closing: String?
    var label: String
    var usage: String
    var slotNumber: Int

    var isPaired: Bool {
        guard let closing else { return false }
        return !closing.isEmpty
    }

    var displayText: String {
        if isPaired, let closing {
            return "\(opening)\(closing)"
        } else {
            return opening
        }
    }

    init(id: UUID = UUID(), opening: String, closing: String? = nil, label: String, usage: String = "", slotNumber: Int) {
        self.id = id
        self.opening = opening
        self.closing = closing
        self.label = label
        self.usage = usage
        self.slotNumber = slotNumber
    }

    // Backward-compatible decoding for data saved without `usage`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        opening = try container.decode(String.self, forKey: .opening)
        closing = try container.decodeIfPresent(String.self, forKey: .closing)
        label = try container.decode(String.self, forKey: .label)
        usage = try container.decodeIfPresent(String.self, forKey: .usage) ?? ""
        slotNumber = try container.decode(Int.self, forKey: .slotNumber)
    }

    static let defaultSymbols: [Symbol] = [
        Symbol(opening: "「", closing: "」", label: String(localized: "preset.paper"), usage: String(localized: "preset.paper.usage"), slotNumber: 1),
        Symbol(opening: "〈", closing: "〉", label: String(localized: "preset.work"), usage: String(localized: "preset.work.usage"), slotNumber: 2),
        Symbol(opening: "『", closing: "』", label: String(localized: "preset.book"), usage: String(localized: "preset.book.usage"), slotNumber: 3),
        Symbol(opening: "《", closing: "》", label: String(localized: "preset.film"), usage: String(localized: "preset.film.usage"), slotNumber: 4),
        Symbol(opening: "—", closing: nil, label: String(localized: "preset.emdash"), usage: String(localized: "preset.emdash.usage"), slotNumber: 5),
        Symbol(opening: "·", closing: nil, label: String(localized: "preset.middledot"), usage: String(localized: "preset.middledot.usage"), slotNumber: 6),
        Symbol(opening: "……", closing: nil, label: String(localized: "preset.ellipsis"), usage: String(localized: "preset.ellipsis.usage"), slotNumber: 7),
        Symbol(opening: "\u{201C}", closing: "\u{201D}", label: String(localized: "preset.quote"), usage: String(localized: "preset.quote.usage"), slotNumber: 8),
        Symbol(opening: "\u{2018}", closing: "\u{2019}", label: String(localized: "preset.emphasis"), usage: String(localized: "preset.emphasis.usage"), slotNumber: 9),
    ]
}
