require "test_helper"

class UI::Account::BalanceReconciliationTest < ViewComponent::TestCase
  test "other liability reconciliation shows repayment as a decrease in principal" do
    account = accounts(:other_liability)
    balance = account.balances.create!(date: Date.current, currency: account.currency,
      balance: 8000, cash_balance: 0, start_non_cash_balance: 10000,
      non_cash_inflows: 2000, non_cash_outflows: 0, flows_factor: -1)
    component = UI::Account::BalanceReconciliation.new(balance: balance.reload, account: account)
    items = component.reconciliation_items

    assert_equal I18n.t("UI.account.balance_reconciliation.labels.start_principal"), items.first[:label]
    assert_equal [ 10000, -2000, 8000 ], items.map { |item| item[:value].amount }
    render_inline(component)
    assert_text Money.new(-2000, account.currency).format
  end
end
