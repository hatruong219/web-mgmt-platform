#!/usr/bin/env node
/**
 * convert-n5.js
 * Chuyển file N5.csv (format cũ) sang format chuẩn để import vào web-mgmt-platform
 *
 * Format cũ (N5.csv):
 *   漢字 | ひらがな | Hán Việt | Nghĩa | Chưa thuộc | Từ loại
 *
 * Format mới (output):
 *   word | reading | meaning_vi | meaning_en | part_of_speech | jlpt_level | tags
 *
 * Chạy:
 *   node scripts/convert-n5.js ~/Downloads/N5.csv
 *   node scripts/convert-n5.js ~/Downloads/N5.csv > output.csv
 */

const fs = require('fs')
const path = require('path')

// ─── Map từ loại tiếng Việt → tiếng Nhật ────────────────────────────────────
const POS_MAP = {
    'n': '名詞',   // Noun
    'v': '動詞',   // Verb
    'a': '形容詞', // Adjective
    'adv': '副詞',   // Adverb
    'p': '助詞',   // Particle
    'pn': '代名詞', // Pronoun
    'exp': '感動詞', // Expression / Interjection
    'con': '接続詞', // Conjunction
    'num': '数詞',   // Number
    'pre': '接頭辞', // Prefix
    'suf': '接尾辞', // Suffix
}

function mapPos(raw) {
    if (!raw) return ''
    const key = raw.toLowerCase().trim()
    return POS_MAP[key] || raw.trim()
}

function parseCSVLine(line) {
    const cols = []
    let cur = '', inQuote = false
    for (const ch of line) {
        if (ch === '"') { inQuote = !inQuote; continue }
        if (ch === ',' && !inQuote) { cols.push(cur.trim()); cur = ''; continue }
        cur += ch
    }
    cols.push(cur.trim())
    return cols
}

function escapeCSV(val) {
    if (!val) return ''
    const s = String(val).trim()
    return s.includes(',') || s.includes('"') || s.includes('\n') ? `"${s.replace(/"/g, '""')}"` : s
}

function main() {
    const inputFile = process.argv[2]
    if (!inputFile) {
        console.error('Usage: node scripts/convert-n5.js <input.csv> [output.csv]')
        process.exit(1)
    }

    const outputFile = process.argv[3]
    const raw = fs.readFileSync(path.resolve(inputFile), 'utf8')
    const lines = raw.trim().split('\n').filter(l => l.trim())

    // Skip header
    const dataLines = lines.slice(1)

    const header = 'word,reading,meaning_vi,meaning_en,part_of_speech,jlpt_level,tags'
    const rows = [header]
    let skipped = 0

    for (const line of dataLines) {
        const cols = parseCSVLine(line)
        // Format cũ: 漢字(0) | ひらがな(1) | Hán Việt(2) | Nghĩa(3) | Chưa thuộc(4) | Từ loại(5)
        const word = cols[0] || ''
        const reading = cols[1] || ''
        const hanViet = cols[2] || ''  // có thể để vào meaning_en hoặc skip
        const nghia = cols[3] || ''
        const posRaw = cols[5] || ''

        if (!word || !nghia) { skipped++; continue }

        const row = [
            escapeCSV(word),
            escapeCSV(reading),
            escapeCSV(nghia),
            escapeCSV(hanViet),   // dùng Hán Việt làm meaning_en
            escapeCSV(mapPos(posRaw)),
            'jlpt-n5',                  // jlpt _level fix cứng là N5
            'jlpt-n5',                  // tags
        ]
        rows.push(row.join(','))
    }

    const output = rows.join('\n')

    if (outputFile) {
        fs.writeFileSync(path.resolve(outputFile), output, 'utf8')
        console.log(`✅ Đã convert ${rows.length - 1} từ → ${outputFile}`)
        if (skipped) console.log(`⚠  Bỏ qua ${skipped} dòng thiếu dữ liệu`)
    } else {
        console.log(output)
    }
}

main()
