module Indelible
  extend ActiveSupport::Concern

  included do
    scope :not_removed, -> { where(removed_at: nil) }
    default_scope { not_removed }
  end

  def removed?
    @marked_for_destruction || removed_at.present?
  end

  def delete
    destroy
  end

  def destroy
    self.removed_at = Time.current
    run_callbacks(:destroy) do
      save(validate: false)
    end
    after_indelible_destroy
  end

  def recover
    @marked_for_destruction = false
    self.removed_at = nil
  end

  def after_indelible_destroy; end
end
