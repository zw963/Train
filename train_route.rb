#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 求职者: 郑伟 zw963@163.com
# 问题选择: TRAINS
# 语言: Ruby 2.0.0-p353

# Problem:
#   The local commuter railroad services a number of towns in Kiwiland.
#   Because of monetary concerns, all of the tracks are 'one-way'.
#   That is, a route from Kaitaia to Invercargill does not imply the existence of
#   a route from Invercargill to Kaitaia.  In fact, even if both of these routes
#   do happen to exist, they are distinct and are not necessarily the same distance!

#   The purpose of this problem is to help the railroad provide its customers with
#   information about the routes. In particular, you will compute the distance along
#   a certain route, the number of different routes between two towns, and the shortest
#   route between two towns.

# Input:
#   A directed graph where a node represents a town and an edge represents a route
#   between two towns.  The weighting of the edge represents the distance between
#   the two towns.  A given route will never appear more than once, and for a given route,
#   the starting and ending town willnot be the same town.

# Output:
#   For test input 1 through 5, if no such route exists, output 'NO SUCH ROUTE'.
#   Otherwise, follow the route as given; do not make any extra stops!
#   For example, the first problem means to start at city A, then travel directly
#   to city B (a distance of 5), then directly to city C (a distance of 4).

# 1. The distance of the route A-B-C.
# 2. The distance of the route A-D.
# 3. The distance of the route A-D-C.
# 4. The distance of the route A-E-B-C-D.
# 5. The distance of the route A-E-D.
# 6. The number of trips starting at C and ending at C with a maximum of 3 stops.
#    In the sample data below, there are two such trips: C-D-C (2 stops). and C-E-B-C (3 stops).
# 7. The number of trips starting at A and ending at C with exactly 4 stops.
#    In the sample data below, there are three such trips: A to C (via B,C,D); A to C (via D,C,D);
#    and A to C (via D,E,B).
# 8. The length of the shortest route (in terms of distance to travel) from A to C.
# 9. The length of the shortest route (in terms of distance to travel) from B to B.
# 10. The number of different routes from C to C with a distance of less than 30.
#     In the sample data, the trips are: CDC, CEBC, CEBCDC, CDCEBC, CDEBC, CEBCEBC, CEBCEBCEBC.

# Test Input:
#   For the test input, the towns are named using the first few letters of the alphabet from A to E.
#   A route between two towns (A to B) with a distance of 5 is represented as AB5.

# Graph: AB5, BC4, CD8, DC8, DE6, AD5, CE2, EB3, AE7

# Expected Output:

#         Output #1: 9
#         Output #2: 5
#         Output #3: 13
#         Output #4: 22
#         Output #5: NO SUCH ROUTE
#         Output #6: 2
#         Output #7: 3
#         Output #8: 9
#         Output #9: 9
#         Output #10: 7

# 根据 graphs 来生成 `哈希表' 的模块.
module TrainGraph
  attr_accessor :graphs

  def graphs_hash
    @graphs_hash ||= Hash[graphs.map {|e| e.split(/(?=\d)/)}]
  end

  def routes_hash
    @routes_hash ||= graphs_hash.keys.group_by {|e| e[0] }
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
      routes_hash[route.chars.last].map {|e| route.chop + e }
    end.flatten
  end

  def traversal
    self.routes_array = concat_station_to_routes_array
    matched_routes_array.concat concat_station_to_routes_array.select {|e| e.chars.last == route[1] }
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
    # 最后一次 traversal 返回的结果集合, 如果是期望的结果, 那么应该通过 + 1 来终止遍历.
    traversal while yield route_length + 1
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
