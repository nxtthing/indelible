module Indelible
  extend ActiveSupport::Concern

  included do
    scope :removed, -> { with_removed.where.not(removed_at: nil) }
    scope :not_removed, -> { where(removed_at: nil) }
    scope :with_removed, -> { unscope(where: :removed_at) }
    default_scope { not_removed }
  end

  def removed?
    removed_at.present?
  end

  # rubocop:disable Rails/SkipsModelValidations
  def destroy_row
    update_column(:removed_at, Time.current) unless removed?
    1
  end
  # rubocop:enable Rails/SkipsModelValidations

  def recover
    self.removed_at = nil
  end
end
