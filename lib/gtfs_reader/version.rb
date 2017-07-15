module GtfsReader
  # This module both contains the current version of GtfsReader, but also has a
  # {Bumper} class which will modify this file to increase the version
  module Version
    # The following four lines are generated, so don't mess with them.
    MAJOR = 1
    MINOR = 2
    PATCH = 0
    BUILD = nil

    #@return [String] the current version in the form of +1.2.3.build+
    def self.to_s
      [MAJOR, MINOR, PATCH, BUILD].compact.join '.'
    end

    # A helper class which bumps the version number stored in this file
    class Bumper
      PARTS = %i[major minor patch]
      PATTERN = %r[(\s+)MAJOR = \d+\s+MINOR = \d+\s+PATCH = \d+\s+BUILD = .+]

      #@param filename [String] the file to edit
      #@param part [String] the part of the version to bump. one of major,
      #  minor, or patch
      def initialize(filename=__FILE__, part)
        raise "#{part} not one of #{PARTS}" unless PARTS.include? part
        @filename, @part = filename, part
      end

      # Increase the version number and write it to this file
      def bump
        parts = new_version
        # \1 holds a newline and the indentation from the source
        text = '\1' + ["MAJOR = #{parts[:major]}",
                       "MINOR = #{parts[:minor]}",
                       "PATCH = #{parts[:patch]}",
                       "BUILD = #{parts[:build] || 'nil'}"].join( '\1' )

        out_data = File.read( @filename ).gsub PATTERN, text
        #puts out_data
        File.open( @filename, 'w' ) { |out| out << out_data }
        puts "Bumped version to #{to_s}"
      end

      #@return [String] What the new version string will be.
      def to_s
        p = new_version
        [p[:major], p[:minor], p[:patch], p[:build]].compact.join ?.
      end

      private

      def new_version
        @vers ||= { major: MAJOR,
                    minor: MINOR,
                    patch: PATCH,
                    build: BUILD }.merge new_parts
      end

      def new_parts
        case @part
        when :major then {
            major: MAJOR + 1,
            minor: 0,
            patch: 0
        }
        when :minor then {
            minor: MINOR + 1,
            patch: 0
        }
        else {
            patch: PATCH + 1
        }
        end
      end
    end
  end
end
