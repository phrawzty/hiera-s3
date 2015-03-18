# Description: Yet Another S3 Backend for Hiera
# Author: Dan "phrawzty" Maher <phrawzty@mozilla.com>
# URL: https://github.com/phrawzty/hiera-s3
class Hiera
    module Backend
        class S3_backend

            def initialize
                require 'rubygems'
                require 'aws-sdk'
                require 'yaml'
                say('initialised!')
            end

            # Purely for convenience.
            def say(msg)
                Hiera.debug("#{self.class.name} #{msg}")
            end

            def bail(msg)
                say(msg)
                raise Exception, "#{self.class.name} #{msg}"
            end

            # Rudimentary sanity checking.
            def parse_config()
                # Need an S3 section in the config.
                if not Config[:s3] then
                    bail('requires an :s3: section.')
                end

                # Bucket needs to be specified
                if not Config[:s3][:bucket] then
                    bail('requires :bucket: to be set.')
                end

                # AWS SDK requires default region.
                if Config[:s3][:region] == nil then
                    # Maybe Facter knows; if so, drop the suffix.
                    if Facter.value('ec2_placement_availability_zone') =~ /^(.*\d)\w?$/ then
                        Config[:s3][:region] = $1
                    else
                        bail('requires a default region to be set.')
                    end
                end
            end

            def lookup(key, scope, order_override, resolution_type)
                parse_config()
                say("using bucket #{Config[:s3][:bucket]}")

                if not Config[:s3][:prefix] == nil then
                    key = Config[:s3][:prefix] + key
                end
                say("looking for #{key}")

                s3 = Aws::S3::Client.new(region: Config[:s3][:region])

                # Validating error conditions? Ain't nobody got time for that.
                begin
                    item = s3.get_object(
                        bucket: Config[:s3][:bucket],
                        key: key
                    )
                    return item[0].string.strip()
                rescue
                    return nil
                end
            end

        end
    end
end
