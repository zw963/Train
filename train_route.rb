#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 根据 graphs 来生成 `哈希表' 的模块.
module TrainGraph
  attr_accessor :graphs

  def graphs_hash
    @graphs_hash ||= Hash[graphs.map {|e| e.split(/(?=\d)/)}]
  end

  def routes_hash
    @routes_hash ||= Hash[graphs_hash.keys.group_by {|e| e[0] }.map {|k, v| [k, v.map {|e| e[1] }] }]
  end

  def station_count
    routes_hash.keys.count
  end
end

# 混入 String 类的模块.
module TrainRouteStringExtension
  def train_route_path
    chars.each_cons(2).map(&:join)
  end

  def train_route_exist?
    train_route_path.all? {|e| TRAIN_GRAPHS_HASH.has_key? e }
  end

  def train_route_distance
    return "NO SUCH ROUTE" unless self.train_route_exist?
    train_route_path.inject(0) {|a, e| a + TRAIN_GRAPHS_HASH[e].to_i }
  end

  def train_route_stop
    chars.count - 1
  end
end

# 主程序模块.
class TrainRoute
  include TrainGraph
  attr_accessor :route
  attr_writer :routes_array

  def routes_array
    @routes_array ||= Array[*route[0]]
  end

  def matched_routes_array
    @matched_routes_array ||= []
  end

  def concat_station_to_routes_array
    routes_array.map do |route|
      routes_hash[route.chars.last].map {|e| route + e }
    end.flatten
  end

  def traversal
    self.routes_array = concat_station_to_routes_array
    matched_routes_array.concat routes_array.select {|e| e.chars.last == route[1] }
  end

  def search_route
    # 最极端的情况下(例如: 所有站点在同一条线上), 对于 N 个站点, 也只需要遍历 N 次, 可以访问到所有站点.
    station_count.times { traversal }
    matched_routes_array
  end

  def route_length
    routes_array.first.chars.count
  end

  def search_route_while_stop(&block)
    traversal while yield route_length
    matched_routes_array
  end

  def route_minimum_distance
    routes_array.map(&:train_route_distance).min
  end

  def search_route_while_distance(&block)
    # 最后一次 traversal 返回的结果中, 最小 distance, 也大于 block 时, 遍历可以停止了.
    traversal while yield route_minimum_distance
    matched_routes_array.select {|e| yield e.train_route_distance }
  end
end
