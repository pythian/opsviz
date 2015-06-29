module OpsVizExtensions
  require 'net/http'

  def get_elasticache_redis_endpoint(redis_cluster_id)
    require 'fog'

    region = Net::HTTP.get('169.254.169.254', '/latest/meta-data/placement/availability-zone')[0...-1]

    ecache = Fog::AWS::Elasticache.new({:use_iam_profile => true, :region => region})
    resp = ecache.describe_cache_clusters(redis_cluster_id, {:show_node_info => true})
    resp.body['CacheClusters'][0]['CacheNodes'][0]['Address']
  end
end
