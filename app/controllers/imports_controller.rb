class ImportsController < ApplicationController
  before_action :set_import, only: %i[show publish destroy revert apply_template]

  def publish
    @import.publish_later

    redirect_to import_path(@import), notice: t(".notice")
  rescue Import::MaxRowCountExceededError
    redirect_back_or_to import_path(@import), alert: t(".alert", max_rows: @import.max_row_count)
  end

  def index
    @imports = Current.family.imports

    render layout: "settings"
  end

  def new
    @pending_import = Current.family.imports.ordered.pending.first
  end

  def create
    account = Current.family.accounts.find_by(id: params.dig(:import, :account_id))
    import = Current.family.imports.create!(
      type: import_params[:type],
      account: account,
      date_format: Current.family.date_format,
    )

    redirect_to import_upload_path(import)
  end

  def show
    if !@import.uploaded?
      redirect_to import_upload_path(@import), alert: t(".alert_upload")
    elsif !@import.publishable?
      redirect_to import_confirm_path(@import), alert: t(".alert_mappings")
    end
  end

  def revert
    @import.revert_later
    redirect_to imports_path, notice: t(".notice")
  end

  def apply_template
    if @import.suggested_template
      @import.apply_template!(@import.suggested_template)
      redirect_to import_configuration_path(@import), notice: t(".notice")
    else
      redirect_to import_configuration_path(@import), alert: t(".alert")
    end
  end

  def destroy
    @import.destroy

    redirect_to imports_path, notice: t(".notice")
  end

  private
    def set_import
      @import = Current.family.imports.find(params[:id])
    end

    def import_params
      params.require(:import).permit(:type)
    end
end
