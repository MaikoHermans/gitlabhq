module Ci
  # Currently this is artificial object, constructed dynamically
  # We should migrate this object to actual database record in the future
  class Stage
    include StaticModel

    attr_reader :pipeline, :name

    delegate :project, to: :pipeline

    def initialize(pipeline, name:, status: nil)
      @pipeline = pipeline
      @name = name
      @status = status
    end

    def to_param
      name
    end

    def status
      @status ||= statuses.latest.status
    end

    def detailed_status
      Gitlab::Ci::Status::Stage::Factory.new(self).fabricate!
    end

    def statuses
      @statuses ||= pipeline.statuses.where(stage: name)
    end

    def builds
      @builds ||= pipeline.builds.where(stage: name)
    end
  end
end
