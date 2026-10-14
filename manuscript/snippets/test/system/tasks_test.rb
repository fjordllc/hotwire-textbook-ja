require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  test "inline create and validation preserve the page" do
    page.execute_script("window.relayTestMarker = 'unchanged'")
    within "#new_task_form" do
      select projects(:one).name, from: "プロジェクト"
      click_on "保存"
      assert_selector ".error-summary"
      fill_in "タイトル", with: "System new task"
      click_on "保存"
    end
    within "#tasks" do
      assert_text "System new task"
      assert_selector "turbo-frame:first-child", text: "System new task"
    end
    assert_equal "unchanged", page.evaluate_script("window.relayTestMarker")
  end

  test "modal errors stay inside dialog and success closes it" do
    click_on "新規作成（モーダル）"
    within "dialog[open]" do
      select projects(:one).name, from: "プロジェクト"
      click_on "保存"
      assert_selector ".error-summary"
      fill_in "タイトル", with: "Modal task"
      click_on "保存"
    end
    assert_no_selector "dialog[open]"
    within("#tasks") { assert_text "Modal task" }
    assert_selector "#new_task_modal_link:focus"
  end

  test "inline editing and deleting work" do
    task = tasks(:one)
    within "##{dom_id(task)}" do
      click_on "編集"
      fill_in "タイトル", with: "Edited inline", fill_options: { clear: :backspace }
      assert_field "タイトル", with: "Edited inline"
      click_on "保存"
    end
    assert_selector "##{dom_id(task)}", text: "Edited inline"
    assert_no_selector "#task_list[busy]"
    within "##{dom_id(task)}" do
      accept_confirm { click_on "削除" }
    end
    assert_no_selector "##{dom_id(task)}"
  end

  test "search and pagination preserve filters" do
    visit project_path(projects(:one))
    24.times { |n| projects(:one).tasks.create!(title: "Needle #{n}") }
    visit tasks_path
    page.document.synchronize do
      assert page.evaluate_script("!!window.Stimulus.getControllerForElementAndIdentifier(document.querySelector('[data-controller=search]'), 'search')")
    end
    fill_in "タイトルで検索", with: "Needle", fill_options: { clear: :backspace }
    assert_field "タイトルで検索", with: "Needle"
    within("#task_list") { assert_text "24 件該当" }
    click_on "次へ"
    assert_current_path tasks_path(q: "Needle", status: "", project_id: "", tag_id: "", mode: "pages", page: "2")
    within("#tasks") { assert_selector "turbo-frame", count: 4 }
  end

  test "more mode appends all pages without duplicate ids" do
    visit project_path(projects(:one))
    43.times { |n| projects(:one).tasks.create!(title: "More #{n}") }
    visit tasks_path(q: "More", mode: "more")
    within("#tasks") { assert_selector "turbo-frame", count: 20 }
    within("#pagination") { click_on "もっと読む" }
    within("#tasks") { assert_selector "turbo-frame", count: 40 }
    within("#pagination") { click_on "もっと読む" }
    within("#tasks") { assert_selector "turbo-frame", count: 43 }
    assert_no_selector "#pagination a"
    ids = all("#tasks turbo-frame").map { |node| node[:id] }
    assert_equal ids.uniq, ids
  end

  test "comments validate and append" do
    visit task_path(tasks(:one))
    within "##{dom_id(tasks(:one), :comment_form)}" do
      click_on "コメント"
      assert_selector "[role=alert]"
      fill_in "コメント本文", with: "System comment"
      click_on "コメント"
    end
    assert_text "System comment"
  end
end
