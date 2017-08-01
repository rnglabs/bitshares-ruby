module Bitshares
  module Helpers
    extend self

    def to_array(args)
      args = [] if args.nil?
      args = [args] unless args.respond_to? :each
      args.flatten
    end
  end
end
