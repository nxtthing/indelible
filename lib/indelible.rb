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
    before_destroying
    self.removed_at = Time.current
    run_callbacks(:destroy) do
      save(validate: false)
    end
  end

  def recover
    @marked_for_destruction = false
    self.removed_at = nil
  end

  def before_destroying; end
end
