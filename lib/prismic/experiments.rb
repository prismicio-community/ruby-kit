# encoding: utf-8
module Prismic

  class Experiments
    attr_reader :draft, :running

    def initialize(draft, running)
      @draft = draft
      @running = running
    end

    def current
      running.first
    end

    def ref_from_cookie(cookie)
      if cookie == nil
        return nil
      end
      splitted = cookie.strip.split('%20')
      if splitted.size >= 2
        experiment = running.find { |exp| exp.google_id == splitted[0] }
        if experiment == nil
          return nil
        end
        var_index = splitted[1].to_i
        if var_index > -1 && var_index < experiment.variations.size
          return experiment.variations[var_index].ref
        end
      end
      nil
    end

    def self.parse(data)
      draft = []
      running = []
      if data != nil
        draft = data['draft'].map { |exp|
          Experiment.parse(exp)
        }
        running = data['running'].map { |exp|
          Experiment.parse(exp)
        }
      end
      new(draft, running)
    end

  end

  class Experiment
    attr_reader :id, :google_id, :name, :variations

    def initialize(id, google_id, name, variations)
      @id = id
      @google_id = google_id
      @name = name
      @variations = variations
    end

    def self.parse(data)
      new(data['id'], data['googleId'], data['name'], data['variations'].map { |variation|
        Variation.parse(variation)
      })
    end
  end

  class Variation
    attr_reader :id, :ref, :label

    def initialize(id, ref, label)
      @id = id
      @ref = ref
      @label = label
    end

    def self.parse(data)
      new(data['id'], data['ref'], data['label'])
    end

  end

end