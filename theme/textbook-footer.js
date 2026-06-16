// 全ページ共通フッター: 本書が FjordBootCamp の教材であることを示す。
// mdBook は章ごとに完全なページを読み込むため、各ページの読み込み時に挿入する。
(function () {
  function addFooter() {
    var main = document.querySelector("main");
    if (!main || document.querySelector(".textbook-footer")) {
      return;
    }
    var footer = document.createElement("footer");
    footer.className = "textbook-footer";
    var link = document.createElement("a");
    link.href = "https://bootcamp.fjord.jp/";
    link.textContent = "FjordBootCamp（フィヨルドブートキャンプ）";
    footer.appendChild(document.createTextNode("本書は "));
    footer.appendChild(link);
    footer.appendChild(document.createTextNode(" の教材です。"));
    main.appendChild(footer);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", addFooter);
  } else {
    addFooter();
  }
})();
