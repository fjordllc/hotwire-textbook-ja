#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"

ROOT = File.expand_path("..", __dir__)
MANUSCRIPT = File.join(ROOT, "manuscript")
FIGURES_DIR = File.join(MANUSCRIPT, "figures")

FileUtils.mkdir_p(FIGURES_DIR)

class Svg
  def initialize(width:, height:, title:, desc:)
    @width = width
    @height = height
    @title = title
    @desc = desc
    @body = +""
  end

  def rect(x, y, w, h, fill:, stroke:, rx: 14, sw: 2)
    @body << %(<rect x="#{x}" y="#{y}" width="#{w}" height="#{h}" rx="#{rx}" fill="#{fill}" stroke="#{stroke}" stroke-width="#{sw}"/>)
  end

  def text(x, y, value, size: 18, weight: 600, fill: "#0f172a", anchor: "start")
    @body << %(<text x="#{x}" y="#{y}" text-anchor="#{anchor}" style="font: #{weight} #{size}px 'Hiragino Sans', 'Yu Gothic', sans-serif; fill: #{fill};">)
    value.to_s.split("\n").each_with_index do |line, idx|
      @body << %(<tspan x="#{x}" dy="#{idx.zero? ? 0 : size + 4}">#{escape(line)}</tspan>)
    end
    @body << %(</text>)
  end

  def line(x1, y1, x2, y2, stroke: "#94a3b8", sw: 2, dash: nil, marker: nil)
    attrs = [
      %(x1="#{x1}"), %(y1="#{y1}"), %(x2="#{x2}"), %(y2="#{y2}"),
      %(stroke="#{stroke}"), %(stroke-width="#{sw}"), %(fill="none")
    ]
    attrs << %(stroke-dasharray="#{dash}") if dash
    attrs << %(marker-end="url(##{marker})") if marker
    @body << %(<line #{attrs.join(" ")} />)
  end

  def arrow(x1, y1, x2, y2, stroke: "#0284c7", sw: 3)
    line(x1, y1, x2, y2, stroke: stroke, sw: sw, marker: "arrow")
  end

  def panel(x, y, w, h, fill: "#f8fafc", stroke: "#cbd5e1")
    rect(x, y, w, h, fill: fill, stroke: stroke, rx: 18, sw: 2)
  end

  def badge(x, y, w, h, text_value, fill: "#dbeafe", stroke: "#0284c7")
    rect(x, y, w, h, fill: fill, stroke: stroke, rx: 12, sw: 2)
    text(x + w / 2.0, y + h / 2.0 + 6, text_value, size: 15, weight: 700, anchor: "middle")
  end

  def to_svg
    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" width="#{@width}" height="#{@height}" viewBox="0 0 #{@width} #{@height}" role="img" aria-labelledby="title desc">
        <title id="title">#{escape(@title)}</title>
        <desc id="desc">#{escape(@desc)}</desc>
        <defs>
          <marker id="arrow" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
            <path d="M0,0 L8,4 L0,8 z" fill="#0284c7"/>
          </marker>
        </defs>
        <rect width="#{@width}" height="#{@height}" fill="#ffffff"/>
        <style>
          .title { font: 700 28px 'Hiragino Sans', 'Yu Gothic', sans-serif; fill: #0f172a; }
          .small { font: 600 15px 'Hiragino Sans', 'Yu Gothic', sans-serif; fill: #475569; }
          .tiny { font: 500 13px 'Hiragino Sans', 'Yu Gothic', sans-serif; fill: #64748b; }
        </style>
        <text x="44" y="42" class="title">#{escape(@title)}</text>
        #{@body}
      </svg>
    SVG
  end

  private

  def escape(text)
    text.to_s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;").gsub('"', "&quot;")
  end
end

FIGURES = {
  "fig-4-2" => {
    width: 1200, height: 420,
    title: "主要画面と使う技術の対応",
    desc: "Relay の主要画面に Turbo Drive、Frames、Streams、Stimulus、Action Cable を対応づけた図。",
    render: lambda { |s|
      s.panel(36, 84, 1128, 280)
      cards = [
        ["プロジェクト一覧 / 詳細", "Drive"],
        ["タスク一覧（リスト / ボード）", "Frames + Stimulus"],
        ["タスク詳細（サイドバー）", "Frames"],
        ["タスク作成 / 編集", "Frames + Streams + Stimulus"],
        ["コメント欄", "Streams + Action Cable"],
        ["通知トースト / flash", "Streams + Stimulus + Action Cable"]
      ]
      cards.each_with_index do |(a, b), i|
        x = 66 + (i % 3) * 360
        y = 120 + (i / 3) * 120
        s.rect(x, y, 300, 84, fill: i.even? ? "#f8fafc" : "#ecfeff", stroke: i.even? ? "#cbd5e1" : "#06b6d4", rx: 16)
        s.text(x + 150, y + 30, a, size: 16, weight: 700, anchor: "middle")
        s.badge(x + 92, y + 44, 116, 24, b)
      end
      s.text(600, 102, "1 画面に複数の技術を組み合わせる", size: 18, weight: 700, anchor: "middle")
    }
  },
  "fig-5-1" => {
    width: 1200, height: 460,
    title: "Rails 認証ジェネレータの生成物",
    desc: "bin/rails generate authentication が作る User、Session、Current、各コントローラやメール周辺を示す図。",
    render: lambda { |s|
      s.panel(36, 84, 1128, 300)
      s.rect(514, 170, 172, 86, fill: "#ecfeff", stroke: "#06b6d4", rx: 18)
      s.text(600, 202, "authentication", size: 20, weight: 700, anchor: "middle")
      s.text(600, 230, "ジェネレータ", size: 15, weight: 600, fill: "#0e7490", anchor: "middle")
      items = [
        ["User", 110, 110], ["Session", 320, 110], ["Current", 530, 110], ["SessionsController", 740, 110],
        ["PasswordsController", 950, 110], ["PasswordsMailer", 740, 300], ["views", 950, 300], ["routes", 530, 300]
      ]
      items.each do |name, x, y|
        s.rect(x, y, 160, 62, fill: name == "User" || name == "Session" ? "#eff6ff" : "#f8fafc", stroke: "#cbd5e1", rx: 14)
        s.text(x + 80, y + 38, name, size: 15, weight: 700, anchor: "middle")
        s.arrow(600, 214, x + 80, y + 31) unless %w[User Session].include?(name)
      end
      s.text(110, 360, "User は domain に近い", size: 14, weight: 700, fill: "#475569")
      s.text(860, 360, "他は認証インフラ", size: 14, weight: 700, fill: "#475569")
      s.text(1080, 202, "bcrypt", size: 15, weight: 700, fill: "#475569")
    }
  },
  "fig-6-1" => {
    width: 1200, height: 420,
    title: "importmap の読み込み経路",
    desc: "application.js から importmap.rb の pin を通じて Turbo と Stimulus が読み込まれる経路を示す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      s.rect(88, 160, 240, 84, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(208, 192, "application.js", size: 18, weight: 700, anchor: "middle")
      s.text(208, 220, 'import "@hotwired/turbo-rails"', size: 13, weight: 600, fill: "#475569", anchor: "middle")
      s.rect(392, 132, 240, 130, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.text(512, 164, "config/importmap.rb", size: 18, weight: 700, anchor: "middle")
      s.text(512, 194, "pin Turbo / Stimulus", size: 14, weight: 600, fill: "#475569", anchor: "middle")
      s.text(512, 222, "ビルド不要", size: 14, weight: 700, fill: "#0e7490", anchor: "middle")
      s.rect(700, 110, 168, 86, fill: "#f8fafc", stroke: "#cbd5e1", rx: 14)
      s.rect(906, 110, 168, 86, fill: "#f8fafc", stroke: "#cbd5e1", rx: 14)
      s.rect(700, 250, 168, 86, fill: "#f8fafc", stroke: "#cbd5e1", rx: 14)
      s.rect(906, 250, 168, 86, fill: "#f8fafc", stroke: "#cbd5e1", rx: 14)
      s.text(784, 158, "Turbo", size: 18, weight: 700, anchor: "middle")
      s.text(990, 158, "Stimulus", size: 18, weight: 700, anchor: "middle")
      s.text(784, 298, "controllers/", size: 18, weight: 700, anchor: "middle")
      s.text(990, 298, "eagerLoadControllersFrom", size: 16, weight: 700, anchor: "middle")
      s.arrow(328, 202, 384, 202)
      s.arrow(632, 202, 694, 158)
      s.arrow(632, 202, 694, 298)
      s.arrow(868, 158, 900, 158)
      s.arrow(868, 298, 900, 298)
    }
  },
  "fig-7-2" => {
    width: 1200, height: 420,
    title: "visit のシーケンス",
    desc: "リンククリックから fetch、HTML 応答、body 差し替えまでの流れを示すシーケンス図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      actors = [["User", 120], ["Turbo", 500], ["Server", 880]]
      actors.each do |name, x|
        s.rect(x - 76, 118, 152, 44, fill: "#f8fafc", stroke: "#cbd5e1", rx: 12)
        s.text(x, 146, name, size: 18, weight: 700, anchor: "middle")
      end
      y = 188
      s.arrow(196, y, 452, y)
      s.text(320, y - 12, "click", size: 13, weight: 700, fill: "#475569", anchor: "middle")
      s.arrow(548, y + 50, 832, y + 50)
      s.text(690, y + 38, "fetch", size: 13, weight: 700, fill: "#475569", anchor: "middle")
      s.arrow(832, y + 100, 548, y + 100)
      s.text(690, y + 88, "HTML", size: 13, weight: 700, fill: "#475569", anchor: "middle")
      s.arrow(452, y + 150, 548, y + 150)
      s.text(500, y + 138, "body 差し替え + head マージ", size: 13, weight: 700, fill: "#475569", anchor: "middle")
      s.text(600, 356, "サーバーは通常どおり HTML を返すだけ", size: 15, weight: 700, fill: "#0e7490", anchor: "middle")
    }
  },
  "fig-9-1" => {
    width: 1200, height: 420,
    title: "snapshot cache とプレビュー",
    desc: "ページ離脱時のスナップショット保存と、戻る時のプレビューから最新差し替えまでの流れを示す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      steps = [
        ["ページ A", "表示"],
        ["before-cache", "スナップショット保存"],
        ["ページ B", "遷移"],
        ["戻る", "プレビュー表示"],
        ["最新取得", "差し替え"]
      ]
      steps.each_with_index do |(a,b), i|
        x = 86 + i * 210
        s.rect(x, 150, 168, 86, fill: i == 3 ? "#ecfeff" : "#f8fafc", stroke: i == 3 ? "#06b6d4" : "#cbd5e1", rx: 16)
        s.text(x + 84, 182, a, size: 17, weight: 700, anchor: "middle")
        s.text(x + 84, 208, b, size: 13, weight: 600, fill: "#475569", anchor: "middle")
        s.arrow(x + 168, 193, x + 194, 193) if i < steps.length - 1
      end
      s.text(600, 118, "プレビューは古い内容を一瞬見せる", size: 18, weight: 700, fill: "#0f172a", anchor: "middle")
    }
  },
  "fig-9-2" => {
    width: 1200, height: 420,
    title: "replace と morph の違い",
    desc: "全置換と差分適用の違い、フォーカスやスクロールの保持を対比する図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      s.rect(82, 136, 466, 170, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(652, 136, 466, 170, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.text(315, 164, "replace", size: 20, weight: 700, anchor: "middle")
      s.text(885, 164, "morph", size: 20, weight: 700, fill: "#075985", anchor: "middle")
      s.rect(130, 198, 170, 44, fill: "#fee2e2", stroke: "#ef4444", rx: 10)
      s.rect(324, 198, 170, 44, fill: "#fee2e2", stroke: "#ef4444", rx: 10)
      s.text(215, 226, "全体を作り直す", size: 14, weight: 700, anchor: "middle")
      s.text(409, 226, "状態を失う", size: 14, weight: 700, anchor: "middle")
      s.rect(700, 198, 170, 44, fill: "#dbeafe", stroke: "#0284c7", rx: 10)
      s.rect(894, 198, 170, 44, fill: "#dbeafe", stroke: "#0284c7", rx: 10)
      s.text(785, 226, "変わった部分だけ", size: 14, weight: 700, anchor: "middle")
      s.text(979, 226, "状態を保つ", size: 14, weight: 700, anchor: "middle")
      s.text(600, 348, "data-turbo-permanent は触らない", size: 15, weight: 700, fill: "#475569", anchor: "middle")
    }
  },
  "fig-10-1" => {
    width: 1200, height: 420,
    title: "visit ライフサイクルのイベント",
    desc: "Turbo の visit 中に発火する主要イベントの順序と、フォームや morph のイベントを示すタイムライン。",
    render: lambda { |s|
      s.panel(36, 84, 1128, 260)
      events = %w[turbo:click before-visit visit before-render render load]
      x = 92
      events.each_with_index do |ev, i|
        s.rect(x, 170, 150, 54, fill: i == 0 ? "#ecfeff" : "#f8fafc", stroke: i == 0 ? "#06b6d4" : "#cbd5e1", rx: 14)
        s.text(x + 75, 203, ev, size: 14, weight: 700, anchor: "middle")
        s.arrow(x + 150, 197, x + 176, 197) if i < events.length - 1
        x += 176
      end
      s.text(600, 128, "中断できるのは before-visit", size: 18, weight: 700, fill: "#0f172a", anchor: "middle")
      s.text(600, 314, "submit-start / submit-end / before-morph-element も別レーン", size: 14, weight: 700, fill: "#475569", anchor: "middle")
    }
  },
  "fig-11-2" => {
    width: 1200, height: 420,
    title: "data-turbo-frame と _top",
    desc: "既定、自分以外の frame、_top での差し替え先の違いを示す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      s.rect(84, 124, 260, 180, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(460, 124, 260, 180, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(836, 124, 260, 180, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(214, 150, "既定", size: 18, weight: 700, anchor: "middle")
      s.text(214, 182, "自分の frame", size: 16, weight: 700, fill: "#475569", anchor: "middle")
      s.text(590, 150, "data-turbo-frame", size: 18, weight: 700, anchor: "middle")
      s.text(590, 182, "別 frame", size: 16, weight: 700, fill: "#475569", anchor: "middle")
      s.text(966, 150, "_top", size: 18, weight: 700, anchor: "middle")
      s.text(966, 182, "ページ全体", size: 16, weight: 700, fill: "#475569", anchor: "middle")
      s.arrow(344, 214, 452, 214)
      s.arrow(720, 214, 828, 214)
      s.text(600, 350, "frame だけ / 別 frame / 全体 visit", size: 15, weight: 700, fill: "#475569", anchor: "middle")
    }
  },
  "fig-12-1" => {
    width: 1200, height: 420,
    title: "インライン編集のフロー",
    desc: "タスク行の frame が表示と編集フォームを、保存・キャンセル・失敗で差し替え合う流れを示す図。",
    render: lambda { |s|
      s.panel(36, 84, 1128, 280)
      s.rect(92, 138, 200, 104, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(92, 270, 200, 72, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.rect(420, 138, 200, 104, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.rect(420, 270, 200, 72, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(192, 170, "表示", size: 18, weight: 700, anchor: "middle")
      s.text(192, 204, "_task", size: 16, weight: 600, fill: "#475569", anchor: "middle")
      s.text(192, 314, "編集リンク", size: 16, weight: 700, anchor: "middle")
      s.text(520, 170, "編集", size: 18, weight: 700, anchor: "middle")
      s.text(520, 204, "_form", size: 16, weight: 600, fill: "#475569", anchor: "middle")
      s.text(520, 314, "保存 / キャンセル", size: 16, weight: 700, anchor: "middle")
      s.arrow(292, 190, 416, 190)
      s.arrow(620, 190, 744, 190)
      s.rect(760, 138, 164, 104, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(948, 138, 164, 104, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(842, 170, "成功", size: 18, weight: 700, anchor: "middle")
      s.text(1030, 170, "失敗", size: 18, weight: 700, anchor: "middle")
      s.text(842, 204, "303 → 表示", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.text(1030, 204, "422 → エラー", size: 14, weight: 700, fill: "#475569", anchor: "middle")
    }
  },
  "fig-13-1" => {
    width: 1200, height: 420,
    title: "lazy loading と skeleton",
    desc: "src と loading=lazy で可視になってから取得し、skeleton が本体に差し替わる流れを示す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      s.rect(90, 160, 220, 96, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(90, 288, 220, 60, fill: "#e2e8f0", stroke: "#94a3b8", rx: 16)
      s.text(200, 190, "page 表示", size: 18, weight: 700, anchor: "middle")
      s.text(200, 320, "skeleton", size: 16, weight: 700, anchor: "middle")
      s.rect(390, 160, 220, 96, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.text(500, 190, "可視になる", size: 18, weight: 700, anchor: "middle")
      s.text(500, 220, "loading=lazy", size: 15, weight: 600, fill: "#475569", anchor: "middle")
      s.rect(700, 160, 220, 96, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(810, 190, "src を fetch", size: 18, weight: 700, anchor: "middle")
      s.rect(970, 160, 120, 96, fill: "#dbeafe", stroke: "#0284c7", rx: 16)
      s.text(1030, 190, "本体", size: 18, weight: 700, anchor: "middle")
      s.arrow(310, 208, 382, 208)
      s.arrow(620, 208, 694, 208)
      s.arrow(920, 208, 962, 208)
    }
  },
  "fig-13-2" => {
    width: 1200, height: 420,
    title: "frame の入れ子（サイドバー詳細）",
    desc: "detail frame の中に task_1 frame が入る入れ子構造を示す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      s.rect(92, 142, 344, 156, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(264, 174, "一覧", size: 18, weight: 700, anchor: "middle")
      s.text(264, 206, 'data-turbo-frame="detail"', size: 14, weight: 600, fill: "#475569", anchor: "middle")
      s.rect(510, 124, 498, 196, fill: "#ecfeff", stroke: "#06b6d4", rx: 18)
      s.text(759, 154, "<turbo-frame id=\"detail\">", size: 17, weight: 700, anchor: "middle")
      s.rect(588, 186, 342, 96, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(759, 214, "<turbo-frame id=\"task_1\">", size: 16, weight: 700, anchor: "middle")
      s.text(759, 242, "_task / インライン編集", size: 14, weight: 600, fill: "#475569", anchor: "middle")
      s.arrow(436, 220, 504, 220)
      s.text(759, 334, "detail の中で task_1 が独立して動く", size: 15, weight: 700, fill: "#475569", anchor: "middle")
    }
  },
  "fig-14-1" => {
    width: 1200, height: 420,
    title: "frame / Streams / 通常遷移 の判断",
    desc: "独立した部分更新の要否と更新箇所数で、通常遷移・Frame・Streams を選ぶフローチャート。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      s.rect(404, 118, 392, 56, fill: "#f8fafc", stroke: "#cbd5e1", rx: 14)
      s.text(600, 151, "画面を更新したい", size: 18, weight: 700, anchor: "middle")
      s.arrow(600, 174, 600, 198)
      s.rect(124, 208, 260, 76, fill: "#ecfeff", stroke: "#06b6d4", rx: 14)
      s.rect(480, 208, 240, 76, fill: "#eff6ff", stroke: "#60a5fa", rx: 14)
      s.rect(796, 208, 280, 76, fill: "#f8fafc", stroke: "#cbd5e1", rx: 14)
      s.text(254, 240, "独立部分更新が要る?", size: 17, weight: 700, anchor: "middle")
      s.text(600, 236, "1 か所?", size: 18, weight: 700, anchor: "middle")
      s.text(936, 232, "複数同時?", size: 17, weight: 700, anchor: "middle")
      s.text(254, 266, "No → Turbo Drive", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.text(600, 266, "Yes → Turbo Frames", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.text(936, 266, "Yes → Turbo Streams", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.arrow(384, 246, 480, 246)
      s.arrow(720, 246, 796, 246)
    }
  },
  "fig-16-1" => {
    width: 1200, height: 420,
    title: "create の複数命令同時更新",
    desc: "1 レスポンスに含めた 3 つの turbo-stream が、一覧・フォーム・フラッシュの 3 か所を同時に更新する図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      s.rect(134, 140, 236, 140, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(252, 166, "response", size: 18, weight: 700, anchor: "middle")
      s.rect(154, 190, 196, 24, fill: "#dbeafe", stroke: "#0284c7", rx: 10)
      s.rect(154, 222, 196, 24, fill: "#dbeafe", stroke: "#0284c7", rx: 10)
      s.rect(154, 254, 196, 24, fill: "#dbeafe", stroke: "#0284c7", rx: 10)
      s.text(252, 206, "prepend tasks", size: 13, weight: 700, anchor: "middle")
      s.text(252, 238, "update form", size: 13, weight: 700, anchor: "middle")
      s.text(252, 270, "update flash", size: 13, weight: 700, anchor: "middle")
      s.rect(460, 132, 176, 54, fill: "#f8fafc", stroke: "#cbd5e1", rx: 14)
      s.rect(460, 210, 176, 54, fill: "#f8fafc", stroke: "#cbd5e1", rx: 14)
      s.rect(460, 288, 176, 54, fill: "#f8fafc", stroke: "#cbd5e1", rx: 14)
      s.text(548, 165, "一覧", size: 18, weight: 700, anchor: "middle")
      s.text(548, 243, "フォーム", size: 18, weight: 700, anchor: "middle")
      s.text(548, 321, "flash", size: 18, weight: 700, anchor: "middle")
      s.arrow(370, 206, 452, 159)
      s.arrow(370, 238, 452, 237)
      s.arrow(370, 270, 452, 315)
      s.text(760, 220, "1 レスポンスで複数更新", size: 20, weight: 700, fill: "#075985", anchor: "middle")
    }
  },
  "fig-17-1" => {
    width: 1200, height: 360,
    title: "dom_id が表示側と命令側を揃える",
    desc: "dom_id(task) が表示側の frame id と stream target をどちらも task_1 に揃えることを示す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 240)
      s.rect(86, 140, 272, 88, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(464, 140, 272, 88, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.rect(842, 140, 272, 88, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(222, 168, "表示側", size: 18, weight: 700, anchor: "middle")
      s.text(222, 194, "turbo_frame_tag task", size: 14, weight: 700, anchor: "middle")
      s.text(600, 168, "dom_id(@task)", size: 18, weight: 700, fill: "#075985", anchor: "middle")
      s.text(600, 194, "task_1", size: 18, weight: 700, fill: "#075985", anchor: "middle")
      s.text(978, 168, "命令側", size: 18, weight: 700, anchor: "middle")
      s.text(978, 194, "turbo_stream.replace @task", size: 14, weight: 700, anchor: "middle")
      s.arrow(358, 184, 456, 184)
      s.arrow(736, 184, 834, 184)
      s.text(600, 286, "手書き id はずれる", size: 15, weight: 700, fill: "#b91c1c", anchor: "middle")
    }
  },
  "fig-20-1" => {
    width: 1200, height: 360,
    title: "controller / action / target",
    desc: "data-action がイベントを controller に、data-target が要素を this.xTarget に結びつける流れを示す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 240)
      s.rect(84, 138, 252, 100, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(424, 138, 320, 100, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.rect(804, 138, 312, 100, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(210, 168, 'HTML: data-action="input->counter#count"', size: 14, weight: 700, anchor: "middle")
      s.text(210, 196, 'data-counter-target="field"', size: 14, weight: 700, anchor: "middle")
      s.text(584, 168, "counter controller", size: 18, weight: 700, fill: "#075985", anchor: "middle")
      s.text(584, 196, "count() / this.fieldTarget", size: 14, weight: 700, fill: "#075985", anchor: "middle")
      s.text(960, 168, "output target", size: 18, weight: 700, anchor: "middle")
      s.text(960, 196, "文字数表示", size: 14, weight: 700, anchor: "middle")
      s.arrow(338, 188, 418, 188)
      s.arrow(744, 188, 796, 188)
    }
  },
  "fig-21-1" => {
    width: 1200, height: 360,
    title: "状態を HTML に置く",
    desc: "状態を data 属性に置けばスナップショットに乗るが、JS のインスタンス変数だけだと差し替えで失われることを対比する図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 240)
      s.rect(90, 138, 420, 116, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.rect(690, 138, 420, 116, fill: "#fef3c7", stroke: "#f59e0b", rx: 16)
      s.text(300, 168, "HTML に状態", size: 18, weight: 700, anchor: "middle")
      s.text(300, 196, "data-...-value / class", size: 14, weight: 700, anchor: "middle")
      s.text(300, 224, "スナップショットに含まれる", size: 14, weight: 700, fill: "#0e7490", anchor: "middle")
      s.text(900, 168, "JS だけに状態", size: 18, weight: 700, anchor: "middle")
      s.text(900, 196, "controller の instance variable", size: 14, weight: 700, anchor: "middle")
      s.text(900, 224, "差し替えで消える", size: 14, weight: 700, fill: "#b45309", anchor: "middle")
      s.arrow(510, 196, 682, 196)
    }
  },
  "fig-22-1" => {
    width: 1200, height: 360,
    title: "外部ライブラリのライフサイクル",
    desc: "connect で初期化し disconnect で破棄し、before-cache で片付ける流れを示すタイムライン。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 240)
      s.line(120, 190, 1080, 190, stroke: "#cbd5e1", sw: 3)
      points = [
        ["connect", "初期化"],
        ["操作", "利用"],
        ["before-cache", "片付け"],
        ["保存", "きれいなスナップショット"],
        ["disconnect", "破棄"]
      ]
      points.each_with_index do |(a,b), i|
        x = 160 + i * 220
        s.rect(x - 70, 140, 140, 80, fill: i == 2 ? "#ecfeff" : "#f8fafc", stroke: i == 2 ? "#06b6d4" : "#cbd5e1", rx: 14)
        s.text(x, 168, a, size: 16, weight: 700, anchor: "middle")
        s.text(x, 196, b, size: 13, weight: 600, fill: "#475569", anchor: "middle")
        s.arrow(x + 70, 180, x + 150, 180) if i < points.length - 1
      end
    }
  },
  "fig-23-1" => {
    width: 1200, height: 380,
    title: "検索の構成",
    desc: "Stimulus で debounce した GET 検索が frame を差し替え、advance で URL を反映する構成図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 260)
      s.rect(80, 150, 220, 84, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(190, 178, "検索ボックス", size: 18, weight: 700, anchor: "middle")
      s.text(190, 206, "Stimulus debounce", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.rect(380, 150, 200, 84, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.text(480, 178, "GET /tasks?q=…", size: 18, weight: 700, anchor: "middle")
      s.text(480, 206, "submit", size: 14, weight: 700, fill: "#0e7490", anchor: "middle")
      s.rect(650, 150, 220, 84, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(760, 178, "task_list frame", size: 18, weight: 700, anchor: "middle")
      s.text(760, 206, "差し替え", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.rect(940, 150, 150, 84, fill: "#dbeafe", stroke: "#0284c7", rx: 16)
      s.text(1015, 178, "URL", size: 18, weight: 700, anchor: "middle")
      s.text(1015, 206, "?q=…", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.arrow(300, 192, 372, 192)
      s.arrow(580, 192, 642, 192)
      s.arrow(870, 192, 932, 192)
    }
  },
  "fig-25-1" => {
    width: 1200, height: 420,
    title: "フォーム UX と a11y",
    desc: "422 で再描画されたフォームに、エラーサマリ、aria-invalid、aria-describedby、送信中ボタン無効化が付く様子を示す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      s.rect(90, 138, 300, 170, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(240, 166, "エラーサマリ", size: 18, weight: 700, anchor: "middle")
      s.rect(96, 182, 288, 28, fill: "#fee2e2", stroke: "#ef4444", rx: 8)
      s.text(240, 201, "role=\"alert\" / tabindex=-1", size: 13, weight: 700, anchor: "middle")
      s.rect(460, 138, 300, 170, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(610, 166, "入力欄", size: 18, weight: 700, anchor: "middle")
      s.rect(500, 188, 220, 32, fill: "#fff", stroke: "#ef4444", rx: 8)
      s.text(610, 209, "aria-invalid / describedby", size: 13, weight: 700, anchor: "middle")
      s.rect(830, 138, 260, 170, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(960, 166, "送信ボタン", size: 18, weight: 700, anchor: "middle")
      s.rect(874, 190, 172, 40, fill: "#dbeafe", stroke: "#0284c7", rx: 10)
      s.text(960, 214, "data-turbo-submits-with", size: 13, weight: 700, anchor: "middle")
      s.arrow(390, 208, 454, 208)
      s.arrow(760, 208, 820, 208)
    }
  },
  "fig-26-2" => {
    width: 1200, height: 420,
    title: "モーダルの構成",
    desc: "modal frame + dialog + Stimulus open + 成功時 Streams close の流れを示す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      s.rect(80, 152, 180, 72, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(170, 180, "新規作成リンク", size: 17, weight: 700, anchor: "middle")
      s.rect(332, 144, 176, 88, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.text(420, 176, "modal frame", size: 18, weight: 700, anchor: "middle")
      s.rect(592, 128, 238, 118, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(711, 158, "<dialog>", size: 18, weight: 700, anchor: "middle")
      s.text(711, 188, "Stimulus modal", size: 14, weight: 700, anchor: "middle")
      s.rect(886, 140, 238, 100, fill: "#dbeafe", stroke: "#0284c7", rx: 16)
      s.text(1005, 168, "create.turbo_stream", size: 17, weight: 700, anchor: "middle")
      s.text(1005, 196, "prepend + close + flash", size: 14, weight: 700, anchor: "middle")
      s.arrow(260, 188, 324, 188)
      s.arrow(508, 188, 586, 188)
      s.arrow(830, 188, 878, 188)
      s.text(711, 308, "Esc で close / cleanup", size: 15, weight: 700, fill: "#475569", anchor: "middle")
    }
  },
  "fig-27-1" => {
    width: 1200, height: 420,
    title: "通知の合わせ技",
    desc: "Streams による差し込み、Stimulus による演出、Action Cable による他者発配信の役割分担を示す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      s.rect(472, 146, 256, 110, fill: "#ecfeff", stroke: "#06b6d4", rx: 18)
      s.text(600, 178, "toasts", size: 18, weight: 700, anchor: "middle")
      s.text(600, 206, "role=status / aria-live", size: 14, weight: 700, fill: "#0e7490", anchor: "middle")
      s.arrow(200, 200, 460, 200)
      s.arrow(760, 200, 1000, 200)
      s.arrow(600, 126, 600, 146)
      s.text(168, 168, "Turbo Streams", size: 16, weight: 700, anchor: "middle")
      s.text(1032, 168, "Stimulus", size: 16, weight: 700, anchor: "middle")
      s.text(600, 112, "Action Cable", size: 16, weight: 700, anchor: "middle")
      s.text(166, 224, "差し込み", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.text(1032, 224, "演出", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.text(600, 236, "broadcast", size: 14, weight: 700, fill: "#475569", anchor: "middle")
    }
  },
  "fig-30-1" => {
    width: 1200, height: 400,
    title: "N+1 と includes",
    desc: "一覧描画で N+1 が起きる様子と、includes で解消する様子をクエリ本数で対比する図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 260)
      s.rect(82, 138, 460, 150, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(658, 138, 460, 150, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.text(312, 168, "N+1", size: 20, weight: 700, anchor: "middle")
      s.text(312, 196, "1 + 20 + 20 ...", size: 18, weight: 700, fill: "#b91c1c", anchor: "middle")
      s.text(312, 224, "クエリが増える", size: 16, weight: 700, anchor: "middle")
      s.text(888, 168, "includes", size: 20, weight: 700, fill: "#075985", anchor: "middle")
      s.text(888, 196, "まとめて数本", size: 18, weight: 700, fill: "#075985", anchor: "middle")
      s.text(888, 224, "broadcast の partial でも同じ", size: 16, weight: 700, anchor: "middle")
      s.line(150, 258, 470, 258, stroke: "#ef4444", sw: 10)
      s.line(726, 258, 1046, 258, stroke: "#0284c7", sw: 10)
    }
  },
  "fig-31-1" => {
    width: 1200, height: 400,
    title: "配信範囲と認可の切り分け",
    desc: "署名付き stream 名、配信範囲、認可が別レイヤーであることを示す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 260)
      [ ["署名付き stream 名", 120], ["配信範囲", 470], ["認可", 820] ].each do |name, x|
        s.rect(x, 144, 240, 110, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
        s.text(x + 120, 176, name, size: 18, weight: 700, anchor: "middle")
      end
      s.text(240, 220, "改ざん防止", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.text(590, 220, "streamable で届く範囲", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.text(940, 220, "controller / model", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.arrow(360, 199, 458, 199)
      s.arrow(710, 199, 808, 199)
      s.text(600, 120, "署名は認可ではない", size: 18, weight: 700, fill: "#0f172a", anchor: "middle")
    }
  },
  "fig-33-1" => {
    width: 1200, height: 360,
    title: "Path Configuration",
    desc: "URL パターンとネイティブの提示方法を rules が対応づける図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 220)
      s.rect(84, 132, 260, 100, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(472, 132, 260, 100, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.rect(860, 132, 260, 100, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(214, 162, "/tasks/new", size: 18, weight: 700, anchor: "middle")
      s.text(214, 190, "/tasks/:id/edit", size: 18, weight: 700, anchor: "middle")
      s.text(602, 162, "presentation", size: 18, weight: 700, anchor: "middle")
      s.text(602, 190, "modal / push", size: 18, weight: 700, anchor: "middle")
      s.text(990, 162, "rules", size: 18, weight: 700, anchor: "middle")
      s.text(990, 190, "JSON", size: 18, weight: 700, anchor: "middle")
      s.arrow(344, 182, 468, 182)
      s.arrow(732, 182, 856, 182)
    }
  },
  "fig-34-1" => {
    width: 1200, height: 380,
    title: "Bridge Components",
    desc: "Web の Stimulus とネイティブ component が名前で対応し、メッセージを往復する図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 240)
      s.rect(86, 146, 300, 96, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(814, 146, 300, 96, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.text(236, 176, "Web Stimulus", size: 18, weight: 700, anchor: "middle")
      s.text(236, 204, "submit-button", size: 16, weight: 700, fill: "#475569", anchor: "middle")
      s.text(964, 176, "Native component", size: 18, weight: 700, anchor: "middle")
      s.text(964, 204, "submit-button", size: 16, weight: 700, fill: "#0e7490", anchor: "middle")
      s.arrow(386, 194, 806, 194)
      s.arrow(806, 220, 386, 220)
      s.text(596, 170, "ボタンを出して", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.text(596, 238, "押された", size: 14, weight: 700, fill: "#475569", anchor: "middle")
    }
  },
  "fig-35-1" => {
    width: 1200, height: 380,
    title: "Web 画面とネイティブ画面の混在と認証同期",
    desc: "ネイティブのログイン画面と Web のタスク一覧が同じアプリ内に混在し、認証セッションを WebView へ渡す図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 240)
      s.rect(86, 146, 280, 90, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.rect(430, 146, 280, 90, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.rect(774, 146, 280, 90, fill: "#f8fafc", stroke: "#cbd5e1", rx: 16)
      s.text(226, 176, "Native login", size: 18, weight: 700, anchor: "middle")
      s.text(226, 204, "cookie / token", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.text(570, 176, "WebView", size: 18, weight: 700, anchor: "middle")
      s.text(570, 204, "Relay の一覧", size: 14, weight: 700, fill: "#0e7490", anchor: "middle")
      s.text(914, 176, "同期", size: 18, weight: 700, anchor: "middle")
      s.text(914, 204, "認証セッション", size: 14, weight: 700, fill: "#475569", anchor: "middle")
      s.arrow(366, 191, 424, 191)
      s.arrow(710, 191, 768, 191)
    }
  },
  "fig-37-2" => {
    width: 1200, height: 420,
    title: "採用判断フローチャート",
    desc: "CRUD 中心か、クライアント状態、オフライン、チーム、API 要否の問いから、Hotwire 向きか SPA/混在向きかを導く図。",
    render: lambda { |s|
      s.panel(38, 82, 1124, 280)
      questions = [
        "データの CRUD が中心?",
        "クライアント状態は小さい?",
        "オフライン不要?",
        "チームは Rails 寄り?",
        "Web だけなら API 不要?"
      ]
      questions.each_with_index do |q, i|
        y = 120 + i * 40
        s.rect(96, y, 508, 30, fill: "#f8fafc", stroke: "#cbd5e1", rx: 10)
        s.text(350, y + 20, q, size: 14, weight: 700, anchor: "middle")
      end
      s.rect(738, 136, 160, 88, fill: "#ecfeff", stroke: "#06b6d4", rx: 16)
      s.rect(960, 136, 160, 88, fill: "#fef3c7", stroke: "#f59e0b", rx: 16)
      s.text(818, 168, "Yes が多い", size: 17, weight: 700, anchor: "middle")
      s.text(818, 196, "Hotwire", size: 18, weight: 700, fill: "#0e7490", anchor: "middle")
      s.text(1040, 168, "No が多い", size: 17, weight: 700, anchor: "middle")
      s.text(1040, 196, "SPA / 混在", size: 18, weight: 700, fill: "#92400e", anchor: "middle")
      s.text(900, 292, "質問に答えると採用方針が見える", size: 15, weight: 700, fill: "#475569", anchor: "middle")
    }
  }
}.freeze

INSERTIONS = {
  "part2/chapter4.md" => [
    ["## 4.5 主要画面", "fig-4-2"]
  ],
  "part2/chapter5.md" => [
    ["## 5.2 認証の追加", "fig-5-1"]
  ],
  "part2/chapter6.md" => [
    ["## 6.3 本書の基本構成: importmap", "fig-6-1"]
  ],
  "part3/chapter7.md" => [
    ["## 7.2 Turbo Drive の visit と body 差し替え", "fig-7-2"]
  ],
  "part3/chapter9.md" => [
    ["## 9.2 preview 表示", "fig-9-1"],
    ["## 9.6 Turbo 8 の page refresh と morph", "fig-9-2"]
  ],
  "part3/chapter10.md" => [
    ["## 10.1 visit ライフサイクルの主要イベント", "fig-10-1"]
  ],
  "part4/chapter11.md" => [
    ["## 11.5 `data-turbo-frame` で別の frame を target する", "fig-11-2"]
  ],
  "part4/chapter12.md" => [
    ["## 12.3 インライン編集", "fig-12-1"]
  ],
  "part4/chapter13.md" => [
    ["## 13.1 lazy loading", "fig-13-1"],
    ["## 13.4 サイドバー詳細", "fig-13-2"]
  ],
  "part4/chapter14.md" => [
    ["## 14.5 通常遷移に戻す判断", "fig-14-1"]
  ],
  "part5/chapter16.md" => [
    ["## 16.4 flash を更新する", "fig-16-1"]
  ],
  "part5/chapter17.md" => [
    ["## 17.5 id 設計と `dom_id`", "fig-17-1"]
  ],
  "part6/chapter20.md" => [
    ["## 20.3 target の参照", "fig-20-1"]
  ],
  "part6/chapter21.md" => [
    ["## 21.5 HTML 側に情報を置く利点", "fig-21-1"]
  ],
  "part6/chapter22.md" => [
    ["## 22.5 Turbo cache との相互作用", "fig-22-1"]
  ],
  "part7/chapter23.md" => [
    ["## 23.5 Stimulus で requestSubmit を debounce する", "fig-23-1"]
  ],
  "part7/chapter25.md" => [
    ["## 25.7 a11y", "fig-25-1"]
  ],
  "part7/chapter26.md" => [
    ["## 26.6 モーダルを Turbo Frames と `<dialog>` で作る", "fig-26-2"]
  ],
  "part7/chapter27.md" => [
    ["## 27.2 この章の選択", "fig-27-1"]
  ],
  "part8/chapter30.md" => [
    ["## 30.3 N+1 と preload", "fig-30-1"]
  ],
  "part8/chapter31.md" => [
    ["## 31.4 署名付き stream 名への購読", "fig-31-1"]
  ],
  "part9/chapter33.md" => [
    ["## 33.3 presentation", "fig-33-1"]
  ],
  "part9/chapter34.md" => [
    ["## 34.4 メッセージの送受信", "fig-34-1"]
  ],
  "part9/chapter35.md" => [
    ["## 35.4 状態同期", "fig-35-1"]
  ],
  "part10/chapter37.md" => [
    ["## 37.7 採用判断チェックリスト", "fig-37-2"]
  ]
}.freeze

def insert_after_heading(content, heading, image_md)
  return content if content.include?(image_md)
  idx = content.index(heading)
  return content unless idx
  line_end = content.index("\n", idx)
  return content unless line_end
  insertion = "\n\n#{image_md}\n"
  content.insert(line_end + 1, insertion)
end

FIGURES.each do |figure_id, spec|
  svg = Svg.new(width: spec[:width], height: spec[:height], title: spec[:title], desc: spec[:desc])
  spec[:render].call(svg)
  File.write(File.join(FIGURES_DIR, "#{figure_id}.svg"), svg.to_svg)
end

INSERTIONS.each do |rel_path, items|
  path = File.join(MANUSCRIPT, rel_path)
  content = File.read(path)
  original = content.dup
  items.each do |heading, figure_id|
    image_md = "![#{FIGURES[figure_id][:desc]}](../figures/#{figure_id}.svg)"
    content = insert_after_heading(content, heading, image_md)
  end
  File.write(path, content) if content != original
end

puts "Generated #{FIGURES.size} more figures and updated chapter links."
