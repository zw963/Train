#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 求职者: 郑伟 zw963@163.com
# 问题选择: TRAINS
# 语言: Ruby 2.0

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

module TrainGraph
  attr_accessor :graphs

  # {"AB"=>"5", "BC"=>"4" ...}
  def train_graphs_hash
    Hash[graphs.map {|e| e.split(/(?=\d)/)}]
  end

  # {"A"=>["AB", "AD", "AE"], "B"=>["BC"] ...}
  def train_graph_routes_hash
    train_graphs_hash.keys.group_by {|e| e[0] }
  end

  def train_station_count
    graphs.join.chars.to_a.uniq.join.count("A-Z")
  end
end

module TrainNoRepeatRoute
  include TrainGraph
  attr_accessor :route

  def route_path
    route.chars.each_cons(2).map(&:join)
  end

  def route_exist?
    route_path.all? {|e| train_graphs_hash.has_key? e }
  end

  def route_distance
    return "NO SUCH ROUTE" unless route_exist?
    route_path.inject(0) {|a, e| a = a + train_graphs_hash[e].to_i }
  end
end

module TrainRepeatRoute
  include TrainGraph
  attr_accessor :route

  def start_station
    @stop_station || route[0]
  end

  def stop_station=(new_stop_station)
    @stop_station = new_stop_station
  end

  def end_station
    route[1]
  end

  # 假设 CC
  #
  # 1. 我希望获取从 C 开始的所有 path 的字符串.
  # 2. 稍后, 我匹配, 看看有没有以 C 结束的, 有的话, 记录下来即可.

  def next_station_string_array
    train_graph_routes_hash[start_station]
      .map {|e| start_station + e }
      .map {|e| e.gsub(/([[:alpha:]])(\1)/, '\1') }
  end

  def parse
    train_station_count.times do
      stop_station = next_station_string_array
    end
  end

  # # ["ACD", "ACE" ...]
  # def route_path_string
  #   # 串起来, 并替换 `连续的重复字符' 为一个.
  #   initial_station = start_station[-1]
  #   next_station_array = train_graph_routes_hash[]
  #     .map {|e| route + e }
  #     .map {|e| e.gsub(/([[:alpha:]])(\1)/, '\1') }
  # end

  # def prase
  #   route = route_path_string
  # end

  # def start_station_char
  #   Array[route[0]]
  # end

  # def next_station_char
  #   route[-1]
  # end

  # def end_station_char
  #   route[1]
  # end
  
  # def matched_routes
  #   # 假设一个站只允许经过一次, 所以, 一次遍历经过的站不会超过总数.
  #   train_station_count.times do
  #     # 遍历
  #     start_station = start_station.map {|e| concat_path(e) }.flatten
  #     # 插入一个数组.
  #     collect_path(_initial_path, _matched_path)
  #     # # 移除重复元素.
  #     remove_collected_and_circle_path(_initial_path)
  #   end
  # end


end

class A
  def routes
    _matched_path = []
    # 起点的名称数组, 例如: ['A']
    _initial_path = Array[route[0]]

    # 假设一个站只允许经过一次, 所以, 一次遍历经过的站不会超过总数.
    train_station_count.times do
      # 遍历
      _initial_path = _initial_path.map {|e| concat_path(e) }.flatten
      # 插入一个数组.
      collect_path(_initial_path, _matched_path)
      # # 移除重复元素.
      remove_collected_and_circle_path(_initial_path)
    end

    # 对于存在回环的路径, 过路站点仍存在经过两次的可能性, 例如: AE, 移除掉ADCDE
    _matched_path.flatten.reject {|e| e.chars.to_a[1..-2].uniq! }
  end

  # def Distance(path)
  #   path.chars.each_cons(2).map(&:join).inject(0) {|a, e| a = a + path_distance_hash[e].to_i }
  # end

  # def Distance_all(path_array)
  #   path_array.map {|e| Distance(e) }
  # end

  def collect_path(path_array, matched_path_array)
    _dest_station = route[1]
    # 将匹配目标站点的字符串加入数组
    matched_path_array << path_array.grep(/#{_dest_station}$/)
    path_array
  end

  def remove_collected_and_circle_path(path_array)
    _start_station, _dest_station = route[0], route[1]
    # 移除已经被收集的 path.
    path_array.reject! {|e| e.match(/#{_dest_station}$/) }
    # 移除存在回环的 path, 例如: DE,这个会移除 DCDE,
    # 很不幸, 它必须在前一个 reject 之后被调用.
    path_array.reject! {|e| e.match(/#{_start_station}$/) }
    path_array
  end

  #  block 版, 需从外部传入终止条件.
  def routes_while_distance(&block)
    _matched_path = []
    _initial_path = Array[route[0]]

    (
     _initial_path = _initial_path.map {|e| concat_path(e) }.flatten
     collect_path(_initial_path, _matched_path)
     ) until not                # 将每次 parse 的最小路径传入代码块.
      yield Distance_all(_initial_path).sort.min

    (_matched_path.flatten.map {|e| Distance(e) }.select &block).size
  end

  #
  def routes_while_stop(stops = 0, &block)
    _matched_path = []
    _initial_path = Array[route[0]]

    if block_given?
      (
       _initial_path = _initial_path.map {|e| concat_path(e) }.flatten
       collect_path(_initial_path, _matched_path)
       ) until not yield _initial_path.sort.min.size - 1

      (_matched_path.flatten.map {|e| e.size - 1 }.select &block).size
    else
      (
       _initial_path = _initial_path.map {|e| concat_path(e) }.flatten
       collect_path(_initial_path, _matched_path)
       ) until _initial_path.sort.min.size - 1 > stops

      _matched_path.flatten.select {|e| e.size - 1 == stops }.size
    end
  end

  def routes_distance
    Distance_all(routes)
  end

  public :routes_while_stop, :routes_distance, :routes_while_distance

end

# # The number of trips starting at C and ending at C with a maximum of 3 stops.
# new_route.route = "CC"
# p new_route.routes_while_stop {|e| e <= 3 }     # => 2

# # # The number of trips starting at A and ending at C with exactly 4 stops
# new_route.route = "AC"
# p new_route.routes_while_stop(4)                # => 3

# # # The length of the shortest route from A to C.
# new_route.route = "AC"
# p new_route.routes_distance.min                 # => 9

# # # The length of the shortest route from B to B.
# new_route.route = "BB"
# p new_route.routes_distance.min                 # => 9

# # # The number of different routes from C to C with a distance of less than 30.
# new_route.route = "CC"
# p new_route.routes_while_distance {|distance| distance < 30 } # => 7
