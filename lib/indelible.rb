module Indelible
  extend ActiveSupport::Concern

  included do
    scope :not_removed, -> { where(removed_at: nil) }
    default_scope { not_removed }
  end

  def removed?
    removed_at.present?
  end

  # rubocop:disable Rails/SkipsModelValidations
  def destroy_row
    update_column(:removed_at, Time.current)
    1
  end
  # rubocop:enable Rails/SkipsModelValidations

  def recover
    self.removed_at = nil
  end
end
