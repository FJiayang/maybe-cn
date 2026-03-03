module TransactionsHelper
  def transaction_search_filters
    [
      { key: "account_filter", label: I18n.t("helpers.transactions.filters.account"), icon: "layers" },
      { key: "date_filter", label: I18n.t("helpers.transactions.filters.date"), icon: "calendar" },
      { key: "type_filter", label: I18n.t("helpers.transactions.filters.type"), icon: "tag" },
      { key: "amount_filter", label: I18n.t("helpers.transactions.filters.amount"), icon: "hash" },
      { key: "category_filter", label: I18n.t("helpers.transactions.filters.category"), icon: "shapes" },
      { key: "tag_filter", label: I18n.t("helpers.transactions.filters.tag"), icon: "tags" },
      { key: "merchant_filter", label: I18n.t("helpers.transactions.filters.merchant"), icon: "store" }
    ]
  end

  def get_transaction_search_filter_partial_path(filter)
    "transactions/searches/filters/#{filter[:key]}"
  end

  def get_default_transaction_search_filter
    transaction_search_filters[0]
  end
end