#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 求职者: 郑伟 zw963@163.com
# 问题选择: TRAINS
# 语言: Ruby 2.0.0-p353

require 'minitest/autorun'
require 'minitest/pride'

require_relative "train_route"

# ============================== 单元测试 ==============================
# ------------------------------ TrainGraph 模块 ------------------------------
class TrainGraphSubject
  include TrainGraph
end

describe TrainGraphSubject do
  subject { TrainGraphSubject.new }

  describe "#graphs_hash" do
    describe "当 @graphs_hash 不存在时" do
      it "应该使用 graphs 生成一个 `哈希表'." do
        def subject.graphs
          %w{AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7}
        end
        subject.instance_variable_set(:@graphs_hash, nil)

        expected = {
          "AB" => "5", "BC" => "4", "CD" => "8",
          "DC" => "8", "DE" => "6", "AD" => "5",
          "CE" => "2", "EB" => "3", "AE" => "7"
        }
        subject.graphs_hash.must_equal expected
        subject.instance_variable_get(:@graphs_hash).must_equal expected
      end
    end

    describe "当 @graphs_hash 存在时" do
      it "应该直接返回这个哈希." do
        subject.instance_variable_set(:@graphs_hash, "CC" => "5")
        subject.graphs_hash.must_equal "CC" => "5"
      end
    end
  end

  describe "#routes_hash" do
    describe "当 @routes_hash 不存在时" do
      it "应该使用 graphs_hash 生成一个 `路由表'." do
        def subject.graphs_hash
          {
            "AB"=>"5", "BC"=>"4", "CD"=>"8",
            "DC"=>"8", "DE"=>"6", "AD"=>"5",
            "CE"=>"2", "EB"=>"3", "AE"=>"7"
          }
        end
        subject.instance_variable_set(:@routes_hash, nil)

        expected = {
          "A"=>["AB", "AD", "AE"],
          "B"=>["BC"],
          "C"=>["CD", "CE"],
          "D"=>["DC", "DE"],
          "E"=>["EB"]
        }
        subject.routes_hash.must_equal expected
        subject.instance_variable_get(:@routes_hash).must_equal expected
      end
    end

    describe "当 @routes_hash 存在时" do
      it "应该直接返回这个哈希." do
        subject.instance_variable_set(:@routes_hash, "A" => ["AB", "AD", "AE"])
        subject.routes_hash.must_equal "A" => ["AB", "AD", "AE"]
      end

    end
  end

  describe "#station_count" do
    it "应该根据 `路由表' 计算 `站点数量'." do
      def subject.routes_hash
        {
          "A"=>["AB", "AD", "AE"],
          "B"=>["BC"],
          "C"=>["CD", "CE"],
          "D"=>["DC", "DE"],
          "E"=>["EB"]
        }
      end
      subject.station_count.must_equal 5
    end
  end
end

# ------------------------------ TrainRoute 字符串扩展 ------------------------------
class String
  include TrainRouteStringExtension
end

TRAIN_GRAPHS_HASH = {
  "AB"=>"5", "BC"=>"4", "CD"=>"8",
  "DC"=>"8", "DE"=>"6", "AD"=>"5",
  "CE"=>"2", "EB"=>"3", "AE"=>"7"
}

describe TrainRouteStringExtension do
  subject { "ABC" }

  describe "#train_route_path" do
    it "应该返回 route 展开后的路径数组." do
      subject.train_route_path.must_equal ["AB", "BC"]
    end
  end

  describe "#train_route_exist?" do
    describe "当 route_path 存在时" do
      it "应该返回 true." do
        def subject.train_route_path
          ["AB", "BC", "CD"]
        end
        subject.train_route_exist?.must_equal true
      end
    end

    describe "当 route_path 不存在时" do
      it "应该返回 false." do
        def subject.train_route_path
          ["AC", "CD"]
        end
        subject.train_route_exist?.must_equal false
      end
    end
  end

  describe "#train_route_distance" do
    describe "当 train_route_exist? 为假时" do
      it "应该直接返回 `NO SUCH ROUTE' 消息." do
        def subject.train_route_exist?
          false
        end
        subject.train_route_distance.must_equal 'NO SUCH ROUTE'
      end
    end

    describe "当 train_route_exist? 为真时" do
      it "应该计算 train route 的距离." do
        def subject.route_exist?
          true
        end
        def subject.route_path
          [ "AB", "BC" ]
        end
        subject.train_route_distance.must_equal 9
      end
    end
  end
end

# ------------------------------ 主程序模块 ------------------------------
describe TrainRoute do
  subject { TrainRoute.new }

  describe "#routes_array 用来收集所有遍历的结果" do
    describe "当 @routes_array 非空时" do
      it "应该返回 @routes_array." do
        subject.instance_variable_set(:@routes_array, ["DEF", "DFE"])
        def subject.route
          "AC"
        end
        subject.routes_array.must_equal ["DEF", "DFE"]
      end
    end

    describe "当 @routes_array 为空时" do
      it "应该返回 Array[*route[0]]" do
        subject.instance_variable_set(:@routes_array, nil)
        def subject.route
          "AC"
        end
        subject.routes_array.must_equal ["A"]
      end
    end
  end

  describe "#matched_routes_array 用来收集所有匹配的路由." do
    it "当 @matched_routes_array 不存在时, 应该提供一个初始值 []" do
      subject.instance_variable_set(:@matched_routes_array, nil)
      subject.matched_routes_array.must_equal []
    end

    it "当 @matched_routes_array 存在时, 应该返回 @matched_routes_array 的值." do
      subject.instance_variable_set(:@matched_routes_array, ["AA", "BB"])
      subject.matched_routes_array.must_equal ["AA", "BB"]
    end
  end

  describe "#concat_station_to_routes_array 执行路由字符串 concat 操作" do
    it "应该将路由 concat 进入下一个站点的数组" do
      def subject.routes_array
        ["BCD"]
      end
      def subject.routes_hash
        {
          "A"=>["AB", "AD", "AE"],
          "B"=>["BC"],
          "C"=>["CD", "CE"],
          "D"=>["DC", "DE"],
          "E"=>["EB"]
        }
      end
      subject.concat_station_to_routes_array.must_equal ["BCDC", "BCDE"]
    end
  end

  describe "#traversal 执行遍历" do
    it "应该调用 self.routes_array=(concat_station_to_routes_array)" do
      def subject.concat_station_to_routes_array
        ["CDC", "CDE"]
      end
      def subject.routes_array=(arg)
        if arg == ["CDC", "CDE"]
          print "OK!"
        end
      end
      def subject.matched_routes_array
        []
      end
      def subject.route
        "AC"
      end
      -> { subject.traversal.must_equal ["CDC"] }.must_output "OK!"
    end
  end

  describe '#search_route' do
    it '应该输出 2 次 OK!, 并且返回 matched_routes_array 的值.' do
      def subject.station_count
        2
      end
      def subject.traversal
        print "OK!"
      end
      def subject.matched_routes_array
        ["AC"]
      end
      -> { subject.search_route.must_equal ["AC"] }.must_output "OK!OK!"
    end
  end

  describe "#route_length" do
    it "应该输出 routes_array 数组的元素的字符数." do
      def subject.routes_array
        ["CDCD", "CDCE", "CDEB", "CEBC"]
      end
      subject.route_length.must_equal 4
    end
  end

  describe "#search_route_while_stop" do
    describe "当 block 条件满足时" do
      it "会立即执行 traversal, 直到条件为假." do
        def subject.route_length
          @route_length ||= 0
        end

        def subject.route_length=(arg)
          @route_length = arg
        end

        def subject.traversal
          print "OK!"
          self.route_length += 1
        end

        def subject.matched_routes_array
          ["ABC", "ABCD"]
        end
        -> { subject.search_route_while_stop {|stop| stop <= 3 }.must_equal ["ABC", "ABCD"] }.must_output "OK!OK!OK!"
      end
    end
  end

  describe "#route_minimum_distance" do
    it "应该输出 routes_array 中所有 route string 的最短距离." do
      def subject.routes_array
        ["CDCD", "CDCE", "CDEB", "CEBC"]
      end
      subject.route_minimum_distance.must_equal 9
    end
  end

  describe "#search_route_while_distance" do
    describe "当 block 条件初始为真时" do
      it "会立即执行 traversal, 直到条件为假." do
        def subject.route_minimum_distance
          @route_minimum_distance ||= 0
        end

        def subject.route_minimum_distance=(arg)
          @route_minimum_distance = arg
        end

        def subject.traversal
          print "OK!"
          self.route_minimum_distance += 4
        end

        def subject.matched_routes_array
          ["ABC", "ABCD"]
        end
        -> { subject.search_route_while_distance {|distance| distance < 10 }.must_equal ["ABC"] }.must_output "OK!OK!OK!"
      end
    end
  end
end

# ============================== 功能测试 ==============================

describe TrainRoute do
  before do
    @subject = TrainRoute.new
    @subject.graphs = %w(AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7)
  end

  specify { "ABC".train_route_distance.must_equal 9 }
  specify { "AD".train_route_distance.must_equal 5 }
  specify { "ADC".train_route_distance.must_equal 13 }
  specify { "AEBCD".train_route_distance.must_equal 22 }
  specify { "AED".train_route_distance.must_equal 'NO SUCH ROUTE' }

  it "应该返回从 C 到 C, 长度不超过 3 的路由" do
    @subject.route = "CC"
    expected = %w{CDC CEBC}
    @subject.search_route_while_stop {|stop| stop <= 3 }.must_equal expected
  end

  it "应该返回从 A 到 C, 长度等于 4 的路由" do
    @subject.route = "AC"
    expected = %w{ABCDC ADCDC ADEBC}
    @subject.search_route_while_stop {|stop| stop <= 4 }.select {|route| route.train_route_stop == 4 }.must_equal expected
  end

  it "应该返回从 A 到 C 的最短路由" do
    @subject.route = "AC"
    @subject.search_route.map(&:train_route_distance).min.must_equal 9
  end

  it "应该返回从 B 到 B 的最短路由" do
    @subject.route = "BB"
    @subject.search_route.map(&:train_route_distance).min.must_equal 9
  end

  it "应该返回从 C 到 C, 距离小于 30 的所有路由" do
    @subject.route = "CC"
    expected = ["CDC", "CEBC", "CDEBC", "CDCEBC", "CEBCDC", "CEBCEBC", "CEBCEBCEBC"]
    @subject.search_route_while_distance {|distance| distance < 30 }.must_equal expected
  end

  it "应该返回从 C 到 E, 距离小于 40, 长度不超过 5 的路由" do
    @subject.route = "CE"
    expected = ["CDE", "CDCE", "CDCDE", "CEBCE"]
    @subject.search_route_while_distance {|distance| distance < 40 }.select {|e| e.chars.count <= 5 }.must_equal expected
  end

  it "应该返回从 C 到 E, 距离大于 60, 长度不超过 10 的路由" do
    @subject.route = "CE"
    expected = ["CDCDCDCDE", "CDCDCDCDCE", "CDCDCDCDCDE", "CDCDCDEBCDE", "CDCDEBCDCDE", "CDEBCDCDCDE"]
    @subject.search_route_while_stop {|stop| stop <= 10 }.select {|e| e.train_route_distance > 60 }.must_equal expected
  end

  it "应该返回从 C 到 E, 距离等于 39 的路由" do
    @subject.route = "CE"
    expected = ["CDCDEBCE", "CDCEBCDE", "CDEBCDCE", "CEBCDCDE"]
    @subject.search_route_while_distance {|distance| distance <= 40 }.select {|e| e.train_route_distance == 39 }.must_equal expected
  end
end
