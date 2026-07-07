#!/usr/bin/env python3
"""『FBC Press: Hotwire』の図版生成。
本書は図が多く（46 点）、元の作図は手描きの SVG として scripts/figures/src/ に持つ。
このスクリプトは元 SVG を入力に、FBC Press の図版規約へ正規化して
manuscript/assets/ に出力する（1 コマンドで全図を再生成できる）。

正規化の内容（FBC_Press/FIGURE_GUIDE.md・ASSET_RULES.md 準拠）:
  - 配色を固定パレットの役割色へ写像する（書籍間で配色を揃える）。
  - フォントを sans-serif に統一する（個別書体名 Hiragino 等を外す）。
  - 焼き込まれた図タイトル（class="title" のテキスト）を除去する。
    図番号・キャプションは本文側で管理する。
  - <title>/<desc> をやめ、role="img" + aria-label（主張の 1 文）に一本化する。
図の骨格（座標・レイアウト）は元 SVG を尊重し、見た目の規約だけを揃える。
"""
import html, re, pathlib

ROOT = pathlib.Path(__file__).resolve().parents[2]
SRC = pathlib.Path(__file__).resolve().parent / "src"
ASSETS = ROOT / "manuscript/assets"
ASSETS.mkdir(parents=True, exist_ok=True)

# 固定パレット（FIGURE_GUIDE の役割別カラー）
INK="#1f2933"; SUB="#52606d"; ACC="#3a6ea5"; DANGER="#b23a48"
NEUT="#eef1f5"; BLUE="#dce9f2"; WARM="#f4e9dc"; LINE="#b8c2cc"
WARM_ST="#c9a26b"; DANGER_FILL="#f6e7e9"; DANGER_ST="#c9727f"

# 元図の色 → 役割色への写像
COLOR_MAP = {
    # 文字・線
    "#0f172a": INK, "#1e293b": INK,
    "#334155": SUB, "#475569": SUB, "#64748b": SUB,
    "#94a3b8": LINE, "#cbd5e1": LINE, "#d8e1ea": LINE,
    "#e2e8f0": NEUT, "#f8fafc": NEUT, "#f8fbfe": NEUT, "#f1f5f9": NEUT,
    # 主役・アクセント（青／シアン／緑をまとめて ACC）
    "#0284c7": ACC, "#0369a1": ACC, "#075985": ACC, "#06b6d4": ACC,
    "#0e7490": ACC, "#0891b2": ACC, "#60a5fa": ACC, "#3b82f6": ACC,
    "#2563eb": ACC, "#38bdf8": ACC, "#93c5fd": ACC,
    "#10b981": ACC, "#059669": ACC, "#047857": ACC, "#16a34a": ACC,
    # アクセントの面
    "#dbeafe": BLUE, "#eff6ff": BLUE, "#f0f9ff": BLUE, "#ecfeff": BLUE,
    "#e0f2fe": BLUE, "#bae6fd": BLUE, "#dcfce7": BLUE, "#ccfbf1": BLUE,
    "#ecfdf5": NEUT, "#f0fdf4": NEUT,
    # 否定・失敗
    "#ef4444": DANGER, "#dc2626": DANGER, "#b91c1c": DANGER,
    "#fee2e2": DANGER_FILL, "#fef2f2": DANGER_FILL, "#fff7f7": DANGER_FILL,
    "#fca5a5": DANGER_ST,
    # 注意（アンバー／紫は WARM 系へ）
    "#f59e0b": WARM_ST, "#d97706": WARM_ST, "#b45309": WARM_ST, "#92400e": WARM_ST,
    "#fef3c7": WARM, "#fffbeb": WARM, "#fff7ed": WARM, "#fed7aa": WARM_ST, "#fde68a": WARM_ST,
    "#a78bfa": WARM_ST, "#ede9fe": WARM, "#7c3aed": ACC, "#8b5cf6": ACC,
}

FONT_RE = re.compile(r"""['"]Hiragino Sans['"]\s*,\s*['"]Yu Gothic['"]\s*,\s*sans-serif""")
MONO_RE = re.compile(r"""['"]SFMono-Regular['"][^;"']*monospace""")

def esc(s): return html.escape(str(s), quote=True)

def normalize(text):
    s = text
    # 1) フォント統一
    s = FONT_RE.sub("sans-serif", s)
    s = MONO_RE.sub("ui-monospace, monospace", s)
    s = s.replace("'Hiragino Sans', 'Yu Gothic', sans-serif", "sans-serif")
    # 2) 配色を役割色へ写像（大文字小文字を無視）
    def repl_color(m):
        return COLOR_MAP.get(m.group(0).lower(), m.group(0))
    s = re.sub(r"#[0-9a-fA-F]{6}", repl_color, s)
    # 3) 焼き込まれたタイトル（見出しテキスト）を除去
    s = re.sub(r'<text[^>]*class="title"[^>]*>.*?</text>', "", s, flags=re.S)
    # 4) aria-label へ一本化
    m = re.search(r"<desc[^>]*>(.*?)</desc>", s, flags=re.S)
    desc = re.sub(r"\s+", " ", m.group(1)).strip() if m else ""
    s = re.sub(r"<title[^>]*>.*?</title>\s*", "", s, flags=re.S)
    s = re.sub(r"<desc[^>]*>.*?</desc>\s*", "", s, flags=re.S)
    if desc:
        s = re.sub(r'aria-labelledby="[^"]*"', f'aria-label="{esc(desc)}"', s)
    # 5) タイトル除去で空いた上部の余白を詰める（viewBox を下げ、幅高さ属性は外す）
    s = crop_top(s, 46)
    return s

def crop_top(s, crop):
    end = s.index(">")
    tag = s[:end]
    mv = re.search(r'viewBox="0 0 (\d+(?:\.\d+)?) (\d+(?:\.\d+)?)"', tag)
    if mv:
        w, h = mv.group(1), float(mv.group(2))
        nh = h - crop
        nh = int(nh) if nh == int(nh) else nh
        tag = tag.replace(mv.group(0), f'viewBox="0 {crop} {w} {nh}"')
    tag = re.sub(r'\s(?:width|height)="[0-9.]+"', "", tag)
    return tag + s[end:]

def main():
    n = 0
    for src in sorted(SRC.glob("fig-*.svg")):
        out = normalize(src.read_text(encoding="utf-8"))
        (ASSETS / src.name).write_text(out, encoding="utf-8")
        n += 1
    print(f"wrote {n} figures to {ASSETS}")

if __name__ == "__main__":
    main()
