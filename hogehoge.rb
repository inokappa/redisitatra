get '/redis.json' do

  # connect to redis
  class Con
    def get_redis_info(param)
      config = YAML.load(File.read("config.yml"))
      Redis.yaml_tag(config)
      redis = Redis.new(config)
      redis.info["#{param}"]
    end
  end

  class Redisinfo < Con
    def get_connectd_clients
      ret = get_redis_info("connectd_clients")
      if ret == nil
        return '0'
      end
    end
    def get_port
      get_redis_info("tcp_port")
    end
    def get_used_memory
      get_redis_info("used_memory")
    end
    def get_total_connections_received
      get_redis_info("total_connections_received")
    end
    def get_total_commands_processed
      get_redis_info("total_commands_processed")
    end
    def get_mem_fragmentation_ratio
      get_redis_info("mem_fragmentation_ratio")
    end
  end
#
  chk = Redisinfo.new()
  rows = { \
    :array => [ \
    {:port => "#{chk.get_port}"},\
    {:connectd_clients => "#{chk.get_connectd_clients}"},\
    {:used_memory => "#{chk.get_used_memory}"},\
    {:total_connections_received => "#{chk.get_total_connections_received}"},\
    {:total_commands_processedtotal_commands_processed => "#{chk.get_total_commands_processed}"},\
    {:mem_fragmentation_ratio => "#{chk.get_mem_fragmentation_ratio}"}
   ]
  }
#
  content_type :json, :charset => 'utf-8'
  rows.to_json(:root => false)
  JSON.pretty_generate([rows])
end
